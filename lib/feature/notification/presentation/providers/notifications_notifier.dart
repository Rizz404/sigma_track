import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart';
import 'package:sigma_track/feature/notification/domain/usecases/create_notification_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/get_notifications_cursor_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/mark_notifications_as_read_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/mark_notifications_as_unread_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/update_notification_usecase.dart';
import 'package:sigma_track/feature/notification/presentation/providers/state/notifications_state.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_current_user_usecase.dart';

class NotificationsNotifier extends AutoDisposeNotifier<NotificationsState> {
  GetNotificationsCursorUsecase get _getNotificationsCursorUsecase =>
      ref.watch(getNotificationsCursorUsecaseProvider);
  CreateNotificationUsecase get _createNotificationUsecase =>
      ref.watch(createNotificationUsecaseProvider);
  UpdateNotificationUsecase get _updateNotificationUsecase =>
      ref.watch(updateNotificationUsecaseProvider);
  DeleteNotificationUsecase get _deleteNotificationUsecase =>
      ref.watch(deleteNotificationUsecaseProvider);
  MarkNotificationsAsReadUsecase get _markNotificationsAsReadUsecase =>
      ref.watch(markNotificationsAsReadUsecaseProvider);
  MarkNotificationsAsUnreadUsecase get _markNotificationsAsUnreadUsecase =>
      ref.watch(markNotificationsAsUnreadUsecaseProvider);
  GetCurrentUserUsecase get _getCurrentUserUsecase =>
      ref.watch(getCurrentUserUsecaseProvider);

  @override
  NotificationsState build() {
    this.logPresentation('Initializing NotificationsNotifier');
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
      notificationsFilter,
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

  Future<void> createNotification(
    CreateNotificationUsecaseParams params,
  ) async {
    this.logPresentation('Creating notification');

    state = NotificationsState.creating(
      currentNotifications: state.notifications,
      notificationsFilter: state.notificationsFilter,
      cursor: state.cursor,
    );

    final result = await _createNotificationUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create notification', failure);
        state = NotificationsState.mutationError(
          currentNotifications: state.notifications,
          notificationsFilter: state.notificationsFilter,
          mutationType: MutationType.create,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Notification created successfully');

        state = state.copyWith(isLoading: true);

        state = await _loadNotifications(
          notificationsFilter: state.notificationsFilter,
        );

        state = NotificationsState.mutationSuccess(
          notifications: state.notifications,
          notificationsFilter: state.notificationsFilter,
          mutationType: MutationType.create,
          message: success.message ?? 'Notification created',
          cursor: state.cursor,
        );
      },
    );
  }

  Future<void> updateNotification(
    UpdateNotificationUsecaseParams params,
  ) async {
    this.logPresentation('Updating notification: ${params.id}');

    state = NotificationsState.updating(
      currentNotifications: state.notifications,
      notificationsFilter: state.notificationsFilter,
      cursor: state.cursor,
    );

    final result = await _updateNotificationUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to update notification', failure);
        state = NotificationsState.mutationError(
          currentNotifications: state.notifications,
          notificationsFilter: state.notificationsFilter,
          mutationType: MutationType.update,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Notification updated successfully');

        state = state.copyWith(isLoading: true);

        state = await _loadNotifications(
          notificationsFilter: state.notificationsFilter,
        );

        state = NotificationsState.mutationSuccess(
          notifications: state.notifications,
          notificationsFilter: state.notificationsFilter,
          mutationType: MutationType.update,
          message: success.message ?? 'Notification updated',
          cursor: state.cursor,
        );
      },
    );
  }

  Future<void> deleteNotification(
    DeleteNotificationUsecaseParams params,
  ) async {
    this.logPresentation('Deleting notification: ${params.id}');

    state = NotificationsState.deleting(
      currentNotifications: state.notifications,
      notificationsFilter: state.notificationsFilter,
      cursor: state.cursor,
    );

    final result = await _deleteNotificationUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete notification', failure);
        state = NotificationsState.mutationError(
          currentNotifications: state.notifications,
          notificationsFilter: state.notificationsFilter,
          mutationType: MutationType.delete,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Notification deleted successfully');

        state = state.copyWith(isLoading: true);

        state = await _loadNotifications(
          notificationsFilter: state.notificationsFilter,
        );

        state = NotificationsState.mutationSuccess(
          notifications: state.notifications,
          notificationsFilter: state.notificationsFilter,
          mutationType: MutationType.delete,
          message: success.message ?? 'Notification deleted',
          cursor: state.cursor,
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

  Future<void> markAsRead(String id) async {
    this.logPresentation('Marking notification as read: $id');
    final result = await _markNotificationsAsReadUsecase.call(
      MarkNotificationsAsReadUsecaseParams(notificationIds: [id]),
    );

    result.fold((failure) => this.logError('Failed to mark as read', failure), (
      success,
    ) {
      state = state.copyWith(
        notifications: state.notifications.map((n) {
          if (n.id == id) return n.copyWith(isRead: true);
          return n;
        }).toList(),
      );
    });
  }

  Future<void> markAsUnread(String id) async {
    this.logPresentation('Marking notification as unread: $id');
    final result = await _markNotificationsAsUnreadUsecase.call(
      MarkNotificationsAsUnreadUsecaseParams(notificationIds: [id]),
    );

    result.fold(
      (failure) => this.logError('Failed to mark as unread', failure),
      (success) {
        state = state.copyWith(
          notifications: state.notifications.map((n) {
            if (n.id == id) return n.copyWith(isRead: false);
            return n;
          }).toList(),
        );
      },
    );
  }

  Future<void> markManyAsRead(List<String> ids) async {
    this.logPresentation('Marking ${ids.length} notifications as read');
    final result = await _markNotificationsAsReadUsecase.call(
      MarkNotificationsAsReadUsecaseParams(notificationIds: ids),
    );

    result.fold(
      (failure) => this.logError('Failed to mark many as read', failure),
      (success) {
        state = state.copyWith(
          notifications: state.notifications.map((n) {
            if (ids.contains(n.id)) return n.copyWith(isRead: true);
            return n;
          }).toList(),
        );
      },
    );
  }

  Future<void> markManyAsUnread(List<String> ids) async {
    this.logPresentation('Marking ${ids.length} notifications as unread');
    final result = await _markNotificationsAsUnreadUsecase.call(
      MarkNotificationsAsUnreadUsecaseParams(notificationIds: ids),
    );

    result.fold(
      (failure) => this.logError('Failed to mark many as unread', failure),
      (success) {
        state = state.copyWith(
          notifications: state.notifications.map((n) {
            if (ids.contains(n.id)) return n.copyWith(isRead: false);
            return n;
          }).toList(),
        );
      },
    );
  }
}
