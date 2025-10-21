import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedules_statistics_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_schedule_statistics_state.dart';

class MaintenanceSchedulesStatisticsNotifier
    extends AutoDisposeNotifier<MaintenanceScheduleStatisticsState> {
  GetMaintenanceSchedulesStatisticsUsecase
  get _getMaintenanceSchedulesStatisticsUsecase =>
      ref.watch(getMaintenanceSchedulesStatisticsUsecaseProvider);

  @override
  MaintenanceScheduleStatisticsState build() {
    // * Cache statistics for 5 minutes (dashboard use case)
    ref.cacheFor(const Duration(minutes: 5));
    this.logPresentation('Loading maintenance schedules statistics');
    _loadStatistics();
    return MaintenanceScheduleStatisticsState.initial();
  }

  Future<void> _loadStatistics() async {
    state = MaintenanceScheduleStatisticsState.loading();

    final result = await _getMaintenanceSchedulesStatisticsUsecase.call(
      NoParams(),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to load maintenance schedules statistics',
          failure,
        );
        state = MaintenanceScheduleStatisticsState.error(failure);
      },
      (success) {
        this.logData('Maintenance schedules statistics loaded');
        if (success.data != null) {
          state = MaintenanceScheduleStatisticsState.success(success.data!);
        } else {
          state = MaintenanceScheduleStatisticsState.error(
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
