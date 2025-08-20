import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client/services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final AuthService authService = AuthService();

  void signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final res = await authService.signUpUser(
        name: name,
        password: password,
        email: email,
      );
      emit(AuthSignupSuccess(res));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void confirmSignUpUser({required String email, required String otp}) async {
    emit(AuthLoading());
    try {
      final res = await authService.confirmSignUpUser(email: email, otp: otp);
      emit(AuthConfirmSignupSuccess(res));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void loginUser({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final res = await authService.loginUser(password: password, email: email);
      emit(AuthLoginSuccess(res));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void isAuthenticated() async {
    emit(AuthLoading());
    try {
      final res = await authService.isAuthenticated();
      if (res) {
        emit(AuthLoginSuccess('Logged in!'));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
