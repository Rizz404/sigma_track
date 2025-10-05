import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';

class UsersFilter extends Equatable {
  final String? search;
  final String? role;
  final bool? isActive;
  final String? employeeId;
  final UserSortBy? sortBy;
  final SortOrder? sortOrder;
  final int? limit;
  final String? cursor;

  UsersFilter({
    this.search,
    this.role,
    this.isActive,
    this.employeeId,
    this.sortBy,
    this.sortOrder,
    this.limit,
    this.cursor,
  });

  UsersFilter copyWith({
    ValueGetter<String?>? search,
    ValueGetter<String?>? role,
    ValueGetter<bool?>? isActive,
    ValueGetter<String?>? employeeId,
    ValueGetter<UserSortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<int?>? limit,
    ValueGetter<String?>? cursor,
  }) {
    return UsersFilter(
      search: search != null ? search() : this.search,
      role: role != null ? role() : this.role,
      isActive: isActive != null ? isActive() : this.isActive,
      employeeId: employeeId != null ? employeeId() : this.employeeId,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortOrder: sortOrder != null ? sortOrder() : this.sortOrder,
      limit: limit != null ? limit() : this.limit,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  @override
  List<Object?> get props {
    return [
      search,
      role,
      isActive,
      employeeId,
      sortBy,
      sortOrder,
      limit,
      cursor,
    ];
  }

  @override
  String toString() {
    return 'UsersFilter(search: $search, role: $role, isActive: $isActive, employeeId: $employeeId, sortBy: $sortBy, sortOrder: $sortOrder, limit: $limit, cursor: $cursor)';
  }
}

class UsersState extends Equatable {
  final List<User> users;
  final User? mutatedUser;
  final UsersFilter usersFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isMutating;
  final String? message;
  final Failure? failure;
  final Cursor? cursor;

  const UsersState({
    this.users = const [],
    this.mutatedUser,
    required this.usersFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isMutating = false,
    this.message,
    this.failure,
    this.cursor,
  });

  factory UsersState.initial() =>
      UsersState(usersFilter: UsersFilter(), isLoading: true);

  factory UsersState.loading({
    required UsersFilter usersFilter,
    List<User>? currentUsers,
  }) => UsersState(
    users: currentUsers ?? const [],
    usersFilter: usersFilter,
    isLoading: true,
  );

  factory UsersState.success({
    required List<User> users,
    required UsersFilter usersFilter,
    Cursor? cursor,
    String? message,
    User? mutatedUser,
  }) => UsersState(
    users: users,
    usersFilter: usersFilter,
    cursor: cursor,
    message: message,
    mutatedUser: mutatedUser,
  );

  factory UsersState.error({
    required Failure failure,
    required UsersFilter usersFilter,
    List<User>? currentUsers,
  }) => UsersState(
    users: currentUsers ?? const [],
    usersFilter: usersFilter,
    failure: failure,
  );

  factory UsersState.loadingMore({
    required List<User> currentUsers,
    required UsersFilter usersFilter,
    Cursor? cursor,
  }) => UsersState(
    users: currentUsers,
    usersFilter: usersFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  UsersState copyWith({
    List<User>? users,
    ValueGetter<User?>? mutatedUser,
    UsersFilter? usersFilter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isMutating,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return UsersState(
      users: users ?? this.users,
      mutatedUser: mutatedUser != null ? mutatedUser() : this.mutatedUser,
      usersFilter: usersFilter ?? this.usersFilter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMutating: isMutating ?? this.isMutating,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  @override
  List<Object?> get props {
    return [
      users,
      mutatedUser,
      usersFilter,
      isLoading,
      isLoadingMore,
      isMutating,
      message,
      failure,
      cursor,
    ];
  }
}
