import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record_statistics.dart';

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
      const MaintenanceRecordStatisticsState();

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
