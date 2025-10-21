import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_statistics_usecase.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movement_statistics_state.dart';

class AssetMovementsStatisticsNotifier
    extends AutoDisposeNotifier<AssetMovementStatisticsState> {
  GetAssetMovementsStatisticsUsecase get _getAssetMovementsStatisticsUsecase =>
      ref.watch(getAssetMovementsStatisticsUsecaseProvider);

  @override
  AssetMovementStatisticsState build() {
    // * Cache statistics for 5 minutes (dashboard use case)
    ref.cacheFor(const Duration(minutes: 5));
    this.logPresentation('Loading asset movements statistics');
    _loadStatistics();
    return AssetMovementStatisticsState.initial();
  }

  Future<void> _loadStatistics() async {
    state = AssetMovementStatisticsState.loading();

    final result = await _getAssetMovementsStatisticsUsecase.call(NoParams());

    result.fold(
      (failure) {
        this.logError('Failed to load asset movements statistics', failure);
        state = AssetMovementStatisticsState.error(failure);
      },
      (success) {
        this.logData('Asset movements statistics loaded');
        if (success.data != null) {
          state = AssetMovementStatisticsState.success(success.data!);
        } else {
          state = AssetMovementStatisticsState.error(
            const ServerFailure(message: 'No statistics data'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadStatistics();
  }
}
