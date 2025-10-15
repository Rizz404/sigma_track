import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
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
    // * Cache asset movement detail for 3 minutes (detail view use case)
    ref.cacheFor(const Duration(minutes: 3));
    this.logPresentation('Loading asset movement by id: $id');
    _loadAssetMovement(id);
    return AssetMovementDetailState.initial();
  }

  Future<void> _loadAssetMovement(String id) async {
    state = AssetMovementDetailState.loading();

    final result = await _getAssetMovementByIdUsecase.call(
      GetAssetMovementByIdUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load asset movement by id', failure);
        state = AssetMovementDetailState.error(failure);
      },
      (success) {
        this.logData('Asset movement loaded by id: ${success.data?.id}');
        if (success.data != null) {
          state = AssetMovementDetailState.success(success.data!);
        } else {
          state = AssetMovementDetailState.error(
            const ServerFailure(message: 'Asset movement not found'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadAssetMovement(arg);
  }
}
