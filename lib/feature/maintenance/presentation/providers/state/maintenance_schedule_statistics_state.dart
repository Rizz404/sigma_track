import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule_statistics.dart';

class MaintenanceScheduleStatisticsState extends Equatable {
  final MaintenanceScheduleStatistics? statistics;
  final bool isLoading;
  final Failure? failure;

  const MaintenanceScheduleStatisticsState({
    this.statistics,
    this.isLoading = false,
    this.failure,
  });

  factory MaintenanceScheduleStatisticsState.initial() =>
      const MaintenanceScheduleStatisticsState();

  MaintenanceScheduleStatisticsState copyWith({
    MaintenanceScheduleStatistics? statistics,
    bool? isLoading,
    Failure? failure,
  }) {
    return MaintenanceScheduleStatisticsState(
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [statistics, isLoading, failure];
}
