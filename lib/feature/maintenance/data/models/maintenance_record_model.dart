import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/model_parsing_extension.dart';
import 'package:sigma_track/core/extensions/date_time_extension.dart';
import 'package:sigma_track/feature/asset/data/models/asset_model.dart';
import 'package:sigma_track/feature/maintenance/data/models/maintenance_schedule_model.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';

class MaintenanceRecordModel extends Equatable {
  final String id;
  final String? scheduleId;
  final String assetId;
  final DateTime maintenanceDate;
  final DateTime? completionDate;
  final int? durationMinutes;
  final String? performedByUserId;
  final String? performedByVendor;
  final MaintenanceResult result;
  final double? actualCost;
  final String title;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MaintenanceRecordTranslationModel>? translations;
  final MaintenanceScheduleModel? schedule;
  final AssetModel? asset;
  final UserModel? performedByUser;

  const MaintenanceRecordModel({
    required this.id,
    this.scheduleId,
    required this.assetId,
    required this.maintenanceDate,
    this.completionDate,
    this.durationMinutes,
    this.performedByUserId,
    this.performedByVendor,
    required this.result,
    this.actualCost,
    required this.title,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.translations,
    this.schedule,
    this.asset,
    this.performedByUser,
  });

  @override
  List<Object?> get props => [
    id,
    scheduleId,
    assetId,
    maintenanceDate,
    completionDate,
    durationMinutes,
    performedByUserId,
    performedByVendor,
    result,
    actualCost,
    title,
    notes,
    createdAt,
    updatedAt,
    translations,
    schedule,
    asset,
    performedByUser,
  ];

  MaintenanceRecordModel copyWith({
    String? id,
    ValueGetter<String?>? scheduleId,
    String? assetId,
    DateTime? maintenanceDate,
    ValueGetter<DateTime?>? completionDate,
    ValueGetter<int?>? durationMinutes,
    ValueGetter<String?>? performedByUserId,
    ValueGetter<String?>? performedByVendor,
    MaintenanceResult? result,
    ValueGetter<double?>? actualCost,
    String? title,
    ValueGetter<String?>? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    ValueGetter<List<MaintenanceRecordTranslationModel>?>? translations,
    ValueGetter<MaintenanceScheduleModel?>? schedule,
    ValueGetter<AssetModel?>? asset,
    ValueGetter<UserModel?>? performedByUser,
  }) {
    return MaintenanceRecordModel(
      id: id ?? this.id,
      scheduleId: scheduleId != null ? scheduleId() : this.scheduleId,
      assetId: assetId ?? this.assetId,
      maintenanceDate: maintenanceDate ?? this.maintenanceDate,
      completionDate: completionDate != null
          ? completionDate()
          : this.completionDate,
      durationMinutes: durationMinutes != null
          ? durationMinutes()
          : this.durationMinutes,
      performedByUserId: performedByUserId != null
          ? performedByUserId()
          : this.performedByUserId,
      performedByVendor: performedByVendor != null
          ? performedByVendor()
          : this.performedByVendor,
      result: result ?? this.result,
      actualCost: actualCost != null ? actualCost() : this.actualCost,
      title: title ?? this.title,
      notes: notes != null ? notes() : this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      translations: translations != null ? translations() : this.translations,
      schedule: schedule != null ? schedule() : this.schedule,
      asset: asset != null ? asset() : this.asset,
      performedByUser: performedByUser != null
          ? performedByUser()
          : this.performedByUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scheduleId': scheduleId,
      'assetId': assetId,
      'maintenanceDate': maintenanceDate.iso8601String,
      'completionDate': completionDate?.iso8601String,
      'durationMinutes': durationMinutes,
      'performedByUserId': performedByUserId,
      'performedByVendor': performedByVendor,
      'result': result.value,
      'actualCost': actualCost,
      'title': title,
      'notes': notes,
      'createdAt': createdAt.iso8601String,
      'updatedAt': updatedAt.iso8601String,
      'translations': translations?.map((x) => x.toMap()).toList() ?? [],
      'schedule': schedule?.toMap(),
      'asset': asset?.toMap(),
      'performedByUser': performedByUser?.toMap(),
    };
  }

