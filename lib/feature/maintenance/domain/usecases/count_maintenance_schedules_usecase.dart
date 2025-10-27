import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_schedule_repository.dart';

class CountMaintenanceSchedulesUsecase
    implements
        Usecase<ItemSuccess<int>, CountMaintenanceSchedulesUsecaseParams> {
  final MaintenanceScheduleRepository _maintenanceScheduleRepository;

  CountMaintenanceSchedulesUsecase(this._maintenanceScheduleRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(
    CountMaintenanceSchedulesUsecaseParams params,
  ) async {
    return await _maintenanceScheduleRepository.countMaintenanceSchedules(
      params,
    );
  }
}

class CountMaintenanceSchedulesUsecaseParams extends Equatable {
  final ScheduleState? state;
  final MaintenanceScheduleType? maintenanceType;

  const CountMaintenanceSchedulesUsecaseParams({
    this.state,
    this.maintenanceType,
  });

  CountMaintenanceSchedulesUsecaseParams copyWith({
    ScheduleState? state,
    MaintenanceScheduleType? maintenanceType,
  }) {
    return CountMaintenanceSchedulesUsecaseParams(
      state: state ?? this.state,
      maintenanceType: maintenanceType ?? this.maintenanceType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (state != null) 'state': state!.value,
      if (maintenanceType != null) 'maintenanceType': maintenanceType!.value,
    };
  }

  factory CountMaintenanceSchedulesUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return CountMaintenanceSchedulesUsecaseParams(
      state: map['state'] != null
          ? ScheduleState.values.firstWhere((e) => e.value == map['state'])
          : null,
      maintenanceType: map['maintenanceType'] != null
          ? MaintenanceScheduleType.values.firstWhere(
              (e) => e.value == map['maintenanceType'],
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CountMaintenanceSchedulesUsecaseParams.fromJson(String source) =>
      CountMaintenanceSchedulesUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'CountMaintenanceSchedulesUsecaseParams(state: $state, maintenanceType: $maintenanceType)';

  @override
  List<Object?> get props => [state, maintenanceType];
}
