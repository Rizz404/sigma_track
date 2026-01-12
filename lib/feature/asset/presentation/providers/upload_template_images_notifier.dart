import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/upload_template_images_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/upload_template_images_state.dart';

class UploadTemplateImagesNotifier extends Notifier<UploadTemplateImagesState> {
  UploadTemplateImagesUsecase get _uploadTemplateImagesUsecase =>
      ref.watch(uploadTemplateImagesUsecaseProvider);

  @override
  UploadTemplateImagesState build() {
    this.logPresentation('Initializing UploadTemplateImagesNotifier');
    return UploadTemplateImagesState.initial();
  }

  void clearState() {
    this.logPresentation('Clearing upload template images state');
    state = UploadTemplateImagesState.initial();
  }

  Future<void> uploadImages(List<String> filePaths) async {
    this.logPresentation('Uploading ${filePaths.length} template images');

    state = UploadTemplateImagesState.uploading();

    final params = UploadTemplateImagesUsecaseParams(filePaths: filePaths);
    final result = await _uploadTemplateImagesUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to upload template images', failure);
        state = UploadTemplateImagesState.error(failure);
      },
      (success) {
        final data = success.data;
        this.logData(
          'Template images uploaded: ${data?.imageUrls.length} URLs',
        );
        state = UploadTemplateImagesState.success(
          data!,
          message: success.message,
        );
      },
    );
  }
}
