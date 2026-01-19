import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';

class UpdateNotificationUsecase
    implements
        Usecase<ItemSuccess<Notification>, UpdateNotificationUsecaseParams> {
  final NotificationRepository _notificationRepository;

  UpdateNotificationUsecase(this._notificationRepository);

  @override
  Future<Either<Failure, ItemSuccess<Notification>>> call(
    UpdateNotificationUsecaseParams params,
  ) async {
    return await _notificationRepository.updateNotification(params);
  }
}

class UpdateNotificationUsecaseParams extends Equatable {
  final String id;
  final String? userId;
  final String? relatedAssetId;
  final NotificationType? type;
  final bool? isRead;
  final NotificationPriority? priority;
  final DateTime? expiresAt;
  final List<UpdateNotificationTranslation>? translations;

  UpdateNotificationUsecaseParams({
    required this.id,
    this.userId,
    this.relatedAssetId,
    this.type,
    this.isRead,
    this.priority,
    this.expiresAt,
    this.translations,
  });

  /// * Factory method to create params with only changed fields
  factory UpdateNotificationUsecaseParams.fromChanges({
    required String id,
    required Notification original,
    String? userId,
    String? relatedAssetId,
    NotificationType? type,
    bool? isRead,
    NotificationPriority? priority,
    DateTime? expiresAt,
    List<UpdateNotificationTranslation>? translations,
  }) {
    return UpdateNotificationUsecaseParams(
      id: id,
      userId: userId != original.userId ? userId : null,
      relatedAssetId: relatedAssetId != original.relatedAssetId
          ? relatedAssetId
          : null,
      type: type != original.type ? type : null,
      isRead: isRead != original.isRead ? isRead : null,
      priority: priority != original.priority ? priority : null,
      expiresAt: expiresAt != original.expiresAt ? expiresAt : null,
      translations: _areTranslationsEqual(original.translations, translations)
          ? null
          : translations,
    );
  }

  /// * Helper method to compare translations
  static bool _areTranslationsEqual(
    List<NotificationTranslation>? original,
    List<UpdateNotificationTranslation>? updated,
  ) {
    if (updated == null) return true;
    if (original == null || original.length != updated.length) return false;

    for (final upd in updated) {
      final orig = original.cast<NotificationTranslation?>().firstWhere(
        (o) => o?.langCode == upd.langCode,
        orElse: () => null,
      );
      if (orig == null) return false;
      if (orig.title != upd.title || orig.message != upd.message) return false;
    }
    return true;
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (userId != null) map['userId'] = userId;
    if (relatedAssetId != null) map['relatedAssetId'] = relatedAssetId;
    if (type != null) map['type'] = type!.value;
    if (isRead != null) map['isRead'] = isRead;
    if (priority != null) map['priority'] = priority!.value;
    if (expiresAt != null) map['expiresAt'] = expiresAt!.toIso8601String();
    if (translations != null) {
      map['translations'] = translations!.map((x) => x.toMap()).toList();
    }
    return map;
  }

  factory UpdateNotificationUsecaseParams.fromMap(Map<String, dynamic> map) {
    return UpdateNotificationUsecaseParams(
      id: map['id'] ?? '',
      userId: map['userId'],
      relatedAssetId: map['relatedAssetId'],
      type: map['type'] != null
          ? NotificationType.values.firstWhere((e) => e.value == map['type'])
          : null,
      isRead: map['isRead'],
      priority: map['priority'] != null
          ? NotificationPriority.values.firstWhere(
              (e) => e.value == map['priority'],
            )
          : null,
      expiresAt: map['expiresAt'] != null
          ? DateTime.parse(map['expiresAt'])
          : null,
      translations: map['translations'] != null
          ? List<UpdateNotificationTranslation>.from(
              map['translations']?.map(
                (x) => UpdateNotificationTranslation.fromMap(x),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateNotificationUsecaseParams.fromJson(String source) =>
      UpdateNotificationUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    id,
    userId,
    relatedAssetId,
    type,
    isRead,
    priority,
    expiresAt,
    translations,
  ];
}

class UpdateNotificationTranslation extends Equatable {
  final String langCode;
  final String title;
  final String message;

  const UpdateNotificationTranslation({
    required this.langCode,
    required this.title,
    required this.message,
  });

  @override
  List<Object> get props => [langCode, title, message];

  UpdateNotificationTranslation copyWith({
    String? langCode,
    String? title,
    String? message,
  }) {
    return UpdateNotificationTranslation(
      langCode: langCode ?? this.langCode,
      title: title ?? this.title,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'title': title, 'message': message};
  }

  factory UpdateNotificationTranslation.fromMap(Map<String, dynamic> map) {
    return UpdateNotificationTranslation(
      langCode: map['langCode'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateNotificationTranslation.fromJson(String source) =>
      UpdateNotificationTranslation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpdateNotificationTranslation(langCode: $langCode, title: $title, message: $message)';
  }
}
