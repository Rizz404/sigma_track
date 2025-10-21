import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_records_cursor_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_records_state.dart';

class MaintenanceRecordsSearchNotifier
    extends AutoDisposeNotifier<MaintenanceRecordsState> {
  GetMaintenanceRecordsCursorUsecase get _getMaintenanceRecordsCursorUsecase =>
      ref.watch(getMaintenanceRecordsCursorUsecaseProvider);

  @override
  MaintenanceRecordsState build() {
    this.logPresentation('Initializing MaintenanceRecordsSearchNotifier');
    return MaintenanceRecordsState.initial();
  }

  Future<MaintenanceRecordsState> _loadMaintenanceRecords({
    required GetMaintenanceRecordsCursorUsecaseParams maintenanceRecordsFilter,
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
          currentMaintenanceRecords: null,
        );
      },
      (success) {
        this.logData(
          'Maintenance records loaded: ${success.data?.length ?? 0} items',
        );
        return MaintenanceRecordsState.success(
          maintenanceRecords: success.data as List<MaintenanceRecord>,
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

  void clear() {
    this.logPresentation('Clearing search results');
    state = MaintenanceRecordsState.initial();
  }
}
