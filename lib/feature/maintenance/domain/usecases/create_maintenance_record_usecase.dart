import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
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
  final String? performedByUserId;
  final String? performedByVendor;
  final double? actualCost;
  final List<CreateMaintenanceRecordTranslation> translations;

  CreateMaintenanceRecordUsecaseParams({
    this.scheduleId,
    required this.assetId,
    required this.maintenanceDate,
    this.performedByUserId,
    this.performedByVendor,
    this.actualCost,
    required this.translations,
  });

  Map<String, dynamic> toMap() {
    return {
      if (scheduleId != null) 'scheduleId': scheduleId,
      'assetId': assetId,
      'maintenanceDate': maintenanceDate.toIso8601String(),
      if (performedByUserId != null) 'performedByUserId': performedByUserId,
      if (performedByVendor != null) 'performedByVendor': performedByVendor,
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
      performedByUserId: map['performedByUserId'],
      performedByVendor: map['performedByVendor'],
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
    performedByUserId,
    performedByVendor,
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
