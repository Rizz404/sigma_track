import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/upload_bulk_data_matrix_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/bulk_data_matrix_state.dart';

class UploadBulkDataMatrixNotifier
    extends AutoDisposeNotifier<BulkDataMatrixState> {
  UploadBulkDataMatrixUsecase get _uploadBulkDataMatrixUsecase =>
      ref.watch(uploadBulkDataMatrixUsecaseProvider);

  @override
  BulkDataMatrixState build() {
    this.logPresentation('Initializing UploadBulkDataMatrixNotifier');
    // * Keep alive to prevent disposal during upload
    ref.keepAlive();
    return BulkDataMatrixState.initial();
  }

  Future<void> uploadImages(
    List<String> assetTags,
    List<String> filePaths,
  ) async {
    this.logPresentation(
      'Uploading ${filePaths.length} data matrix images for ${assetTags.length} assets',
    );

    state = BulkDataMatrixState.uploading();

    final result = await _uploadBulkDataMatrixUsecase.call(
      UploadBulkDataMatrixUsecaseParams(
        assetTags: assetTags,
        filePaths: filePaths,
      ),
    );

    result.fold(
      (failure) {
        this.logError('Failed to upload bulk data matrix images', failure);
        state = BulkDataMatrixState.error(failure);
      },
      (success) {
        if (success.data != null) {
          this.logData(
            'Uploaded ${success.data!.count} data matrix images successfully',
          );
          state = BulkDataMatrixState.success(
            success.data!,
            message: success.message,
          );
        } else {
          this.logError(
            'Failed to upload bulk data matrix',
            'No data returned',
          );
          state = BulkDataMatrixState.error(
            const ServerFailure(message: 'No data returned'),
          );
        }
      },
    );
  }

  void clearState() {
    this.logPresentation('Clearing bulk data matrix state');
    state = BulkDataMatrixState.initial();
  }
}

final uploadBulkDataMatrixNotifierProvider =
    AutoDisposeNotifierProvider<
      UploadBulkDataMatrixNotifier,
      BulkDataMatrixState
    >(UploadBulkDataMatrixNotifier.new);
