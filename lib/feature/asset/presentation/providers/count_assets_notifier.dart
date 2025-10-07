import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/count_assets_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/asset_count_state.dart';

class CountAssetsNotifier
    extends
        AutoDisposeFamilyNotifier<AssetCountState, CountAssetsUsecaseParams> {
  CountAssetsUsecase get _countAssetsUsecase =>
      ref.watch(countAssetsUsecaseProvider);

  @override
  AssetCountState build(CountAssetsUsecaseParams params) {
    this.logPresentation('Counting assets with params: $params');
    _countAssets(params);
    return AssetCountState.initial();
  }

  Future<void> _countAssets(CountAssetsUsecaseParams params) async {
    state = AssetCountState.loading();

    final result = await _countAssetsUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to count assets', failure);
        state = AssetCountState.error(failure);
      },
      (success) {
        this.logData('Assets count: ${success.data}');
        state = AssetCountState.success(success.data ?? 0);
      },
    );
  }

  Future<void> refresh() async {
    await _countAssets(arg);
  }
}
