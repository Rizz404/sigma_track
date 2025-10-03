import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';

class CreateNotificationUsecase
    implements
        Usecase<ItemSuccess<Notification>, CreateNotificationUsecaseParams> {
  final NotificationRepository _notificationRepository;

  CreateNotificationUsecase(this._notificationRepository);

  @override
  Future<Either<Failure, ItemSuccess<Notification>>> call(
    CreateNotificationUsecaseParams params,
  ) async {
    return await _notificationRepository.createNotification(params);
  }
}

class CreateNotificationUsecaseParams extends Equatable {
  final String userId;
  final String? relatedAssetId;
  final NotificationType type;
  final List<CreateNotificationTranslation> translations;

  CreateNotificationUsecaseParams({
    required this.userId,
    this.relatedAssetId,
    required this.type,
    required this.translations,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'relatedAssetId': relatedAssetId,
      'type': type.toJson(),
      'translations': translations.map((x) => x.toMap()).toList(),
    };
  }

  factory CreateNotificationUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CreateNotificationUsecaseParams(
      userId: map['userId'] ?? '',
      relatedAssetId: map['relatedAssetId'],
      type: NotificationType.fromJson(map['type']),
      translations: List<CreateNotificationTranslation>.from(
        map['translations']?.map(
          (x) => CreateNotificationTranslation.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateNotificationUsecaseParams.fromJson(String source) =>
      CreateNotificationUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [userId, relatedAssetId, type, translations];
}

class CreateNotificationTranslation extends Equatable {
  final String langCode;
  final String title;
  final String message;

  const CreateNotificationTranslation({
    required this.langCode,
    required this.title,
    required this.message,
  });

  @override
  List<Object> get props => [langCode, title, message];

  CreateNotificationTranslation copyWith({
    String? langCode,
    String? title,
    String? message,
  }) {
    return CreateNotificationTranslation(
      langCode: langCode ?? this.langCode,
      title: title ?? this.title,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'title': title, 'message': message};
  }

  factory CreateNotificationTranslation.fromMap(Map<String, dynamic> map) {
    return CreateNotificationTranslation(
      langCode: map['langCode'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateNotificationTranslation.fromJson(String source) =>
      CreateNotificationTranslation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CreateNotificationTranslation(langCode: $langCode, title: $title, message: $message)';
  }
}
