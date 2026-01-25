import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_cursor_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/assets_state.dart';

class AssetsSearchDropdownNotifier extends AutoDisposeNotifier<AssetsState> {
  GetAssetsCursorUsecase get _getAssetsCursorUsecase =>
      ref.watch(getAssetsCursorUsecaseProvider);

  @override
  AssetsState build() {
    // * Cache search results for 2 minutes (dropdown use case)
    ref.cacheFor(const Duration(minutes: 2));
    this.logPresentation('Initializing AssetsSearchDropdownNotifier');
    _initializeAssets();
    return AssetsState.initial();
  }

  Future<void> _initializeAssets() async {
    state = await _loadAssets(
      assetsFilter: const GetAssetsCursorUsecaseParams(),
    );
  }

  Future<AssetsState> _loadAssets({
    required GetAssetsCursorUsecaseParams assetsFilter,
  }) async {
    this.logPresentation('Loading assets with filter: $assetsFilter');

    final result = await _getAssetsCursorUsecase.call(
      GetAssetsCursorUsecaseParams(
        search: assetsFilter.search,
        categoryId: assetsFilter.categoryId,
        locationId: assetsFilter.locationId,
        status: assetsFilter.status,
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
          currentAssets: null,
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

    state = state.copyWith(isLoadingMore: true);

    final newFilter = state.assetsFilter.copyWith(
      cursor: () => state.cursor?.nextCursor,
    );

    final result = await _getAssetsCursorUsecase.call(newFilter);

    result.fold(
      (failure) {
        this.logError('Failed to load more assets', failure);
        state = state.copyWith(isLoadingMore: false, failure: () => failure);
      },
      (success) {
        this.logData('More assets loaded: ${success.data?.length ?? 0}');
        state = AssetsState.success(
          assets: [...state.assets, ...success.data ?? []],
          assetsFilter: newFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  void clear() {
    this.logPresentation('Clearing search results');
    state = AssetsState.initial();
  }
}
