import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_records_statistics_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_record_statistics_state.dart';

class MaintenanceRecordsStatisticsNotifier
    extends AutoDisposeNotifier<MaintenanceRecordStatisticsState> {
  GetMaintenanceRecordsStatisticsUsecase
  get _getMaintenanceRecordsStatisticsUsecase =>
      ref.watch(getMaintenanceRecordsStatisticsUsecaseProvider);

  @override
  MaintenanceRecordStatisticsState build() {
    // * Cache statistics for 5 minutes (dashboard use case)
    ref.cacheFor(const Duration(minutes: 5));
    this.logPresentation('Loading maintenance records statistics');
    _loadStatistics();
    return MaintenanceRecordStatisticsState.initial();
  }

  Future<void> _loadStatistics() async {
    state = MaintenanceRecordStatisticsState.loading();

    final result = await _getMaintenanceRecordsStatisticsUsecase.call(
      NoParams(),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load maintenance records statistics', failure);
        state = MaintenanceRecordStatisticsState.error(failure);
      },
      (success) {
        this.logData('Maintenance records statistics loaded');
        if (success.data != null) {
          state = MaintenanceRecordStatisticsState.success(success.data!);
        } else {
          state = MaintenanceRecordStatisticsState.error(
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
