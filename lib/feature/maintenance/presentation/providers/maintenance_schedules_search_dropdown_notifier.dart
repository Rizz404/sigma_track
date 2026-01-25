import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedules_cursor_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_schedules_state.dart';

class MaintenanceSchedulesSearchDropdownNotifier
    extends AutoDisposeNotifier<MaintenanceSchedulesState> {
  GetMaintenanceSchedulesCursorUsecase
  get _getMaintenanceSchedulesCursorUsecase =>
      ref.watch(getMaintenanceSchedulesCursorUsecaseProvider);

  @override
  MaintenanceSchedulesState build() {
    this.logPresentation(
      'Initializing MaintenanceSchedulesSearchDropdownNotifier',
    );
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
          currentMaintenanceSchedules: null,
        );
      },
      (success) {
        this.logData(
          'Maintenance schedules loaded: ${success.data?.length ?? 0} items',
        );
        return MaintenanceSchedulesState.success(
          maintenanceSchedules: success.data as List<MaintenanceSchedule>,
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

    state = state.copyWith(isLoadingMore: true);

    final newFilter = state.maintenanceSchedulesFilter.copyWith(
      cursor: () => state.cursor?.nextCursor,
    );

    final result = await _getMaintenanceSchedulesCursorUsecase.call(newFilter);

    result.fold(
      (failure) {
        this.logError('Failed to load more maintenance schedules', failure);
        state = state.copyWith(isLoadingMore: false, failure: () => failure);
      },
      (success) {
        this.logData(
          'More maintenance schedules loaded: ${success.data?.length ?? 0}',
        );
        state = MaintenanceSchedulesState.success(
          maintenanceSchedules: [
            ...state.maintenanceSchedules,
            ...success.data ?? [],
          ],
          maintenanceSchedulesFilter: newFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  void clear() {
    this.logPresentation('Clearing search results');
    state = MaintenanceSchedulesState.initial();
  }
}
