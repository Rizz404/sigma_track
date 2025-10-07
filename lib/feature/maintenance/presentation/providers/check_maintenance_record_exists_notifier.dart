import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/check_maintenance_record_exists_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_record_boolean_state.dart';

class CheckMaintenanceRecordExistsNotifier
    extends AutoDisposeNotifier<MaintenanceRecordBooleanState> {
  CheckMaintenanceRecordExistsUsecase
  get _checkMaintenanceRecordExistsUsecase =>
      ref.watch(checkMaintenanceRecordExistsUsecaseProvider);

  @override
  MaintenanceRecordBooleanState build() {
    this.logPresentation('Initializing CheckMaintenanceRecordExistsNotifier');
    return MaintenanceRecordBooleanState.initial();
  }

  Future<void> checkMaintenanceRecordExists(String id) async {
    this.logPresentation('Checking if maintenance record exists: $id');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _checkMaintenanceRecordExistsUsecase.call(
      CheckMaintenanceRecordExistsUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to check maintenance record exists',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation('Successfully checked maintenance record exists');
        state = state.copyWith(
          isLoading: false,
          result: success.data,
          failure: null,
        );
      },
    );
  }
}