  factory MaintenanceRecordModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceRecordModel(
      id: map.getField<String>('id'),
      scheduleId: map.getFieldOrNull<String>('scheduleId'),
      assetId: map.getField<String>('assetId'),
      maintenanceDate: map.getField<DateTime>('maintenanceDate'),
      completionDate: map.getFieldOrNull<DateTime>('completionDate'),
      durationMinutes: map.getFieldOrNull<int>('durationMinutes'),
      performedByUserId: map.getFieldOrNull<String>('performedByUserId'),
      performedByVendor: map.getFieldOrNull<String>('performedByVendor'),
      result: MaintenanceResult.values.firstWhere(
        (e) => e.value == map.getField<String>('result'),
        orElse: () => MaintenanceResult.success,
      ),
      actualCost: map.getFieldOrNull<double>('actualCost'),
      title: map.getField<String>('title'),
      notes: map.getFieldOrNull<String>('notes'),
      createdAt: map.getField<DateTime>('createdAt'),
      updatedAt: map.getField<DateTime>('updatedAt'),
      translations: List<MaintenanceRecordTranslationModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('translations')
                ?.map(
                  (x) => MaintenanceRecordTranslationModel.fromMap(
                    x as Map<String, dynamic>,
                  ),
                ) ??
            [],
      ),
      schedule:
          map.getFieldOrNull<Map<String, dynamic>>('schedule') != null &&
              (map.getFieldOrNull<Map<String, dynamic>>('schedule')?['id']
                          as String?)
                      ?.isNotEmpty ==
                  true
          ? MaintenanceScheduleModel.fromMap(
              map.getField<Map<String, dynamic>>('schedule'),
            )
          : null,
      asset:
          map.getFieldOrNull<Map<String, dynamic>>('asset') != null &&
              (map.getFieldOrNull<Map<String, dynamic>>('asset')?['id']
                          as String?)
                      ?.isNotEmpty ==
                  true
          ? AssetModel.fromMap(map.getField<Map<String, dynamic>>('asset'))
          : null,
      performedByUser:
          map.getFieldOrNull<Map<String, dynamic>>('performedByUser') != null &&
              (map.getFieldOrNull<Map<String, dynamic>>(
                            'performedByUser',
                          )?['id']
                          as String?)
                      ?.isNotEmpty ==
                  true
          ? UserModel.fromMap(
              map.getField<Map<String, dynamic>>('performedByUser'),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceRecordModel.fromJson(String source) =>
      MaintenanceRecordModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MaintenanceRecordModel(id: $id, scheduleId: $scheduleId, assetId: $assetId, maintenanceDate: $maintenanceDate, performedByUserId: $performedByUserId, performedByVendor: $performedByVendor, actualCost: $actualCost, title: $title, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, translations: $translations, schedule: $schedule, asset: $asset, performedByUser: $performedByUser)';
  }
}

class MaintenanceRecordTranslationModel extends Equatable {
  final String langCode;
  final String title;
  final String? notes;

  const MaintenanceRecordTranslationModel({
    required this.langCode,
    required this.title,
    this.notes,
  });

  @override
  List<Object?> get props => [langCode, title, notes];

  MaintenanceRecordTranslationModel copyWith({
    String? langCode,
    String? title,
    ValueGetter<String?>? notes,
  }) {
    return MaintenanceRecordTranslationModel(
      langCode: langCode ?? this.langCode,
      title: title ?? this.title,
      notes: notes != null ? notes() : this.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'title': title, 'notes': notes};
  }

  factory MaintenanceRecordTranslationModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceRecordTranslationModel(
      langCode: map.getField<String>('langCode'),
      title: map.getField<String>('title'),
      notes: map.getFieldOrNull<String>('notes'),
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceRecordTranslationModel.fromJson(String source) =>
      MaintenanceRecordTranslationModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'MaintenanceRecordTranslationModel(langCode: $langCode, title: $title, notes: $notes)';
}
