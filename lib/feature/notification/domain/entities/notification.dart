import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';

class Notification extends Equatable {
  final String id;
  final String userId;
  final String? relatedEntityType;
  final String? relatedEntityId;
  final String? relatedAssetId;
  final NotificationType type;
  final NotificationPriority priority;
  final bool isRead;
  final DateTime? readAt;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final String title;
  final String message;
  final List<NotificationTranslation>? translations;

  const Notification({
    required this.id,
    required this.userId,
    this.relatedEntityType,
    this.relatedEntityId,
    this.relatedAssetId,
    required this.type,
    required this.priority,
    required this.isRead,
    this.readAt,
    this.expiresAt,
    required this.createdAt,
    required this.title,
    required this.message,
    this.translations,
  });

  factory Notification.dummy() => Notification(
    id: '',
    userId: '',
    type: NotificationType.maintenance,
    priority: NotificationPriority.normal,
    isRead: false,
    createdAt: DateTime(0),
    title: '',
    message: '',
  );

  // * Helper untuk encode navigation data ke payload
  Map<String, String> toNavigationData() {
    return {
      'id': id,
      'type': type.value,
      if (relatedEntityType != null) 'entityType': relatedEntityType!,
      if (relatedEntityId != null) 'entityId': relatedEntityId!,
      if (relatedAssetId != null) 'assetId': relatedAssetId!,
    };
  }

  @override
  List<Object?> get props {
    return [
      id,
      userId,
      relatedEntityType,
      relatedEntityId,
      relatedAssetId,
      type,
      priority,
      isRead,
      readAt,
      expiresAt,
      createdAt,
      title,
      message,
      translations,
    ];
  }
}

class NotificationTranslation extends Equatable {
  final String id;
  final String notificationId;
  final String langCode;
  final String title;
  final String message;

  const NotificationTranslation({
    required this.id,
    required this.notificationId,
    required this.langCode,
    required this.title,
    required this.message,
  });

  @override
  List<Object> get props => [id, notificationId, langCode, title, message];
}
