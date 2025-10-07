import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/check_maintenance_schedule_exists_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_schedule_boolean_state.dart';

class CheckMaintenanceScheduleExistsNotifier
    extends AutoDisposeNotifier<MaintenanceScheduleBooleanState> {
  CheckMaintenanceScheduleExistsUsecase
  get _checkMaintenanceScheduleExistsUsecase =>
      ref.watch(checkMaintenanceScheduleExistsUsecaseProvider);

  @override
  MaintenanceScheduleBooleanState build() {
    this.logPresentation('Initializing CheckMaintenanceScheduleExistsNotifier');
    return MaintenanceScheduleBooleanState.initial();
  }

  Future<void> checkMaintenanceScheduleExists(String id) async {
    this.logPresentation('Checking if maintenance schedule exists: $id');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _checkMaintenanceScheduleExistsUsecase.call(
      CheckMaintenanceScheduleExistsUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to check maintenance schedule exists',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation(
          'Successfully checked maintenance schedule exists',
        );
        state = state.copyWith(
          isLoading: false,
          result: success.data,
          failure: null,
        );
      },
    );
  }
}
