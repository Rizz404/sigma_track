import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/create_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/delete_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedules_cursor_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/update_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_schedules_state.dart';

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

  @override
  MaintenanceSchedulesState build() {
    this.logPresentation('Initializing MaintenanceSchedulesNotifier');
    _initializeMaintenanceSchedules();
    return MaintenanceSchedulesState.initial();
  }

  Future<void> _initializeMaintenanceSchedules() async {
    state = await _loadMaintenanceSchedules(
      maintenanceSchedulesFilter: MaintenanceSchedulesFilter(),
    );
  }

  Future<MaintenanceSchedulesState> _loadMaintenanceSchedules({
    required MaintenanceSchedulesFilter maintenanceSchedulesFilter,
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
        status: maintenanceSchedulesFilter.status,
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

  Future<void> updateFilter(MaintenanceSchedulesFilter newFilter) async {
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
        status: newFilter.status,
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

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _createMaintenanceScheduleUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create maintenance schedule', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('Maintenance schedule created successfully');

        state = state.copyWith(
          message: () => success.message ?? 'Maintenance schedule created',
          isMutating: false,
        );

        await Future.delayed(const Duration(milliseconds: 100));

        state = state.copyWith(message: () => null, isLoading: true);

        state = await _loadMaintenanceSchedules(
          maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
        );
      },
    );
  }

  Future<void> updateMaintenanceSchedule(
    UpdateMaintenanceScheduleUsecaseParams params,
  ) async {
    this.logPresentation('Updating maintenance schedule: ${params.id}');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _updateMaintenanceScheduleUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to update maintenance schedule', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('Maintenance schedule updated successfully');

        state = state.copyWith(
          message: () => success.message ?? 'Maintenance schedule updated',
          isMutating: false,
        );

        await Future.delayed(const Duration(milliseconds: 100));

        state = state.copyWith(message: () => null, isLoading: true);

        state = await _loadMaintenanceSchedules(
          maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
        );
      },
    );
  }

  Future<void> deleteMaintenanceSchedule(
    DeleteMaintenanceScheduleUsecaseParams params,
  ) async {
    this.logPresentation('Deleting maintenance schedule: ${params.id}');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _deleteMaintenanceScheduleUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete maintenance schedule', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('Maintenance schedule deleted successfully');

        state = state.copyWith(
          message: () => success.message ?? 'Maintenance schedule deleted',
          isMutating: false,
        );

        await Future.delayed(const Duration(milliseconds: 100));

        state = state.copyWith(message: () => null, isLoading: true);

        state = await _loadMaintenanceSchedules(
          maintenanceSchedulesFilter: state.maintenanceSchedulesFilter,
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

    // Todo: Tunggu backend impl
    await refresh();
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
