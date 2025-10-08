import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_statistics_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/asset_statistics_state.dart';

class AssetStatisticsNotifier
    extends AutoDisposeNotifier<AssetStatisticsState> {
  GetAssetsStatisticsUsecase get _getAssetsStatisticsUsecase =>
      ref.watch(getAssetsStatisticsUsecaseProvider);

  @override
  AssetStatisticsState build() {
    // * Cache statistics for 5 minutes (dashboard use case)
    ref.cacheFor(const Duration(minutes: 5));
    this.logPresentation('Loading asset statistics');
    _loadStatistics();
    return AssetStatisticsState.initial();
  }

  Future<void> _loadStatistics() async {
    state = AssetStatisticsState.loading();

    final result = await _getAssetsStatisticsUsecase.call(NoParams());

    result.fold(
      (failure) {
        this.logError('Failed to load asset statistics', failure);
        state = AssetStatisticsState.error(failure);
      },
      (success) {
        this.logData('Asset statistics loaded');
        if (success.data != null) {
          state = AssetStatisticsState.success(success.data!);
        } else {
          state = AssetStatisticsState.error(
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
