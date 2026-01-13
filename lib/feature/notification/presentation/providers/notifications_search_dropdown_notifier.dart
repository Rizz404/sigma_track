import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart';
import 'package:sigma_track/feature/notification/domain/usecases/get_notifications_cursor_usecase.dart';
import 'package:sigma_track/feature/notification/presentation/providers/state/notifications_state.dart';

class NotificationsSearchDropdownNotifier
    extends AutoDisposeNotifier<NotificationsState> {
  GetNotificationsCursorUsecase get _getNotificationsCursorUsecase =>
      ref.watch(getNotificationsCursorUsecaseProvider);

  @override
  NotificationsState build() {
    // * Cache search results for 1 minute (notification dropdown use case)
    ref.cacheFor(const Duration(minutes: 1));
    this.logPresentation('Initializing NotificationsSearchDropdownNotifier');
    _initializeNotifications();
    return NotificationsState.initial();
  }

  Future<void> _initializeNotifications() async {
    state = await _loadNotifications(
      notificationsFilter: GetNotificationsCursorUsecaseParams(),
    );
  }

  Future<NotificationsState> _loadNotifications({
    required GetNotificationsCursorUsecaseParams notificationsFilter,
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
          currentNotifications: null,
        );
      },
      (success) {
        this.logData(
          'Notifications loaded: ${success.data?.length ?? 0} items',
        );
        return NotificationsState.success(
          notifications: success.data as List<Notification>,
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

  void clear() {
    this.logPresentation('Clearing search results');
    state = NotificationsState.initial();
  }
}
