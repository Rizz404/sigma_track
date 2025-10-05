import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart'
    as entities;

enum NotificationStatus { initial, loading, error, success }

class NotificationMutationState extends Equatable {
  final NotificationStatus notificationStatus;
  final entities.Notification? notification;
  final String? message;
  final Failure? failure;

  const NotificationMutationState({
    required this.notificationStatus,
    this.notification,
    this.message,
    this.failure,
  });

  factory NotificationMutationState.success({
    entities.Notification? notification,
    String? message,
  }) {
    return NotificationMutationState(
      notificationStatus: NotificationStatus.success,
      notification: notification,
      message: message,
    );
  }

  factory NotificationMutationState.error({Failure? failure}) {
    return NotificationMutationState(
      notificationStatus: NotificationStatus.error,
      failure: failure,
      message: failure?.message,
    );
  }

  NotificationMutationState copyWith({
    NotificationStatus? notificationStatus,
    ValueGetter<entities.Notification?>? notification,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
  }) {
    return NotificationMutationState(
      notificationStatus: notificationStatus ?? this.notificationStatus,
      notification: notification != null ? notification() : this.notification,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [
    notificationStatus,
    notification,
    message,
    failure,
  ];
}
