import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart';
import 'package:sigma_track/feature/notification/domain/usecases/create_notification_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/get_notifications_cursor_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/update_notification_usecase.dart';
import 'package:sigma_track/feature/notification/presentation/providers/state/notifications_state.dart';

class NotificationsNotifier extends AutoDisposeNotifier<NotificationsState> {
  GetNotificationsCursorUsecase get _getNotificationsCursorUsecase =>
      ref.watch(getNotificationsCursorUsecaseProvider);
  CreateNotificationUsecase get _createNotificationUsecase =>
      ref.watch(createNotificationUsecaseProvider);
  UpdateNotificationUsecase get _updateNotificationUsecase =>
      ref.watch(updateNotificationUsecaseProvider);
  DeleteNotificationUsecase get _deleteNotificationUsecase =>
      ref.watch(deleteNotificationUsecaseProvider);

  @override
  NotificationsState build() {
    this.logPresentation('Initializing NotificationsNotifier');
    _initializeNotifications();
    return NotificationsState.initial();
  }

  Future<void> _initializeNotifications() async {
    state = await _loadNotifications(
      notificationsFilter: NotificationsFilter(),
    );
  }

  Future<NotificationsState> _loadNotifications({
    required NotificationsFilter notificationsFilter,
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

  Future<void> updateFilter(NotificationsFilter newFilter) async {
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

  Future<void> createNotification(
    CreateNotificationUsecaseParams params,
  ) async {
    this.logPresentation('Creating notification');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _createNotificationUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create notification', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('Notification created successfully');

        state = state.copyWith(
          message: () => success.message ?? 'Notification created',
          isMutating: false,
        );

        await Future.delayed(const Duration(milliseconds: 100));

        state = state.copyWith(message: () => null, isLoading: true);

        state = await _loadNotifications(
          notificationsFilter: state.notificationsFilter,
        );
      },
    );
  }

  Future<void> updateNotification(
    UpdateNotificationUsecaseParams params,
  ) async {
    this.logPresentation('Updating notification: ${params.id}');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _updateNotificationUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to update notification', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('Notification updated successfully');

        state = state.copyWith(
          message: () => success.message ?? 'Notification updated',
          isMutating: false,
        );

        await Future.delayed(const Duration(milliseconds: 100));

        state = state.copyWith(message: () => null, isLoading: true);

        state = await _loadNotifications(
          notificationsFilter: state.notificationsFilter,
        );
      },
    );
  }

  Future<void> deleteNotification(
    DeleteNotificationUsecaseParams params,
  ) async {
    this.logPresentation('Deleting notification: ${params.id}');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _deleteNotificationUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete notification', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('Notification deleted successfully');

        state = state.copyWith(
          message: () => success.message ?? 'Notification deleted',
          isMutating: false,
        );

        await Future.delayed(const Duration(milliseconds: 100));

        state = state.copyWith(message: () => null, isLoading: true);

        state = await _loadNotifications(
          notificationsFilter: state.notificationsFilter,
        );
      },
    );
  }

  Future<void> deleteManyNotifications(List<String> notificationIds) async {
    this.logPresentation('Deleting ${notificationIds.length} notifications');

    // Todo: Tunggu backend impl
    await refresh();
  }

  Future<void> refresh() async {
    // * Preserve current filter when refreshing
    final currentFilter = state.notificationsFilter;
    state = state.copyWith(isLoading: true);
    state = await _loadNotifications(notificationsFilter: currentFilter);
  }
}
