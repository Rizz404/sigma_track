import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart'
    as domain_notification;

class NotificationsFilter extends Equatable {
  final String? search;
  final String? userId;
  final String? relatedAssetId;
  final NotificationType? type;
  final bool? isRead;
  final NotificationSortBy? sortBy;
  final SortOrder? sortOrder;
  final String? cursor;
  final int? limit;

  NotificationsFilter({
    this.search,
    this.userId,
    this.relatedAssetId,
    this.type,
    this.isRead,
    this.sortBy,
    this.sortOrder,
    this.cursor,
    this.limit,
  });

  NotificationsFilter copyWith({
    ValueGetter<String?>? search,
    ValueGetter<String?>? userId,
    ValueGetter<String?>? relatedAssetId,
    ValueGetter<NotificationType?>? type,
    ValueGetter<bool?>? isRead,
    ValueGetter<NotificationSortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<String?>? cursor,
    ValueGetter<int?>? limit,
  }) {
    return NotificationsFilter(
      search: search != null ? search() : this.search,
      userId: userId != null ? userId() : this.userId,
      relatedAssetId: relatedAssetId != null
          ? relatedAssetId()
          : this.relatedAssetId,
      type: type != null ? type() : this.type,
      isRead: isRead != null ? isRead() : this.isRead,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortOrder: sortOrder != null ? sortOrder() : this.sortOrder,
      cursor: cursor != null ? cursor() : this.cursor,
      limit: limit != null ? limit() : this.limit,
    );
  }

  @override
  List<Object?> get props {
    return [
      search,
      userId,
      relatedAssetId,
      type,
      isRead,
      sortBy,
      sortOrder,
      cursor,
      limit,
    ];
  }

  @override
  String toString() {
    return 'NotificationsFilter(search: $search, userId: $userId, relatedAssetId: $relatedAssetId, type: $type, isRead: $isRead, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';
  }
}

class NotificationsState extends Equatable {
  final List<domain_notification.Notification> notifications;
  final domain_notification.Notification? mutatedNotification;
  final NotificationsFilter notificationsFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isMutating;
  final String? message;
  final Failure? failure;
  final Cursor? cursor;

  const NotificationsState({
    this.notifications = const [],
    this.mutatedNotification,
    required this.notificationsFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isMutating = false,
    this.message,
    this.failure,
    this.cursor,
  });

  factory NotificationsState.initial() => NotificationsState(
    notificationsFilter: NotificationsFilter(),
    isLoading: true,
  );

  factory NotificationsState.loading({
    required NotificationsFilter notificationsFilter,
    List<domain_notification.Notification>? currentNotifications,
  }) => NotificationsState(
    notifications: currentNotifications ?? const [],
    notificationsFilter: notificationsFilter,
    isLoading: true,
  );

  factory NotificationsState.success({
    required List<domain_notification.Notification> notifications,
    required NotificationsFilter notificationsFilter,
    Cursor? cursor,
    String? message,
    domain_notification.Notification? mutatedNotification,
  }) => NotificationsState(
    notifications: notifications,
    notificationsFilter: notificationsFilter,
    cursor: cursor,
    message: message,
    mutatedNotification: mutatedNotification,
  );

  factory NotificationsState.error({
    required Failure failure,
    required NotificationsFilter notificationsFilter,
    List<domain_notification.Notification>? currentNotifications,
  }) => NotificationsState(
    notifications: currentNotifications ?? const [],
    notificationsFilter: notificationsFilter,
    failure: failure,
  );

  factory NotificationsState.loadingMore({
    required List<domain_notification.Notification> currentNotifications,
    required NotificationsFilter notificationsFilter,
    Cursor? cursor,
  }) => NotificationsState(
    notifications: currentNotifications,
    notificationsFilter: notificationsFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  NotificationsState copyWith({
    List<domain_notification.Notification>? notifications,
    ValueGetter<domain_notification.Notification?>? mutatedNotification,
    NotificationsFilter? notificationsFilter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isMutating,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      mutatedNotification: mutatedNotification != null
          ? mutatedNotification()
          : this.mutatedNotification,
      notificationsFilter: notificationsFilter ?? this.notificationsFilter,
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
      notifications,
      mutatedNotification,
      notificationsFilter,
      isLoading,
      isLoadingMore,
      isMutating,
      message,
      failure,
      cursor,
    ];
  }
}
