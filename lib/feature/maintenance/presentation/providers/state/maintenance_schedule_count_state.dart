import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';

class MaintenanceScheduleCountState extends Equatable {
  final int? count;
  final bool isLoading;
  final Failure? failure;

  const MaintenanceScheduleCountState({
    this.count,
    this.isLoading = false,
    this.failure,
  });

  factory MaintenanceScheduleCountState.initial() =>
      const MaintenanceScheduleCountState();

  MaintenanceScheduleCountState copyWith({
    int? count,
    bool? isLoading,
    Failure? failure,
  }) {
    return MaintenanceScheduleCountState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [count, isLoading, failure];
}
