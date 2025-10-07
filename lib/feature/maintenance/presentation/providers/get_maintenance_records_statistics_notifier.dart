import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_records_statistics_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_record_statistics_state.dart';

class GetMaintenanceRecordsStatisticsNotifier
    extends AutoDisposeNotifier<MaintenanceRecordStatisticsState> {
  GetMaintenanceRecordsStatisticsUsecase
  get _getMaintenanceRecordsStatisticsUsecase =>
      ref.watch(getMaintenanceRecordsStatisticsUsecaseProvider);

  @override
  MaintenanceRecordStatisticsState build() {
    this.logPresentation(
      'Initializing GetMaintenanceRecordsStatisticsNotifier',
    );
    return MaintenanceRecordStatisticsState.initial();
  }

  Future<void> getMaintenanceRecordsStatistics() async {
    this.logPresentation('Getting maintenance records statistics');

    state = state.copyWith(isLoading: true, failure: null);

    final result = await _getMaintenanceRecordsStatisticsUsecase.call(
      NoParams(),
    );

    result.fold(
      (failure) {
        this.logError(
          'Failed to get maintenance records statistics',
          failure,
          StackTrace.current,
        );
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) {
        this.logPresentation('Successfully got maintenance records statistics');
        state = state.copyWith(
          isLoading: false,
          statistics: success.data,
          failure: null,
        );
      },
    );
  }
}
