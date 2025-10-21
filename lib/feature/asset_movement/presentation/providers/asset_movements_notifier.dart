import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/create_asset_movement_for_location_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/create_asset_movement_for_user_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/delete_asset_movement_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_cursor_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/update_asset_movement_for_location_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/update_asset_movement_for_user_usecase.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movements_state.dart';

class AssetMovementsNotifier extends AutoDisposeNotifier<AssetMovementsState> {
  GetAssetMovementsCursorUsecase get _getAssetMovementsCursorUsecase =>
      ref.watch(getAssetMovementsCursorUsecaseProvider);
  CreateAssetMovementForLocationUsecase
  get _createAssetMovementForLocationUsecase =>
      ref.watch(createAssetMovementForLocationUsecaseProvider);
  CreateAssetMovementForUserUsecase get _createAssetMovementForUserUsecase =>
      ref.watch(createAssetMovementForUserUsecaseProvider);
  UpdateAssetMovementForLocationUsecase
  get _updateAssetMovementForLocationUsecase =>
      ref.watch(updateAssetMovementForLocationUsecaseProvider);
  UpdateAssetMovementForUserUsecase get _updateAssetMovementForUserUsecase =>
      ref.watch(updateAssetMovementForUserUsecaseProvider);
  DeleteAssetMovementUsecase get _deleteAssetMovementUsecase =>
      ref.watch(deleteAssetMovementUsecaseProvider);

  @override
  AssetMovementsState build() {
    this.logPresentation('Initializing AssetMovementsNotifier');
    _initializeAssetMovements();
    return AssetMovementsState.initial();
  }

  Future<void> _initializeAssetMovements() async {
    state = await _loadAssetMovements(
      assetMovementsFilter: const GetAssetMovementsCursorUsecaseParams(),
    );
  }

