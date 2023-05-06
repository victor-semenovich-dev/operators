import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:operators/src/data/repository/auth.dart';

part '../../../../generated/src/ui/authorization/reset_password/reset_password_bloc.freezed.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepository authRepository;

  ResetPasswordCubit(this.authRepository) : super(ResetPasswordState());

  void resetPassword(String email) async {
    try {
      await authRepository.resetPassword(customEmail: email);
      emit(state.copyWith(isResetCompleted: true));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(error: e.message));
    }
  }

  void consumeError() {
    emit(state.copyWith(error: null));
  }
}

@freezed
class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    @Default(null) String? error,
    @Default(false) bool isResetCompleted,
  }) = _ResetPasswordState;
}
