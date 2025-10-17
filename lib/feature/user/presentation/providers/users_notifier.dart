import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/domain/usecases/create_user_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/delete_user_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_users_cursor_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/change_user_password_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/update_user_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/users_state.dart';

class UsersNotifier extends AutoDisposeNotifier<UsersState> {
  GetUsersCursorUsecase get _getUsersCursorUsecase =>
      ref.watch(getUsersCursorUsecaseProvider);
  CreateUserUsecase get _createUserUsecase =>
      ref.watch(createUserUsecaseProvider);
  UpdateUserUsecase get _updateUserUsecase =>
      ref.watch(updateUserUsecaseProvider);
  DeleteUserUsecase get _deleteUserUsecase =>
      ref.watch(deleteUserUsecaseProvider);
  ChangeUserPasswordUsecase get _changeUserPasswordUsecase =>
      ref.watch(changeUserPasswordUsecaseProvider);

  @override
  UsersState build() {
    this.logPresentation('Initializing UsersNotifier');
    _initializeUsers();
    return UsersState.initial();
  }

  Future<void> _initializeUsers() async {
    state = await _loadUsers(usersFilter: UsersFilter());
  }

  Future<UsersState> _loadUsers({
    required UsersFilter usersFilter,
    List<User>? currentUsers,
  }) async {
    this.logPresentation('Loading users with filter: $usersFilter');

    final result = await _getUsersCursorUsecase.call(
      GetUsersCursorUsecaseParams(
        search: usersFilter.search,
        role: usersFilter.role,
        isActive: usersFilter.isActive,
        employeeId: usersFilter.employeeId,
        sortBy: usersFilter.sortBy,
        sortOrder: usersFilter.sortOrder,
        limit: usersFilter.limit,
        cursor: usersFilter.cursor,
      ),
    );

    return result.fold(
      (failure) {
        this.logError('Failed to load users', failure);
        return UsersState.error(
          failure: failure,
          usersFilter: usersFilter,
          currentUsers: currentUsers,
        );
      },
      (success) {
        this.logData('Users loaded: ${success.data?.length ?? 0} items');
        return UsersState.success(
          users: success.data ?? [],
          usersFilter: usersFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> search(String search) async {
    this.logPresentation('Searching users: $search');

    final newFilter = state.usersFilter.copyWith(
      search: () => search.isEmpty ? null : search,
      cursor: () => null,
    );

    state = state.copyWith(isLoading: true);
    state = await _loadUsers(usersFilter: newFilter);
  }

  Future<void> updateFilter(UsersFilter newFilter) async {
    this.logPresentation('Updating filter: $newFilter');

    // * Preserve search from current filter
    final filterWithResetCursor = newFilter.copyWith(
      search: () => state.usersFilter.search,
      cursor: () => null,
    );

    this.logPresentation('Filter after merge: $filterWithResetCursor');
    state = state.copyWith(isLoading: true);
    state = await _loadUsers(usersFilter: filterWithResetCursor);
  }

  Future<void> loadMore() async {
    if (state.cursor == null || !state.cursor!.hasNextPage) {
      this.logPresentation('No more pages to load');
      return;
    }

    if (state.isLoadingMore) {
      this.logPresentation('Already loading more');
      return;
    }

    this.logPresentation('Loading more users');

    state = UsersState.loadingMore(
      currentUsers: state.users,
      usersFilter: state.usersFilter,
      cursor: state.cursor,
    );

    final newFilter = state.usersFilter.copyWith(
      cursor: () => state.cursor?.nextCursor,
    );

    final result = await _getUsersCursorUsecase.call(
      GetUsersCursorUsecaseParams(
        search: newFilter.search,
        role: newFilter.role,
        isActive: newFilter.isActive,
        employeeId: newFilter.employeeId,
        sortBy: newFilter.sortBy,
        sortOrder: newFilter.sortOrder,
        limit: newFilter.limit,
        cursor: newFilter.cursor,
      ),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load more users', failure);
        state = UsersState.error(
          failure: failure,
          usersFilter: newFilter,
          currentUsers: state.users,
        );
      },
      (success) {
        this.logData('More users loaded: ${success.data?.length ?? 0}');
        state = UsersState.success(
          users: [...state.users, ...success.data ?? []],
          usersFilter: newFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> createUser(CreateUserUsecaseParams params) async {
    this.logPresentation('Creating user');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _createUserUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create user', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('User created successfully');

        state = state.copyWith(
          message: () => success.message ?? 'User created',
          isMutating: false,
        );

        await Future.delayed(const Duration(milliseconds: 100));

        state = state.copyWith(message: () => null, isLoading: true);

        state = await _loadUsers(usersFilter: state.usersFilter);
      },
    );
  }

  Future<void> updateUser(UpdateUserUsecaseParams params) async {
    this.logPresentation('Updating user: ${params.id}');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _updateUserUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to update user', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('User updated successfully');

        state = state.copyWith(
          message: () => success.message ?? 'User updated',
          isMutating: false,
        );

        await Future.delayed(const Duration(milliseconds: 100));

        state = state.copyWith(message: () => null, isLoading: true);

        state = await _loadUsers(usersFilter: state.usersFilter);
      },
    );
  }

  Future<void> deleteUser(DeleteUserUsecaseParams params) async {
    this.logPresentation('Deleting user: ${params.id}');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _deleteUserUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete user', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('User deleted successfully');

        state = state.copyWith(
          message: () => success.message ?? 'User deleted',
          isMutating: false,
        );

        await Future.delayed(const Duration(milliseconds: 100));

        state = state.copyWith(message: () => null, isLoading: true);

        state = await _loadUsers(usersFilter: state.usersFilter);
      },
    );
  }

  Future<void> changeUserPassword(
    ChangeUserPasswordUsecaseParams params,
  ) async {
    this.logPresentation('Changing password for user: ${params.id}');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _changeUserPasswordUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to change user password', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('User password changed successfully');
        state = state.copyWith(
          message: () => success.message ?? 'Password changed',
          isMutating: false,
        );
        // Note: No refresh needed as password change doesn't affect user list
      },
    );
  }

  Future<void> deleteManyUsers(List<String> userIds) async {
    this.logPresentation('Deleting ${userIds.length} users');

    // Todo: Tunggu backend impl
    await refresh();
  }

  Future<void> refresh() async {
    // * Preserve current filter when refreshing
    final currentFilter = state.usersFilter;
    state = state.copyWith(isLoading: true);
    state = await _loadUsers(usersFilter: currentFilter);
  }
}
