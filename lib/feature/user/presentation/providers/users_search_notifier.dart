import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_users_cursor_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/users_state.dart';

class UsersSearchNotifier extends AutoDisposeNotifier<UsersState> {
  GetUsersCursorUsecase get _getUsersCursorUsecase =>
      ref.watch(getUsersCursorUsecaseProvider);

  @override
  UsersState build() {
    // * Cache search results for 2 minutes (dropdown use case)
    ref.cacheFor(const Duration(minutes: 2));
    this.logPresentation('Initializing UsersSearchNotifier');
    return UsersState.initial();
  }

  Future<UsersState> _loadUsers({required UsersFilter usersFilter}) async {
    this.logPresentation('Loading users with filter: $usersFilter');

    final result = await _getUsersCursorUsecase.call(
      GetUsersCursorUsecaseParams(
        search: usersFilter.search,
        role: usersFilter.role,
        isActive: usersFilter.isActive,
        employeeId: usersFilter.employeeId,
        sortBy: usersFilter.sortBy,
        sortOrder: usersFilter.sortOrder,
        cursor: usersFilter.cursor,
        limit: usersFilter.limit,
      ),
    );

    return result.fold(
      (failure) {
        this.logError('Failed to load users', failure);
        return UsersState.error(
          failure: failure,
          usersFilter: usersFilter,
          currentUsers: null,
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

  void clear() {
    this.logPresentation('Clearing search results');
    state = UsersState.initial();
  }
}
