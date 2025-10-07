import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';

class MaintenanceScheduleBooleanState extends Equatable {
  final bool? result;
  final bool isLoading;
  final Failure? failure;

  const MaintenanceScheduleBooleanState({
    this.result,
    this.isLoading = false,
    this.failure,
  });

  factory MaintenanceScheduleBooleanState.initial() =>
      const MaintenanceScheduleBooleanState();

  MaintenanceScheduleBooleanState copyWith({
    bool? result,
    bool? isLoading,
    Failure? failure,
  }) {
    return MaintenanceScheduleBooleanState(
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [result, isLoading, failure];
}
