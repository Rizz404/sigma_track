import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/export_maintenance_schedule_list_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/export_maintenance_schedules_state.dart';

class ExportMaintenanceSchedulesNotifier
    extends AutoDisposeNotifier<ExportMaintenanceSchedulesState> {
  ExportMaintenanceScheduleListUsecase
  get _exportMaintenanceScheduleListUsecase =>
      ref.watch(exportMaintenanceScheduleListUsecaseProvider);

  @override
  ExportMaintenanceSchedulesState build() {
    this.logPresentation('Initializing ExportMaintenanceSchedulesNotifier');
    return ExportMaintenanceSchedulesState.initial();
  }

  void reset() {
    this.logPresentation('Resetting export state');
    state = ExportMaintenanceSchedulesState.initial();
  }

  Future<void> exportMaintenanceSchedules(
    ExportMaintenanceScheduleListUsecaseParams params,
  ) async {
    this.logPresentation(
      'Exporting maintenance schedules with params: $params',
    );

    state = state.copyWith(
      isLoading: true,
      failure: null,
      message: null,
      previewData: null,
    );

    final result = await _exportMaintenanceScheduleListUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to export maintenance schedules', failure);
        state = state.copyWith(isLoading: false, failure: failure);
      },
      (success) async {
        this.logData('Maintenance schedules exported successfully');
        state = state.copyWith(
          isLoading: false,
          previewData: success.data,
          message: 'Export preview generated successfully',
        );
      },
    );
  }
}
