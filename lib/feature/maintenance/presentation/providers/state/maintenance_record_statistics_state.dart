import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record_statistics.dart';

// * State untuk getMaintenanceRecordsStatistics usecase
class MaintenanceRecordStatisticsState extends Equatable {
  final MaintenanceRecordStatistics? statistics;
  final bool isLoading;
  final Failure? failure;

  const MaintenanceRecordStatisticsState({
    this.statistics,
    this.isLoading = false,
    this.failure,
  });

  factory MaintenanceRecordStatisticsState.initial() =>
      const MaintenanceRecordStatisticsState(isLoading: true);

  factory MaintenanceRecordStatisticsState.loading() =>
      const MaintenanceRecordStatisticsState(isLoading: true);

  factory MaintenanceRecordStatisticsState.success(
    MaintenanceRecordStatistics statistics,
  ) => MaintenanceRecordStatisticsState(statistics: statistics);

  factory MaintenanceRecordStatisticsState.error(Failure failure) =>
      MaintenanceRecordStatisticsState(failure: failure);

  MaintenanceRecordStatisticsState copyWith({
    MaintenanceRecordStatistics? statistics,
    bool? isLoading,
    Failure? failure,
  }) {
    return MaintenanceRecordStatisticsState(
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [statistics, isLoading, failure];
}
