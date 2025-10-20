import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/model_parsing_extension.dart';
import 'package:sigma_track/core/extensions/date_time_extension.dart';
import 'package:sigma_track/feature/asset/data/models/asset_model.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';

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
  final List<MaintenanceScheduleTranslationModel>? translations;
  final AssetModel? asset;
  final UserModel? createdBy;

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
    this.translations,
    this.asset,
    this.createdBy,
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
      'maintenanceType': maintenanceType.value,
      'scheduledDate': scheduledDate.iso8601String,
      'frequencyMonths': frequencyMonths,
      'status': status.value,
      'createdById': createdById,
      'createdAt': createdAt.iso8601String,
      'title': title,
      'description': description,
      'translations': translations?.map((x) => x.toMap()).toList() ?? [],
      'asset': asset?.toMap(),
      'createdBy': createdBy?.toMap(),
    };
  }

  factory MaintenanceScheduleModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceScheduleModel(
      id: map.getField<String>('id'),
      assetId: map.getField<String>('assetId'),
      maintenanceType: MaintenanceScheduleType.values.firstWhere(
        (e) => e.value == map.getField<String>('maintenanceType'),
      ),
      scheduledDate: map.getField<DateTime>('scheduledDate'),
      frequencyMonths: map.getFieldOrNull<int>('frequencyMonths'),
      status: ScheduleStatus.values.firstWhere(
        (e) => e.value == map.getField<String>('status'),
      ),
      createdById: map.getField<String>('createdById'),
      createdAt: map.getField<DateTime>('createdAt'),
      title: map.getField<String>('title'),
      description: map.getFieldOrNull<String>('description'),
      translations: List<MaintenanceScheduleTranslationModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('translations')
                ?.map(
                  (x) => MaintenanceScheduleTranslationModel.fromMap(
                    x as Map<String, dynamic>,
                  ),
                ) ??
            [],
      ),
      asset:
          map.getFieldOrNull<Map<String, dynamic>>('asset') != null &&
              (map.getFieldOrNull<Map<String, dynamic>>('asset')?['id']
                          as String?)
                      ?.isNotEmpty ==
                  true
          ? AssetModel.fromMap(map.getField<Map<String, dynamic>>('asset'))
          : null,
      createdBy:
          map.getFieldOrNull<Map<String, dynamic>>('createdBy') != null &&
              (map.getFieldOrNull<Map<String, dynamic>>('createdBy')?['id']
                          as String?)
                      ?.isNotEmpty ==
                  true
          ? UserModel.fromMap(map.getField<Map<String, dynamic>>('createdBy'))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceScheduleModel.fromJson(String source) =>
      MaintenanceScheduleModel.fromMap(json.decode(source));
}

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
      langCode: map.getField<String>('langCode'),
      title: map.getField<String>('title'),
      description: map.getFieldOrNull<String>('description'),
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceScheduleTranslationModel.fromJson(String source) =>
      MaintenanceScheduleTranslationModel.fromMap(json.decode(source));
}
