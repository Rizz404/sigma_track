import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_cursor_usecase.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/state/scan_logs_state.dart';

class ScanLogsSearchDropdownNotifier
    extends AutoDisposeNotifier<ScanLogsState> {
  GetScanLogsCursorUsecase get _getScanLogsCursorUsecase =>
      ref.watch(getScanLogsCursorUsecaseProvider);

  @override
  ScanLogsState build() {
    // * Cache search results for 2 minutes (dropdown use case)
    ref.cacheFor(const Duration(minutes: 2));
    this.logPresentation('Initializing ScanLogsSearchDropdownNotifier');
    _initializeScanLogs();
    return ScanLogsState.initial();
  }

  Future<void> _initializeScanLogs() async {
    state = await _loadScanLogs(
      scanLogsFilter: GetScanLogsCursorUsecaseParams(),
    );
  }

  Future<ScanLogsState> _loadScanLogs({
    required GetScanLogsCursorUsecaseParams scanLogsFilter,
  }) async {
    this.logPresentation('Loading scan logs with filter: $scanLogsFilter');

    final result = await _getScanLogsCursorUsecase.call(
      GetScanLogsCursorUsecaseParams(
        search: scanLogsFilter.search,
        scanMethod: scanLogsFilter.scanMethod,
        scanResult: scanLogsFilter.scanResult,
        scannedBy: scanLogsFilter.scannedBy,
        assetId: scanLogsFilter.assetId,
        dateFrom: scanLogsFilter.dateFrom,
        dateTo: scanLogsFilter.dateTo,
        hasCoordinates: scanLogsFilter.hasCoordinates,
        sortBy: scanLogsFilter.sortBy,
        sortOrder: scanLogsFilter.sortOrder,
        cursor: scanLogsFilter.cursor,
        limit: scanLogsFilter.limit,
      ),
    );

    return result.fold(
      (failure) {
        this.logError('Failed to load scan logs', failure);
        return ScanLogsState.error(
          failure: failure,
          scanLogsFilter: scanLogsFilter,
          currentScanLogs: null,
        );
      },
      (success) {
        this.logData('Scan logs loaded: ${success.data?.length ?? 0} items');
        return ScanLogsState.success(
          scanLogs: success.data as List<ScanLog>,
          scanLogsFilter: scanLogsFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> search(String search) async {
    this.logPresentation('Searching scan logs: $search');

    final newFilter = state.scanLogsFilter.copyWith(
      search: () => search.isEmpty ? null : search,
      cursor: () => null,
    );

    state = state.copyWith(isLoading: true);
    state = await _loadScanLogs(scanLogsFilter: newFilter);
  }

  void clear() {
    this.logPresentation('Clearing search results');
    state = ScanLogsState.initial();
  }
}
