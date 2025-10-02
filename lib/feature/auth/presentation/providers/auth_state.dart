import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/feature/user/domain/entities/user.dart';

enum AuthStatus { authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String message;
  final bool isError;

  AuthState({
    required this.status,
    this.user,
    required this.message,
    this.isError = false,
  });

  factory AuthState.authenticated({User? user, required String message}) {
    return AuthState(
      status: AuthStatus.authenticated,
      user: user,
      message: message,
      isError: false,
    );
  }

  factory AuthState.unauthenticated({
    required String message,
    bool isError = false,
  }) {
    return AuthState(
      status: AuthStatus.unauthenticated,
      message: message,
      isError: isError,
    );
  }

  AuthState copyWith({
    AuthStatus? status,
    ValueGetter<User?>? user,
    ValueGetter<String>? message,
    ValueGetter<bool>? isError,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user != null ? user() : this.user,
      message: message != null ? message() : this.message,
      isError: isError != null ? isError() : this.isError,
    );
  }

  @override
  List<Object?> get props => [status, user, message, isError];
}
