import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/bulk_create_maintenance_schedules_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/bulk_delete_maintenance_schedules_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/create_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/delete_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedules_cursor_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/update_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_schedules_state.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';

class MaintenanceSchedulesNotifier
    extends AutoDisposeNotifier<MaintenanceSchedulesState> {
  GetMaintenanceSchedulesCursorUsecase
  get _getMaintenanceSchedulesCursorUsecase =>
      ref.watch(getMaintenanceSchedulesCursorUsecaseProvider);
  CreateMaintenanceScheduleUsecase get _createMaintenanceScheduleUsecase =>
      ref.watch(createMaintenanceScheduleUsecaseProvider);
  UpdateMaintenanceScheduleUsecase get _updateMaintenanceScheduleUsecase =>
      ref.watch(updateMaintenanceScheduleUsecaseProvider);
  DeleteMaintenanceScheduleUsecase get _deleteMaintenanceScheduleUsecase =>
      ref.watch(deleteMaintenanceScheduleUsecaseProvider);
  BulkCreateMaintenanceSchedulesUsecase
  get _bulkCreateMaintenanceSchedulesUsecase =>
      ref.watch(bulkCreateMaintenanceSchedulesUsecaseProvider);
  BulkDeleteMaintenanceSchedulesUsecase
  get _bulkDeleteMaintenanceSchedulesUsecase =>
      ref.watch(bulkDeleteMaintenanceSchedulesUsecaseProvider);

  @override
  MaintenanceSchedulesState build() {
    this.logPresentation('Initializing MaintenanceSchedulesNotifier');
    _initializeMaintenanceSchedules();
    return MaintenanceSchedulesState.initial();
  }

  Future<void> _initializeMaintenanceSchedules() async {
    state = await _loadMaintenanceSchedules(
      maintenanceSchedulesFilter:
          const GetMaintenanceSchedulesCursorUsecaseParams(),
    );
  }

  Future<MaintenanceSchedulesState> _loadMaintenanceSchedules({
    required GetMaintenanceSchedulesCursorUsecaseParams
    maintenanceSchedulesFilter,
    List<MaintenanceSchedule>? currentMaintenanceSchedules,
  }) async {
    this.logPresentation(
      'Loading maintenance schedules with filter: $maintenanceSchedulesFilter',
    );

    final result = await _getMaintenanceSchedulesCursorUsecase.call(
      GetMaintenanceSchedulesCursorUsecaseParams(
        search: maintenanceSchedulesFilter.search,
        assetId: maintenanceSchedulesFilter.assetId,
        maintenanceType: maintenanceSchedulesFilter.maintenanceType,
        state: maintenanceSchedulesFilter.state,
        createdBy: maintenanceSchedulesFilter.createdBy,
        fromDate: maintenanceSchedulesFilter.fromDate,
        toDate: maintenanceSchedulesFilter.toDate,
        sortBy: maintenanceSchedulesFilter.sortBy,
        sortOrder: maintenanceSchedulesFilter.sortOrder,
        cursor: maintenanceSchedulesFilter.cursor,
        limit: maintenanceSchedulesFilter.limit,
      ),
    );

    return result.fold(
      (failure) {
        this.logError('Failed to load maintenance schedules', failure);
        return MaintenanceSchedulesState.error(
          failure: failure,
          maintenanceSchedulesFilter: maintenanceSchedulesFilter,
          currentMaintenanceSchedules: currentMaintenanceSchedules,
        );
      },
      (success) {
        this.logData(
          'Maintenance schedules loaded: ${success.data?.length ?? 0} items',
        );
        return MaintenanceSchedulesState.success(
          maintenanceSchedules: (success.data ?? [])
              .cast<MaintenanceSchedule>(),
          maintenanceSchedulesFilter: maintenanceSchedulesFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> search(String search) async {
    this.logPresentation('Searching maintenance schedules: $search');

    final newFilter = state.maintenanceSchedulesFilter.copyWith(
      search: () => search.isEmpty ? null : search,
      cursor: () => null,
    );

    state = state.copyWith(isLoading: true);
    state = await _loadMaintenanceSchedules(
      maintenanceSchedulesFilter: newFilter,
    );
  }

  Future<void> updateFilter(
    GetMaintenanceSchedulesCursorUsecaseParams newFilter,
  ) async {
    this.logPresentation('Updating filter: $newFilter');

    // * Preserve search from current filter
    final filterWithResetCursor = newFilter.copyWith(
      search: () => state.maintenanceSchedulesFilter.search,
      cursor: () => null,
    );

    this.logPresentation('Filter after merge: $filterWithResetCursor');
    state = state.copyWith(isLoading: true);
    state = await _loadMaintenanceSchedules(
      maintenanceSchedulesFilter: filterWithResetCursor,
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

    this.logPresentation('Loading more maintenance schedules');

    state = MaintenanceSchedulesState.loadingMore(
      currentMaintenanceSchedules: state.maintenanceSchedules,
      maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
      cursor: state.cursor,
    );

    final newFilter = state.maintenanceSchedulesFilter.copyWith(
      cursor: () => state.cursor?.nextCursor,
    );

    final result = await _getMaintenanceSchedulesCursorUsecase.call(
      GetMaintenanceSchedulesCursorUsecaseParams(
        search: newFilter.search,
        assetId: newFilter.assetId,
        maintenanceType: newFilter.maintenanceType,
        state: newFilter.state,
        createdBy: newFilter.createdBy,
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
        this.logError('Failed to load more maintenance schedules', failure);
        state = MaintenanceSchedulesState.error(
          failure: failure,
          maintenanceSchedulesFilter: newFilter,
          currentMaintenanceSchedules: state.maintenanceSchedules,
        );
      },
      (success) {
        this.logData(
          'More maintenance schedules loaded: ${success.data?.length ?? 0}',
        );
        state = MaintenanceSchedulesState.success(
          maintenanceSchedules: [
            ...state.maintenanceSchedules,
            ...(success.data ?? []).cast<MaintenanceSchedule>(),
          ],
          maintenanceSchedulesFilter: newFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> createMaintenanceSchedule(
    CreateMaintenanceScheduleUsecaseParams params,
  ) async {
    this.logPresentation('Creating maintenance schedule');

    state = MaintenanceSchedulesState.creating(
      currentMaintenanceSchedules: state.maintenanceSchedules,
      maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
      cursor: state.cursor,
    );

    final result = await _createMaintenanceScheduleUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create maintenance schedule', failure);
        state = MaintenanceSchedulesState.mutationError(
          currentMaintenanceSchedules: state.maintenanceSchedules,
          maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
          mutationType: MutationType.create,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Maintenance schedule created successfully');

        state = state.copyWith(isLoading: true);

        state = await _loadMaintenanceSchedules(
          maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
        );

        state = MaintenanceSchedulesState.mutationSuccess(
          maintenanceSchedules: state.maintenanceSchedules,
          maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
          mutationType: MutationType.create,
          message: success.message ?? 'Maintenance schedule created',
          cursor: state.cursor,
        );
      },
    );
  }

  Future<void> updateMaintenanceSchedule(
    UpdateMaintenanceScheduleUsecaseParams params,
  ) async {
    this.logPresentation('Updating maintenance schedule: ${params.id}');

    state = MaintenanceSchedulesState.updating(
      currentMaintenanceSchedules: state.maintenanceSchedules,
      maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
      cursor: state.cursor,
    );

    final result = await _updateMaintenanceScheduleUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to update maintenance schedule', failure);
        state = MaintenanceSchedulesState.mutationError(
          currentMaintenanceSchedules: state.maintenanceSchedules,
          maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
          mutationType: MutationType.update,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Maintenance schedule updated successfully');

        state = state.copyWith(isLoading: true);

        state = await _loadMaintenanceSchedules(
          maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
        );

        state = MaintenanceSchedulesState.mutationSuccess(
          maintenanceSchedules: state.maintenanceSchedules,
          maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
          mutationType: MutationType.update,
          message: success.message ?? 'Maintenance schedule updated',
          cursor: state.cursor,
        );
      },
    );
  }

  Future<void> deleteMaintenanceSchedule(
    DeleteMaintenanceScheduleUsecaseParams params,
  ) async {
    this.logPresentation('Deleting maintenance schedule: ${params.id}');

    state = MaintenanceSchedulesState.deleting(
      currentMaintenanceSchedules: state.maintenanceSchedules,
      maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
      cursor: state.cursor,
    );

    final result = await _deleteMaintenanceScheduleUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete maintenance schedule', failure);
        state = MaintenanceSchedulesState.mutationError(
          currentMaintenanceSchedules: state.maintenanceSchedules,
          maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
          mutationType: MutationType.delete,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Maintenance schedule deleted successfully');

        state = state.copyWith(isLoading: true);

        state = await _loadMaintenanceSchedules(
          maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
        );

        state = MaintenanceSchedulesState.mutationSuccess(
          maintenanceSchedules: state.maintenanceSchedules,
          maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
          mutationType: MutationType.delete,
          message: success.message ?? 'Maintenance schedule deleted',
          cursor: state.cursor,
        );
      },
    );
  }

  Future<void> createManyMaintenanceSchedules(
    BulkCreateMaintenanceSchedulesParams params,
  ) async {
    this.logPresentation(
      'Creating ${params.maintenanceSchedules.length} maintenance schedules',
    );

    state = MaintenanceSchedulesState.creating(
      currentMaintenanceSchedules: state.maintenanceSchedules,
      maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
      cursor: state.cursor,
    );

    final result = await _bulkCreateMaintenanceSchedulesUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create maintenance schedules', failure);
        state = MaintenanceSchedulesState.mutationError(
          currentMaintenanceSchedules: state.maintenanceSchedules,
          maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
          mutationType: MutationType.create,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData(
          'Maintenance schedules created successfully: ${success.data?.maintenanceSchedules.length ?? 0}',
        );

        // * Reload maintenance schedules dengan state sukses
        state = state.copyWith(isLoading: true);
        final newState = await _loadMaintenanceSchedules(
          maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
        );

        // * Set mutation success setelah reload
        state = MaintenanceSchedulesState.mutationSuccess(
          maintenanceSchedules: newState.maintenanceSchedules,
          maintenanceSchedulesFilter: newState.maintenanceSchedulesFilter,
          mutationType: MutationType.create,
          message: 'Maintenance schedules created successfully',
          cursor: newState.cursor,
        );
      },
    );
  }

  Future<void> deleteManyMaintenanceSchedules(
    List<String> maintenanceScheduleIds,
  ) async {
    this.logPresentation(
      'Deleting ${maintenanceScheduleIds.length} maintenance schedules',
    );

    state = MaintenanceSchedulesState.deleting(
      currentMaintenanceSchedules: state.maintenanceSchedules,
      maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
      cursor: state.cursor,
    );

    final params = BulkDeleteParams(ids: maintenanceScheduleIds);
    final result = await _bulkDeleteMaintenanceSchedulesUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete maintenance schedules', failure);
        state = MaintenanceSchedulesState.mutationError(
          currentMaintenanceSchedules: state.maintenanceSchedules,
          maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
          mutationType: MutationType.delete,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Maintenance schedules deleted successfully');

        // * Reload maintenance schedules dengan state sukses
        state = state.copyWith(isLoading: true);
        final newState = await _loadMaintenanceSchedules(
          maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
        );

        // * Set mutation success setelah reload
        state = MaintenanceSchedulesState.mutationSuccess(
          maintenanceSchedules: newState.maintenanceSchedules,
          maintenanceSchedulesFilter: newState.maintenanceSchedulesFilter,
          mutationType: MutationType.delete,
          message: 'Maintenance schedules deleted successfully',
          cursor: newState.cursor,
        );
      },
    );
  }

  Future<void> refresh() async {
    // * Preserve current filter when refreshing
    final currentFilter = state.maintenanceSchedulesFilter;
    state = state.copyWith(isLoading: true);
    state = await _loadMaintenanceSchedules(
      maintenanceSchedulesFilter: currentFilter,
    );
  }
}
