import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
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
    // * Cache maintenance schedule detail for 3 minutes (detail view use case)
    ref.cacheFor(const Duration(minutes: 3));
    this.logPresentation('Loading maintenance schedule by id: $id');
    _loadMaintenanceSchedule(id);
    return MaintenanceScheduleDetailState.initial();
  }

  Future<void> _loadMaintenanceSchedule(String id) async {
    state = MaintenanceScheduleDetailState.loading();

    final result = await _getMaintenanceScheduleByIdUsecase.call(
      GetMaintenanceScheduleByIdUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load maintenance schedule by id', failure);
        state = MaintenanceScheduleDetailState.error(failure);
      },
      (success) {
        this.logData('Maintenance schedule loaded by id: ${success.data?.id}');
        if (success.data != null) {
          state = MaintenanceScheduleDetailState.success(success.data!);
        } else {
          state = MaintenanceScheduleDetailState.error(
            const ServerFailure(message: 'Maintenance schedule not found'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadMaintenanceSchedule(arg);
  }
}
