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
  final MaintenanceScheduleType? maintenanceType;
  final bool? isRecurring;
  final int? intervalValue;
  final IntervalUnit? intervalUnit;
  final String? scheduledTime;
  final DateTime? nextScheduledDate;
  final ScheduleState? state;
  final bool? autoComplete;
  final double? estimatedCost;
  final List<UpdateMaintenanceScheduleTranslation>? translations;

  UpdateMaintenanceScheduleUsecaseParams({
    required this.id,
    this.maintenanceType,
    this.isRecurring,
    this.intervalValue,
    this.intervalUnit,
    this.scheduledTime,
    this.nextScheduledDate,
    this.state,
    this.autoComplete,
    this.estimatedCost,
    this.translations,
  });

  /// * Factory method to create params with only changed fields
  factory UpdateMaintenanceScheduleUsecaseParams.fromChanges({
    required String id,
    required MaintenanceSchedule original,
    MaintenanceScheduleType? maintenanceType,
    bool? isRecurring,
    int? intervalValue,
    IntervalUnit? intervalUnit,
    String? scheduledTime,
    DateTime? nextScheduledDate,
    ScheduleState? state,
    bool? autoComplete,
    double? estimatedCost,
    List<UpdateMaintenanceScheduleTranslation>? translations,
  }) {
    return UpdateMaintenanceScheduleUsecaseParams(
      id: id,
      maintenanceType: maintenanceType != original.maintenanceType
          ? maintenanceType
          : null,
      isRecurring: isRecurring != original.isRecurring ? isRecurring : null,
      intervalValue: intervalValue != original.intervalValue
          ? intervalValue
          : null,
      intervalUnit: intervalUnit != original.intervalUnit ? intervalUnit : null,
      scheduledTime: scheduledTime != original.scheduledTime
          ? scheduledTime
          : null,
      nextScheduledDate: nextScheduledDate != original.nextScheduledDate
          ? nextScheduledDate
          : null,
      state: state != original.state ? state : null,
      autoComplete: autoComplete != original.autoComplete ? autoComplete : null,
      estimatedCost: estimatedCost != original.estimatedCost
          ? estimatedCost
          : null,
      translations: translations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (maintenanceType != null) 'maintenanceType': maintenanceType!.value,
      if (isRecurring != null) 'isRecurring': isRecurring,
      if (intervalValue != null) 'intervalValue': intervalValue,
      if (intervalUnit != null) 'intervalUnit': intervalUnit!.value,
      if (scheduledTime != null) 'scheduledTime': scheduledTime,
      if (nextScheduledDate != null)
        'nextScheduledDate': nextScheduledDate?.iso8601Date,
      if (state != null) 'state': state!.value,
      if (autoComplete != null) 'autoComplete': autoComplete,
      if (estimatedCost != null) 'estimatedCost': estimatedCost,
      if (translations != null)
        'translations': translations!.map((x) => x.toMap()).toList(),
    };
  }

  factory UpdateMaintenanceScheduleUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return UpdateMaintenanceScheduleUsecaseParams(
      id: map['id'] ?? '',
      maintenanceType: map['maintenanceType'] != null
          ? MaintenanceScheduleType.values.firstWhere(
              (e) => e.value == map['maintenanceType'],
            )
          : null,
      isRecurring: map['isRecurring'],
      intervalValue: map['intervalValue']?.toInt(),
      intervalUnit: map['intervalUnit'] != null
          ? IntervalUnit.values.firstWhere(
              (e) => e.value == map['intervalUnit'],
            )
          : null,
      scheduledTime: map['scheduledTime'],
      nextScheduledDate: map['nextScheduledDate'] != null
          ? DateTime.parse(map['nextScheduledDate'])
          : null,
      state: map['state'] != null
          ? ScheduleState.values.firstWhere((e) => e.value == map['state'])
          : null,
      autoComplete: map['autoComplete'],
      estimatedCost: map['estimatedCost']?.toDouble(),
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
    maintenanceType,
    isRecurring,
    intervalValue,
    intervalUnit,
    scheduledTime,
    nextScheduledDate,
    state,
    autoComplete,
    estimatedCost,
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
