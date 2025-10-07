import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedules_statistics_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_schedule_statistics_state.dart';

class GetMaintenanceSchedulesStatisticsNotifier
    extends AutoDisposeNotifier<MaintenanceScheduleStatisticsState> {
  GetMaintenanceSchedulesStatisticsUsecase
  get _getMaintenanceSchedulesStatisticsUsecase =>
      ref.watch(getMaintenanceSchedulesStatisticsUsecaseProvider);

  @override
  MaintenanceScheduleStatisticsState build() {
    this.logPresentation(
      'Initializing GetMaintenanceSchedulesStatisticsNotifier',
    );
    return MaintenanceScheduleStatisticsState.initial();
  }

  Future<void> getMaintenanceSchedulesStatistics() async {
    this.logPresentation('Getting maintenance schedules statistics');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _getMaintenanceSchedulesStatisticsUsecase.call(
      NoParams(),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to get maintenance schedules statistics',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation(
          'Successfully got maintenance schedules statistics',
        );
        state = state.copyWith(
          isLoading: false,
          statistics: success.data,
          failure: null,
        );
      },
    );
  }
}
