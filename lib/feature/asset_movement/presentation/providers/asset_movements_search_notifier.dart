import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_cursor_usecase.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movements_state.dart';

class AssetMovementsSearchNotifier
    extends AutoDisposeNotifier<AssetMovementsState> {
  GetAssetMovementsCursorUsecase get _getAssetMovementsCursorUsecase =>
      ref.watch(getAssetMovementsCursorUsecaseProvider);

  @override
  AssetMovementsState build() {
    // * Cache search results for 2 minutes (dropdown use case)
    ref.cacheFor(const Duration(minutes: 2));
    this.logPresentation('Initializing AssetMovementsSearchNotifier');
    return AssetMovementsState.initial();
  }

  Future<AssetMovementsState> _loadAssetMovements({
    required AssetMovementsFilter assetMovementsFilter,
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
        fromUserId: assetMovementsFilter.fromUserId,
        toUserId: assetMovementsFilter.toUserId,
        movedBy: assetMovementsFilter.movedBy,
        dateFrom: assetMovementsFilter.dateFrom,
        dateTo: assetMovementsFilter.dateTo,
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
          currentAssetMovements: null,
        );
      },
      (success) {
        this.logData(
          'Asset movements loaded: ${success.data?.length ?? 0} items',
        );
        return AssetMovementsState.success(
          assetMovements: success.data as List<AssetMovement>,
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

  void clear() {
    this.logPresentation('Clearing search results');
    state = AssetMovementsState.initial();
  }
}
