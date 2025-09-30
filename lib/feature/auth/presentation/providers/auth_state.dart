import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/feature/user/domain/entities/user.dart';

enum AuthStatus { authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String message;

  AuthState({required this.status, this.user, required this.message});

  factory AuthState.authenticated({User? user, required String message}) {
    return AuthState(
      status: AuthStatus.authenticated,
      user: user,
      message: message,
    );
  }

  factory AuthState.unauthenticated({required String message}) {
    return AuthState(status: AuthStatus.unauthenticated, message: message);
  }

  AuthState copyWith({
    AuthStatus? status,
    ValueGetter<User?>? user,
    ValueGetter<String>? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user != null ? user() : this.user,
      message: message != null ? message() : this.message,
    );
  }

  @override
  List<Object?> get props => [status, user, message];
}
