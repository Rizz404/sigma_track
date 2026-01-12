import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/upload_template_images_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/export_assets_state.dart';

class UploadTemplateImagesNotifier extends Notifier<ExportAssetsState> {
  UploadTemplateImagesUsecase get _uploadTemplateImagesUsecase =>
      ref.watch(uploadTemplateImagesUsecaseProvider);

  @override
  ExportAssetsState build() {
    this.logPresentation('Initializing UploadTemplateImagesNotifier');
    return ExportAssetsState.initial();
  }

  void reset() {
    this.logPresentation('Resetting upload template images state');
    state = ExportAssetsState.initial();
  }

  Future<void> uploadTemplateImages(
    UploadTemplateImagesUsecaseParams params,
  ) async {
    this.logPresentation('Uploading template images with params: $params');

    state = state.copyWith(isLoading: true, failure: null, message: null);

    final result = await _uploadTemplateImagesUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to upload template images', failure);
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logData('Template images uploaded successfully');
        state = state.copyWith(isLoading: false, message: success.message);
      },
    );
  }
}
