import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedules_cursor_usecase.dart';

// * State untuk mutation operation yang lebih descriptive
class MaintenanceScheduleMutationState extends Equatable {
  final MutationType type;
  final bool isLoading;
  final String? successMessage;
  final Failure? failure;

  const MaintenanceScheduleMutationState({
    required this.type,
    this.isLoading = false,
    this.successMessage,
    this.failure,
  });

  bool get isSuccess => successMessage != null && failure == null;
  bool get isError => failure != null;

  @override
  List<Object?> get props => [type, isLoading, successMessage, failure];
}

class MaintenanceSchedulesState extends Equatable {
  final List<MaintenanceSchedule> maintenanceSchedules;
  final GetMaintenanceSchedulesCursorUsecaseParams maintenanceSchedulesFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final MaintenanceScheduleMutationState? mutation;
  final Failure? failure;
  final Cursor? cursor;

  const MaintenanceSchedulesState({
    this.maintenanceSchedules = const [],
    required this.maintenanceSchedulesFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.mutation,
    this.failure,
    this.cursor,
  });

  // * Computed properties untuk kemudahan di UI
  bool get isMutating => mutation?.isLoading ?? false;
  bool get isCreating =>
      mutation?.type == MutationType.create && mutation!.isLoading;
  bool get isUpdating =>
      mutation?.type == MutationType.update && mutation!.isLoading;
  bool get isDeleting =>
      mutation?.type == MutationType.delete && mutation!.isLoading;
  bool get hasMutationSuccess => mutation?.isSuccess ?? false;
  bool get hasMutationError => mutation?.isError ?? false;
  String? get mutationMessage => mutation?.successMessage;
  Failure? get mutationFailure => mutation?.failure;

  // * Factory methods yang lebih descriptive
  factory MaintenanceSchedulesState.initial() => const MaintenanceSchedulesState(
    maintenanceSchedulesFilter: GetMaintenanceSchedulesCursorUsecaseParams(),
    isLoading: true,
  );

  factory MaintenanceSchedulesState.loading({
    required GetMaintenanceSchedulesCursorUsecaseParams
    maintenanceSchedulesFilter,
    List<MaintenanceSchedule>? currentMaintenanceSchedules,
  }) => MaintenanceSchedulesState(
    maintenanceSchedules: currentMaintenanceSchedules ?? const [],
    maintenanceSchedulesFilter: maintenanceSchedulesFilter,
    isLoading: true,
  );

  factory MaintenanceSchedulesState.success({
    required List<MaintenanceSchedule> maintenanceSchedules,
    required GetMaintenanceSchedulesCursorUsecaseParams
    maintenanceSchedulesFilter,
    Cursor? cursor,
  }) => MaintenanceSchedulesState(
    maintenanceSchedules: maintenanceSchedules,
    maintenanceSchedulesFilter: maintenanceSchedulesFilter,
    cursor: cursor,
  );

  factory MaintenanceSchedulesState.error({
    required Failure failure,
    required GetMaintenanceSchedulesCursorUsecaseParams
    maintenanceSchedulesFilter,
    List<MaintenanceSchedule>? currentMaintenanceSchedules,
  }) => MaintenanceSchedulesState(
    maintenanceSchedules: currentMaintenanceSchedules ?? const [],
    maintenanceSchedulesFilter: maintenanceSchedulesFilter,
    failure: failure,
  );

