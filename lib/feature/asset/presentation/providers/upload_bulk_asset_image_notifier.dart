import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/upload_bulk_asset_image_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/export_assets_state.dart';

class UploadBulkAssetImageNotifier extends Notifier<ExportAssetsState> {
  UploadBulkAssetImageUsecase get _uploadBulkAssetImageUsecase =>
      ref.watch(uploadBulkAssetImageUsecaseProvider);

  @override
  ExportAssetsState build() {
    this.logPresentation('Initializing UploadBulkAssetImageNotifier');
    return ExportAssetsState.initial();
  }

  void reset() {
    this.logPresentation('Resetting upload bulk asset image state');
    state = ExportAssetsState.initial();
  }

  Future<void> uploadBulkAssetImage(
    UploadBulkAssetImageUsecaseParams params,
  ) async {
    this.logPresentation('Uploading bulk asset images with params: $params');

    state = state.copyWith(isLoading: true, failure: null, message: null);

    final result = await _uploadBulkAssetImageUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to upload bulk asset images', failure);
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logData('Bulk asset images uploaded successfully');
        state = state.copyWith(isLoading: false, message: success.message);
      },
    );
  }
}
