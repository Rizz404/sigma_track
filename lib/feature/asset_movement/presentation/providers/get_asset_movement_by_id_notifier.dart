import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movement_by_id_usecase.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movement_detail_state.dart';

class GetAssetMovementByIdNotifier
    extends AutoDisposeFamilyNotifier<AssetMovementDetailState, String> {
  GetAssetMovementByIdUsecase get _getAssetMovementByIdUsecase =>
      ref.watch(getAssetMovementByIdUsecaseProvider);

  @override
  AssetMovementDetailState build(String id) {
    this.logPresentation('Initializing GetAssetMovementByIdNotifier');
    getAssetMovementById(id);
    return AssetMovementDetailState.initial();
  }

  Future<void> getAssetMovementById(String id) async {
    this.logPresentation('Getting asset movement by id: $id');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _getAssetMovementByIdUsecase.call(
      GetAssetMovementByIdUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to get asset movement by id',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation('Successfully got asset movement by id');
        state = state.copyWith(
          isLoading: false,
          assetMovement: success.data,
          failure: null,
        );
      },
    );
  }
}
