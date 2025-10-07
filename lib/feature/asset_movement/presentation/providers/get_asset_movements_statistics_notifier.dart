import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_statistics_usecase.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movement_statistics_state.dart';

class GetAssetMovementsStatisticsNotifier
    extends AutoDisposeNotifier<AssetMovementStatisticsState> {
  GetAssetMovementsStatisticsUsecase get _getAssetMovementsStatisticsUsecase =>
      ref.watch(getAssetMovementsStatisticsUsecaseProvider);

  @override
  AssetMovementStatisticsState build() {
    this.logPresentation('Initializing GetAssetMovementsStatisticsNotifier');
    return AssetMovementStatisticsState.initial();
  }

  Future<void> getAssetMovementsStatistics() async {
    this.logPresentation('Getting asset movements statistics');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _getAssetMovementsStatisticsUsecase.call(NoParams());

    result.fold(
      (failure) {
        this.logError(
          'Failed to get asset movements statistics',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation('Successfully got asset movements statistics');
        state = state.copyWith(
          isLoading: false,
          statistics: success.data,
          failure: null,
        );
      },
    );
  }
}
