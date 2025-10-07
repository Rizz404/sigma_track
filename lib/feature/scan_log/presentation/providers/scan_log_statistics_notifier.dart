import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_statistics_usecase.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/state/scan_log_statistics_state.dart';

class ScanLogStatisticsNotifier
    extends AutoDisposeNotifier<ScanLogStatisticsState> {
  GetScanLogsStatisticsUsecase get _getScanLogsStatisticsUsecase =>
      ref.watch(getScanLogsStatisticsUsecaseProvider);

  @override
  ScanLogStatisticsState build() {
    this.logPresentation('Loading scan log statistics');
    _loadStatistics();
    return ScanLogStatisticsState.initial();
  }

  Future<void> _loadStatistics() async {
    state = ScanLogStatisticsState.loading();

    final result = await _getScanLogsStatisticsUsecase.call(NoParams());

    result.fold(
      (failure) {
        this.logError('Failed to load scan log statistics', failure);
        state = ScanLogStatisticsState.error(failure);
      },
      (success) {
        this.logData('Scan log statistics loaded');
        if (success.data != null) {
          state = ScanLogStatisticsState.success(success.data!);
        } else {
          state = ScanLogStatisticsState.error(
            const ServerFailure(message: 'No statistics data'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadStatistics();
  }
}
