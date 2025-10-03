import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';

import 'package:sigma_track/feature/user/domain/entities/user.dart';

enum AuthStatus { authenticated, unauthenticated }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final ItemSuccess? success;
  final Failure? failure;

  const AuthState({
    required this.status,
    this.user,
    this.success,
    this.failure,
  });

  factory AuthState.authenticated({User? user, ItemSuccess? success}) {
    return AuthState(
      status: AuthStatus.authenticated,
      user: user,
      success: success,
    );
  }

  factory AuthState.unauthenticated({Failure? failure, ItemSuccess? success}) {
    return AuthState(
      status: AuthStatus.unauthenticated,
      failure: failure,
      success: success,
    );
  }

  AuthState copyWith({
    AuthStatus? status,
    ValueGetter<User?>? user,
    ValueGetter<ItemSuccess?>? success,
    ValueGetter<Failure?>? failure,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user != null ? user() : this.user,
      success: success != null ? success() : this.success,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [status, user, success, failure];
}
