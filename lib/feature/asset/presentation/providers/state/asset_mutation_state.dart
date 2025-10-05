import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';

enum AssetStatus { initial, loading, error, success }

class AssetMutationState extends Equatable {
  final AssetStatus assetStatus;
  final Asset? asset;
  final String? message;
  final Failure? failure;

  const AssetMutationState({
    required this.assetStatus,
    this.asset,
    this.message,
    this.failure,
  });

  factory AssetMutationState.success({Asset? asset, String? message}) {
    return AssetMutationState(
      assetStatus: AssetStatus.success,
      asset: asset,
      message: message,
    );
  }

  factory AssetMutationState.error({Failure? failure}) {
    return AssetMutationState(
      assetStatus: AssetStatus.error,
      failure: failure,
      message: failure?.message,
    );
  }

  AssetMutationState copyWith({
    AssetStatus? assetStatus,
    ValueGetter<Asset?>? asset,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
  }) {
    return AssetMutationState(
      assetStatus: assetStatus ?? this.assetStatus,
      asset: asset != null ? asset() : this.asset,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [assetStatus, asset, message, failure];
}
