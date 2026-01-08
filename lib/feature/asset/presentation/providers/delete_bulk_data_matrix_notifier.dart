import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/delete_bulk_data_matrix_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/delete_bulk_data_matrix_state.dart';

class DeleteBulkDataMatrixNotifier
    extends AutoDisposeNotifier<DeleteBulkDataMatrixState> {
  DeleteBulkDataMatrixUsecase get _deleteBulkDataMatrixUsecase =>
      ref.watch(deleteBulkDataMatrixUsecaseProvider);

  @override
  DeleteBulkDataMatrixState build() {
    this.logPresentation('Initializing DeleteBulkDataMatrixNotifier');
    return DeleteBulkDataMatrixState.initial();
  }

  Future<void> deleteImages(List<String> assetTags) async {
    this.logPresentation(
      'Deleting data matrix images for ${assetTags.length} assets',
    );

    state = DeleteBulkDataMatrixState.deleting();

    final result = await _deleteBulkDataMatrixUsecase.call(
      DeleteBulkDataMatrixUsecaseParams(assetTags: assetTags),
    );

    result.fold(
      (failure) {
        this.logError('Failed to delete bulk data matrix images', failure);
        state = DeleteBulkDataMatrixState.error(failure);
      },
      (success) {
        if (success.data != null) {
          this.logData(
            'Deleted ${success.data!.deletedCount} data matrix images successfully',
          );
          state = DeleteBulkDataMatrixState.success(
            success.data!,
            message: success.message,
          );
        } else {
          this.logError(
            'Failed to delete bulk data matrix',
            'No data returned',
          );
          state = DeleteBulkDataMatrixState.error(
            const ServerFailure(message: 'No data returned'),
          );
        }
      },
    );
  }

  void clearState() {
    this.logPresentation('Clearing delete bulk data matrix state');
    state = DeleteBulkDataMatrixState.initial();
  }
}

final deleteBulkDataMatrixNotifierProvider =
    AutoDisposeNotifierProvider<
      DeleteBulkDataMatrixNotifier,
      DeleteBulkDataMatrixState
    >(DeleteBulkDataMatrixNotifier.new);
