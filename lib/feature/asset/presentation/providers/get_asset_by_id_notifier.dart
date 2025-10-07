import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_asset_by_id_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/asset_detail_state.dart';

class GetAssetByIdNotifier
    extends AutoDisposeFamilyNotifier<AssetDetailState, String> {
  GetAssetByIdUsecase get _getAssetByIdUsecase =>
      ref.watch(getAssetByIdUsecaseProvider);

  @override
  AssetDetailState build(String id) {
    this.logPresentation('Loading asset by id: $id');
    _loadAsset(id);
    return AssetDetailState.initial();
  }

  Future<void> _loadAsset(String id) async {
    state = AssetDetailState.loading();

    final result = await _getAssetByIdUsecase.call(
      GetAssetByIdUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load asset by id', failure);
        state = AssetDetailState.error(failure);
      },
      (success) {
        this.logData('Asset loaded by id: ${success.data?.assetName}');
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
