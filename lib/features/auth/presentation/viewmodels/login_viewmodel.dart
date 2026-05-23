import 'package:flutter_riverpod/flutter_riverpod.dart';

enum LoginStatus { idle, loading, success, error }

class LoginState {
  final LoginStatus status;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.idle,
    this.errorMessage,
  });

  LoginState copyWith({LoginStatus? status, String? errorMessage}) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(const LoginState());

  static const _hardcodedEmail = 'docente@sep.gob.mx';
  static const _hardcodedPassword = '123456';

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: LoginStatus.loading);

    await Future.delayed(const Duration(milliseconds: 800));

    if (email.trim() == _hardcodedEmail && password == _hardcodedPassword) {
      state = state.copyWith(status: LoginStatus.success);
    } else {
      state = state.copyWith(
        status: LoginStatus.error,
        errorMessage: 'Correo o contraseña incorrectos',
      );
    }
  }

  void resetError() {
    state = state.copyWith(status: LoginStatus.idle, errorMessage: null);
  }
}

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, LoginState>(
  (ref) => LoginViewModel(),
);
