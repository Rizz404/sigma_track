import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/export_maintenance_record_list_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/export_maintenance_records_state.dart';

class ExportMaintenanceRecordsNotifier
    extends AutoDisposeNotifier<ExportMaintenanceRecordsState> {
  ExportMaintenanceRecordListUsecase get _exportMaintenanceRecordListUsecase =>
      ref.watch(exportMaintenanceRecordListUsecaseProvider);

  @override
  ExportMaintenanceRecordsState build() {
    this.logPresentation('Initializing ExportMaintenanceRecordsNotifier');
    return ExportMaintenanceRecordsState.initial();
  }

  void reset() {
    this.logPresentation('Resetting export state');
    state = ExportMaintenanceRecordsState.initial();
  }

  Future<void> exportMaintenanceRecords(
    ExportMaintenanceRecordListUsecaseParams params,
  ) async {
    this.logPresentation('Exporting maintenance records with params: $params');

    state = state.copyWith(
      isLoading: true,
      failure: null,
      message: null,
      previewData: null,
    );

    final result = await _exportMaintenanceRecordListUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to export maintenance records', failure);
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) async {
        this.logData('Maintenance records exported successfully');
        state = state.copyWith(
          isLoading: false,
          previewData: success.data,
          message: 'Export preview generated successfully',
        );
      },
    );
  }
}
