import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:workly_flutter/features/auth/domain/entities/user.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final User? user;
  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.user,
    this.errorMessage,
  });

  LoginState copyWith({LoginStatus? status, User? user, String? errorMessage}) {
    final newState = LoginState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );

    debugPrint('LoginState.copyWith - Criando novo estado: $newState');
    return newState;
  }

  @override
  List<Object?> get props => [status, user, errorMessage];

  @override
  String toString() {
    return 'LoginState(status: $status, user: ${user?.email}, errorMessage: $errorMessage)';
  }
}
