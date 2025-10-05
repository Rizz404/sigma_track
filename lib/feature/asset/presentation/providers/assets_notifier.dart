import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/usecases/create_asset_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/delete_asset_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_cursor_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/update_asset_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/assets_state.dart';

class AssetsNotifier extends AutoDisposeNotifier<AssetsState> {
  GetAssetsCursorUsecase get _getAssetsCursorUsecase =>
      ref.watch(getAssetsCursorUsecaseProvider);
  CreateAssetUsecase get _createAssetUsecase =>
      ref.watch(createAssetUsecaseProvider);
  UpdateAssetUsecase get _updateAssetUsecase =>
      ref.watch(updateAssetUsecaseProvider);
  DeleteAssetUsecase get _deleteAssetUsecase =>
      ref.watch(deleteAssetUsecaseProvider);

  @override
  AssetsState build() {
    this.logPresentation('Initializing AssetsNotifier');
    _initializeAssets();
    return AssetsState.initial();
  }

  Future<void> _initializeAssets() async {
    state = await _loadAssets(assetsFilter: AssetsFilter());
  }

  Future<AssetsState> _loadAssets({
    required AssetsFilter assetsFilter,
    List<Asset>? currentAssets,
  }) async {
    this.logPresentation('Loading assets with filter: $assetsFilter');

    final result = await _getAssetsCursorUsecase.call(
      GetAssetsCursorUsecaseParams(
        search: assetsFilter.search,
        status: assetsFilter.status,
        condition: assetsFilter.condition,
        categoryId: assetsFilter.categoryId,
        locationId: assetsFilter.locationId,
        assignedTo: assetsFilter.assignedTo,
        brand: assetsFilter.brand,
        model: assetsFilter.model,
        sortBy: assetsFilter.sortBy,
        sortOrder: assetsFilter.sortOrder,
        cursor: assetsFilter.cursor,
        limit: assetsFilter.limit,
      ),
    );

    return result.fold(
      (failure) {
        this.logError('Failed to load assets', failure);
        return AssetsState.error(
          failure: failure,
          assetsFilter: assetsFilter,
          currentAssets: currentAssets,
        );
      },
      (success) {
        this.logData('Assets loaded: ${success.data?.length ?? 0} items');
        return AssetsState.success(
          assets: (success.data ?? []).cast<Asset>(),
          assetsFilter: assetsFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> search(String search) async {
    this.logPresentation('Searching assets: $search');

    final newFilter = state.assetsFilter.copyWith(
      search: () => search.isEmpty ? null : search,
      cursor: () => null,
    );

    state = state.copyWith(isLoading: true);
    state = await _loadAssets(assetsFilter: newFilter);
  }

  Future<void> updateFilter(AssetsFilter newFilter) async {
    this.logPresentation('Updating filter: $newFilter');

    // * Preserve search from current filter
    final filterWithResetCursor = newFilter.copyWith(
      search: () => state.assetsFilter.search,
      cursor: () => null,
    );

    this.logPresentation('Filter after merge: $filterWithResetCursor');
    state = state.copyWith(isLoading: true);
    state = await _loadAssets(assetsFilter: filterWithResetCursor);
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

    this.logPresentation('Loading more assets');

    state = AssetsState.loadingMore(
      currentAssets: state.assets,
      assetsFilter: state.assetsFilter,
      cursor: state.cursor,
    );

    final newFilter = state.assetsFilter.copyWith(
      cursor: () => state.cursor?.nextCursor,
    );

    final result = await _getAssetsCursorUsecase.call(
      GetAssetsCursorUsecaseParams(
        search: newFilter.search,
        status: newFilter.status,
        condition: newFilter.condition,
        categoryId: newFilter.categoryId,
        locationId: newFilter.locationId,
        assignedTo: newFilter.assignedTo,
        brand: newFilter.brand,
        model: newFilter.model,
        sortBy: newFilter.sortBy,
        sortOrder: newFilter.sortOrder,
        cursor: newFilter.cursor,
        limit: newFilter.limit,
      ),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load more assets', failure);
        state = AssetsState.error(
          failure: failure,
          assetsFilter: newFilter,
          currentAssets: state.assets,
        );
      },
      (success) {
        this.logData('More assets loaded: ${success.data?.length ?? 0}');
        state = AssetsState.success(
          assets: [...state.assets, ...(success.data ?? []).cast<Asset>()],
          assetsFilter: newFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> createAsset(CreateAssetUsecaseParams params) async {
    this.logPresentation('Creating asset');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _createAssetUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create asset', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('Asset created successfully');
        state = state.copyWith(
          message: () => success.message ?? 'Asset created',
          isMutating: false,
        );
        await refresh();
      },
    );
  }

  Future<void> updateAsset(UpdateAssetUsecaseParams params) async {
    this.logPresentation('Updating asset: ${params.id}');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _updateAssetUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to update asset', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('Asset updated successfully');
        state = state.copyWith(
          message: () => success.message ?? 'Asset updated',
          isMutating: false,
        );
        await refresh();
      },
    );
  }

  Future<void> deleteAsset(DeleteAssetUsecaseParams params) async {
    this.logPresentation('Deleting asset: ${params.id}');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _deleteAssetUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete asset', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('Asset deleted successfully');
        state = state.copyWith(
          message: () => success.message ?? 'Asset deleted',
          isMutating: false,
        );
        await refresh();
      },
    );
  }

  Future<void> deleteManyAssets(List<String> assetIds) async {
    this.logPresentation('Deleting ${assetIds.length} assets');

    // Todo: Tunggu backend impl
    await refresh();
  }

  Future<void> refresh() async {
    // * Preserve current filter when refreshing
    final currentFilter = state.assetsFilter;
    state = state.copyWith(isLoading: true);
    state = await _loadAssets(assetsFilter: currentFilter);
  }
}
