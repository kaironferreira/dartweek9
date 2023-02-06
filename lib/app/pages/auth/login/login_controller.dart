// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:delivery_app/app/core/excepetions/unauthorized_exceptions.dart';
import 'package:delivery_app/app/core/rest_client/custom_dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:delivery_app/app/pages/auth/login/login_state.dart';
import 'package:delivery_app/app/repositories/auth/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginController(
    this._authRepository,
  ) : super(const LoginState.initial());

  Future<void> login(String email, String password) async {
    try {
      emit(state.copyWith(status: LoginStatus.login));
      final authResult = await _authRepository.login(email, password);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', authResult.accessToken);
      prefs.setString('refreshToken', authResult.refreshToken);
      emit(state.copyWith(status: LoginStatus.success));
    } on UnauthorizedExceptions catch (e, s) {
      log('Login ou senha inválidos', error: e, stackTrace: s);
      emit(state.copyWith(
          status: LoginStatus.loginError,
          errorMessage: 'Login ou senha inválidos'));
    } catch (e, s) {
      log('Erro ao realizar login', error: e, stackTrace: s);
      emit(state.copyWith(
          status: LoginStatus.error, errorMessage: 'Erro ao realizar login'));
    }
  }
}
