import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedule_by_id_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_schedule_detail_state.dart';

class GetMaintenanceScheduleByIdNotifier
    extends AutoDisposeFamilyNotifier<MaintenanceScheduleDetailState, String> {
  GetMaintenanceScheduleByIdUsecase get _getMaintenanceScheduleByIdUsecase =>
      ref.watch(getMaintenanceScheduleByIdUsecaseProvider);

  @override
  MaintenanceScheduleDetailState build(String id) {
    this.logPresentation('Initializing GetMaintenanceScheduleByIdNotifier');
    getMaintenanceScheduleById(id);
    return MaintenanceScheduleDetailState.initial();
  }

  Future<void> getMaintenanceScheduleById(String id) async {
    this.logPresentation('Getting maintenance schedule by id: $id');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _getMaintenanceScheduleByIdUsecase.call(
      GetMaintenanceScheduleByIdUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to get maintenance schedule by id',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation('Successfully got maintenance schedule by id');
        state = state.copyWith(
          isLoading: false,
          maintenanceSchedule: success.data,
          failure: null,
        );
      },
    );
  }
}
