import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_record_by_id_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_record_detail_state.dart';

class GetMaintenanceRecordByIdNotifier
    extends AutoDisposeNotifier<MaintenanceRecordDetailState> {
  GetMaintenanceRecordByIdUsecase get _getMaintenanceRecordByIdUsecase =>
      ref.watch(getMaintenanceRecordByIdUsecaseProvider);

  @override
  MaintenanceRecordDetailState build() {
    this.logPresentation('Initializing GetMaintenanceRecordByIdNotifier');
    return MaintenanceRecordDetailState.initial();
  }

  Future<void> getMaintenanceRecordById(String id) async {
    this.logPresentation('Getting maintenance record by id: $id');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _getMaintenanceRecordByIdUsecase.call(
      GetMaintenanceRecordByIdUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to get maintenance record by id',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation('Successfully got maintenance record by id');
        state = state.copyWith(
          isLoading: false,
          maintenanceRecord: success.data,
          failure: null,
        );
      },
    );
  }
}
