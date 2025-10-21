import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart'
    as domain_notification;
import 'package:sigma_track/feature/notification/domain/usecases/get_notifications_cursor_usecase.dart';

// * State untuk mutation operation yang lebih descriptive
class NotificationMutationState extends Equatable {
  final MutationType type;
  final bool isLoading;
  final String? successMessage;
  final Failure? failure;

  const NotificationMutationState({
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

class NotificationsState extends Equatable {
  final List<domain_notification.Notification> notifications;
  final GetNotificationsCursorUsecaseParams notificationsFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final NotificationMutationState? mutation;
  final Failure? failure;
  final Cursor? cursor;

  const NotificationsState({
    this.notifications = const [],
    required this.notificationsFilter,
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
  factory NotificationsState.initial() => const NotificationsState(
    notificationsFilter: GetNotificationsCursorUsecaseParams(),
    isLoading: true,
  );

  factory NotificationsState.loading({
    required GetNotificationsCursorUsecaseParams notificationsFilter,
    List<domain_notification.Notification>? currentNotifications,
  }) => NotificationsState(
    notifications: currentNotifications ?? const [],
    notificationsFilter: notificationsFilter,
    isLoading: true,
  );

  factory NotificationsState.success({
    required List<domain_notification.Notification> notifications,
    required GetNotificationsCursorUsecaseParams notificationsFilter,
    Cursor? cursor,
  }) => NotificationsState(
    notifications: notifications,
    notificationsFilter: notificationsFilter,
    cursor: cursor,
  );

  factory NotificationsState.error({
    required Failure failure,
    required GetNotificationsCursorUsecaseParams notificationsFilter,
    List<domain_notification.Notification>? currentNotifications,
  }) => NotificationsState(
    notifications: currentNotifications ?? const [],
    notificationsFilter: notificationsFilter,
    failure: failure,
  );

  factory NotificationsState.loadingMore({
    required List<domain_notification.Notification> currentNotifications,
    required GetNotificationsCursorUsecaseParams notificationsFilter,
    Cursor? cursor,
  }) => NotificationsState(
    notifications: currentNotifications,
    notificationsFilter: notificationsFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  // * Factory methods untuk mutation states
  factory NotificationsState.creating({
    required List<domain_notification.Notification> currentNotifications,
    required GetNotificationsCursorUsecaseParams notificationsFilter,
    Cursor? cursor,
  }) => NotificationsState(
    notifications: currentNotifications,
    notificationsFilter: notificationsFilter,
    cursor: cursor,
    mutation: const NotificationMutationState(
      type: MutationType.create,
      isLoading: true,
    ),
  );

  factory NotificationsState.updating({
    required List<domain_notification.Notification> currentNotifications,
    required GetNotificationsCursorUsecaseParams notificationsFilter,
    Cursor? cursor,
  }) => NotificationsState(
    notifications: currentNotifications,
    notificationsFilter: notificationsFilter,
    cursor: cursor,
    mutation: const NotificationMutationState(
      type: MutationType.update,
      isLoading: true,
    ),
  );

  factory NotificationsState.deleting({
    required List<domain_notification.Notification> currentNotifications,
    required GetNotificationsCursorUsecaseParams notificationsFilter,
    Cursor? cursor,
  }) => NotificationsState(
    notifications: currentNotifications,
    notificationsFilter: notificationsFilter,
    cursor: cursor,
    mutation: const NotificationMutationState(
      type: MutationType.delete,
      isLoading: true,
    ),
  );

  factory NotificationsState.mutationSuccess({
    required List<domain_notification.Notification> notifications,
    required GetNotificationsCursorUsecaseParams notificationsFilter,
    required MutationType mutationType,
    required String message,
    Cursor? cursor,
  }) => NotificationsState(
    notifications: notifications,
    notificationsFilter: notificationsFilter,
    cursor: cursor,
    mutation: NotificationMutationState(
      type: mutationType,
      successMessage: message,
    ),
  );

  factory NotificationsState.mutationError({
    required List<domain_notification.Notification> currentNotifications,
    required GetNotificationsCursorUsecaseParams notificationsFilter,
    required MutationType mutationType,
    required Failure failure,
    Cursor? cursor,
  }) => NotificationsState(
    notifications: currentNotifications,
    notificationsFilter: notificationsFilter,
    cursor: cursor,
    mutation: NotificationMutationState(type: mutationType, failure: failure),
  );

  NotificationsState copyWith({
    List<domain_notification.Notification>? notifications,
    GetNotificationsCursorUsecaseParams? notificationsFilter,
    bool? isLoading,
    bool? isLoadingMore,
    ValueGetter<NotificationMutationState?>? mutation,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      notificationsFilter: notificationsFilter ?? this.notificationsFilter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      mutation: mutation != null ? mutation() : this.mutation,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  // * Helper untuk clear mutation state setelah handled
  NotificationsState clearMutation() {
    return copyWith(mutation: () => null);
  }

  @override
  List<Object?> get props {
    return [
      notifications,
      notificationsFilter,
      isLoading,
      isLoadingMore,
      mutation,
      failure,
      cursor,
    ];
  }
}
