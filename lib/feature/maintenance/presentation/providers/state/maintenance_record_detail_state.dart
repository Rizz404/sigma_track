import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';

class MaintenanceRecordDetailState extends Equatable {
  final MaintenanceRecord? maintenanceRecord;
  final bool isLoading;
  final Failure? failure;

  const MaintenanceRecordDetailState({
    this.maintenanceRecord,
    this.isLoading = false,
    this.failure,
  });

  factory MaintenanceRecordDetailState.initial() =>
      const MaintenanceRecordDetailState();

  factory MaintenanceRecordDetailState.loading() =>
      const MaintenanceRecordDetailState(isLoading: true);

  factory MaintenanceRecordDetailState.success(
    MaintenanceRecord maintenanceRecord,
  ) => MaintenanceRecordDetailState(maintenanceRecord: maintenanceRecord);

  factory MaintenanceRecordDetailState.error(Failure failure) =>
      MaintenanceRecordDetailState(failure: failure);

  MaintenanceRecordDetailState copyWith({
    MaintenanceRecord? maintenanceRecord,
    bool? isLoading,
    Failure? failure,
  }) {
    return MaintenanceRecordDetailState(
      maintenanceRecord: maintenanceRecord ?? this.maintenanceRecord,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [maintenanceRecord, isLoading, failure];
}
