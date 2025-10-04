import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/feature/asset/data/models/asset_model.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';

class MaintenanceScheduleTranslationModel extends Equatable {
  final String langCode;
  final String title;
  final String? description;

  const MaintenanceScheduleTranslationModel({
    required this.langCode,
    required this.title,
    this.description,
  });

  @override
  List<Object?> get props => [langCode, title, description];

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'title': title, 'description': description};
  }

  factory MaintenanceScheduleTranslationModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return MaintenanceScheduleTranslationModel(
      langCode: map['langCode'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceScheduleTranslationModel.fromJson(String source) =>
      MaintenanceScheduleTranslationModel.fromMap(json.decode(source));
}

class MaintenanceScheduleModel extends Equatable {
  final String id;
  final String assetId;
  final MaintenanceScheduleType maintenanceType;
  final DateTime scheduledDate;
  final int? frequencyMonths;
  final ScheduleStatus status;
  final String createdById;
  final DateTime createdAt;
  final String title;
  final String? description;
  final List<MaintenanceScheduleTranslationModel> translations;
  final AssetModel asset;
  final UserModel createdBy;

  const MaintenanceScheduleModel({
    required this.id,
    required this.assetId,
    required this.maintenanceType,
    required this.scheduledDate,
    this.frequencyMonths,
    required this.status,
    required this.createdById,
    required this.createdAt,
    required this.title,
    this.description,
    required this.translations,
    required this.asset,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [
    id,
    assetId,
    maintenanceType,
    scheduledDate,
    frequencyMonths,
    status,
    createdById,
    createdAt,
    title,
    description,
    translations,
    asset,
    createdBy,
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assetId': assetId,
      'maintenanceType': maintenanceType.toJson(),
      'scheduledDate': scheduledDate.millisecondsSinceEpoch,
      'frequencyMonths': frequencyMonths,
      'status': status.toJson(),
      'createdById': createdById,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'title': title,
      'description': description,
      'translations': translations.map((x) => x.toMap()).toList(),
      'asset': asset.toMap(),
      'createdBy': createdBy.toMap(),
    };
  }

  factory MaintenanceScheduleModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceScheduleModel(
      id: map['id'] ?? '',
      assetId: map['assetId'] ?? '',
      maintenanceType: MaintenanceScheduleType.fromJson(map['maintenanceType']),
      scheduledDate: DateTime.fromMillisecondsSinceEpoch(map['scheduledDate']),
      frequencyMonths: map['frequencyMonths']?.toInt(),
      status: ScheduleStatus.fromJson(map['status']),
      createdById: map['createdById'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] as String),
      title: map['title'] ?? '',
      description: map['description'],
      translations: List<MaintenanceScheduleTranslationModel>.from(
        map['translations']?.map(
          (x) => MaintenanceScheduleTranslationModel.fromMap(x),
        ),
      ),
      asset: AssetModel.fromMap(map['asset']),
      createdBy: UserModel.fromMap(map['createdBy']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceScheduleModel.fromJson(String source) =>
      MaintenanceScheduleModel.fromMap(json.decode(source));
}
