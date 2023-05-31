import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:operators/src/data/model/event.dart';
import 'package:operators/src/data/model/table.dart';
import 'package:operators/src/data/model/user.dart';
import 'package:operators/src/data/repository/auth.dart';
import 'package:operators/src/data/repository/events.dart';
import 'package:operators/src/data/repository/fcm.dart';
import 'package:operators/src/data/repository/table.dart';
import 'package:operators/src/data/usecase/sync_events.dart';

part '../../../generated/src/ui/home/home_bloc.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  final FcmRepository fcmRepository;
  final AuthRepository authRepository;
  final TableRepository tableRepository;
  final EventsRepository eventsRepository;

  late StreamSubscription _firebaseUserSubscription;
  late StreamSubscription _tableDataSubscription;
  late StreamSubscription _isAdminSubscription;
  late StreamSubscription _eventsSubscription;
  late StreamSubscription _usersSubscription;

  HomeCubit(this.fcmRepository, this.authRepository, this.tableRepository,
      this.eventsRepository)
      : super(HomeState()) {
    _firebaseUserSubscription =
        authRepository.userStream.listen((firebaseUser) {
      emit(state.copyWith(currentFirebaseUser: firebaseUser));
    });
    _tableDataSubscription = tableRepository.tableStream.listen((tableData) {
      emit(state.copyWith(tableData: tableData));
    });
    _isAdminSubscription = authRepository.isAdminStream.listen((isAdmin) {
      emit(state.copyWith(isAdmin: isAdmin));
    });
    _eventsSubscription = tableRepository.eventsStream.listen((events) {
      emit(state.copyWith(allEvents: events));
    });
    _usersSubscription = tableRepository.usersStream.listen((users) {
      emit(state.copyWith(allUsers: users));
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

  Rating getRating(TableUser user, TableEvent event) {
    int value = 0;
    DateTime? lastDate;
    state.allEvents.forEach((e) {
      if (e.date.isBefore(event.date) &&
          DateTime.now().difference(e.date) < Duration(days: 30) &&
          e.state[user.id]?.role != null) {
        value++;
        if (lastDate == null || e.date.isAfter(lastDate!)) {
          lastDate = e.date;
        }
      }
    });
    return Rating(value, lastDate);
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

  void updateEvents() {
    SyncEventsUseCase(eventsRepository, tableRepository).perform();
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
    @Default(null) TableData? tableData,
    @Default(false) bool isAdmin,
    @Default([]) List<TableEvent> allEvents,
    @Default([]) List<TableUser> allUsers,
  }) = _HomeState;

  bool get isLoggedIn => currentFirebaseUser != null;

  TableUser? get currentUser => tableData?.users
      .firstWhereOrNull((user) => user.uid == currentFirebaseUser?.uid);
}

class Rating {
  final int value;
  final DateTime? lastDate;

  Rating(this.value, this.lastDate);
}
