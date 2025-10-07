import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/count_asset_movements_usecase.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movement_count_state.dart';

class CountAssetMovementsNotifier
    extends AutoDisposeNotifier<AssetMovementCountState> {
  CountAssetMovementsUsecase get _countAssetMovementsUsecase =>
      ref.watch(countAssetMovementsUsecaseProvider);

  @override
  AssetMovementCountState build() {
    this.logPresentation('Initializing CountAssetMovementsNotifier');
    return AssetMovementCountState.initial();
  }

  Future<void> countAssetMovements({String? assetId, String? dateFrom}) async {
    this.logPresentation('Counting asset movements with filters');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _countAssetMovementsUsecase.call(
      CountAssetMovementsUsecaseParams(assetId: assetId, dateFrom: dateFrom),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to count asset movements',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation('Successfully counted asset movements');
        state = state.copyWith(
          isLoading: false,
          count: success.data,
          failure: null,
        );
      },
    );
  }
}
