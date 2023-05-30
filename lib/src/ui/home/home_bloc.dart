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
  }

  void updateUserFcmData() {
    fcmRepository.updateUserFcmData();
  }

  void toggleCanHelp(TableUser user, TableEvent event) {
    tableRepository.toggleCanHelp(user, event);
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
  }) = _HomeState;

  bool get isLoggedIn => currentFirebaseUser != null;

  TableUser? get currentUser => tableData?.users
      .firstWhereOrNull((user) => user.uid == currentFirebaseUser?.uid);
}
