import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';

// * State untuk single asset (getById, getByTag)
class AssetDetailState extends Equatable {
  final Asset? asset;
  final bool isLoading;
  final Failure? failure;

  const AssetDetailState({this.asset, this.isLoading = false, this.failure});

  factory AssetDetailState.initial() => const AssetDetailState(isLoading: true);

  factory AssetDetailState.loading() => const AssetDetailState(isLoading: true);

  factory AssetDetailState.success(Asset asset) =>
      AssetDetailState(asset: asset);

  factory AssetDetailState.error(Failure failure) =>
      AssetDetailState(failure: failure);

  AssetDetailState copyWith({Asset? asset, bool? isLoading, Failure? failure}) {
    return AssetDetailState(
      asset: asset ?? this.asset,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [asset, isLoading, failure];
}
