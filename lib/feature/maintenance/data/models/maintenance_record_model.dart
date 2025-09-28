import 'dart:convert';

import 'package:equatable/equatable.dart';
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

  Map<String, dynamic> toMap() {
    return {'langCode': langCode, 'title': title, 'notes': notes};
  }

  factory MaintenanceRecordTranslationModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceRecordTranslationModel(
      langCode: map['langCode'] ?? '',
      title: map['title'] ?? '',
      notes: map['notes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceRecordTranslationModel.fromJson(String source) =>
      MaintenanceRecordTranslationModel.fromMap(json.decode(source));
}

class MaintenanceScheduleModel extends Equatable {
  final String id;

  const MaintenanceScheduleModel({required this.id});

  @override
  List<Object> get props => [id];

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory MaintenanceScheduleModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceScheduleModel(id: map['id'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceScheduleModel.fromJson(String source) =>
      MaintenanceScheduleModel.fromMap(json.decode(source));
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
      id: map['id'] ?? '',
      scheduleId: map['scheduleId'],
      assetId: map['assetId'] ?? '',
      maintenanceDate: DateTime.fromMillisecondsSinceEpoch(
        map['maintenanceDate'],
      ),
      performedByUserId: map['performedByUserId'],
      performedByVendor: map['performedByVendor'],
      actualCost: map['actualCost']?.toDouble(),
      title: map['title'] ?? '',
      notes: map['notes'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      translations: List<MaintenanceRecordTranslationModel>.from(
        map['translations']?.map(
          (x) => MaintenanceRecordTranslationModel.fromMap(x),
        ),
      ),
      schedule: map['schedule'] != null
          ? MaintenanceScheduleModel.fromMap(map['schedule'])
          : null,
      asset: AssetModel.fromMap(map['asset']),
      performedByUser: map['performedByUser'] != null
          ? UserModel.fromMap(map['performedByUser'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MaintenanceRecordModel.fromJson(String source) =>
      MaintenanceRecordModel.fromMap(json.decode(source));
}
