import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_exists_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/asset_boolean_state.dart';

class CheckAssetExistsNotifier
    extends AutoDisposeFamilyNotifier<AssetBooleanState, String> {
  CheckAssetExistsUsecase get _checkAssetExistsUsecase =>
      ref.watch(checkAssetExistsUsecaseProvider);

  @override
  AssetBooleanState build(String id) {
    this.logPresentation('Checking if asset exists: $id');
    _checkExists(id);
    return AssetBooleanState.initial();
  }

  Future<void> _checkExists(String id) async {
    state = AssetBooleanState.loading();

    final result = await _checkAssetExistsUsecase.call(
      CheckAssetExistsUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError('Failed to check asset exists', failure);
        state = AssetBooleanState.error(failure);
      },
      (success) {
        this.logData('Asset exists: ${success.data}');
        state = AssetBooleanState.success(success.data ?? false);
      },
    );
  }

  Future<void> refresh() async {
    await _checkExists(arg);
  }
}
