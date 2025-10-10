import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';

// * State untuk single user (getById, getByEmail, getByName, getCurrentUser)
class CurrentUserState extends Equatable {
  final User? user;
  final User? mutatedUser;
  final bool isLoading;
  final bool isMutating;
  final String? message;
  final Failure? failure;

  const CurrentUserState({
    this.user,
    this.mutatedUser,
    this.isLoading = false,
    this.isMutating = false,
    this.message,
    this.failure,
  });

  factory CurrentUserState.initial() => const CurrentUserState(isLoading: true);

  factory CurrentUserState.loading() => const CurrentUserState(isLoading: true);

  factory CurrentUserState.success(
    User user, {
    String? message,
    User? mutatedUser,
  }) =>
      CurrentUserState(user: user, message: message, mutatedUser: mutatedUser);

  factory CurrentUserState.error(Failure failure) =>
      CurrentUserState(failure: failure);

  factory CurrentUserState.mutating({User? currentUser, User? mutatedUser}) =>
      CurrentUserState(
        user: currentUser,
        mutatedUser: mutatedUser,
        isMutating: true,
      );

  CurrentUserState copyWith({
    ValueGetter<User?>? user,
    ValueGetter<User?>? mutatedUser,
    bool? isLoading,
    bool? isMutating,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
  }) {
    return CurrentUserState(
      user: user != null ? user() : this.user,
      mutatedUser: mutatedUser != null ? mutatedUser() : this.mutatedUser,
      isLoading: isLoading ?? this.isLoading,
      isMutating: isMutating ?? this.isMutating,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [
    user,
    mutatedUser,
    isLoading,
    isMutating,
    message,
    failure,
  ];
}
