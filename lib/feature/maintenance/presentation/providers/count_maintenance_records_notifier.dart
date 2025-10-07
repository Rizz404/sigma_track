import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/count_maintenance_records_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_record_count_state.dart';

class CountMaintenanceRecordsNotifier
    extends AutoDisposeNotifier<MaintenanceRecordCountState> {
  CountMaintenanceRecordsUsecase get _countMaintenanceRecordsUsecase =>
      ref.watch(countMaintenanceRecordsUsecaseProvider);

  @override
  MaintenanceRecordCountState build() {
    this.logPresentation('Initializing CountMaintenanceRecordsNotifier');
    return MaintenanceRecordCountState.initial();
  }

  Future<void> countMaintenanceRecords({
    String? assetId,
    String? performedByUser,
  }) async {
    this.logPresentation('Counting maintenance records with filters');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _countMaintenanceRecordsUsecase.call(
      CountMaintenanceRecordsUsecaseParams(
        assetId: assetId,
        performedByUser: performedByUser,
      ),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to count maintenance records',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation('Successfully counted maintenance records');
        state = state.copyWith(
          isLoading: false,
          count: success.data,
          failure: null,
        );
      },
    );
  }
}
