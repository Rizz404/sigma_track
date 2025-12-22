import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';
import 'package:sigma_track/feature/notification/domain/usecases/create_notification_usecase.dart';

class BulkCreateNotificationsUsecase
    implements
        Usecase<
          ItemSuccess<BulkCreateNotificationsResponse>,
          BulkCreateNotificationsParams
        > {
  final NotificationRepository _notificationRepository;

  BulkCreateNotificationsUsecase(this._notificationRepository);

  @override
  Future<Either<Failure, ItemSuccess<BulkCreateNotificationsResponse>>> call(
    BulkCreateNotificationsParams params,
  ) async {
    return await _notificationRepository.createManyNotifications(params);
  }
}

class BulkCreateNotificationsParams extends Equatable {
  final List<CreateNotificationUsecaseParams> notifications;

  const BulkCreateNotificationsParams({required this.notifications});

  Map<String, dynamic> toMap() {
    return {'notifications': notifications.map((x) => x.toMap()).toList()};
  }

  factory BulkCreateNotificationsParams.fromMap(Map<String, dynamic> map) {
    return BulkCreateNotificationsParams(
      notifications: List<CreateNotificationUsecaseParams>.from(
        (map['notifications'] as List).map(
          (x) => CreateNotificationUsecaseParams.fromMap(
            x as Map<String, dynamic>,
          ),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateNotificationsParams.fromJson(String source) =>
      BulkCreateNotificationsParams.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [notifications];
}

class BulkCreateNotificationsResponse extends Equatable {
  final List<Notification> notifications;

  const BulkCreateNotificationsResponse({required this.notifications});

  Map<String, dynamic> toMap() {
    return {
      'notifications': notifications.map((x) => _notificationToMap(x)).toList(),
    };
  }

  factory BulkCreateNotificationsResponse.fromMap(Map<String, dynamic> map) {
    return BulkCreateNotificationsResponse(
      notifications: List<Notification>.from(
        (map['notifications'] as List).map(
          (x) => _notificationFromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateNotificationsResponse.fromJson(String source) =>
      BulkCreateNotificationsResponse.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [notifications];

  static Map<String, dynamic> _notificationToMap(Notification notification) {
    return {
      'id': notification.id,
      'userId': notification.userId,
      'relatedEntityType': notification.relatedEntityType,
      'relatedEntityId': notification.relatedEntityId,
      'relatedAssetId': notification.relatedAssetId,
      'type': notification.type.value,
      'priority': notification.priority.value,
      'title': notification.title,
      'message': notification.message,
      'isRead': notification.isRead,
      'readAt': notification.readAt?.toIso8601String(),
      'expiresAt': notification.expiresAt?.toIso8601String(),
      'createdAt': notification.createdAt.toIso8601String(),
    };
  }

  static Notification _notificationFromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      relatedEntityType: map['relatedEntityType'],
      relatedEntityId: map['relatedEntityId'],
      relatedAssetId: map['relatedAssetId'],
      type: NotificationType.values.firstWhere(
        (e) => e.value == map['type'],
        orElse: () => NotificationType.maintenance,
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.value == map['priority'],
        orElse: () => NotificationPriority.normal,
      ),
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      isRead: map['isRead'] ?? false,
      readAt: map['readAt'] != null
          ? DateTime.parse(map['readAt'].toString())
          : null,
      expiresAt: map['expiresAt'] != null
          ? DateTime.parse(map['expiresAt'].toString())
          : null,
      createdAt: DateTime.parse(map['createdAt'].toString()),
    );
  }
}
