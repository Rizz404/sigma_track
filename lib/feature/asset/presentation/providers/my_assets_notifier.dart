import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_cursor_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/assets_state.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_current_user_usecase.dart';

class MyAssetsNotifier extends AutoDisposeNotifier<AssetsState> {
  GetAssetsCursorUsecase get _getAssetsCursorUsecase =>
      ref.watch(getAssetsCursorUsecaseProvider);
  GetCurrentUserUsecase get _getCurrentUserUsecase =>
      ref.watch(getCurrentUserUsecaseProvider);

  @override
  AssetsState build() {
    this.logPresentation('Initializing MyAssetsNotifier');
    _initializeAssets();
    return AssetsState.initial();
  }

  Future<void> _initializeAssets() async {
    final userResult = await _getCurrentUserUsecase.call(NoParams());
    final userId = userResult.fold((failure) {
      this.logError('Failed to get current user', failure);
      return null;
    }, (success) => success.data?.id);
    state = await _loadAssets(assetsFilter: AssetsFilter(assignedTo: userId));
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

  Future<void> refresh() async {
    // * Preserve current filter when refreshing
    final currentFilter = state.assetsFilter;
    state = state.copyWith(isLoading: true);
    state = await _loadAssets(assetsFilter: currentFilter);
  }
}
