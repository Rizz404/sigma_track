import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/check_asset_movement_exists_usecase.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movement_boolean_state.dart';

class CheckAssetMovementExistsNotifier
    extends AutoDisposeNotifier<AssetMovementBooleanState> {
  CheckAssetMovementExistsUsecase get _checkAssetMovementExistsUsecase =>
      ref.watch(checkAssetMovementExistsUsecaseProvider);

  @override
  AssetMovementBooleanState build() {
    this.logPresentation('Initializing CheckAssetMovementExistsNotifier');
    return AssetMovementBooleanState.initial();
  }

  Future<void> checkAssetMovementExists(String id) async {
    this.logPresentation('Checking if asset movement exists: $id');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _checkAssetMovementExistsUsecase.call(
      CheckAssetMovementExistsUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to check asset movement exists',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation('Successfully checked asset movement exists');
        state = state.copyWith(
          isLoading: false,
          result: success.data,
          failure: null,
        );
      },
    );
  }
}
