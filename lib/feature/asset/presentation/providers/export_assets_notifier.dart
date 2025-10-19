import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/export_asset_list_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/export_assets_state.dart';

class ExportAssetsNotifier extends AutoDisposeNotifier<ExportAssetsState> {
  ExportAssetListUsecase get _exportAssetListUsecase =>
      ref.watch(exportAssetListUsecaseProvider);

  @override
  ExportAssetsState build() {
    this.logPresentation('Initializing ExportAssetsNotifier');
    return ExportAssetsState.initial();
  }

  void reset() {
    this.logPresentation('Resetting export state');
    state = ExportAssetsState.initial();
  }

  Future<void> exportAssets(ExportAssetListUsecaseParams params) async {
    this.logPresentation('Exporting assets with params: $params');

    state = state.copyWith(
      isLoading: true,
      failure: null,
      message: null,
      previewData: null,
    );

    final result = await _exportAssetListUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to export assets', failure);
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) async {
        this.logData('Assets exported successfully');

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
