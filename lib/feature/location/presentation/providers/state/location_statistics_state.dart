import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/location/domain/entities/location_statistics.dart';

// * State untuk getLocationsStatistics usecase
class LocationStatisticsState extends Equatable {
  final LocationStatistics? statistics;
  final bool isLoading;
  final Failure? failure;

  const LocationStatisticsState({
    this.statistics,
    this.isLoading = false,
    this.failure,
  });

  factory LocationStatisticsState.initial() =>
      const LocationStatisticsState(isLoading: true);

  factory LocationStatisticsState.loading() =>
      const LocationStatisticsState(isLoading: true);

  factory LocationStatisticsState.success(LocationStatistics statistics) =>
      LocationStatisticsState(statistics: statistics);

  factory LocationStatisticsState.error(Failure failure) =>
      LocationStatisticsState(failure: failure);

  LocationStatisticsState copyWith({
    LocationStatistics? statistics,
    bool? isLoading,
    Failure? failure,
  }) {
    return LocationStatisticsState(
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [statistics, isLoading, failure];
}
