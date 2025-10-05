import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';

enum MaintenanceScheduleStatus { initial, loading, error, success }

class MaintenanceScheduleMutationState extends Equatable {
  final MaintenanceScheduleStatus maintenanceScheduleStatus;
  final MaintenanceSchedule? maintenanceSchedule;
  final String? message;
  final Failure? failure;

  const MaintenanceScheduleMutationState({
    required this.maintenanceScheduleStatus,
    this.maintenanceSchedule,
    this.message,
    this.failure,
  });

  factory MaintenanceScheduleMutationState.success({
    MaintenanceSchedule? maintenanceSchedule,
    String? message,
  }) {
    return MaintenanceScheduleMutationState(
      maintenanceScheduleStatus: MaintenanceScheduleStatus.success,
      maintenanceSchedule: maintenanceSchedule,
      message: message,
    );
  }

  factory MaintenanceScheduleMutationState.error({Failure? failure}) {
    return MaintenanceScheduleMutationState(
      maintenanceScheduleStatus: MaintenanceScheduleStatus.error,
      failure: failure,
      message: failure?.message,
    );
  }

  MaintenanceScheduleMutationState copyWith({
    MaintenanceScheduleStatus? maintenanceScheduleStatus,
    ValueGetter<MaintenanceSchedule?>? maintenanceSchedule,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
  }) {
    return MaintenanceScheduleMutationState(
      maintenanceScheduleStatus:
          maintenanceScheduleStatus ?? this.maintenanceScheduleStatus,
      maintenanceSchedule: maintenanceSchedule != null
          ? maintenanceSchedule()
          : this.maintenanceSchedule,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [
    maintenanceScheduleStatus,
    maintenanceSchedule,
    message,
    failure,
  ];
}
