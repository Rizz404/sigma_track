import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_asset_by_tag_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/asset_detail_state.dart';

class GetAssetByTagNotifier
    extends AutoDisposeFamilyNotifier<AssetDetailState, String> {
  GetAssetByTagUsecase get _getAssetByTagUsecase =>
      ref.watch(getAssetByTagUsecaseProvider);

  @override
  AssetDetailState build(String tag) {
    this.logPresentation('Loading asset by tag: $tag');
    _loadAsset(tag);
    return AssetDetailState.initial();
  }

  Future<void> _loadAsset(String tag) async {
    state = AssetDetailState.loading();

    final result = await _getAssetByTagUsecase.call(
      GetAssetByTagUsecaseParams(tag: tag),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load asset by tag', failure);
        state = AssetDetailState.error(failure);
      },
      (success) {
        this.logData('Asset loaded by tag: ${success.data?.assetName}');
        if (success.data != null) {
          state = AssetDetailState.success(success.data!);
        } else {
          state = AssetDetailState.error(
            const ServerFailure(message: 'Asset not found'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadAsset(arg);
  }
}
