import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement_statistics.dart';

class AssetMovementStatisticsState extends Equatable {
  final AssetMovementStatistics? statistics;
  final bool isLoading;
  final Failure? failure;

  const AssetMovementStatisticsState({
    this.statistics,
    this.isLoading = false,
    this.failure,
  });

  factory AssetMovementStatisticsState.initial() =>
      const AssetMovementStatisticsState();

  AssetMovementStatisticsState copyWith({
    AssetMovementStatistics? statistics,
    bool? isLoading,
    Failure? failure,
  }) {
    return AssetMovementStatisticsState(
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [statistics, isLoading, failure];
}
