import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_cursor_usecase.dart';

// * State untuk mutation operation yang lebih descriptive
class AssetMovementMutationState extends Equatable {
  final MutationType type;
  final bool isLoading;
  final String? successMessage;
  final Failure? failure;
  final AssetMovement? updatedAssetMovement;

  const AssetMovementMutationState({
    required this.type,
    this.isLoading = false,
    this.successMessage,
    this.failure,
    this.updatedAssetMovement,
  });

  bool get isSuccess => successMessage != null && failure == null;
  bool get isError => failure != null;

  @override
  List<Object?> get props => [
    type,
    isLoading,
    successMessage,
    failure,
    updatedAssetMovement,
  ];
}

class AssetMovementsState extends Equatable {
  final List<AssetMovement> assetMovements;
  final GetAssetMovementsCursorUsecaseParams assetMovementsFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final AssetMovementMutationState? mutation;
  final Failure? failure;
  final Cursor? cursor;

  const AssetMovementsState({
    this.assetMovements = const [],
    required this.assetMovementsFilter,
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
  factory AssetMovementsState.initial() => const AssetMovementsState(
    assetMovementsFilter: GetAssetMovementsCursorUsecaseParams(),
    isLoading: true,
  );

  factory AssetMovementsState.loading({
    required GetAssetMovementsCursorUsecaseParams assetMovementsFilter,
    List<AssetMovement>? currentAssetMovements,
  }) => AssetMovementsState(
    assetMovements: currentAssetMovements ?? const [],
    assetMovementsFilter: assetMovementsFilter,
    isLoading: true,
  );

  factory AssetMovementsState.success({
    required List<AssetMovement> assetMovements,
    required GetAssetMovementsCursorUsecaseParams assetMovementsFilter,
    Cursor? cursor,
  }) => AssetMovementsState(
    assetMovements: assetMovements,
    assetMovementsFilter: assetMovementsFilter,
    cursor: cursor,
  );

  factory AssetMovementsState.error({
    required Failure failure,
    required GetAssetMovementsCursorUsecaseParams assetMovementsFilter,
    List<AssetMovement>? currentAssetMovements,
  }) => AssetMovementsState(
    assetMovements: currentAssetMovements ?? const [],
    assetMovementsFilter: assetMovementsFilter,
    failure: failure,
  );

  factory AssetMovementsState.loadingMore({
    required List<AssetMovement> currentAssetMovements,
    required GetAssetMovementsCursorUsecaseParams assetMovementsFilter,
    Cursor? cursor,
  }) => AssetMovementsState(
    assetMovements: currentAssetMovements,
    assetMovementsFilter: assetMovementsFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  // * Factory methods untuk mutation states
  factory AssetMovementsState.creating({
    required List<AssetMovement> currentAssetMovements,
    required GetAssetMovementsCursorUsecaseParams assetMovementsFilter,
    Cursor? cursor,
  }) => AssetMovementsState(
    assetMovements: currentAssetMovements,
    assetMovementsFilter: assetMovementsFilter,
    cursor: cursor,
    mutation: const AssetMovementMutationState(
      type: MutationType.create,
      isLoading: true,
    ),
  );

  factory AssetMovementsState.updating({
    required List<AssetMovement> currentAssetMovements,
    required GetAssetMovementsCursorUsecaseParams assetMovementsFilter,
    Cursor? cursor,
  }) => AssetMovementsState(
    assetMovements: currentAssetMovements,
    assetMovementsFilter: assetMovementsFilter,
    cursor: cursor,
    mutation: const AssetMovementMutationState(
      type: MutationType.update,
      isLoading: true,
    ),
  );

  factory AssetMovementsState.deleting({
    required List<AssetMovement> currentAssetMovements,
    required GetAssetMovementsCursorUsecaseParams assetMovementsFilter,
    Cursor? cursor,
  }) => AssetMovementsState(
    assetMovements: currentAssetMovements,
    assetMovementsFilter: assetMovementsFilter,
    cursor: cursor,
    mutation: const AssetMovementMutationState(
      type: MutationType.delete,
      isLoading: true,
    ),
  );

  factory AssetMovementsState.mutationSuccess({
    required List<AssetMovement> assetMovements,
    required GetAssetMovementsCursorUsecaseParams assetMovementsFilter,
    required MutationType mutationType,
    required String message,
    AssetMovement? updatedAssetMovement,
    Cursor? cursor,
  }) => AssetMovementsState(
    assetMovements: assetMovements,
    assetMovementsFilter: assetMovementsFilter,
    cursor: cursor,
    mutation: AssetMovementMutationState(
      type: mutationType,
      successMessage: message,
      updatedAssetMovement: updatedAssetMovement,
    ),
  );

  factory AssetMovementsState.mutationError({
    required List<AssetMovement> currentAssetMovements,
    required GetAssetMovementsCursorUsecaseParams assetMovementsFilter,
    required MutationType mutationType,
    required Failure failure,
    Cursor? cursor,
  }) => AssetMovementsState(
    assetMovements: currentAssetMovements,
    assetMovementsFilter: assetMovementsFilter,
    cursor: cursor,
    mutation: AssetMovementMutationState(type: mutationType, failure: failure),
  );

  AssetMovementsState copyWith({
    List<AssetMovement>? assetMovements,
    GetAssetMovementsCursorUsecaseParams? assetMovementsFilter,
    bool? isLoading,
    bool? isLoadingMore,
    ValueGetter<AssetMovementMutationState?>? mutation,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return AssetMovementsState(
      assetMovements: assetMovements ?? this.assetMovements,
      assetMovementsFilter: assetMovementsFilter ?? this.assetMovementsFilter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      mutation: mutation != null ? mutation() : this.mutation,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  // * Helper untuk clear mutation state setelah handled
  AssetMovementsState clearMutation() {
    return copyWith(mutation: () => null);
  }

  @override
  List<Object?> get props {
    return [
      assetMovements,
      assetMovementsFilter,
      isLoading,
      isLoadingMore,
      mutation,
      failure,
      cursor,
    ];
  }
}
