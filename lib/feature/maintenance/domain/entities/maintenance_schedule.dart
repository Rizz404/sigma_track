import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';

class MaintenanceSchedule extends Equatable {
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
  final List<MaintenanceScheduleTranslation>? translations;
  final Asset? asset;
  final User? createdBy;

  const MaintenanceSchedule({
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

  factory MaintenanceSchedule.dummy() => MaintenanceSchedule(
    id: '',
    assetId: '',
    maintenanceType: MaintenanceScheduleType.preventive,
    scheduledDate: DateTime(0),
    status: ScheduleStatus.scheduled,
    createdById: '',
    createdAt: DateTime(0),
    title: '',
  );

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
