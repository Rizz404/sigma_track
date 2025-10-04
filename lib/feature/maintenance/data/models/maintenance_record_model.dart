import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/extensions/model_parsing_extension.dart';
import 'package:sigma_track/feature/asset/data/models/asset_model.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';

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
    String? notes,
  }) {
    return MaintenanceRecordTranslationModel(
      langCode: langCode ?? this.langCode,
      title: title ?? this.title,
      notes: notes ?? this.notes,
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

class MaintenanceScheduleModel extends Equatable {
  final String id;

  const MaintenanceScheduleModel({required this.id});

  @override
  List<Object> get props => [id];

  MaintenanceScheduleModel copyWith({String? id}) {
    return MaintenanceScheduleModel(id: id ?? this.id);
  }

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory MaintenanceScheduleModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceScheduleModel(id: map.getField<String>('id'));
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceScheduleModel.fromJson(String source) =>
      MaintenanceScheduleModel.fromMap(json.decode(source));

  @override
  String toString() => 'MaintenanceScheduleModel(id: $id)';
}

class MaintenanceRecordModel extends Equatable {
  final String id;
  final String? scheduleId;
  final String assetId;
  final DateTime maintenanceDate;
  final String? performedByUserId;
  final String? performedByVendor;
  final double? actualCost;
  final String title;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MaintenanceRecordTranslationModel> translations;
  final MaintenanceScheduleModel? schedule;
  final AssetModel asset;
  final UserModel? performedByUser;

  const MaintenanceRecordModel({
    required this.id,
    this.scheduleId,
    required this.assetId,
    required this.maintenanceDate,
    this.performedByUserId,
    this.performedByVendor,
    this.actualCost,
    required this.title,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.translations,
    this.schedule,
    required this.asset,
    this.performedByUser,
  });

  @override
  List<Object?> get props => [
    id,
    scheduleId,
    assetId,
    maintenanceDate,
    performedByUserId,
    performedByVendor,
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
    String? scheduleId,
    String? assetId,
    DateTime? maintenanceDate,
    String? performedByUserId,
    String? performedByVendor,
    double? actualCost,
    String? title,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<MaintenanceRecordTranslationModel>? translations,
    MaintenanceScheduleModel? schedule,
    AssetModel? asset,
    UserModel? performedByUser,
  }) {
    return MaintenanceRecordModel(
      id: id ?? this.id,
      scheduleId: scheduleId ?? this.scheduleId,
      assetId: assetId ?? this.assetId,
      maintenanceDate: maintenanceDate ?? this.maintenanceDate,
      performedByUserId: performedByUserId ?? this.performedByUserId,
      performedByVendor: performedByVendor ?? this.performedByVendor,
      actualCost: actualCost ?? this.actualCost,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      translations: translations ?? this.translations,
      schedule: schedule ?? this.schedule,
      asset: asset ?? this.asset,
      performedByUser: performedByUser ?? this.performedByUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scheduleId': scheduleId,
      'assetId': assetId,
      'maintenanceDate': maintenanceDate.millisecondsSinceEpoch,
      'performedByUserId': performedByUserId,
      'performedByVendor': performedByVendor,
      'actualCost': actualCost,
      'title': title,
      'notes': notes,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'translations': translations.map((x) => x.toMap()).toList(),
      'schedule': schedule?.toMap(),
      'asset': asset.toMap(),
      'performedByUser': performedByUser?.toMap(),
    };
  }

  factory MaintenanceRecordModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceRecordModel(
      id: map.getField<String>('id'),
      scheduleId: map.getFieldOrNull<String>('scheduleId'),
      assetId: map.getField<String>('assetId'),
      maintenanceDate: map.getDateTime('maintenanceDate'),
      performedByUserId: map.getFieldOrNull<String>('performedByUserId'),
      performedByVendor: map.getFieldOrNull<String>('performedByVendor'),
      actualCost: map.getFieldOrNull<double>('actualCost'),
      title: map.getField<String>('title'),
      notes: map.getFieldOrNull<String>('notes'),
      createdAt: map.getDateTime('createdAt'),
      updatedAt: map.getDateTime('updatedAt'),
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
      schedule: map.getFieldOrNull<Map<String, dynamic>>('schedule') != null
          ? MaintenanceScheduleModel.fromMap(
              map.getField<Map<String, dynamic>>('schedule'),
            )
          : null,
      asset: AssetModel.fromMap(map.getField<Map<String, dynamic>>('asset')),
      performedByUser:
          map.getFieldOrNull<Map<String, dynamic>>('performedByUser') != null
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
