import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';

class MaintenanceScheduleDetailState extends Equatable {
  final MaintenanceSchedule? maintenanceSchedule;
  final bool isLoading;
  final Failure? failure;

  const MaintenanceScheduleDetailState({
    this.maintenanceSchedule,
    this.isLoading = false,
    this.failure,
  });

  factory MaintenanceScheduleDetailState.initial() =>
      const MaintenanceScheduleDetailState();

  factory MaintenanceScheduleDetailState.loading() =>
      const MaintenanceScheduleDetailState(isLoading: true);

  factory MaintenanceScheduleDetailState.success(
    MaintenanceSchedule maintenanceSchedule,
  ) => MaintenanceScheduleDetailState(maintenanceSchedule: maintenanceSchedule);

  factory MaintenanceScheduleDetailState.error(Failure failure) =>
      MaintenanceScheduleDetailState(failure: failure);

  MaintenanceScheduleDetailState copyWith({
    MaintenanceSchedule? maintenanceSchedule,
    bool? isLoading,
    Failure? failure,
  }) {
    return MaintenanceScheduleDetailState(
      maintenanceSchedule: maintenanceSchedule ?? this.maintenanceSchedule,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [maintenanceSchedule, isLoading, failure];
}
