import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';

import 'package:sigma_track/core/extensions/model_parsing_extension.dart';
import 'package:sigma_track/core/extensions/date_time_extension.dart';

class NotificationModel extends Equatable {
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
  final List<NotificationTranslationModel>? translations;

  const NotificationModel({
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

  NotificationModel copyWith({
    String? id,
    String? userId,
    ValueGetter<String?>? relatedEntityType,
    ValueGetter<String?>? relatedEntityId,
    ValueGetter<String?>? relatedAssetId,
    NotificationType? type,
    NotificationPriority? priority,
    bool? isRead,
    ValueGetter<DateTime?>? readAt,
    ValueGetter<DateTime?>? expiresAt,
    DateTime? createdAt,
    String? title,
    String? message,
    ValueGetter<List<NotificationTranslationModel>?>? translations,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      relatedEntityType: relatedEntityType != null
          ? relatedEntityType()
          : this.relatedEntityType,
      relatedEntityId: relatedEntityId != null
          ? relatedEntityId()
          : this.relatedEntityId,
      relatedAssetId: relatedAssetId != null
          ? relatedAssetId()
          : this.relatedAssetId,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
      readAt: readAt != null ? readAt() : this.readAt,
      expiresAt: expiresAt != null ? expiresAt() : this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      message: message ?? this.message,
      translations: translations != null ? translations() : this.translations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'relatedEntityType': relatedEntityType,
      'relatedEntityId': relatedEntityId,
      'relatedAssetId': relatedAssetId,
      'type': type.value,
      'priority': priority.value,
      'isRead': isRead,
      'readAt': readAt?.iso8601String,
      'expiresAt': expiresAt?.iso8601String,
      'createdAt': createdAt.iso8601String,
      'title': title,
      'message': message,
      'translations': translations?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map.getField<String>('id'),
      userId: map.getField<String>('userId'),
      relatedEntityType: map.getFieldOrNull<String>('relatedEntityType'),
      relatedEntityId: map.getFieldOrNull<String>('relatedEntityId'),
      relatedAssetId: map.getFieldOrNull<String>('relatedAssetId'),
      type: NotificationType.values.firstWhere(
        (e) => e.value == map.getField<String>('type'),
        orElse: () => NotificationType.movement,
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.value == map.getField<String>('priority'),
        orElse: () => NotificationPriority.normal,
      ),
      isRead: map.getFieldOrNull<bool>('isRead') ?? false,
      readAt: map.getFieldOrNull<DateTime>('readAt'),
      expiresAt: map.getFieldOrNull<DateTime>('expiresAt'),
      createdAt: map.getField<DateTime>('createdAt'),
      title: map.getField<String>('title'),
      message: map.getField<String>('message'),
      translations: List<NotificationTranslationModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('translations')
                ?.map(
                  (x) => NotificationTranslationModel.fromMap(
                    x as Map<String, dynamic>,
                  ),
                ) ??
            [],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationModel(id: $id, userId: $userId, relatedEntityType: $relatedEntityType, relatedEntityId: $relatedEntityId, relatedAssetId: $relatedAssetId, type: $type, priority: $priority, isRead: $isRead, readAt: $readAt, expiresAt: $expiresAt, createdAt: $createdAt, title: $title, message: $message, translations: $translations)';
  }
}

class NotificationTranslationModel extends Equatable {
  final String id;
  final String notificationId;
  final String langCode;
  final String title;
  final String message;

  const NotificationTranslationModel({
    required this.id,
    required this.notificationId,
    required this.langCode,
    required this.title,
    required this.message,
  });

  @override
  List<Object> get props => [id, notificationId, langCode, title, message];

  NotificationTranslationModel copyWith({
    String? id,
    String? notificationId,
    String? langCode,
    String? title,
    String? message,
  }) {
    return NotificationTranslationModel(
      id: id ?? this.id,
      notificationId: notificationId ?? this.notificationId,
      langCode: langCode ?? this.langCode,
      title: title ?? this.title,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notificationId': notificationId,
      'langCode': langCode,
      'title': title,
      'message': message,
    };
  }

  factory NotificationTranslationModel.fromMap(Map<String, dynamic> map) {
    return NotificationTranslationModel(
      id: map.getField<String>('id'),
      notificationId: map.getField<String>('notificationId'),
      langCode: map.getField<String>('langCode'),
      title: map.getField<String>('title'),
      message: map.getField<String>('message'),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationTranslationModel.fromJson(String source) =>
      NotificationTranslationModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'NotificationTranslationModel(id: $id, notificationId: $notificationId, langCode: $langCode, title: $title, message: $message)';
}
