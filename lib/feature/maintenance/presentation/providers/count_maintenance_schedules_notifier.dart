import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/count_maintenance_schedules_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_schedule_count_state.dart';

class CountMaintenanceSchedulesNotifier
    extends AutoDisposeNotifier<MaintenanceScheduleCountState> {
  CountMaintenanceSchedulesUsecase get _countMaintenanceSchedulesUsecase =>
      ref.watch(countMaintenanceSchedulesUsecaseProvider);

  @override
  MaintenanceScheduleCountState build() {
    this.logPresentation('Initializing CountMaintenanceSchedulesNotifier');
    return MaintenanceScheduleCountState.initial();
  }

  Future<void> countMaintenanceSchedules({
    ScheduleStatus? status,
    MaintenanceScheduleType? maintenanceType,
  }) async {
    this.logPresentation('Counting maintenance schedules with filters');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _countMaintenanceSchedulesUsecase.call(
      CountMaintenanceSchedulesUsecaseParams(
        status: status,
        maintenanceType: maintenanceType,
      ),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to count maintenance schedules',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation('Successfully counted maintenance schedules');
        state = state.copyWith(
          isLoading: false,
          count: success.data,
          failure: null,
        );
      },
    );
  }
}