  factory MaintenanceSchedulesState.loadingMore({
    required List<MaintenanceSchedule> currentMaintenanceSchedules,
    required GetMaintenanceSchedulesCursorUsecaseParams
    maintenanceSchedulesFilter,
    Cursor? cursor,
  }) => MaintenanceSchedulesState(
    maintenanceSchedules: currentMaintenanceSchedules,
    maintenanceSchedulesFilter: maintenanceSchedulesFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  // * Factory methods untuk mutation states
  factory MaintenanceSchedulesState.creating({
    required List<MaintenanceSchedule> currentMaintenanceSchedules,
    required GetMaintenanceSchedulesCursorUsecaseParams
    maintenanceSchedulesFilter,
    Cursor? cursor,
  }) => MaintenanceSchedulesState(
    maintenanceSchedules: currentMaintenanceSchedules,
    maintenanceSchedulesFilter: maintenanceSchedulesFilter,
    cursor: cursor,
    mutation: const MaintenanceScheduleMutationState(
      type: MutationType.create,
      isLoading: true,
    ),
  );

  factory MaintenanceSchedulesState.updating({
    required List<MaintenanceSchedule> currentMaintenanceSchedules,
    required GetMaintenanceSchedulesCursorUsecaseParams
    maintenanceSchedulesFilter,
    Cursor? cursor,
  }) => MaintenanceSchedulesState(
    maintenanceSchedules: currentMaintenanceSchedules,
    maintenanceSchedulesFilter: maintenanceSchedulesFilter,
    cursor: cursor,
    mutation: const MaintenanceScheduleMutationState(
      type: MutationType.update,
      isLoading: true,
    ),
  );

  factory MaintenanceSchedulesState.deleting({
    required List<MaintenanceSchedule> currentMaintenanceSchedules,
    required GetMaintenanceSchedulesCursorUsecaseParams
    maintenanceSchedulesFilter,
    Cursor? cursor,
  }) => MaintenanceSchedulesState(
    maintenanceSchedules: currentMaintenanceSchedules,
    maintenanceSchedulesFilter: maintenanceSchedulesFilter,
    cursor: cursor,
    mutation: const MaintenanceScheduleMutationState(
      type: MutationType.delete,
      isLoading: true,
    ),
  );

  factory MaintenanceSchedulesState.mutationSuccess({
    required List<MaintenanceSchedule> maintenanceSchedules,
    required GetMaintenanceSchedulesCursorUsecaseParams
    maintenanceSchedulesFilter,
    required MutationType mutationType,
    required String message,
    Cursor? cursor,
  }) => MaintenanceSchedulesState(
    maintenanceSchedules: maintenanceSchedules,
    maintenanceSchedulesFilter: maintenanceSchedulesFilter,
    cursor: cursor,
    mutation: MaintenanceScheduleMutationState(
      type: mutationType,
      successMessage: message,
    ),
  );

  factory MaintenanceSchedulesState.mutationError({
    required List<MaintenanceSchedule> currentMaintenanceSchedules,
    required GetMaintenanceSchedulesCursorUsecaseParams
    maintenanceSchedulesFilter,
    required MutationType mutationType,
    required Failure failure,
    Cursor? cursor,
  }) => MaintenanceSchedulesState(
    maintenanceSchedules: currentMaintenanceSchedules,
    maintenanceSchedulesFilter: maintenanceSchedulesFilter,
    cursor: cursor,
    mutation: MaintenanceScheduleMutationState(
      type: mutationType,
      failure: failure,
    ),
  );

  MaintenanceSchedulesState copyWith({
    List<MaintenanceSchedule>? maintenanceSchedules,
    GetMaintenanceSchedulesCursorUsecaseParams? maintenanceSchedulesFilter,
    bool? isLoading,
    bool? isLoadingMore,
    ValueGetter<MaintenanceScheduleMutationState?>? mutation,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return MaintenanceSchedulesState(
      maintenanceSchedules: maintenanceSchedules ?? this.maintenanceSchedules,
      maintenanceSchedulesFilter:
          maintenanceSchedulesFilter ?? this.maintenanceSchedulesFilter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      mutation: mutation != null ? mutation() : this.mutation,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  // * Helper untuk clear mutation state setelah handled
  MaintenanceSchedulesState clearMutation() {
    return copyWith(mutation: () => null);
  }

  @override
  List<Object?> get props {
    return [
      maintenanceSchedules,
      maintenanceSchedulesFilter,
      isLoading,
      isLoadingMore,
      mutation,
      failure,
      cursor,
    ];
  }
}
