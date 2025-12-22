import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_record_repository.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/create_maintenance_record_usecase.dart';

class BulkCreateMaintenanceRecordsUsecase
    implements
        Usecase<
          ItemSuccess<BulkCreateMaintenanceRecordsResponse>,
          BulkCreateMaintenanceRecordsParams
        > {
  final MaintenanceRecordRepository _maintenanceRecordRepository;

  BulkCreateMaintenanceRecordsUsecase(this._maintenanceRecordRepository);

  @override
  Future<Either<Failure, ItemSuccess<BulkCreateMaintenanceRecordsResponse>>>
  call(BulkCreateMaintenanceRecordsParams params) async {
    return await _maintenanceRecordRepository.createManyMaintenanceRecords(
      params,
    );
  }
}

class BulkCreateMaintenanceRecordsParams extends Equatable {
  final List<CreateMaintenanceRecordUsecaseParams> maintenanceRecords;

  const BulkCreateMaintenanceRecordsParams({required this.maintenanceRecords});

  Map<String, dynamic> toMap() {
    return {
      'maintenanceRecords': maintenanceRecords.map((x) => x.toMap()).toList(),
    };
  }

  factory BulkCreateMaintenanceRecordsParams.fromMap(Map<String, dynamic> map) {
    return BulkCreateMaintenanceRecordsParams(
      maintenanceRecords: List<CreateMaintenanceRecordUsecaseParams>.from(
        (map['maintenanceRecords'] as List).map(
          (x) => CreateMaintenanceRecordUsecaseParams.fromMap(
            x as Map<String, dynamic>,
          ),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateMaintenanceRecordsParams.fromJson(String source) =>
      BulkCreateMaintenanceRecordsParams.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [maintenanceRecords];
}

class BulkCreateMaintenanceRecordsResponse extends Equatable {
  final List<MaintenanceRecord> maintenanceRecords;

  const BulkCreateMaintenanceRecordsResponse({
    required this.maintenanceRecords,
  });

  Map<String, dynamic> toMap() {
    return {
      'maintenanceRecords': maintenanceRecords
          .map((x) => _maintenanceRecordToMap(x))
          .toList(),
    };
  }

  factory BulkCreateMaintenanceRecordsResponse.fromMap(
    Map<String, dynamic> map,
  ) {
    return BulkCreateMaintenanceRecordsResponse(
      maintenanceRecords: List<MaintenanceRecord>.from(
        (map['maintenanceRecords'] as List).map(
          (x) => _maintenanceRecordFromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateMaintenanceRecordsResponse.fromJson(String source) =>
      BulkCreateMaintenanceRecordsResponse.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [maintenanceRecords];

  static Map<String, dynamic> _maintenanceRecordToMap(
    MaintenanceRecord maintenanceRecord,
  ) {
    return {
      'id': maintenanceRecord.id,
      'scheduleId': maintenanceRecord.scheduleId,
      'assetId': maintenanceRecord.assetId,
      'maintenanceDate': maintenanceRecord.maintenanceDate.toIso8601String(),
      'completionDate': maintenanceRecord.completionDate?.toIso8601String(),
      'durationMinutes': maintenanceRecord.durationMinutes,
      'performedByUserId': maintenanceRecord.performedByUserId,
      'performedByVendor': maintenanceRecord.performedByVendor,
      'result': maintenanceRecord.result.value,
      'actualCost': maintenanceRecord.actualCost,
      'title': maintenanceRecord.title,
      'notes': maintenanceRecord.notes,
      'createdAt': maintenanceRecord.createdAt.toIso8601String(),
      'updatedAt': maintenanceRecord.updatedAt.toIso8601String(),
    };
  }

  static MaintenanceRecord _maintenanceRecordFromMap(Map<String, dynamic> map) {
    return MaintenanceRecord(
      id: map['id'] ?? '',
      scheduleId: map['scheduleId'],
      assetId: map['assetId'] ?? '',
      maintenanceDate: DateTime.parse(map['maintenanceDate'].toString()),
      completionDate: map['completionDate'] != null
          ? DateTime.parse(map['completionDate'].toString())
          : null,
      durationMinutes: map['durationMinutes']?.toInt(),
      performedByUserId: map['performedByUserId'],
      performedByVendor: map['performedByVendor'],
      result: MaintenanceResult.values.firstWhere(
        (e) => e.value == map['result'],
        orElse: () => MaintenanceResult.success,
      ),
      actualCost: map['actualCost']?.toDouble(),
      title: map['title'] ?? '',
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt'].toString()),
      updatedAt: DateTime.parse(map['updatedAt'].toString()),
    );
  }
}