  Future<AssetMovementsState> _loadAssetMovements({
    required GetAssetMovementsCursorUsecaseParams assetMovementsFilter,
    List<AssetMovement>? currentAssetMovements,
  }) async {
    this.logPresentation(
      'Loading asset movements with filter: $assetMovementsFilter',
    );

    final result = await _getAssetMovementsCursorUsecase.call(
      GetAssetMovementsCursorUsecaseParams(
        search: assetMovementsFilter.search,
        assetId: assetMovementsFilter.assetId,
        fromLocationId: assetMovementsFilter.fromLocationId,
        toLocationId: assetMovementsFilter.toLocationId,
        movedBy: assetMovementsFilter.movedBy,
        sortBy: assetMovementsFilter.sortBy,
        sortOrder: assetMovementsFilter.sortOrder,
        cursor: assetMovementsFilter.cursor,
        limit: assetMovementsFilter.limit,
      ),
    );

    return result.fold(
      (failure) {
        this.logError('Failed to load asset movements', failure);
        return AssetMovementsState.error(
          failure: failure,
          assetMovementsFilter: assetMovementsFilter,
          currentAssetMovements: currentAssetMovements,
        );
      },
      (success) {
        this.logData(
          'Asset movements loaded: ${success.data?.length ?? 0} items',
        );
        return AssetMovementsState.success(
          assetMovements: (success.data ?? []).cast<AssetMovement>(),
          assetMovementsFilter: assetMovementsFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> search(String search) async {
    this.logPresentation('Searching asset movements: $search');

    final newFilter = state.assetMovementsFilter.copyWith(
      search: () => search.isEmpty ? null : search,
      cursor: () => null,
    );

    state = state.copyWith(isLoading: true);
    state = await _loadAssetMovements(assetMovementsFilter: newFilter);
  }

  Future<void> updateFilter(
    GetAssetMovementsCursorUsecaseParams newFilter,
  ) async {
    this.logPresentation('Updating filter: $newFilter');

    // * Preserve search from current filter
    final filterWithResetCursor = newFilter.copyWith(
      search: () => state.assetMovementsFilter.search,
      cursor: () => null,
    );

    this.logPresentation('Filter after merge: $filterWithResetCursor');
    state = state.copyWith(isLoading: true);
    state = await _loadAssetMovements(
      assetMovementsFilter: filterWithResetCursor,
    );
  }

  Future<void> loadMore() async {
    if (state.cursor == null || !state.cursor!.hasNextPage) {
      this.logPresentation('No more pages to load');
      return;
    }

    if (state.isLoadingMore) {
      this.logPresentation('Already loading more');
      return;
    }

    this.logPresentation('Loading more asset movements');

    state = AssetMovementsState.loadingMore(
      currentAssetMovements: state.assetMovements,
      assetMovementsFilter: state.assetMovementsFilter,
      cursor: state.cursor,
    );

    final newFilter = state.assetMovementsFilter.copyWith(
      cursor: () => state.cursor?.nextCursor,
    );

    final result = await _getAssetMovementsCursorUsecase.call(
      GetAssetMovementsCursorUsecaseParams(
        search: newFilter.search,
        assetId: newFilter.assetId,
        fromLocationId: newFilter.fromLocationId,
        toLocationId: newFilter.toLocationId,
        movedBy: newFilter.movedBy,
        sortBy: newFilter.sortBy,
        sortOrder: newFilter.sortOrder,
        cursor: newFilter.cursor,
        limit: newFilter.limit,
      ),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load more asset movements', failure);
        state = AssetMovementsState.error(
          failure: failure,
          assetMovementsFilter: newFilter,
          currentAssetMovements: state.assetMovements,
        );
      },
      (success) {
        this.logData(
          'More asset movements loaded: ${success.data?.length ?? 0}',
        );
        state = AssetMovementsState.success(
          assetMovements: [
            ...state.assetMovements,
            ...(success.data ?? []).cast<AssetMovement>(),
          ],
          assetMovementsFilter: newFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> createAssetMovementForLocation(
    CreateAssetMovementForLocationUsecaseParams params,
  ) async {
    this.logPresentation('Creating asset movement for location');

    state = AssetMovementsState.creating(
      currentAssetMovements: state.assetMovements,
      assetMovementsFilter: state.assetMovementsFilter,
      cursor: state.cursor,
    );

    final result = await _createAssetMovementForLocationUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create asset movement for location', failure);
        state = AssetMovementsState.mutationError(
          currentAssetMovements: state.assetMovements,
          assetMovementsFilter: state.assetMovementsFilter,
          mutationType: MutationType.create,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Asset movement for location created successfully');

        state = state.copyWith(isLoading: true);

        state = await _loadAssetMovements(
          assetMovementsFilter: state.assetMovementsFilter,
        );

        state = AssetMovementsState.mutationSuccess(
          assetMovements: state.assetMovements,
          assetMovementsFilter: state.assetMovementsFilter,
          mutationType: MutationType.create,
          message: success.message ?? 'Asset movement created',
          cursor: state.cursor,
        );
      },
    );
  }

  Future<void> createAssetMovementForUser(
    CreateAssetMovementForUserUsecaseParams params,
  ) async {
    this.logPresentation('Creating asset movement for user');

    state = AssetMovementsState.creating(
      currentAssetMovements: state.assetMovements,
      assetMovementsFilter: state.assetMovementsFilter,
      cursor: state.cursor,
    );

    final result = await _createAssetMovementForUserUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create asset movement for user', failure);
        state = AssetMovementsState.mutationError(
          currentAssetMovements: state.assetMovements,
          assetMovementsFilter: state.assetMovementsFilter,
          mutationType: MutationType.create,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Asset movement for user created successfully');

        state = state.copyWith(isLoading: true);

        state = await _loadAssetMovements(
          assetMovementsFilter: state.assetMovementsFilter,
        );

        state = AssetMovementsState.mutationSuccess(
          assetMovements: state.assetMovements,
          assetMovementsFilter: state.assetMovementsFilter,
          mutationType: MutationType.create,
          message: success.message ?? 'Asset movement created',
          cursor: state.cursor,
        );
      },
    );
  }

  Future<void> updateAssetMovementForLocation(
    UpdateAssetMovementForLocationUsecaseParams params,
  ) async {
    this.logPresentation('Updating asset movement for location: ${params.id}');

    state = AssetMovementsState.updating(
      currentAssetMovements: state.assetMovements,
      assetMovementsFilter: state.assetMovementsFilter,
      cursor: state.cursor,
    );

    final result = await _updateAssetMovementForLocationUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to update asset movement for location', failure);
        state = AssetMovementsState.mutationError(
          currentAssetMovements: state.assetMovements,
          assetMovementsFilter: state.assetMovementsFilter,
          mutationType: MutationType.update,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Asset movement for location updated successfully');

        state = state.copyWith(isLoading: true);

        state = await _loadAssetMovements(
          assetMovementsFilter: state.assetMovementsFilter,
        );

        state = AssetMovementsState.mutationSuccess(
          assetMovements: state.assetMovements,
          assetMovementsFilter: state.assetMovementsFilter,
          mutationType: MutationType.update,
          message: success.message ?? 'Asset movement updated',
          cursor: state.cursor,
        );
      },
    );
  }

  Future<void> updateAssetMovementForUser(
    UpdateAssetMovementForUserUsecaseParams params,
  ) async {
    this.logPresentation('Updating asset movement for user: ${params.id}');

    state = AssetMovementsState.updating(
      currentAssetMovements: state.assetMovements,
      assetMovementsFilter: state.assetMovementsFilter,
      cursor: state.cursor,
    );

    final result = await _updateAssetMovementForUserUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to update asset movement for user', failure);
        state = AssetMovementsState.mutationError(
          currentAssetMovements: state.assetMovements,
          assetMovementsFilter: state.assetMovementsFilter,
          mutationType: MutationType.update,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Asset movement for user updated successfully');

        state = state.copyWith(isLoading: true);

        state = await _loadAssetMovements(
          assetMovementsFilter: state.assetMovementsFilter,
        );

        state = AssetMovementsState.mutationSuccess(
          assetMovements: state.assetMovements,
          assetMovementsFilter: state.assetMovementsFilter,
          mutationType: MutationType.update,
          message: success.message ?? 'Asset movement updated',
          cursor: state.cursor,
        );
      },
    );
  }

  Future<void> deleteAssetMovement(
    DeleteAssetMovementUsecaseParams params,
  ) async {
    this.logPresentation('Deleting asset movement: ${params.id}');

    state = AssetMovementsState.deleting(
      currentAssetMovements: state.assetMovements,
      assetMovementsFilter: state.assetMovementsFilter,
      cursor: state.cursor,
    );

    final result = await _deleteAssetMovementUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete asset movement', failure);
        state = AssetMovementsState.mutationError(
          currentAssetMovements: state.assetMovements,
          assetMovementsFilter: state.assetMovementsFilter,
          mutationType: MutationType.delete,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Asset movement deleted successfully');

        state = state.copyWith(isLoading: true);

        state = await _loadAssetMovements(
          assetMovementsFilter: state.assetMovementsFilter,
        );

        state = AssetMovementsState.mutationSuccess(
          assetMovements: state.assetMovements,
          assetMovementsFilter: state.assetMovementsFilter,
          mutationType: MutationType.delete,
          message: success.message ?? 'Asset movement deleted',
          cursor: state.cursor,
        );
      },
    );
  }

  Future<void> deleteManyAssetMovements(List<String> assetMovementIds) async {
    this.logPresentation('Deleting ${assetMovementIds.length} asset movements');

    // Todo: Tunggu backend impl
    await refresh();
  }

  Future<void> refresh() async {
    // * Preserve current filter when refreshing
    final currentFilter = state.assetMovementsFilter;
    state = state.copyWith(isLoading: true);
    state = await _loadAssetMovements(assetMovementsFilter: currentFilter);
  }
}
