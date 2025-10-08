import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_log_by_id_usecase.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/state/scan_log_detail_state.dart';

class GetScanLogByIdNotifier
    extends AutoDisposeFamilyNotifier<ScanLogDetailState, String> {
  GetScanLogByIdUsecase get _getScanLogByIdUsecase =>
      ref.watch(getScanLogByIdUsecaseProvider);

  @override
  ScanLogDetailState build(String id) {
    // * Cache scan log detail for 3 minutes (detail view use case)
    ref.cacheFor(const Duration(minutes: 3));
    this.logPresentation('Loading scan log by id: $id');
    _loadScanLog(id);
    return ScanLogDetailState.initial();
  }

  Future<void> _loadScanLog(String id) async {
    state = ScanLogDetailState.loading();

    final result = await _getScanLogByIdUsecase.call(
      GetScanLogByIdUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load scan log by id', failure);
        state = ScanLogDetailState.error(failure);
      },
      (success) {
        this.logData('Scan log loaded by id: ${success.data?.scannedValue}');
        if (success.data != null) {
          state = ScanLogDetailState.success(success.data!);
        } else {
          state = ScanLogDetailState.error(
            const ServerFailure(message: 'Scan log not found'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadScanLog(arg);
  }
}
