import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';

class MaintenanceSchedule extends Equatable {
  final String id;
  final String assetId;
  final MaintenanceScheduleType maintenanceType;
  final bool isRecurring;
  final int? intervalValue;
  final IntervalUnit? intervalUnit;
  final String? scheduledTime;
  final DateTime nextScheduledDate;
  final DateTime? lastExecutedDate;
  final ScheduleState state;
  final bool autoComplete;
  final double? estimatedCost;
  final String createdById;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String title;
  final String? description;
  final List<MaintenanceScheduleTranslation>? translations;
  final Asset? asset;
  final User? createdBy;

  const MaintenanceSchedule({
    required this.id,
    required this.assetId,
    required this.maintenanceType,
    required this.isRecurring,
    this.intervalValue,
    this.intervalUnit,
    this.scheduledTime,
    required this.nextScheduledDate,
    this.lastExecutedDate,
    required this.state,
    required this.autoComplete,
    this.estimatedCost,
    required this.createdById,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    this.description,
    this.translations,
    this.asset,
    this.createdBy,
  });

  factory MaintenanceSchedule.dummy() => MaintenanceSchedule(
    id: '',
    assetId: '',
    maintenanceType: MaintenanceScheduleType.preventive,
    isRecurring: false,
    nextScheduledDate: DateTime(0),
    state: ScheduleState.active,
    autoComplete: false,
    createdById: '',
    createdAt: DateTime(0),
    updatedAt: DateTime(0),
    title: '',
  );

  @override
  List<Object?> get props => [
    id,
    assetId,
    maintenanceType,
    isRecurring,
    intervalValue,
    intervalUnit,
    scheduledTime,
    nextScheduledDate,
    lastExecutedDate,
    state,
    autoComplete,
    estimatedCost,
    createdById,
    createdAt,
    updatedAt,
    title,
    description,
    translations,
    asset,
    createdBy,
  ];
}

class MaintenanceScheduleTranslation extends Equatable {
  final String langCode;
  final String title;
  final String? description;

  const MaintenanceScheduleTranslation({
    required this.langCode,
    required this.title,
    this.description,
  });

  @override
  List<Object?> get props => [langCode, title, description];
}
