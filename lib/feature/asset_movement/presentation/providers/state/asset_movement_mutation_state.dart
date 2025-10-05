import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';

enum AssetMovementStatus { initial, loading, error, success }

class AssetMovementMutationState extends Equatable {
  final AssetMovementStatus assetMovementStatus;
  final AssetMovement? assetMovement;
  final String? message;
  final Failure? failure;

  const AssetMovementMutationState({
    required this.assetMovementStatus,
    this.assetMovement,
    this.message,
    this.failure,
  });

  factory AssetMovementMutationState.success({
    AssetMovement? assetMovement,
    String? message,
  }) {
    return AssetMovementMutationState(
      assetMovementStatus: AssetMovementStatus.success,
      assetMovement: assetMovement,
      message: message,
    );
  }

  factory AssetMovementMutationState.error({Failure? failure}) {
    return AssetMovementMutationState(
      assetMovementStatus: AssetMovementStatus.error,
      failure: failure,
      message: failure?.message,
    );
  }

  AssetMovementMutationState copyWith({
    AssetMovementStatus? assetMovementStatus,
    ValueGetter<AssetMovement?>? assetMovement,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
  }) {
    return AssetMovementMutationState(
      assetMovementStatus: assetMovementStatus ?? this.assetMovementStatus,
      assetMovement: assetMovement != null
          ? assetMovement()
          : this.assetMovement,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [
    assetMovementStatus,
    assetMovement,
    message,
    failure,
  ];
}
