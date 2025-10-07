import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';

class MaintenanceRecordBooleanState extends Equatable {
  final bool? result;
  final bool isLoading;
  final Failure? failure;

  const MaintenanceRecordBooleanState({
    this.result,
    this.isLoading = false,
    this.failure,
  });

  factory MaintenanceRecordBooleanState.initial() =>
      const MaintenanceRecordBooleanState();

  MaintenanceRecordBooleanState copyWith({
    bool? result,
    bool? isLoading,
    Failure? failure,
  }) {
    return MaintenanceRecordBooleanState(
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [result, isLoading, failure];
}
