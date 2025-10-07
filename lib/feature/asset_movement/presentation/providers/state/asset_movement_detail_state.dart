import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';

class AssetMovementDetailState extends Equatable {
  final AssetMovement? assetMovement;
  final bool isLoading;
  final Failure? failure;

  const AssetMovementDetailState({
    this.assetMovement,
    this.isLoading = false,
    this.failure,
  });

  factory AssetMovementDetailState.initial() =>
      const AssetMovementDetailState();

  AssetMovementDetailState copyWith({
    AssetMovement? assetMovement,
    bool? isLoading,
    Failure? failure,
  }) {
    return AssetMovementDetailState(
      assetMovement: assetMovement ?? this.assetMovement,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [assetMovement, isLoading, failure];
}
