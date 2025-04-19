import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:workly_flutter/features/auth/domain/entities/user.dart';
import 'package:workly_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:workly_flutter/features/auth/presentation/bloc/login/login_event.dart';
import 'package:workly_flutter/features/auth/presentation/bloc/login/login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc(this._loginUseCase) : super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>(_onLoginReset);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LoginStatus.loading));

      await Future.delayed(const Duration(milliseconds: 300));

      final result = await _loginUseCase(
        LoginParams(email: event.email, password: event.password),
      );

      // Processar o resultado
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: LoginStatus.failure,
              errorMessage: failure.message,
            ),
          );
        },
        (user) {
          if (user.token.isNotEmpty) {
            emit(state.copyWith(status: LoginStatus.success, user: user));
          } else {
            emit(
              state.copyWith(
                status: LoginStatus.failure,
                errorMessage: 'Token de autenticação inválido',
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Erro inesperado: $e',
        ),
      );
    }
  }

  void _onLoginReset(LoginReset event, Emitter<LoginState> emit) {
    emit(const LoginState());
  }

  int min(int a, int b) => a < b ? a : b;
}
