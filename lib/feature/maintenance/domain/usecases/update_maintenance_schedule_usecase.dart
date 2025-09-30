import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_schedule_repository.dart';

class UpdateMaintenanceScheduleUsecase
    implements
        Usecase<
          ItemSuccess<MaintenanceSchedule>,
          UpdateMaintenanceScheduleUsecaseParams
        > {
  final MaintenanceScheduleRepository _maintenanceScheduleRepository;

  UpdateMaintenanceScheduleUsecase(this._maintenanceScheduleRepository);

  @override
  Future<Either<Failure, ItemSuccess<MaintenanceSchedule>>> call(
    UpdateMaintenanceScheduleUsecaseParams params,
  ) async {
    return await _maintenanceScheduleRepository.updateMaintenanceSchedule(
      params,
    );
  }
}

class UpdateMaintenanceScheduleUsecaseParams extends Equatable {
  final String id;
  final String? assetId;
  final MaintenanceScheduleType? maintenanceType;
  final DateTime? scheduledDate;
  final int? frequencyMonths;
  final ScheduleStatus? status;
  final String? createdById;
  final List<UpdateMaintenanceScheduleTranslation>? translations;

  UpdateMaintenanceScheduleUsecaseParams({
    required this.id,
    this.assetId,
    this.maintenanceType,
    this.scheduledDate,
    this.frequencyMonths,
    this.status,
    this.createdById,
    this.translations,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (assetId != null) 'assetId': assetId,
      if (maintenanceType != null) 'maintenanceType': maintenanceType!.name,
      if (scheduledDate != null)
        'scheduledDate': scheduledDate!.toIso8601String(),
      if (frequencyMonths != null) 'frequencyMonths': frequencyMonths,
      if (status != null) 'status': status!.name,
      if (createdById != null) 'createdById': createdById,
      if (translations != null)
        'translations': translations!.map((x) => x.toMap()).toList(),
    };
  }

  factory UpdateMaintenanceScheduleUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return UpdateMaintenanceScheduleUsecaseParams(
      id: map['id'] ?? '',
      assetId: map['assetId'],
      maintenanceType: map['maintenanceType'] != null
          ? MaintenanceScheduleType.values.byName(map['maintenanceType'])
          : null,
      scheduledDate: map['scheduledDate'] != null
          ? DateTime.parse(map['scheduledDate'])
          : null,
      frequencyMonths: map['frequencyMonths']?.toInt(),
      status: map['status'] != null
          ? ScheduleStatus.values.byName(map['status'])
          : null,
      createdById: map['createdById'],
      translations: map['translations'] != null
          ? List<UpdateMaintenanceScheduleTranslation>.from(
              map['translations']?.map(
                    (x) => UpdateMaintenanceScheduleTranslation.fromMap(x),
                  ) ??
                  [],
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateMaintenanceScheduleUsecaseParams.fromJson(String source) =>
      UpdateMaintenanceScheduleUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    id,
    assetId,
    maintenanceType,
    scheduledDate,
    frequencyMonths,
    status,
    createdById,
    translations,
  ];
}

class UpdateMaintenanceScheduleTranslation extends Equatable {
  final String langCode;
  final String? title;
  final String? description;

  UpdateMaintenanceScheduleTranslation({
    required this.langCode,
    this.title,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'langCode': langCode,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
    };
  }

  factory UpdateMaintenanceScheduleTranslation.fromMap(
    Map<String, dynamic> map,
  ) {
    return UpdateMaintenanceScheduleTranslation(
      langCode: map['langCode'] ?? '',
      title: map['title'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateMaintenanceScheduleTranslation.fromJson(String source) =>
      UpdateMaintenanceScheduleTranslation.fromMap(json.decode(source));

  @override
  List<Object?> get props => [langCode, title, description];
}
