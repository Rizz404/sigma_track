import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_by_asset_id_usecase.dart';

class AssetMovementsByAssetState extends Equatable {
  final List<AssetMovement> assetMovements;
  final bool isLoading;
  final bool isLoadingMore;
  final Failure? failure;
  final GetAssetMovementsByAssetIdUsecaseParams filter;
  final bool hasMore;

  const AssetMovementsByAssetState({
    this.assetMovements = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.failure,
    required this.filter,
    this.hasMore = true,
  });

  factory AssetMovementsByAssetState.initial(
    GetAssetMovementsByAssetIdUsecaseParams filter,
  ) => AssetMovementsByAssetState(filter: filter);

  AssetMovementsByAssetState copyWith({
    List<AssetMovement>? assetMovements,
    bool? isLoading,
    bool? isLoadingMore,
    Failure? failure,
    GetAssetMovementsByAssetIdUsecaseParams? filter,
    bool? hasMore,
  }) {
    return AssetMovementsByAssetState(
      assetMovements: assetMovements ?? this.assetMovements,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      failure: failure ?? this.failure,
      filter: filter ?? this.filter,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
    assetMovements,
    isLoading,
    isLoadingMore,
    failure,
    filter,
    hasMore,
  ];
}
