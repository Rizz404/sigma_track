import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/domain/failure.dart';

class MaintenanceRecordCountState extends Equatable {
  final int? count;
  final bool isLoading;
  final Failure? failure;

  const MaintenanceRecordCountState({
    this.count,
    this.isLoading = false,
    this.failure,
  });

  factory MaintenanceRecordCountState.initial() =>
      const MaintenanceRecordCountState();

  MaintenanceRecordCountState copyWith({
    int? count,
    bool? isLoading,
    Failure? failure,
  }) {
    return MaintenanceRecordCountState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [count, isLoading, failure];
}
