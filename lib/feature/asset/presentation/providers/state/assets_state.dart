import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_cursor_usecase.dart';

// * State untuk mutation operation yang lebih descriptive
class AssetMutationState extends Equatable {
  final MutationType type;
  final bool isLoading;
  final String? successMessage;
  final Failure? failure;

  const AssetMutationState({
    required this.type,
    this.isLoading = false,
    this.successMessage,
    this.failure,
  });

  bool get isSuccess => successMessage != null && failure == null;
  bool get isError => failure != null;

  @override
  List<Object?> get props => [type, isLoading, successMessage, failure];
}

class AssetsState extends Equatable {
  final List<Asset> assets;
  final GetAssetsCursorUsecaseParams assetsFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final AssetMutationState? mutation;
  final Failure? failure;
  final Cursor? cursor;

  const AssetsState({
    this.assets = const [],
    required this.assetsFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.mutation,
    this.failure,
    this.cursor,
  });

  // * Computed properties untuk kemudahan di UI
  bool get isMutating => mutation?.isLoading ?? false;
  bool get isCreating =>
      mutation?.type == MutationType.create && mutation!.isLoading;
  bool get isUpdating =>
      mutation?.type == MutationType.update && mutation!.isLoading;
  bool get isDeleting =>
      mutation?.type == MutationType.delete && mutation!.isLoading;
  bool get hasMutationSuccess => mutation?.isSuccess ?? false;
  bool get hasMutationError => mutation?.isError ?? false;
  String? get mutationMessage => mutation?.successMessage;
  Failure? get mutationFailure => mutation?.failure;

  // * Factory methods yang lebih descriptive
  factory AssetsState.initial() => const AssetsState(
    assetsFilter: GetAssetsCursorUsecaseParams(),
    isLoading: true,
  );

  factory AssetsState.loading({
    required GetAssetsCursorUsecaseParams assetsFilter,
    List<Asset>? currentAssets,
  }) => AssetsState(
    assets: currentAssets ?? const [],
    assetsFilter: assetsFilter,
    isLoading: true,
  );

  factory AssetsState.success({
    required List<Asset> assets,
    required GetAssetsCursorUsecaseParams assetsFilter,
    Cursor? cursor,
  }) => AssetsState(assets: assets, assetsFilter: assetsFilter, cursor: cursor);

  factory AssetsState.error({
    required Failure failure,
    required GetAssetsCursorUsecaseParams assetsFilter,
    List<Asset>? currentAssets,
  }) => AssetsState(
    assets: currentAssets ?? const [],
    assetsFilter: assetsFilter,
    failure: failure,
  );

  factory AssetsState.loadingMore({
    required List<Asset> currentAssets,
    required GetAssetsCursorUsecaseParams assetsFilter,
    Cursor? cursor,
  }) => AssetsState(
    assets: currentAssets,
    assetsFilter: assetsFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  // * Factory methods untuk mutation states
  factory AssetsState.creating({
    required List<Asset> currentAssets,
    required GetAssetsCursorUsecaseParams assetsFilter,
    Cursor? cursor,
  }) => AssetsState(
    assets: currentAssets,
    assetsFilter: assetsFilter,
    cursor: cursor,
    mutation: const AssetMutationState(
      type: MutationType.create,
      isLoading: true,
    ),
  );

  factory AssetsState.updating({
    required List<Asset> currentAssets,
    required GetAssetsCursorUsecaseParams assetsFilter,
    Cursor? cursor,
  }) => AssetsState(
    assets: currentAssets,
    assetsFilter: assetsFilter,
    cursor: cursor,
    mutation: const AssetMutationState(
      type: MutationType.update,
      isLoading: true,
    ),
  );

  factory AssetsState.deleting({
    required List<Asset> currentAssets,
    required GetAssetsCursorUsecaseParams assetsFilter,
    Cursor? cursor,
  }) => AssetsState(
    assets: currentAssets,
    assetsFilter: assetsFilter,
    cursor: cursor,
    mutation: const AssetMutationState(
      type: MutationType.delete,
      isLoading: true,
    ),
  );

  factory AssetsState.mutationSuccess({
    required List<Asset> assets,
    required GetAssetsCursorUsecaseParams assetsFilter,
    required MutationType mutationType,
    required String message,
    Cursor? cursor,
  }) => AssetsState(
    assets: assets,
    assetsFilter: assetsFilter,
    cursor: cursor,
    mutation: AssetMutationState(type: mutationType, successMessage: message),
  );

  factory AssetsState.mutationError({
    required List<Asset> currentAssets,
    required GetAssetsCursorUsecaseParams assetsFilter,
    required MutationType mutationType,
    required Failure failure,
    Cursor? cursor,
  }) => AssetsState(
    assets: currentAssets,
    assetsFilter: assetsFilter,
    cursor: cursor,
    mutation: AssetMutationState(type: mutationType, failure: failure),
  );

  AssetsState copyWith({
    List<Asset>? assets,
    GetAssetsCursorUsecaseParams? assetsFilter,
    bool? isLoading,
    bool? isLoadingMore,
    ValueGetter<AssetMutationState?>? mutation,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return AssetsState(
      assets: assets ?? this.assets,
      assetsFilter: assetsFilter ?? this.assetsFilter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      mutation: mutation != null ? mutation() : this.mutation,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  // * Helper untuk clear mutation state setelah handled
  AssetsState clearMutation() {
    return copyWith(mutation: () => null);
  }

  @override
  List<Object?> get props {
    return [
      assets,
      assetsFilter,
      isLoading,
      isLoadingMore,
      mutation,
      failure,
      cursor,
    ];
  }
}
