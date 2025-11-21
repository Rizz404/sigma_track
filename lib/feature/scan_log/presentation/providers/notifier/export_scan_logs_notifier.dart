import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/export_scan_log_list_usecase.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/state/export_scan_logs_state.dart';

class ExportScanLogsNotifier extends AutoDisposeNotifier<ExportScanLogsState> {
  ExportScanLogListUsecase get _exportScanLogListUsecase =>
      ref.watch(exportScanLogListUsecaseProvider);

  @override
  ExportScanLogsState build() {
    this.logPresentation('Initializing ExportScanLogsNotifier');
    return ExportScanLogsState.initial();
  }

  void reset() {
    this.logPresentation('Resetting export state');
    state = ExportScanLogsState.initial();
  }

  Future<void> exportScanLogs(ExportScanLogListUsecaseParams params) async {
    this.logPresentation('Exporting scan logs with params: $params');

    state = state.copyWith(
      isLoading: true,
      failure: null,
      message: null,
      previewData: null,
    );

    final result = await _exportScanLogListUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to export scan logs', failure);
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) async {
        this.logData('Scan logs exported successfully');
        state = state.copyWith(
          isLoading: false,
          previewData: success.data,
          message: 'Export preview generated successfully',
        );
      },
    );
  }
}
