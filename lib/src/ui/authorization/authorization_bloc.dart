import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:operators/src/data/repository/auth.dart';

part '../../../generated/src/ui/authorization/authorization_bloc.freezed.dart';

class AuthorizationCubit extends Cubit<AuthorizationState> {
  final AuthRepository authRepository;

  AuthorizationCubit(this.authRepository) : super(AuthorizationState());

  void login(String email, String password) async {
    try {
      emit(state.copyWith(error: null));
      await authRepository.login(email, password);
      emit(state.copyWith(isLoggedIn: true));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(error: e.message));
    }
  }

  void consumeError() {
    emit(state.copyWith(error: null));
  }
}

@freezed
class AuthorizationState with _$AuthorizationState {
  const factory AuthorizationState({
    @Default(null) String? error,
    @Default(false) bool isLoggedIn,
  }) = _AuthorizationState;
}
