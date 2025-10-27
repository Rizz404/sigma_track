import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';

class MaintenanceRecord extends Equatable {
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
  final List<MaintenanceRecordTranslation>? translations;
  final MaintenanceSchedule? schedule;
  final Asset? asset;
  final User? performedByUser;

  const MaintenanceRecord({
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

  factory MaintenanceRecord.dummy() => MaintenanceRecord(
    id: '',
    assetId: '',
    maintenanceDate: DateTime(0),
    result: MaintenanceResult.success,
    title: '',
    createdAt: DateTime(0),
    updatedAt: DateTime(0),
  );

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
}

class MaintenanceRecordTranslation extends Equatable {
  final String langCode;
  final String title;
  final String? notes;

  const MaintenanceRecordTranslation({
    required this.langCode,
    required this.title,
    this.notes,
  });

  @override
  List<Object?> get props => [langCode, title, notes];
}
