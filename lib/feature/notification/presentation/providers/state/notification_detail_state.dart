import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart';

// * State untuk single notification (getById)
class NotificationDetailState extends Equatable {
  final Notification? notification;
  final bool isLoading;
  final Failure? failure;

  const NotificationDetailState({
    this.notification,
    this.isLoading = false,
    this.failure,
  });

  factory NotificationDetailState.initial() =>
      const NotificationDetailState(isLoading: true);

  factory NotificationDetailState.loading() =>
      const NotificationDetailState(isLoading: true);

  factory NotificationDetailState.success(Notification notification) =>
      NotificationDetailState(notification: notification);

  factory NotificationDetailState.error(Failure failure) =>
      NotificationDetailState(failure: failure);

  NotificationDetailState copyWith({
    Notification? notification,
    bool? isLoading,
    Failure? failure,
  }) {
    return NotificationDetailState(
      notification: notification ?? this.notification,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [notification, isLoading, failure];
}
