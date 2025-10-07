import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_serial_exists_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/asset_boolean_state.dart';

class CheckAssetSerialExistsNotifier
    extends AutoDisposeFamilyNotifier<AssetBooleanState, String> {
  CheckAssetSerialExistsUsecase get _checkAssetSerialExistsUsecase =>
      ref.watch(checkAssetSerialExistsUsecaseProvider);

  @override
  AssetBooleanState build(String serial) {
    this.logPresentation('Checking if asset serial exists: $serial');
    _checkExists(serial);
    return AssetBooleanState.initial();
  }

  Future<void> _checkExists(String serial) async {
    state = AssetBooleanState.loading();

    final result = await _checkAssetSerialExistsUsecase.call(
      CheckAssetSerialExistsUsecaseParams(serial: serial),
    );

    result.fold(
      (failure) {
        this.logError('Failed to check asset serial exists', failure);
        state = AssetBooleanState.error(failure);
      },
      (success) {
        this.logData('Asset serial exists: ${success.data}');
        state = AssetBooleanState.success(success.data ?? false);
      },
    );
  }

  Future<void> refresh() async {
    await _checkExists(arg);
  }
}
