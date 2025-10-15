import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_record_repository.dart';

class UpdateMaintenanceRecordUsecase
    implements
        Usecase<
          ItemSuccess<MaintenanceRecord>,
          UpdateMaintenanceRecordUsecaseParams
        > {
  final MaintenanceRecordRepository _maintenanceRecordRepository;

  UpdateMaintenanceRecordUsecase(this._maintenanceRecordRepository);

  @override
  Future<Either<Failure, ItemSuccess<MaintenanceRecord>>> call(
    UpdateMaintenanceRecordUsecaseParams params,
  ) async {
    return await _maintenanceRecordRepository.updateMaintenanceRecord(params);
  }
}

class UpdateMaintenanceRecordUsecaseParams extends Equatable {
  final String id;
  final String? scheduleId;
  final String? assetId;
  final DateTime? maintenanceDate;
  final String? performedByUserId;
  final String? performedByVendor;
  final double? actualCost;
  final List<UpdateMaintenanceRecordTranslation>? translations;

  UpdateMaintenanceRecordUsecaseParams({
    required this.id,
    this.scheduleId,
    this.assetId,
    this.maintenanceDate,
    this.performedByUserId,
    this.performedByVendor,
    this.actualCost,
    this.translations,
  });

  /// * Factory method to create params with only changed fields
  factory UpdateMaintenanceRecordUsecaseParams.fromChanges({
    required String id,
    required MaintenanceRecord original,
    String? scheduleId,
    String? assetId,
    DateTime? maintenanceDate,
    String? performedByUserId,
    String? performedByVendor,
    double? actualCost,
    List<UpdateMaintenanceRecordTranslation>? translations,
  }) {
    return UpdateMaintenanceRecordUsecaseParams(
      id: id,
      scheduleId: scheduleId != original.scheduleId ? scheduleId : null,
      assetId: assetId != original.assetId ? assetId : null,
      maintenanceDate: maintenanceDate != original.maintenanceDate
          ? maintenanceDate
          : null,
      performedByUserId: performedByUserId != original.performedByUserId
          ? performedByUserId
          : null,
      performedByVendor: performedByVendor != original.performedByVendor
          ? performedByVendor
          : null,
      actualCost: actualCost != original.actualCost ? actualCost : null,
      translations: translations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (scheduleId != null) 'scheduleId': scheduleId,
      if (assetId != null) 'assetId': assetId,
      if (maintenanceDate != null)
        'maintenanceDate': maintenanceDate!.toIso8601String(),
      if (performedByUserId != null) 'performedByUserId': performedByUserId,
      if (performedByVendor != null) 'performedByVendor': performedByVendor,
      if (actualCost != null) 'actualCost': actualCost,
      if (translations != null)
        'translations': translations!.map((x) => x.toMap()).toList(),
    };
  }

  factory UpdateMaintenanceRecordUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return UpdateMaintenanceRecordUsecaseParams(
      id: map['id'] ?? '',
      scheduleId: map['scheduleId'],
      assetId: map['assetId'],
      maintenanceDate: map['maintenanceDate'] != null
          ? DateTime.parse(map['maintenanceDate'])
          : null,
      performedByUserId: map['performedByUserId'],
      performedByVendor: map['performedByVendor'],
      actualCost: map['actualCost']?.toDouble(),
      translations: map['translations'] != null
          ? List<UpdateMaintenanceRecordTranslation>.from(
              map['translations']?.map(
                    (x) => UpdateMaintenanceRecordTranslation.fromMap(x),
                  ) ??
                  [],
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateMaintenanceRecordUsecaseParams.fromJson(String source) =>
      UpdateMaintenanceRecordUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    id,
    scheduleId,
    assetId,
    maintenanceDate,
    performedByUserId,
    performedByVendor,
    actualCost,
    translations,
  ];
}

class UpdateMaintenanceRecordTranslation extends Equatable {
  final String langCode;
  final String? title;
  final String? notes;

  UpdateMaintenanceRecordTranslation({
    required this.langCode,
    this.title,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'langCode': langCode,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
    };
  }

  factory UpdateMaintenanceRecordTranslation.fromMap(Map<String, dynamic> map) {
    return UpdateMaintenanceRecordTranslation(
      langCode: map['langCode'] ?? '',
      title: map['title'],
      notes: map['notes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateMaintenanceRecordTranslation.fromJson(String source) =>
      UpdateMaintenanceRecordTranslation.fromMap(json.decode(source));

  @override
  List<Object?> get props => [langCode, title, notes];
}
