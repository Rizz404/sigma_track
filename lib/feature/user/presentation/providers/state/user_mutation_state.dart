import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';

enum UserStatus { initial, loading, error, success }

class UserMutationState extends Equatable {
  final UserStatus userStatus;
  final User? user;
  final String? message;
  final Failure? failure;

  const UserMutationState({
    required this.userStatus,
    this.user,
    this.message,
    this.failure,
  });

  factory UserMutationState.success({User? user, String? message}) {
    return UserMutationState(
      userStatus: UserStatus.success,
      user: user,
      message: message,
    );
  }

  factory UserMutationState.error({Failure? failure}) {
    return UserMutationState(
      userStatus: UserStatus.error,
      failure: failure,
      message: failure?.message,
    );
  }

  UserMutationState copyWith({
    UserStatus? userStatus,
    ValueGetter<User?>? user,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
  }) {
    return UserMutationState(
      userStatus: userStatus ?? this.userStatus,
      user: user != null ? user() : this.user,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [userStatus, user, message, failure];
}
