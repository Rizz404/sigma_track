import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/delete_bulk_asset_image_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/export_assets_state.dart';

class DeleteBulkAssetImageNotifier
    extends AutoDisposeNotifier<ExportAssetsState> {
  DeleteBulkAssetImageUsecase get _deleteBulkAssetImageUsecase =>
      ref.watch(deleteBulkAssetImageUsecaseProvider);

  @override
  ExportAssetsState build() {
    this.logPresentation('Initializing DeleteBulkAssetImageNotifier');
    return ExportAssetsState.initial();
  }

  void reset() {
    this.logPresentation('Resetting delete bulk asset image state');
    state = ExportAssetsState.initial();
  }

  Future<void> deleteBulkAssetImage(
    DeleteBulkAssetImageUsecaseParams params,
  ) async {
    this.logPresentation('Deleting bulk asset images with params: $params');

    state = state.copyWith(isLoading: true, failure: null, message: null);

    final result = await _deleteBulkAssetImageUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete bulk asset images', failure);
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logData('Bulk asset images deleted successfully');
        state = state.copyWith(isLoading: false, message: success.message);
      },
    );
  }
}
