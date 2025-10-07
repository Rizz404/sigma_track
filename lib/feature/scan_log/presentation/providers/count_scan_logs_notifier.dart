import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/count_scan_logs_usecase.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/state/scan_log_count_state.dart';

class CountScanLogsNotifier
    extends
        AutoDisposeFamilyNotifier<
          ScanLogCountState,
          CountScanLogsUsecaseParams
        > {
  CountScanLogsUsecase get _countScanLogsUsecase =>
      ref.watch(countScanLogsUsecaseProvider);

  @override
  ScanLogCountState build(CountScanLogsUsecaseParams params) {
    this.logPresentation('Counting scan logs with params: $params');
    _countScanLogs(params);
    return ScanLogCountState.initial();
  }

  Future<void> _countScanLogs(CountScanLogsUsecaseParams params) async {
    state = ScanLogCountState.loading();

    final result = await _countScanLogsUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to count scan logs', failure);
        state = ScanLogCountState.error(failure);
      },
      (success) {
        this.logData('Scan logs count: ${success.data}');
        state = ScanLogCountState.success(success.data ?? 0);
      },
    );
  }

  Future<void> refresh() async {
    await _countScanLogs(arg);
  }
}
