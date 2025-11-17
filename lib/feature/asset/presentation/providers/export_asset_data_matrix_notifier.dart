import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/export_asset_data_matrix_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/export_assets_state.dart';

class ExportAssetDataMatrixNotifier
    extends AutoDisposeNotifier<ExportAssetsState> {
  ExportAssetDataMatrixUsecase get _exportAssetDataMatrixUsecase =>
      ref.watch(exportAssetDataMatrixUsecaseProvider);

  @override
  ExportAssetsState build() {
    this.logPresentation('Initializing ExportAssetDataMatrixNotifier');
    return ExportAssetsState.initial();
  }

  void reset() {
    this.logPresentation('Resetting export data matrix state');
    state = ExportAssetsState.initial();
  }

  Future<void> exportDataMatrix(
    ExportAssetDataMatrixUsecaseParams params,
  ) async {
    this.logPresentation('Exporting asset data matrix with params: $params');

    state = state.copyWith(
      isLoading: true,
      failure: null,
      message: null,
      previewData: null,
    );

    final result = await _exportAssetDataMatrixUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to export asset data matrix', failure);
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) async {
        this.logData('Asset data matrix exported successfully');

        // * Set preview data from the export result
        state = state.copyWith(
          isLoading: false,
          previewData: success.data,
          message: 'Export preview generated successfully',
        );
      },
    );
  }
}
