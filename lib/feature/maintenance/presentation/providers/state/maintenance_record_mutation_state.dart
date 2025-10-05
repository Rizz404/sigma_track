import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';

enum MaintenanceRecordStatus { initial, loading, error, success }

class MaintenanceRecordMutationState extends Equatable {
  final MaintenanceRecordStatus maintenanceRecordStatus;
  final MaintenanceRecord? maintenanceRecord;
  final String? message;
  final Failure? failure;

  const MaintenanceRecordMutationState({
    required this.maintenanceRecordStatus,
    this.maintenanceRecord,
    this.message,
    this.failure,
  });

  factory MaintenanceRecordMutationState.success({
    MaintenanceRecord? maintenanceRecord,
    String? message,
  }) {
    return MaintenanceRecordMutationState(
      maintenanceRecordStatus: MaintenanceRecordStatus.success,
      maintenanceRecord: maintenanceRecord,
      message: message,
    );
  }

  factory MaintenanceRecordMutationState.error({Failure? failure}) {
    return MaintenanceRecordMutationState(
      maintenanceRecordStatus: MaintenanceRecordStatus.error,
      failure: failure,
      message: failure?.message,
    );
  }

  MaintenanceRecordMutationState copyWith({
    MaintenanceRecordStatus? maintenanceRecordStatus,
    ValueGetter<MaintenanceRecord?>? maintenanceRecord,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
  }) {
    return MaintenanceRecordMutationState(
      maintenanceRecordStatus:
          maintenanceRecordStatus ?? this.maintenanceRecordStatus,
      maintenanceRecord: maintenanceRecord != null
          ? maintenanceRecord()
          : this.maintenanceRecord,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [
    maintenanceRecordStatus,
    maintenanceRecord,
    message,
    failure,
  ];
}
