import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/create_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/delete_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_records_cursor_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/update_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_records_state.dart';

class MaintenanceRecordsNotifier
    extends AutoDisposeNotifier<MaintenanceRecordsState> {
  GetMaintenanceRecordsCursorUsecase get _getMaintenanceRecordsCursorUsecase =>
      ref.watch(getMaintenanceRecordsCursorUsecaseProvider);
  CreateMaintenanceRecordUsecase get _createMaintenanceRecordUsecase =>
      ref.watch(createMaintenanceRecordUsecaseProvider);
  UpdateMaintenanceRecordUsecase get _updateMaintenanceRecordUsecase =>
      ref.watch(updateMaintenanceRecordUsecaseProvider);
  DeleteMaintenanceRecordUsecase get _deleteMaintenanceRecordUsecase =>
      ref.watch(deleteMaintenanceRecordUsecaseProvider);

  @override
  MaintenanceRecordsState build() {
    this.logPresentation('Initializing MaintenanceRecordsNotifier');
    _initializeMaintenanceRecords();
    return MaintenanceRecordsState.initial();
  }

  Future<void> _initializeMaintenanceRecords() async {
    state = await _loadMaintenanceRecords(
      maintenanceRecordsFilter: MaintenanceRecordsFilter(),
    );
  }

  Future<MaintenanceRecordsState> _loadMaintenanceRecords({
    required MaintenanceRecordsFilter maintenanceRecordsFilter,
    List<MaintenanceRecord>? currentMaintenanceRecords,
  }) async {
    this.logPresentation(
      'Loading maintenance records with filter: $maintenanceRecordsFilter',
    );

    final result = await _getMaintenanceRecordsCursorUsecase.call(
      GetMaintenanceRecordsCursorUsecaseParams(
        search: maintenanceRecordsFilter.search,
        assetId: maintenanceRecordsFilter.assetId,
        scheduleId: maintenanceRecordsFilter.scheduleId,
        performedByUser: maintenanceRecordsFilter.performedByUser,
        vendorName: maintenanceRecordsFilter.vendorName,
        fromDate: maintenanceRecordsFilter.fromDate,
        toDate: maintenanceRecordsFilter.toDate,
        sortBy: maintenanceRecordsFilter.sortBy,
        sortOrder: maintenanceRecordsFilter.sortOrder,
        cursor: maintenanceRecordsFilter.cursor,
        limit: maintenanceRecordsFilter.limit,
      ),
    );

    return result.fold(
      (failure) {
        this.logError('Failed to load maintenance records', failure);
        return MaintenanceRecordsState.error(
          failure: failure,
          maintenanceRecordsFilter: maintenanceRecordsFilter,
          currentMaintenanceRecords: currentMaintenanceRecords,
        );
      },
      (success) {
        this.logData(
          'Maintenance records loaded: ${success.data?.length ?? 0} items',
        );
        return MaintenanceRecordsState.success(
          maintenanceRecords: (success.data ?? []).cast<MaintenanceRecord>(),
          maintenanceRecordsFilter: maintenanceRecordsFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> search(String search) async {
    this.logPresentation('Searching maintenance records: $search');

    final newFilter = state.maintenanceRecordsFilter.copyWith(
      search: () => search.isEmpty ? null : search,
      cursor: () => null,
    );

    state = state.copyWith(isLoading: true);
    state = await _loadMaintenanceRecords(maintenanceRecordsFilter: newFilter);
  }

  Future<void> updateFilter(MaintenanceRecordsFilter newFilter) async {
    this.logPresentation('Updating filter: $newFilter');

    // * Preserve search from current filter
    final filterWithResetCursor = newFilter.copyWith(
      search: () => state.maintenanceRecordsFilter.search,
      cursor: () => null,
    );

    this.logPresentation('Filter after merge: $filterWithResetCursor');
    state = state.copyWith(isLoading: true);
    state = await _loadMaintenanceRecords(
      maintenanceRecordsFilter: filterWithResetCursor,
    );
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

    this.logPresentation('Loading more maintenance records');

    state = MaintenanceRecordsState.loadingMore(
      currentMaintenanceRecords: state.maintenanceRecords,
      maintenanceRecordsFilter: state.maintenanceRecordsFilter,
      cursor: state.cursor,
    );

    final newFilter = state.maintenanceRecordsFilter.copyWith(
      cursor: () => state.cursor?.nextCursor,
    );

    final result = await _getMaintenanceRecordsCursorUsecase.call(
      GetMaintenanceRecordsCursorUsecaseParams(
        search: newFilter.search,
        assetId: newFilter.assetId,
        scheduleId: newFilter.scheduleId,
        performedByUser: newFilter.performedByUser,
        vendorName: newFilter.vendorName,
        fromDate: newFilter.fromDate,
        toDate: newFilter.toDate,
        sortBy: newFilter.sortBy,
        sortOrder: newFilter.sortOrder,
        cursor: newFilter.cursor,
        limit: newFilter.limit,
      ),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load more maintenance records', failure);
        state = MaintenanceRecordsState.error(
          failure: failure,
          maintenanceRecordsFilter: newFilter,
          currentMaintenanceRecords: state.maintenanceRecords,
        );
      },
      (success) {
        this.logData(
          'More maintenance records loaded: ${success.data?.length ?? 0}',
        );
        state = MaintenanceRecordsState.success(
          maintenanceRecords: [
            ...state.maintenanceRecords,
            ...(success.data ?? []).cast<MaintenanceRecord>(),
          ],
          maintenanceRecordsFilter: newFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> createMaintenanceRecord(
    CreateMaintenanceRecordUsecaseParams params,
  ) async {
    this.logPresentation('Creating maintenance record');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _createMaintenanceRecordUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create maintenance record', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('Maintenance record created successfully');
        state = state.copyWith(
          message: () => success.message ?? 'Maintenance record created',
          isMutating: false,
        );
        await refresh();
      },
    );
  }

  Future<void> updateMaintenanceRecord(
    UpdateMaintenanceRecordUsecaseParams params,
  ) async {
    this.logPresentation('Updating maintenance record: ${params.id}');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _updateMaintenanceRecordUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to update maintenance record', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('Maintenance record updated successfully');
        state = state.copyWith(
          message: () => success.message ?? 'Maintenance record updated',
          isMutating: false,
        );
        await refresh();
      },
    );
  }

  Future<void> deleteMaintenanceRecord(
    DeleteMaintenanceRecordUsecaseParams params,
  ) async {
    this.logPresentation('Deleting maintenance record: ${params.id}');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _deleteMaintenanceRecordUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete maintenance record', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('Maintenance record deleted successfully');
        state = state.copyWith(
          message: () => success.message ?? 'Maintenance record deleted',
          isMutating: false,
        );
        await refresh();
      },
    );
  }

  Future<void> deleteManyMaintenanceRecords(
    List<String> maintenanceRecordIds,
  ) async {
    this.logPresentation(
      'Deleting ${maintenanceRecordIds.length} maintenance records',
    );

    // Todo: Tunggu backend impl
    await refresh();
  }

  Future<void> refresh() async {
    // * Preserve current filter when refreshing
    final currentFilter = state.maintenanceRecordsFilter;
    state = state.copyWith(isLoading: true);
    state = await _loadMaintenanceRecords(
      maintenanceRecordsFilter: currentFilter,
    );
  }
}
