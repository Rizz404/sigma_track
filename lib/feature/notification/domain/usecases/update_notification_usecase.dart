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
  final List<UpdateNotificationTranslation>? translations;

  UpdateNotificationUsecaseParams({
    required this.id,
    this.userId,
    this.relatedAssetId,
    this.type,
    this.isRead,
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
      translations: translations,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (userId != null) map['userId'] = userId;
    if (relatedAssetId != null) map['relatedAssetId'] = relatedAssetId;
    if (type != null) map['type'] = type!.value;
    if (isRead != null) map['isRead'] = isRead;
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
