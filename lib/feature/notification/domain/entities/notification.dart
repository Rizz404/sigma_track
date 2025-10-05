import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';

class Notification extends Equatable {
  final String id;
  final String userId;
  final String? relatedAssetId;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final String title;
  final String message;
  final List<NotificationTranslation>? translations;

  const Notification({
    required this.id,
    required this.userId,
    this.relatedAssetId,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.title,
    required this.message,
    this.translations,
  });

  @override
  List<Object?> get props {
    return [
      id,
      userId,
      relatedAssetId,
      type,
      isRead,
      createdAt,
      title,
      message,
      translations,
    ];
  }
}

class NotificationTranslation extends Equatable {
  final String langCode;
  final String title;
  final String message;

  const NotificationTranslation({
    required this.langCode,
    required this.title,
    required this.message,
  });

  @override
  List<Object> get props => [langCode, title, message];
}
