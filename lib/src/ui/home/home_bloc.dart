import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:operators/src/data/model/event.dart';
import 'package:operators/src/data/model/table.dart';
import 'package:operators/src/data/model/telegram.dart';
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
  late StreamSubscription _telegramConfigsSubscription;

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
    _telegramConfigsSubscription =
        telegramRepository.telegramConfigsStream.listen((telegramConfigs) {
      emit(state.copyWith(telegramConfigs: telegramConfigs));
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

  List<Rating> _getRating(TableUser user, DateTime dateTime) {
    int pcValue = 0;
    int cameraValue = 0;
    DateTime? pcLastDate;
    DateTime? cameraLastDate;
    state.allEvents.forEach((e) {
      final role = e.state[user.id]?.role;
      if (e.date.isBefore(dateTime) && role != null) {
        if (role == Role.PC) {
          if (e.date.isAfter(DateTime.now().subtract(Duration(days: 31))))
            pcValue++;
          if (pcLastDate == null || e.date.isAfter(pcLastDate!))
            pcLastDate = e.date;
        } else if (role == Role.CAMERA) {
          if (e.date.isAfter(DateTime.now().subtract(Duration(days: 31))))
            cameraValue++;
          if (cameraLastDate == null || e.date.isAfter(cameraLastDate!))
            cameraLastDate = e.date;
        }
      }
    });
    final result = <Rating>[];
    if (pcLastDate != null) result.add(Rating(Role.PC, pcValue, pcLastDate));
    if (cameraLastDate != null)
      result.add(Rating(Role.CAMERA, cameraValue, cameraLastDate));
    return result;
  }

  List<Rating> getRating(TableUser user) {
    return _getRating(user, DateTime.now());
  }

  void setSortType(SortType sortType) {
    emit(state.copyWith(sortType: sortType));
    _sortUsers();
  }

  void _sortUsers() {
    final tableData = state.tableData;
    if (tableData != null) {
      final users = tableData.users;

      int Function(TableUser, TableUser) comparator;

      switch (state.sortType) {
        case SortType.BY_NAME:
          comparator = (u1, u2) => u1.name.compareTo(u2.name);
          break;
        case SortType.BY_RATING_PC:
          comparator = (u1, u2) => _compareByRating(u1, u2, Role.PC);
          break;
        case SortType.BY_RATING_CAMERA:
          comparator = (u1, u2) => _compareByRating(u1, u2, Role.CAMERA);
          break;
        case SortType.BY_LAST_DATE_PC:
          comparator = (u1, u2) => _compareByLastDate(u1, u2, Role.PC);
          break;
        case SortType.BY_LAST_DATE_CAMERA:
          comparator = (u1, u2) => _compareByLastDate(u1, u2, Role.CAMERA);
          break;
      }

      emit(
        state.copyWith(
          sortedTableUsers: users.sortedByCompare((user) => user, comparator),
          sortedAllUsers:
              state.allUsers.sortedByCompare((user) => user, comparator),
        ),
      );
    }
  }

  int _getValue(List<Rating> ratingList, Role role) {
    Rating? rating = ratingList.firstWhereOrNull((r) => r.role == role);
    return rating?.value ?? 0;
  }

  DateTime _getLastDate(List<Rating> ratingList, Role role) {
    Rating? rating = ratingList.firstWhereOrNull((r) => r.role == role);
    return rating?.lastDate ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  int _compareByRating(TableUser user1, TableUser user2, Role role) {
    final rating1 = getRating(user1);
    final rating2 = getRating(user2);
    final rating1Value = _getValue(rating1, role);
    final rating2Value = _getValue(rating2, role);
    final lastDate1 = _getLastDate(rating1, role);
    final lastDate2 = _getLastDate(rating2, role);
    if (user1.roles.contains(role) && !user2.roles.contains(role)) {
      return -1;
    } else if (!user1.roles.contains(role) && user2.roles.contains(role)) {
      return 1;
    } else {
      if (rating1Value == rating2Value) {
        if (lastDate1 == lastDate2) {
          return user1.name.compareTo(user2.name);
        } else {
          return lastDate1.compareTo(lastDate2);
        }
      } else {
        return rating1Value - rating2Value;
      }
    }
  }

  int _compareByLastDate(TableUser user1, TableUser user2, Role role) {
    final rating1 = getRating(user1);
    final rating2 = getRating(user2);
    final rating1Value = _getValue(rating1, role);
    final rating2Value = _getValue(rating2, role);
    final lastDate1 = _getLastDate(rating1, role);
    final lastDate2 = _getLastDate(rating2, role);
    if (user1.roles.contains(role) && !user2.roles.contains(role)) {
      return -1;
    } else if (!user1.roles.contains(role) && user2.roles.contains(role)) {
      return 1;
    } else {
      if (lastDate1 == lastDate2) {
        if (rating1Value == rating2Value) {
          return user1.name.compareTo(user2.name);
        } else {
          return rating1Value - rating2Value;
        }
      } else {
        return lastDate1.compareTo(lastDate2);
      }
    }
  }

  String getNotificationText(TableEvent event) {
    final buffer = StringBuffer();
    final allUsers = state.allUsers;
    var isFirst = true;
    final sortedEntries = event.state.entries.sorted((a, b) {
      final roleDif = (a.value.role?.index ?? -1) - (b.value.role?.index ?? -1);
      if (roleDif == 0) {
        final user1Name =
            allUsers.firstWhereOrNull((e) => e.id == a.key)?.name ?? '';
        final user2Name =
            allUsers.firstWhereOrNull((e) => e.id == b.key)?.name ?? '';
        return user1Name.compareTo(user2Name);
      } else {
        return roleDif;
      }
    });
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
    List<TelegramConfig> telegramConfigs,
  ) async {
    for (final config in telegramConfigs) {
      final message =
          config.messages[MARKS_REMINDER_KEY]?.replaceAll('\\n', '\n');
      if (message != null) {
        if (config.messageThreadId == null) {
          telegramRepository.sendMessageToTelegramChat(message, config.chatId);
        } else {
          telegramRepository.sendMessageToTelegramChatThread(
              message, config.chatId, config.messageThreadId!);
        }
      }
    }
    telegramRepository.lastTimeRemind = DateTime.now();

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
    List<TelegramConfig> telegramConfigs,
  ) async {
    for (final config in telegramConfigs) {
      if (config.messageThreadId == null) {
        telegramRepository.sendMessageToTelegramChat(
            "$title\n\n$body", config.chatId);
      } else {
        telegramRepository.sendMessageToTelegramChatThread(
            "$title\n\n$body", config.chatId, config.messageThreadId!);
      }
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
    await _telegramConfigsSubscription.cancel();
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
    @Default([]) List<TelegramConfig> telegramConfigs,
    @Default(SortType.BY_NAME) SortType sortType,
    @Default(false) bool showAllUsers,
  }) = _HomeState;

  bool get isLoggedIn => currentFirebaseUser != null;

  TableUser? get currentUser => tableData?.users
      .firstWhereOrNull((user) => user.uid == currentFirebaseUser?.uid);

  bool get showIntercomOption =>
      currentUser?.roles.contains(Role.CAMERA) == true;
}

class Rating {
  final Role role;
  final int value;
  final DateTime? lastDate;

  Rating(this.role, this.value, this.lastDate);

  @override
  String toString() {
    if (lastDate == null) {
      return value.toString();
    } else {
      return "$value (${DateFormat("dd.MM").format(lastDate!)})";
    }
  }
}
