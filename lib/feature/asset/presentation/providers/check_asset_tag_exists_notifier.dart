import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_tag_exists_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/asset_boolean_state.dart';

class CheckAssetTagExistsNotifier
    extends AutoDisposeFamilyNotifier<AssetBooleanState, String> {
  CheckAssetTagExistsUsecase get _checkAssetTagExistsUsecase =>
      ref.watch(checkAssetTagExistsUsecaseProvider);

  @override
  AssetBooleanState build(String tag) {
    this.logPresentation('Checking if asset tag exists: $tag');
    _checkExists(tag);
    return AssetBooleanState.initial();
  }

  Future<void> _checkExists(String tag) async {
    state = AssetBooleanState.loading();

    final result = await _checkAssetTagExistsUsecase.call(
      CheckAssetTagExistsUsecaseParams(tag: tag),
    );

    result.fold(
      (failure) {
        this.logError('Failed to check asset tag exists', failure);
        state = AssetBooleanState.error(failure);
      },
      (success) {
        this.logData('Asset tag exists: ${success.data}');
        state = AssetBooleanState.success(success.data ?? false);
      },
    );
  }

  Future<void> refresh() async {
    await _checkExists(arg);
  }
}
