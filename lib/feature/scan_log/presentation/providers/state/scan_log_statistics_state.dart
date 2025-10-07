import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log_statistics.dart';

// * State untuk getScanLogsStatistics usecase
class ScanLogStatisticsState extends Equatable {
  final ScanLogStatistics? statistics;
  final bool isLoading;
  final Failure? failure;

  const ScanLogStatisticsState({
    this.statistics,
    this.isLoading = false,
    this.failure,
  });

  factory ScanLogStatisticsState.initial() =>
      const ScanLogStatisticsState(isLoading: true);

  factory ScanLogStatisticsState.loading() =>
      const ScanLogStatisticsState(isLoading: true);

  factory ScanLogStatisticsState.success(ScanLogStatistics statistics) =>
      ScanLogStatisticsState(statistics: statistics);

  factory ScanLogStatisticsState.error(Failure failure) =>
      ScanLogStatisticsState(failure: failure);

  ScanLogStatisticsState copyWith({
    ScanLogStatistics? statistics,
    bool? isLoading,
    Failure? failure,
  }) {
    return ScanLogStatisticsState(
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [statistics, isLoading, failure];
}
