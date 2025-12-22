import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_schedule_repository.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/create_maintenance_schedule_usecase.dart';

class BulkCreateMaintenanceSchedulesUsecase
    implements
        Usecase<
          ItemSuccess<BulkCreateMaintenanceSchedulesResponse>,
          BulkCreateMaintenanceSchedulesParams
        > {
  final MaintenanceScheduleRepository _maintenanceScheduleRepository;

  BulkCreateMaintenanceSchedulesUsecase(this._maintenanceScheduleRepository);

  @override
  Future<Either<Failure, ItemSuccess<BulkCreateMaintenanceSchedulesResponse>>>
  call(BulkCreateMaintenanceSchedulesParams params) async {
    return await _maintenanceScheduleRepository.createManyMaintenanceSchedules(
      params,
    );
  }
}

class BulkCreateMaintenanceSchedulesParams extends Equatable {
  final List<CreateMaintenanceScheduleUsecaseParams> maintenanceSchedules;

  const BulkCreateMaintenanceSchedulesParams({
    required this.maintenanceSchedules,
  });

  Map<String, dynamic> toMap() {
    return {
      'maintenanceSchedules': maintenanceSchedules
          .map((x) => x.toMap())
          .toList(),
    };
  }

  factory BulkCreateMaintenanceSchedulesParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return BulkCreateMaintenanceSchedulesParams(
      maintenanceSchedules: List<CreateMaintenanceScheduleUsecaseParams>.from(
        (map['maintenanceSchedules'] as List).map(
          (x) => CreateMaintenanceScheduleUsecaseParams.fromMap(
            x as Map<String, dynamic>,
          ),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateMaintenanceSchedulesParams.fromJson(String source) =>
      BulkCreateMaintenanceSchedulesParams.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [maintenanceSchedules];
}

class BulkCreateMaintenanceSchedulesResponse extends Equatable {
  final List<MaintenanceSchedule> maintenanceSchedules;

  const BulkCreateMaintenanceSchedulesResponse({
    required this.maintenanceSchedules,
  });

  Map<String, dynamic> toMap() {
    return {
      'maintenanceSchedules': maintenanceSchedules
          .map((x) => _maintenanceScheduleToMap(x))
          .toList(),
    };
  }

  factory BulkCreateMaintenanceSchedulesResponse.fromMap(
    Map<String, dynamic> map,
  ) {
    return BulkCreateMaintenanceSchedulesResponse(
      maintenanceSchedules: List<MaintenanceSchedule>.from(
        (map['maintenanceSchedules'] as List).map(
          (x) => _maintenanceScheduleFromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateMaintenanceSchedulesResponse.fromJson(String source) =>
      BulkCreateMaintenanceSchedulesResponse.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [maintenanceSchedules];

  static Map<String, dynamic> _maintenanceScheduleToMap(
    MaintenanceSchedule maintenanceSchedule,
  ) {
    return {
      'id': maintenanceSchedule.id,
      'assetId': maintenanceSchedule.assetId,
      'maintenanceType': maintenanceSchedule.maintenanceType.value,
      'isRecurring': maintenanceSchedule.isRecurring,
      'intervalValue': maintenanceSchedule.intervalValue,
      'intervalUnit': maintenanceSchedule.intervalUnit?.value,
      'scheduledTime': maintenanceSchedule.scheduledTime,
      'nextScheduledDate': maintenanceSchedule.nextScheduledDate
          .toIso8601String(),
      'lastExecutedDate': maintenanceSchedule.lastExecutedDate
          ?.toIso8601String(),
      'autoComplete': maintenanceSchedule.autoComplete,
      'estimatedCost': maintenanceSchedule.estimatedCost,
      'createdById': maintenanceSchedule.createdById,
      'state': maintenanceSchedule.state.value,
      'title': maintenanceSchedule.title,
      'description': maintenanceSchedule.description,
      'createdAt': maintenanceSchedule.createdAt.toIso8601String(),
      'updatedAt': maintenanceSchedule.updatedAt.toIso8601String(),
    };
  }

  static MaintenanceSchedule _maintenanceScheduleFromMap(
    Map<String, dynamic> map,
  ) {
    return MaintenanceSchedule(
      id: map['id'] ?? '',
      assetId: map['assetId'] ?? '',
      maintenanceType: MaintenanceScheduleType.values.firstWhere(
        (e) => e.value == map['maintenanceType'],
        orElse: () => MaintenanceScheduleType.preventive,
      ),
      isRecurring: map['isRecurring'] ?? false,
      intervalValue: map['intervalValue']?.toInt(),
      intervalUnit: map['intervalUnit'] != null
          ? IntervalUnit.values.firstWhere(
              (e) => e.value == map['intervalUnit'],
              orElse: () => IntervalUnit.days,
            )
          : null,
      scheduledTime: map['scheduledTime'],
      nextScheduledDate: DateTime.parse(map['nextScheduledDate'].toString()),
      lastExecutedDate: map['lastExecutedDate'] != null
          ? DateTime.parse(map['lastExecutedDate'].toString())
          : null,
      state: ScheduleState.values.firstWhere(
        (e) => e.value == map['state'],
        orElse: () => ScheduleState.active,
      ),
      autoComplete: map['autoComplete'] ?? false,
      estimatedCost: map['estimatedCost']?.toDouble(),
      createdById: map['createdById'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt'].toString()),
      updatedAt: DateTime.parse(map['updatedAt'].toString()),
    );
  }
}
