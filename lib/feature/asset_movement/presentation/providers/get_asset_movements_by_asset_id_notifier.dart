import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_by_asset_id_usecase.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movements_by_asset_state.dart';

class GetAssetMovementsByAssetIdNotifier
    extends AutoDisposeNotifier<AssetMovementsByAssetState> {
  GetAssetMovementsByAssetIdUsecase get _getAssetMovementsByAssetIdUsecase =>
      ref.watch(getAssetMovementsByAssetIdUsecaseProvider);

  @override
  AssetMovementsByAssetState build() {
    this.logPresentation('Initializing GetAssetMovementsByAssetIdNotifier');
    // Note: This notifier requires an assetId to be set, so initial state is not loaded
    throw UnimplementedError(
      'AssetMovementsByAssetState requires an assetId filter',
    );
  }

  AssetMovementsByAssetState buildWithFilter(
    GetAssetMovementsByAssetIdUsecaseParams filter,
  ) {
    this.logPresentation(
      'Building GetAssetMovementsByAssetIdNotifier with filter: $filter',
    );
    _initializeAssetMovements(filter);
    return AssetMovementsByAssetState.initial(filter);
  }

  Future<void> _initializeAssetMovements(
    GetAssetMovementsByAssetIdUsecaseParams filter,
  ) async {
    state = await _loadAssetMovements(filter: filter);
  }

  Future<AssetMovementsByAssetState> _loadAssetMovements({
    required GetAssetMovementsByAssetIdUsecaseParams filter,
    List<AssetMovement>? currentAssetMovements,
  }) async {
    this.logPresentation(
      'Loading asset movements by asset id with filter: $filter',
    );

    final page = (currentAssetMovements?.length ?? 0) ~/ (filter.limit) + 1;

    final result = await _getAssetMovementsByAssetIdUsecase.call(
      GetAssetMovementsByAssetIdUsecaseParams(
        assetId: filter.assetId,
        page: page,
        limit: filter.limit,
        search: filter.search,
        sortBy: filter.sortBy,
        sortOrder: filter.sortOrder,
        startDate: filter.startDate,
        endDate: filter.endDate,
      ),
    );

    return result.fold(
      (failure) {
        this.logError(
          'Failed to load asset movements by asset id',
          failure,
          StackTrace.current,
        );
        return state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          failure: failure,
        );
      },
      (success) {
        final newAssetMovements = currentAssetMovements ?? [];
        newAssetMovements.addAll(success.data!);

        this.logPresentation('Successfully loaded asset movements by asset id');
        return state.copyWith(
          assetMovements: newAssetMovements,
          isLoading: false,
          isLoadingMore: false,
          failure: null,
          hasMore: success.data!.length == filter.limit,
        );
      },
    );
  }

  Future<void> loadAssetMovements({
    GetAssetMovementsByAssetIdUsecaseParams? newFilter,
  }) async {
    final filter = newFilter ?? state.filter;

    if (newFilter != null) {
      state = AssetMovementsByAssetState.initial(filter);
    }

    state = state.copyWith(isLoading: true, failure: null);

    final newState = await _loadAssetMovements(filter: filter);
    state = newState;
  }

  Future<void> loadMoreAssetMovements() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    final newState = await _loadAssetMovements(
      filter: state.filter,
      currentAssetMovements: state.assetMovements,
    );
    state = newState;
  }

  void updateFilter(GetAssetMovementsByAssetIdUsecaseParams newFilter) {
    state = state.copyWith(filter: newFilter);
  }
}
