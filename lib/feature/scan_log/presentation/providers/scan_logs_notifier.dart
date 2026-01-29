import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/bulk_create_scan_logs_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/bulk_delete_scan_logs_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/create_scan_log_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/delete_scan_log_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_cursor_usecase.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/state/scan_logs_state.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';

class ScanLogsNotifier extends AutoDisposeNotifier<ScanLogsState> {
  GetScanLogsCursorUsecase get _getScanLogsCursorUsecase =>
      ref.watch(getScanLogsCursorUsecaseProvider);
  CreateScanLogUsecase get _createScanLogUsecase =>
      ref.watch(createScanLogUsecaseProvider);
  DeleteScanLogUsecase get _deleteScanLogUsecase =>
      ref.watch(deleteScanLogUsecaseProvider);
  BulkCreateScanLogsUsecase get _bulkCreateScanLogsUsecase =>
      ref.watch(bulkCreateScanLogsUsecaseProvider);
  BulkDeleteScanLogsUsecase get _bulkDeleteScanLogsUsecase =>
      ref.watch(bulkDeleteScanLogsUsecaseProvider);

  @override
  ScanLogsState build() {
    this.logPresentation('Initializing ScanLogsNotifier');
    _initializeScanLogs();
    return ScanLogsState.initial();
  }

  Future<void> _initializeScanLogs() async {
    state = await _loadScanLogs(
      scanLogsFilter: const GetScanLogsCursorUsecaseParams(),
    );
  }

