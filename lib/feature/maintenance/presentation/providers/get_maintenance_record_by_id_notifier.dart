import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_record_by_id_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_record_detail_state.dart';

class GetMaintenanceRecordByIdNotifier
    extends AutoDisposeFamilyNotifier<MaintenanceRecordDetailState, String> {
  GetMaintenanceRecordByIdUsecase get _getMaintenanceRecordByIdUsecase =>
      ref.watch(getMaintenanceRecordByIdUsecaseProvider);

  @override
  MaintenanceRecordDetailState build(String id) {
    // * Cache maintenance record detail for 3 minutes (detail view use case)
    ref.cacheFor(const Duration(minutes: 3));
    this.logPresentation('Loading maintenance record by id: $id');
    _loadMaintenanceRecord(id);
    return MaintenanceRecordDetailState.initial();
  }

  Future<void> _loadMaintenanceRecord(String id) async {
    state = MaintenanceRecordDetailState.loading();

    final result = await _getMaintenanceRecordByIdUsecase.call(
      GetMaintenanceRecordByIdUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load maintenance record by id', failure);
        state = MaintenanceRecordDetailState.error(failure);
      },
      (success) {
        this.logData('Maintenance record loaded by id: ${success.data?.id}');
        if (success.data != null) {
          state = MaintenanceRecordDetailState.success(success.data!);
        } else {
          state = MaintenanceRecordDetailState.error(
            const ServerFailure(message: 'Maintenance record not found'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadMaintenanceRecord(arg);
  }
}
