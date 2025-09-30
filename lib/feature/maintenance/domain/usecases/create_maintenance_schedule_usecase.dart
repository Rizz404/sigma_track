import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_schedule_repository.dart';

class CreateMaintenanceScheduleUsecase
    implements
        Usecase<
          ItemSuccess<MaintenanceSchedule>,
          CreateMaintenanceScheduleUsecaseParams
        > {
  final MaintenanceScheduleRepository _maintenanceScheduleRepository;

  CreateMaintenanceScheduleUsecase(this._maintenanceScheduleRepository);

  @override
  Future<Either<Failure, ItemSuccess<MaintenanceSchedule>>> call(
    CreateMaintenanceScheduleUsecaseParams params,
  ) async {
    return await _maintenanceScheduleRepository.createMaintenanceSchedule(
      params,
    );
  }
}

class CreateMaintenanceScheduleUsecaseParams extends Equatable {
  final String assetId;
  final MaintenanceScheduleType maintenanceType;
  final DateTime scheduledDate;
  final int? frequencyMonths;
  final ScheduleStatus status;
  final String createdById;
  final List<CreateMaintenanceScheduleTranslation> translations;

  CreateMaintenanceScheduleUsecaseParams({
    required this.assetId,
    required this.maintenanceType,
    required this.scheduledDate,
    this.frequencyMonths,
    required this.status,
    required this.createdById,
    required this.translations,
  });

  Map<String, dynamic> toMap() {
    return {
      'assetId': assetId,
      'maintenanceType': maintenanceType.name,
      'scheduledDate': scheduledDate.toIso8601String(),
      if (frequencyMonths != null) 'frequencyMonths': frequencyMonths,
      'status': status.name,
      'createdById': createdById,
      'translations': translations.map((x) => x.toMap()).toList(),
    };
  }

  factory CreateMaintenanceScheduleUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return CreateMaintenanceScheduleUsecaseParams(
      assetId: map['assetId'] ?? '',
      maintenanceType: MaintenanceScheduleType.values.byName(
        map['maintenanceType'],
      ),
      scheduledDate: DateTime.parse(map['scheduledDate']),
      frequencyMonths: map['frequencyMonths']?.toInt(),
      status: ScheduleStatus.values.byName(map['status']),
      createdById: map['createdById'] ?? '',
      translations: List<CreateMaintenanceScheduleTranslation>.from(
        map['translations']?.map(
              (x) => CreateMaintenanceScheduleTranslation.fromMap(x),
            ) ??
            [],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateMaintenanceScheduleUsecaseParams.fromJson(String source) =>
      CreateMaintenanceScheduleUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    assetId,
    maintenanceType,
    scheduledDate,
    frequencyMonths,
    status,
    createdById,
    translations,
  ];
}

class CreateMaintenanceScheduleTranslation extends Equatable {
  final String langCode;
  final String title;
  final String? description;

  CreateMaintenanceScheduleTranslation({
    required this.langCode,
    required this.title,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'langCode': langCode,
      'title': title,
      if (description != null) 'description': description,
    };
  }

  factory CreateMaintenanceScheduleTranslation.fromMap(
    Map<String, dynamic> map,
  ) {
    return CreateMaintenanceScheduleTranslation(
      langCode: map['langCode'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateMaintenanceScheduleTranslation.fromJson(String source) =>
      CreateMaintenanceScheduleTranslation.fromMap(json.decode(source));

  @override
  List<Object?> get props => [langCode, title, description];
}
