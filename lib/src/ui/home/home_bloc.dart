import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:operators/src/data/model/event.dart';
import 'package:operators/src/data/model/table.dart';
import 'package:operators/src/data/model/user.dart';
import 'package:operators/src/data/repository/auth.dart';
import 'package:operators/src/data/repository/events.dart';
import 'package:operators/src/data/repository/fcm.dart';
import 'package:operators/src/data/repository/table.dart';
import 'package:operators/src/data/repository/telegram.dart';
import 'package:operators/src/data/usecase/sync_events.dart';

part '../../../generated/src/ui/home/home_bloc.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  final FcmRepository fcmRepository;
  final AuthRepository authRepository;
  final TableRepository tableRepository;
  final EventsRepository eventsRepository;
  final TelegramRepository telegramRepository;

  late StreamSubscription _firebaseUserSubscription;
  late StreamSubscription _tableDataSubscription;
  late StreamSubscription _isAdminSubscription;
  late StreamSubscription _eventsSubscription;
  late StreamSubscription _usersSubscription;

  HomeCubit(this.fcmRepository, this.authRepository, this.tableRepository,
      this.eventsRepository, this.telegramRepository)
      : super(HomeState()) {
    _firebaseUserSubscription =
        authRepository.userStream.listen((firebaseUser) {
      emit(state.copyWith(currentFirebaseUser: firebaseUser));
    });
    _tableDataSubscription = tableRepository.tableStream.listen((tableData) {
      emit(state.copyWith(tableData: tableData));
      _sortUsers();
    });
    _isAdminSubscription = authRepository.isAdminStream.listen((isAdmin) {
      emit(state.copyWith(isAdmin: isAdmin));
    });
    _eventsSubscription = tableRepository.eventsStream.listen((events) {
      emit(state.copyWith(allEvents: events));
      _sortUsers();
    });
    _usersSubscription = tableRepository.usersStream.listen((users) {
      emit(state.copyWith(allUsers: users));
      _sortUsers();
    });
  }

  void updateUserFcmData() {
    fcmRepository.updateUserFcmData();
  }

  void toggleCanHelp(TableUser user, TableEvent event) {
    tableRepository.toggleCanHelp(user, event);
  }

  void onRoleSelected(TableUser user, TableEvent event, Role? role) {
    tableRepository.setRole(user, event, role);
  }

  void onCanHelpSelected(TableUser user, TableEvent event, bool? canHelp) {
    tableRepository.setCanHelp(user, event, canHelp);
  }

  Rating _getRating(TableUser user, DateTime dateTime) {
    int value = 0;
    DateTime? lastDate;
    state.allEvents.forEach((e) {
      if (e.date.isBefore(dateTime) && e.state[user.id]?.role != null) {
        if (DateTime.now().difference(e.date) < Duration(days: 30)) {
          value++;
        }
        if (lastDate == null || e.date.isAfter(lastDate!)) {
          lastDate = e.date;
        }
      }
    });
    return Rating(value, lastDate);
  }

  Rating getRating(TableUser user) {
    return _getRating(user, DateTime.now());
  }

  Rating getRatingForEvent(TableUser user, TableEvent event) {
    return _getRating(user, event.date);
  }

  void setSortType(SortType sortType) {
    emit(state.copyWith(sortType: sortType));
    _sortUsers();
  }

  void _sortUsers() {
    final tableData = state.tableData;
    if (tableData != null) {
      final users = tableData.users;
      switch (state.sortType) {
        case SortType.BY_NAME:
          emit(state.copyWith(
            sortedTableUsers: users.sortedBy((e) => e.name),
            sortedAllUsers: state.allUsers.sortedBy((e) => e.name),
          ));
          break;
        case SortType.BY_RATING:
          emit(
            state.copyWith(
              sortedTableUsers: users.sortedByCompare(
                (user) => user,
                (user1, user2) => _compareByRating(user1, user2),
              ),
              sortedAllUsers: state.allUsers.sortedByCompare(
                (user) => user,
                (user1, user2) => _compareByRating(user1, user2),
              ),
            ),
          );
          break;
      }
    }
  }

  int _compareByRating(TableUser user1, TableUser user2) {
    final rating1 = getRating(user1);
    final rating2 = getRating(user2);
    final lastDate1 = rating1.lastDate;
    final lastDate2 = rating2.lastDate;
    if (rating1.value == rating2.value) {
      if (lastDate1 == lastDate2) {
        return user1.name.compareTo(user2.name);
      } else if (lastDate1 == null) {
        return -1;
      } else if (lastDate2 == null) {
        return 1;
      } else {
        return lastDate1.compareTo(lastDate2);
      }
    } else {
      return rating1.value - rating2.value;
    }
  }

  String getNotificationText(TableEvent event) {
    final buffer = StringBuffer();
    final allUsers = state.allUsers;
    var isFirst = true;
    final sortedEntries = event.state.entries.sorted(
        (a, b) => (a.value.role?.index ?? -1) - (b.value.role?.index ?? -1));
    for (final entry in sortedEntries) {
      if (entry.value.role != null) {
        if (!isFirst) {
          buffer.write('\n');
        }
        final userName =
            allUsers.firstWhereOrNull((user) => user.id == entry.key)?.name ??
                '?';
        final roleStr = roleToReadableString(entry.value.role) ?? '?';
        buffer.write('$userName - $roleStr');
        isFirst = false;
      }
    }
    return buffer.toString();
  }

  List<TableUser> getMissedMarksUsers(TableEvent event) {
    return state.tableData?.users
            .where((user) => event.state[user.id]?.canHelp == null)
            .toList() ??
        [];
  }

  bool getRemindTelegramDefaultValue() {
    final lastTime = telegramRepository.lastTimeRemind;
    return lastTime == null ||
        DateTime.now().difference(lastTime) > Duration(days: 1);
  }

  void sendRemind(
    TableEvent event,
    List<TableUser> users,
    bool telegramSendToPCChannel,
    bool telegramSendToVideoChannel,
  ) async {
    final msgPC = (await FirebaseDatabase.instance
            .ref('/messages/remind_operators_pc')
            .get())
        .value
        .toString()
        .replaceAll('\\n', '\n');
    final msgVideo = (await FirebaseDatabase.instance
            .ref('/messages/remind_operators_video')
            .get())
        .value
        .toString()
        .replaceAll('\\n', '\n');

    final dateNow = DateTime.now();
    if (telegramSendToPCChannel) {
      telegramRepository.sendMessageToTelegramChat(msgPC, PC_CHANNEL_ID);
      telegramRepository.lastTimeRemind = dateNow;
    }

    if (telegramSendToVideoChannel) {
      telegramRepository.sendMessageToTelegramChat(msgVideo, VIDEO_CHANNEL_ID);
      telegramRepository.lastTimeRemind = dateNow;
    }

    final result = await fcmRepository.sendNotificationToUsers(
      'Напоминание',
      'Отметься на служение "${event.title}"',
      users
          .map((e) => e.uid)
          .where((uid) => uid != null)
          .map((e) => e!)
          .toList(),
    );
    emit(state.copyWith(sendNotificationResult: result));
  }

  void sendNotification(
    String title,
    String body,
    bool telegramSendToPCChannel,
    bool telegramSendToVideoChannel,
  ) async {
    if (telegramSendToPCChannel) {
      telegramRepository.sendMessageToTelegramChat(
          "$title\n\n$body", PC_CHANNEL_ID);
    }
    if (telegramSendToVideoChannel) {
      telegramRepository.sendMessageToTelegramChat(
          "$title\n\n$body", VIDEO_CHANNEL_ID);
    }
    final result = await fcmRepository.sendNotification(title, body);
    emit(state.copyWith(sendNotificationResult: result));
  }

  String? getNotificationResultReadableText() {
    switch (state.sendNotificationResult) {
      case SendNotificationResult.SUCCESS:
        return 'Уведомление отправлено';
      case SendNotificationResult.FAILURE:
        return 'Не удалось отправить уведомление';
      case SendNotificationResult.FAILURE_TOPIC:
        return 'Ошибка отправки уведомления на мобильные клиенты';
      case SendNotificationResult.FAILURE_WEB:
        return 'Ошибка отправки уведомления на веб клиенты';
      default:
        return null;
    }
  }

  String? getSyncResultText() {
    final syncResult = state.syncResult;
    if (syncResult == null) {
      return null;
    } else {
      final eventsResult =
          'добавлено: ${syncResult.added}, обновлено: ${syncResult.updated}, '
          'скрыто: ${syncResult.hidden}, удалено: ${syncResult.deleted}';
      if (syncResult.error == null) {
        return 'Синхронизация успешно завершена ($eventsResult)';
      } else {
        return 'Произошла ошибка: "${syncResult.error}" ($eventsResult)';
      }
    }
  }

  void consumeSendNotificationResult() {
    emit(state.copyWith(sendNotificationResult: null));
  }

  void logout() {
    authRepository.logout();
  }

  void resetPassword() async {
    await authRepository.resetPassword();
    emit(state.copyWith(isResetPasswordCompleted: true));
  }

  void consumeResetPasswordState() {
    emit(state.copyWith(isResetPasswordCompleted: false));
  }

  void updateEvents() async {
    emit(state.copyWith(syncInProgress: true));
    final result =
        await SyncEventsUseCase(eventsRepository, tableRepository).perform();
    emit(state.copyWith(syncInProgress: false, syncResult: result));
  }

  void consumeSyncEventsResult() {
    emit(state.copyWith(syncResult: null));
  }

  void addEvent(DateTime dateTime, String title) {
    tableRepository.addOrUpdateEvent(dateTime, title);
  }

  void updateEvent(int id, DateTime dateTime, String title) {
    tableRepository.updateEvent(id, date: dateTime, title: title);
  }

  void hideEvent(TableEvent event) {
    tableRepository.updateEvent(event.id, isActive: false);
  }

  void deleteEvent(TableEvent event) {
    tableRepository.deleteEvent(event.id);
  }

  void showAllUsers(bool showAllUsers) {
    emit(state.copyWith(showAllUsers: showAllUsers));
  }

  @override
  Future<void> close() async {
    await _firebaseUserSubscription.cancel();
    await _tableDataSubscription.cancel();
    await _isAdminSubscription.cancel();
    await _eventsSubscription.cancel();
    await _usersSubscription.cancel();
    return super.close();
  }
}

@freezed
class HomeState with _$HomeState {
  const HomeState._();

  const factory HomeState({
    @Default(null) User? currentFirebaseUser,
    @Default(false) bool isResetPasswordCompleted,
    @Default(null) SendNotificationResult? sendNotificationResult,
    @Default(null) SyncResult? syncResult,
    @Default(false) bool syncInProgress,
    @Default(null) TableData? tableData,
    @Default(false) bool isAdmin,
    @Default([]) List<TableEvent> allEvents,
    @Default([]) List<TableUser> allUsers,
    @Default([]) List<TableUser> sortedAllUsers,
    @Default([]) List<TableUser> sortedTableUsers,
    @Default(SortType.BY_NAME) SortType sortType,
    @Default(false) bool showAllUsers,
  }) = _HomeState;

  bool get isLoggedIn => currentFirebaseUser != null;

  TableUser? get currentUser => tableData?.users
      .firstWhereOrNull((user) => user.uid == currentFirebaseUser?.uid);
}

class Rating {
  final int value;
  final DateTime? lastDate;

  Rating(this.value, this.lastDate);

  @override
  String toString() {
    return 'Rating{value: $value, lastDate: $lastDate}';
  }
}
