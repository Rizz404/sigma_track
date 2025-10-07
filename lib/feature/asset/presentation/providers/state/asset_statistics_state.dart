import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset_statistics.dart';

// * State untuk getAssetsStatistics usecase
class AssetStatisticsState extends Equatable {
  final AssetStatistics? statistics;
  final bool isLoading;
  final Failure? failure;

  const AssetStatisticsState({
    this.statistics,
    this.isLoading = false,
    this.failure,
  });

  factory AssetStatisticsState.initial() =>
      const AssetStatisticsState(isLoading: true);

  factory AssetStatisticsState.loading() =>
      const AssetStatisticsState(isLoading: true);

  factory AssetStatisticsState.success(AssetStatistics statistics) =>
      AssetStatisticsState(statistics: statistics);

  factory AssetStatisticsState.error(Failure failure) =>
      AssetStatisticsState(failure: failure);

  AssetStatisticsState copyWith({
    AssetStatistics? statistics,
    bool? isLoading,
    Failure? failure,
  }) {
    return AssetStatisticsState(
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [statistics, isLoading, failure];
}
