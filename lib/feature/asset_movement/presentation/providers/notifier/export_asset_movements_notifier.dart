import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/export_asset_movement_list_usecase.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/export_asset_movements_state.dart';

class ExportAssetMovementsNotifier
    extends AutoDisposeNotifier<ExportAssetMovementsState> {
  ExportAssetMovementListUsecase get _exportAssetMovementListUsecase =>
      ref.watch(exportAssetMovementListUsecaseProvider);

  @override
  ExportAssetMovementsState build() {
    this.logPresentation('Initializing ExportAssetMovementsNotifier');
    return ExportAssetMovementsState.initial();
  }

  void reset() {
    this.logPresentation('Resetting export state');
    state = ExportAssetMovementsState.initial();
  }

  Future<void> exportAssetMovements(
    ExportAssetMovementListUsecaseParams params,
  ) async {
    this.logPresentation('Exporting asset movements with params: $params');

    state = state.copyWith(
      isLoading: true,
      failure: null,
      message: null,
      previewData: null,
    );

    final result = await _exportAssetMovementListUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to export asset movements', failure);
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) async {
        this.logData('Asset movements exported successfully');
        state = state.copyWith(
          isLoading: false,
          previewData: success.data,
          message: 'Export preview generated successfully',
        );
      },
    );
  }
}