  Future<ScanLogsState> _loadScanLogs({
    required GetScanLogsCursorUsecaseParams scanLogsFilter,
    List<ScanLog>? currentScanLogs,
  }) async {
    this.logPresentation('Loading scan logs with filter: $scanLogsFilter');

    final result = await _getScanLogsCursorUsecase.call(scanLogsFilter);

    return result.fold(
      (failure) {
        this.logError('Failed to load scan logs', failure);
        return ScanLogsState.error(
          failure: failure,
          scanLogsFilter: scanLogsFilter,
          currentScanLogs: currentScanLogs,
        );
      },
      (success) {
        this.logData('Scan logs loaded: ${success.data?.length ?? 0} items');
        return ScanLogsState.success(
          scanLogs: (success.data ?? []).cast<ScanLog>(),
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

  Future<void> updateFilter(GetScanLogsCursorUsecaseParams newFilter) async {
    this.logPresentation('Updating filter: $newFilter');

    // * Preserve search from current filter
    final filterWithResetCursor = newFilter.copyWith(
      search: () => state.scanLogsFilter.search,
      cursor: () => null,
    );

    this.logPresentation('Filter after merge: $filterWithResetCursor');
    state = state.copyWith(isLoading: true);
    state = await _loadScanLogs(scanLogsFilter: filterWithResetCursor);
  }

  Future<void> loadMore() async {
    if (state.cursor == null || !state.cursor!.hasNextPage) {
      this.logPresentation('No more pages to load');
      return;
    }

    if (state.isLoadingMore) {
      this.logPresentation('Already loading more');
      return;
    }

    this.logPresentation('Loading more scan logs');

    state = ScanLogsState.loadingMore(
      currentScanLogs: state.scanLogs,
      scanLogsFilter: state.scanLogsFilter,
      cursor: state.cursor,
    );

    final newFilter = state.scanLogsFilter.copyWith(
      cursor: () => state.cursor?.nextCursor,
    );

    final result = await _getScanLogsCursorUsecase.call(
      GetScanLogsCursorUsecaseParams(
        search: newFilter.search,
        scanMethod: newFilter.scanMethod,
        scanResult: newFilter.scanResult,
        scannedBy: newFilter.scannedBy,
        assetId: newFilter.assetId,
        dateFrom: newFilter.dateFrom,
        dateTo: newFilter.dateTo,
        hasCoordinates: newFilter.hasCoordinates,
        sortBy: newFilter.sortBy,
        sortOrder: newFilter.sortOrder,
        cursor: newFilter.cursor,
        limit: newFilter.limit,
      ),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load more scan logs', failure);
        state = ScanLogsState.error(
          failure: failure,
          scanLogsFilter: newFilter,
          currentScanLogs: state.scanLogs,
        );
      },
      (success) {
        this.logData('More scan logs loaded: ${success.data?.length ?? 0}');
        state = ScanLogsState.success(
          scanLogs: [
            ...state.scanLogs,
            ...(success.data ?? []).cast<ScanLog>(),
          ],
          scanLogsFilter: newFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> createScanLog(CreateScanLogUsecaseParams params) async {
    this.logPresentation('Creating scan log');

    state = ScanLogsState.creating(
      currentScanLogs: state.scanLogs,
      scanLogsFilter: state.scanLogsFilter,
      cursor: state.cursor,
    );

    final result = await _createScanLogUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create scan log', failure);
        state = ScanLogsState.mutationError(
          currentScanLogs: state.scanLogs,
          scanLogsFilter: state.scanLogsFilter,
          mutationType: MutationType.create,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Scan log created successfully');

        // * Reset cursor when creating to fetch from beginning
        final resetCursorFilter = state.scanLogsFilter.copyWith(
          cursor: () => null,
        );

        state = state.copyWith(isLoading: true);
        final newState = await _loadScanLogs(scanLogsFilter: resetCursorFilter);

        state = ScanLogsState.mutationSuccess(
          scanLogs: newState.scanLogs,
          scanLogsFilter: newState.scanLogsFilter,
          mutationType: MutationType.create,
          message: success.message ?? 'Scan log created',
          cursor: newState.cursor,
        );
      },
    );
  }

  Future<void> deleteScanLog(DeleteScanLogUsecaseParams params) async {
    this.logPresentation('Deleting scan log: ${params.id}');

    state = ScanLogsState.deleting(
      currentScanLogs: state.scanLogs,
      scanLogsFilter: state.scanLogsFilter,
      cursor: state.cursor,
    );

    final result = await _deleteScanLogUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete scan log', failure);
        state = ScanLogsState.mutationError(
          currentScanLogs: state.scanLogs,
          scanLogsFilter: state.scanLogsFilter,
          mutationType: MutationType.delete,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Scan log deleted successfully');

        // * Reset cursor when deleting to fetch from beginning
        final resetCursorFilter = state.scanLogsFilter.copyWith(
          cursor: () => null,
        );

        state = state.copyWith(isLoading: true);
        final newState = await _loadScanLogs(scanLogsFilter: resetCursorFilter);

        state = ScanLogsState.mutationSuccess(
          scanLogs: newState.scanLogs,
          scanLogsFilter: newState.scanLogsFilter,
          mutationType: MutationType.delete,
          message: success.message ?? 'Scan log deleted',
          cursor: newState.cursor,
        );
      },
    );
  }

  Future<void> createManyScanLogs(BulkCreateScanLogsParams params) async {
    this.logPresentation('Creating ${params.scanLogs.length} scan logs');

    state = ScanLogsState.creating(
      currentScanLogs: state.scanLogs,
      scanLogsFilter: state.scanLogsFilter,
      cursor: state.cursor,
    );

    final result = await _bulkCreateScanLogsUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create scan logs', failure);
        state = ScanLogsState.mutationError(
          currentScanLogs: state.scanLogs,
          scanLogsFilter: state.scanLogsFilter,
          mutationType: MutationType.create,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData(
          'Scan logs created successfully: ${success.data?.scanLogs.length ?? 0}',
        );

        // * Reset cursor when creating to fetch from beginning
        final resetCursorFilter = state.scanLogsFilter.copyWith(
          cursor: () => null,
        );

        // * Reload scan logs dari awal dengan state sukses
        state = state.copyWith(isLoading: true);
        final newState = await _loadScanLogs(scanLogsFilter: resetCursorFilter);

        // * Set mutation success setelah reload
        state = ScanLogsState.mutationSuccess(
          scanLogs: newState.scanLogs,
          scanLogsFilter: newState.scanLogsFilter,
          mutationType: MutationType.create,
          message: 'Scan logs created successfully',
          cursor: newState.cursor,
        );
      },
    );
  }

  Future<void> deleteManyScanLogs(List<String> scanLogIds) async {
    this.logPresentation('Deleting ${scanLogIds.length} scan logs');

    state = ScanLogsState.deleting(
      currentScanLogs: state.scanLogs,
      scanLogsFilter: state.scanLogsFilter,
      cursor: state.cursor,
    );

    final params = BulkDeleteParams(ids: scanLogIds);
    final result = await _bulkDeleteScanLogsUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete scan logs', failure);
        state = ScanLogsState.mutationError(
          currentScanLogs: state.scanLogs,
          scanLogsFilter: state.scanLogsFilter,
          mutationType: MutationType.delete,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Scan logs deleted successfully');

        // * Reset cursor when deleting to fetch from beginning
        final resetCursorFilter = state.scanLogsFilter.copyWith(
          cursor: () => null,
        );

        // * Reload scan logs dari awal dengan state sukses
        state = state.copyWith(isLoading: true);
        final newState = await _loadScanLogs(scanLogsFilter: resetCursorFilter);

        // * Set mutation success setelah reload
        state = ScanLogsState.mutationSuccess(
          scanLogs: newState.scanLogs,
          scanLogsFilter: newState.scanLogsFilter,
          mutationType: MutationType.delete,
          message: 'Scan logs deleted successfully',
          cursor: newState.cursor,
        );
      },
    );
  }

  Future<void> refresh() async {
    // * Preserve current filter but reset cursor when refreshing
    final resetCursorFilter = state.scanLogsFilter.copyWith(cursor: () => null);
    state = state.copyWith(isLoading: true);
    state = await _loadScanLogs(scanLogsFilter: resetCursorFilter);
  }
}
