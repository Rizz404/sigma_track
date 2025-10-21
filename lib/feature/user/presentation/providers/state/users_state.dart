import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_users_cursor_usecase.dart';

// * State untuk mutation operation yang lebih descriptive
class UserMutationState extends Equatable {
  final MutationType type;
  final bool isLoading;
  final String? successMessage;
  final Failure? failure;

  const UserMutationState({
    required this.type,
    this.isLoading = false,
    this.successMessage,
    this.failure,
  });

  bool get isSuccess => successMessage != null && failure == null;
  bool get isError => failure != null;

  @override
  List<Object?> get props => [type, isLoading, successMessage, failure];
}

class UsersState extends Equatable {
  final List<User> users;
  final GetUsersCursorUsecaseParams usersFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final UserMutationState? mutation;
  final Failure? failure;
  final Cursor? cursor;

  const UsersState({
    this.users = const [],
    required this.usersFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.mutation,
    this.failure,
    this.cursor,
  });

  // * Computed properties untuk kemudahan di UI
  bool get isMutating => mutation?.isLoading ?? false;
  bool get isCreating =>
      mutation?.type == MutationType.create && mutation!.isLoading;
  bool get isUpdating =>
      mutation?.type == MutationType.update && mutation!.isLoading;
  bool get isDeleting =>
      mutation?.type == MutationType.delete && mutation!.isLoading;
  bool get hasMutationSuccess => mutation?.isSuccess ?? false;
  bool get hasMutationError => mutation?.isError ?? false;
  String? get mutationMessage => mutation?.successMessage;
  Failure? get mutationFailure => mutation?.failure;

  // * Factory methods yang lebih descriptive
  factory UsersState.initial() =>
      UsersState(usersFilter: GetUsersCursorUsecaseParams(), isLoading: true);

  factory UsersState.loading({
    required GetUsersCursorUsecaseParams usersFilter,
    List<User>? currentUsers,
  }) => UsersState(
    users: currentUsers ?? const [],
    usersFilter: usersFilter,
    isLoading: true,
  );

  factory UsersState.success({
    required List<User> users,
    required GetUsersCursorUsecaseParams usersFilter,
    Cursor? cursor,
  }) => UsersState(users: users, usersFilter: usersFilter, cursor: cursor);

  factory UsersState.error({
    required Failure failure,
    required GetUsersCursorUsecaseParams usersFilter,
    List<User>? currentUsers,
  }) => UsersState(
    users: currentUsers ?? const [],
    usersFilter: usersFilter,
    failure: failure,
  );

  factory UsersState.loadingMore({
    required List<User> currentUsers,
    required GetUsersCursorUsecaseParams usersFilter,
    Cursor? cursor,
  }) => UsersState(
    users: currentUsers,
    usersFilter: usersFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  // * Factory methods untuk mutation states
  factory UsersState.creating({
    required List<User> currentUsers,
    required GetUsersCursorUsecaseParams usersFilter,
    Cursor? cursor,
  }) => UsersState(
    users: currentUsers,
    usersFilter: usersFilter,
    cursor: cursor,
    mutation: const UserMutationState(
      type: MutationType.create,
      isLoading: true,
    ),
  );

  factory UsersState.updating({
    required List<User> currentUsers,
    required GetUsersCursorUsecaseParams usersFilter,
    Cursor? cursor,
  }) => UsersState(
    users: currentUsers,
    usersFilter: usersFilter,
    cursor: cursor,
    mutation: const UserMutationState(
      type: MutationType.update,
      isLoading: true,
    ),
  );

  factory UsersState.deleting({
    required List<User> currentUsers,
    required GetUsersCursorUsecaseParams usersFilter,
    Cursor? cursor,
  }) => UsersState(
    users: currentUsers,
    usersFilter: usersFilter,
    cursor: cursor,
    mutation: const UserMutationState(
      type: MutationType.delete,
      isLoading: true,
    ),
  );

  factory UsersState.mutationSuccess({
    required List<User> users,
    required GetUsersCursorUsecaseParams usersFilter,
    required MutationType mutationType,
    required String message,
    Cursor? cursor,
  }) => UsersState(
    users: users,
    usersFilter: usersFilter,
    cursor: cursor,
    mutation: UserMutationState(type: mutationType, successMessage: message),
  );

  factory UsersState.mutationError({
    required List<User> currentUsers,
    required GetUsersCursorUsecaseParams usersFilter,
    required MutationType mutationType,
    required Failure failure,
    Cursor? cursor,
  }) => UsersState(
    users: currentUsers,
    usersFilter: usersFilter,
    cursor: cursor,
    mutation: UserMutationState(type: mutationType, failure: failure),
  );

  UsersState copyWith({
    List<User>? users,
    GetUsersCursorUsecaseParams? usersFilter,
    bool? isLoading,
    bool? isLoadingMore,
    ValueGetter<UserMutationState?>? mutation,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return UsersState(
      users: users ?? this.users,
      usersFilter: usersFilter ?? this.usersFilter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      mutation: mutation != null ? mutation() : this.mutation,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  // * Helper untuk clear mutation state setelah handled
  UsersState clearMutation() {
    return copyWith(mutation: () => null);
  }

  @override
  List<Object?> get props {
    return [
      users,
      usersFilter,
      isLoading,
      isLoadingMore,
      mutation,
      failure,
      cursor,
    ];
  }
}
