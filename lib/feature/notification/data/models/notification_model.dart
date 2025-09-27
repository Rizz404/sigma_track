import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';

class NotificationModel extends Equatable {
  final String id;
  final String userID;
  final String? relatedAssetID;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final String title;
  final String message;
  final List<NotificationTranslationModel> translations;

  const NotificationModel({
    required this.id,
    required this.userID,
    this.relatedAssetID,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.title,
    required this.message,
    required this.translations,
  });

  @override
  List<Object?> get props {
    return [
      id,
      userID,
      relatedAssetID,
      type,
      isRead,
      createdAt,
      title,
      message,
      translations,
    ];
  }

  NotificationModel copyWith({
    String? id,
    String? userID,
    String? relatedAssetID,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
    String? title,
    String? message,
    List<NotificationTranslationModel>? translations,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      relatedAssetID: relatedAssetID ?? this.relatedAssetID,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      message: message ?? this.message,
      translations: translations ?? this.translations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userID,
      'relatedAssetId': relatedAssetID,
      'type': type.toJson(),
      'isRead': isRead,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'title': title,
      'message': message,
      'translations': translations.map((x) => x.toMap()).toList(),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      userID: map['userId'] ?? '',
      relatedAssetID: map['relatedAssetId'],
      type: NotificationType.fromJson(map['type']),
      isRead: map['isRead'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      translations: List<NotificationTranslationModel>.from(
        map['translations']?.map(
          (x) => NotificationTranslationModel.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationModel(id: $id, userID: $userID, relatedAssetID: $relatedAssetID, type: $type, isRead: $isRead, createdAt: $createdAt, title: $title, message: $message, translations: $translations)';
  }
}

class NotificationTranslationModel extends Equatable {
  final String langCode;
  final String title;
  final String message;

  const NotificationTranslationModel({
    required this.langCode,
    required this.title,
    required this.message,
  });

  @override
  List<Object> get props => [langCode, title, message];

  NotificationTranslationModel copyWith({
    String? langCode,
    String? title,
    String? message,
  }) {
    return NotificationTranslationModel(
      langCode: langCode ?? this.langCode,
      title: title ?? this.title,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'title': title, 'message': message};
  }

  factory NotificationTranslationModel.fromMap(Map<String, dynamic> map) {
    return NotificationTranslationModel(
      langCode: map['langCode'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationTranslationModel.fromJson(String source) =>
      NotificationTranslationModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'NotificationTranslationModel(langCode: $langCode, title: $title, message: $message)';
}
