import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/date_time_extension.dart';
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
  final bool? isRecurring;
  final int? intervalValue;
  final IntervalUnit? intervalUnit;
  final String? scheduledTime;
  final DateTime nextScheduledDate;
  final bool? autoComplete;
  final double? estimatedCost;
  final String createdById;
  final List<CreateMaintenanceScheduleTranslation> translations;

  CreateMaintenanceScheduleUsecaseParams({
    required this.assetId,
    required this.maintenanceType,
    this.isRecurring,
    this.intervalValue,
    this.intervalUnit,
    this.scheduledTime,
    required this.nextScheduledDate,
    this.autoComplete,
    this.estimatedCost,
    required this.createdById,
    required this.translations,
  });

  Map<String, dynamic> toMap() {
    return {
      'assetId': assetId,
      'maintenanceType': maintenanceType.value,
      if (isRecurring != null) 'isRecurring': isRecurring,
      if (intervalValue != null) 'intervalValue': intervalValue,
      if (intervalUnit != null) 'intervalUnit': intervalUnit!.value,
      if (scheduledTime != null) 'scheduledTime': scheduledTime,
      'nextScheduledDate': nextScheduledDate.iso8601Date,
      if (autoComplete != null) 'autoComplete': autoComplete,
      if (estimatedCost != null) 'estimatedCost': estimatedCost,
      'createdById': createdById,
      'translations': translations.map((x) => x.toMap()).toList(),
    };
  }

  factory CreateMaintenanceScheduleUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return CreateMaintenanceScheduleUsecaseParams(
      assetId: map['assetId'] ?? '',
      maintenanceType: MaintenanceScheduleType.values.firstWhere(
        (e) => e.value == map['maintenanceType'],
      ),
      isRecurring: map['isRecurring'],
      intervalValue: map['intervalValue']?.toInt(),
      intervalUnit: map['intervalUnit'] != null
          ? IntervalUnit.values.firstWhere(
              (e) => e.value == map['intervalUnit'],
            )
          : null,
      scheduledTime: map['scheduledTime'],
      nextScheduledDate: DateTime.parse(map['nextScheduledDate']),
      autoComplete: map['autoComplete'],
      estimatedCost: map['estimatedCost']?.toDouble(),
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
    isRecurring,
    intervalValue,
    intervalUnit,
    scheduledTime,
    nextScheduledDate,
    autoComplete,
    estimatedCost,
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
