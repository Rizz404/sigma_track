import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart';
import 'package:sigma_track/feature/notification/domain/usecases/get_notifications_cursor_usecase.dart';
import 'package:sigma_track/feature/notification/presentation/providers/state/notifications_state.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_current_user_usecase.dart';

class MyNotificationsNotifier extends AutoDisposeNotifier<NotificationsState> {
  GetNotificationsCursorUsecase get _getNotificationsCursorUsecase =>
      ref.watch(getNotificationsCursorUsecaseProvider);
  GetCurrentUserUsecase get _getCurrentUserUsecase =>
      ref.watch(getCurrentUserUsecaseProvider);

  @override
  NotificationsState build() {
    this.logPresentation('Initializing MyNotificationsNotifier');
    _initializeNotifications();
    return NotificationsState.initial();
  }

  Future<void> _initializeNotifications() async {
    final userResult = await _getCurrentUserUsecase.call(NoParams());
    final userId = userResult.fold((failure) {
      this.logError('Failed to get current user', failure);
      return null;
    }, (success) => success.data?.id);
    state = await _loadNotifications(
      notificationsFilter: GetNotificationsCursorUsecaseParams(userId: userId),
    );
  }

  Future<NotificationsState> _loadNotifications({
    required GetNotificationsCursorUsecaseParams notificationsFilter,
    List<Notification>? currentNotifications,
  }) async {
    this.logPresentation(
      'Loading notifications with filter: $notificationsFilter',
    );

    final result = await _getNotificationsCursorUsecase.call(
      GetNotificationsCursorUsecaseParams(
        search: notificationsFilter.search,
        userId: notificationsFilter.userId,
        relatedAssetId: notificationsFilter.relatedAssetId,
        type: notificationsFilter.type,
        isRead: notificationsFilter.isRead,
        sortBy: notificationsFilter.sortBy,
        sortOrder: notificationsFilter.sortOrder,
        cursor: notificationsFilter.cursor,
        limit: notificationsFilter.limit,
      ),
    );

    return result.fold(
      (failure) {
        this.logError('Failed to load notifications', failure);
        return NotificationsState.error(
          failure: failure,
          notificationsFilter: notificationsFilter,
          currentNotifications: currentNotifications,
        );
      },
      (success) {
        this.logData(
          'Notifications loaded: ${success.data?.length ?? 0} items',
        );
        return NotificationsState.success(
          notifications: (success.data ?? []).cast<Notification>(),
          notificationsFilter: notificationsFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> search(String search) async {
    this.logPresentation('Searching notifications: $search');

    final newFilter = state.notificationsFilter.copyWith(
      search: () => search.isEmpty ? null : search,
      cursor: () => null,
    );

    state = state.copyWith(isLoading: true);
    state = await _loadNotifications(notificationsFilter: newFilter);
  }

  Future<void> updateFilter(
    GetNotificationsCursorUsecaseParams newFilter,
  ) async {
    this.logPresentation('Updating filter: $newFilter');

    // * Preserve search from current filter
    final filterWithResetCursor = newFilter.copyWith(
      search: () => state.notificationsFilter.search,
      cursor: () => null,
    );

    this.logPresentation('Filter after merge: $filterWithResetCursor');
    state = state.copyWith(isLoading: true);
    state = await _loadNotifications(
      notificationsFilter: filterWithResetCursor,
    );
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

    this.logPresentation('Loading more notifications');

    state = NotificationsState.loadingMore(
      currentNotifications: state.notifications,
      notificationsFilter: state.notificationsFilter,
      cursor: state.cursor,
    );

    final newFilter = state.notificationsFilter.copyWith(
      cursor: () => state.cursor?.nextCursor,
    );

    final result = await _getNotificationsCursorUsecase.call(
      GetNotificationsCursorUsecaseParams(
        search: newFilter.search,
        userId: newFilter.userId,
        relatedAssetId: newFilter.relatedAssetId,
        type: newFilter.type,
        isRead: newFilter.isRead,
        sortBy: newFilter.sortBy,
        sortOrder: newFilter.sortOrder,
        cursor: newFilter.cursor,
        limit: newFilter.limit,
      ),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load more notifications', failure);
        state = NotificationsState.error(
          failure: failure,
          notificationsFilter: newFilter,
          currentNotifications: state.notifications,
        );
      },
      (success) {
        this.logData('More notifications loaded: ${success.data?.length ?? 0}');
        state = NotificationsState.success(
          notifications: [
            ...state.notifications,
            ...(success.data ?? []).cast<Notification>(),
          ],
          notificationsFilter: newFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> refresh() async {
    // * Preserve current filter when refreshing
    final currentFilter = state.notificationsFilter;
    state = state.copyWith(isLoading: true);
    state = await _loadNotifications(notificationsFilter: currentFilter);
  }
}
