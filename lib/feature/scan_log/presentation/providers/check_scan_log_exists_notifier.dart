import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/check_scan_log_exists_usecase.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/state/scan_log_boolean_state.dart';

class CheckScanLogExistsNotifier
    extends AutoDisposeFamilyNotifier<ScanLogBooleanState, String> {
  CheckScanLogExistsUsecase get _checkScanLogExistsUsecase =>
      ref.watch(checkScanLogExistsUsecaseProvider);

  @override
  ScanLogBooleanState build(String id) {
    this.logPresentation('Checking if scan log exists: $id');
    _checkExists(id);
    return ScanLogBooleanState.initial();
  }

  Future<void> _checkExists(String id) async {
    state = ScanLogBooleanState.loading();

    final result = await _checkScanLogExistsUsecase.call(
      CheckScanLogExistsUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError('Failed to check scan log exists', failure);
        state = ScanLogBooleanState.error(failure);
      },
      (success) {
        this.logData('Scan log exists: ${success.data}');
        state = ScanLogBooleanState.success(success.data ?? false);
      },
    );
  }

  Future<void> refresh() async {
    await _checkExists(arg);
  }
}
