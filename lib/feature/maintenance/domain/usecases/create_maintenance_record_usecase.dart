import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/date_time_extension.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_record_repository.dart';

class CreateMaintenanceRecordUsecase
    implements
        Usecase<
          ItemSuccess<MaintenanceRecord>,
          CreateMaintenanceRecordUsecaseParams
        > {
  final MaintenanceRecordRepository _maintenanceRecordRepository;

  CreateMaintenanceRecordUsecase(this._maintenanceRecordRepository);

  @override
  Future<Either<Failure, ItemSuccess<MaintenanceRecord>>> call(
    CreateMaintenanceRecordUsecaseParams params,
  ) async {
    return await _maintenanceRecordRepository.createMaintenanceRecord(params);
  }
}

class CreateMaintenanceRecordUsecaseParams extends Equatable {
  final String? scheduleId;
  final String assetId;
  final DateTime maintenanceDate;
  final DateTime? completionDate;
  final int? durationMinutes;
  final String? performedByUserId;
  final String? performedByVendor;
  final MaintenanceResult result;
  final double? actualCost;
  final List<CreateMaintenanceRecordTranslation> translations;

  CreateMaintenanceRecordUsecaseParams({
    this.scheduleId,
    required this.assetId,
    required this.maintenanceDate,
    this.completionDate,
    this.durationMinutes,
    this.performedByUserId,
    this.performedByVendor,
    required this.result,
    this.actualCost,
    required this.translations,
  });

  Map<String, dynamic> toMap() {
    return {
      if (scheduleId != null) 'scheduleId': scheduleId,
      'assetId': assetId,
      'maintenanceDate': maintenanceDate.iso8601Date,
      if (completionDate != null) 'completionDate': completionDate!.iso8601Date,
      if (durationMinutes != null) 'durationMinutes': durationMinutes,
      if (performedByUserId != null) 'performedByUserId': performedByUserId,
      if (performedByVendor != null) 'performedByVendor': performedByVendor,
      'result': result.value,
      if (actualCost != null) 'actualCost': actualCost,
      'translations': translations.map((x) => x.toMap()).toList(),
    };
  }

  factory CreateMaintenanceRecordUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return CreateMaintenanceRecordUsecaseParams(
      scheduleId: map['scheduleId'],
      assetId: map['assetId'] ?? '',
      maintenanceDate: DateTime.parse(map['maintenanceDate']),
      completionDate: map['completionDate'] != null
          ? DateTime.parse(map['completionDate'])
          : null,
      durationMinutes: map['durationMinutes'],
      performedByUserId: map['performedByUserId'],
      performedByVendor: map['performedByVendor'],
      result: MaintenanceResult.values.firstWhere(
        (e) => e.value == map['result'],
        orElse: () => MaintenanceResult.success,
      ),
      actualCost: map['actualCost']?.toDouble(),
      translations: List<CreateMaintenanceRecordTranslation>.from(
        map['translations']?.map(
              (x) => CreateMaintenanceRecordTranslation.fromMap(x),
            ) ??
            [],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateMaintenanceRecordUsecaseParams.fromJson(String source) =>
      CreateMaintenanceRecordUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    scheduleId,
    assetId,
    maintenanceDate,
    completionDate,
    durationMinutes,
    performedByUserId,
    performedByVendor,
    result,
    actualCost,
    translations,
  ];
}

class CreateMaintenanceRecordTranslation extends Equatable {
  final String langCode;
  final String title;
  final String? notes;

  CreateMaintenanceRecordTranslation({
    required this.langCode,
    required this.title,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'langCode': langCode,
      'title': title,
      if (notes != null) 'notes': notes,
    };
  }

  factory CreateMaintenanceRecordTranslation.fromMap(Map<String, dynamic> map) {
    return CreateMaintenanceRecordTranslation(
      langCode: map['langCode'] ?? '',
      title: map['title'] ?? '',
      notes: map['notes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateMaintenanceRecordTranslation.fromJson(String source) =>
      CreateMaintenanceRecordTranslation.fromMap(json.decode(source));

  @override
  List<Object?> get props => [langCode, title, notes];
}
