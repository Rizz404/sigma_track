import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_records_cursor_usecase.dart';

// * State untuk mutation operation yang lebih descriptive
class MaintenanceRecordMutationState extends Equatable {
  final MutationType type;
  final bool isLoading;
  final String? successMessage;
  final Failure? failure;

  const MaintenanceRecordMutationState({
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

class MaintenanceRecordsState extends Equatable {
  final List<MaintenanceRecord> maintenanceRecords;
  final GetMaintenanceRecordsCursorUsecaseParams maintenanceRecordsFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final MaintenanceRecordMutationState? mutation;
  final Failure? failure;
  final Cursor? cursor;

  const MaintenanceRecordsState({
    this.maintenanceRecords = const [],
    required this.maintenanceRecordsFilter,
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
  factory MaintenanceRecordsState.initial() => const MaintenanceRecordsState(
    maintenanceRecordsFilter: GetMaintenanceRecordsCursorUsecaseParams(),
    isLoading: true,
  );

  factory MaintenanceRecordsState.loading({
    required GetMaintenanceRecordsCursorUsecaseParams maintenanceRecordsFilter,
    List<MaintenanceRecord>? currentMaintenanceRecords,
  }) => MaintenanceRecordsState(
    maintenanceRecords: currentMaintenanceRecords ?? const [],
    maintenanceRecordsFilter: maintenanceRecordsFilter,
    isLoading: true,
  );

  factory MaintenanceRecordsState.success({
    required List<MaintenanceRecord> maintenanceRecords,
    required GetMaintenanceRecordsCursorUsecaseParams maintenanceRecordsFilter,
    Cursor? cursor,
  }) => MaintenanceRecordsState(
    maintenanceRecords: maintenanceRecords,
    maintenanceRecordsFilter: maintenanceRecordsFilter,
    cursor: cursor,
  );

  factory MaintenanceRecordsState.error({
    required Failure failure,
    required GetMaintenanceRecordsCursorUsecaseParams maintenanceRecordsFilter,
    List<MaintenanceRecord>? currentMaintenanceRecords,
  }) => MaintenanceRecordsState(
    maintenanceRecords: currentMaintenanceRecords ?? const [],
    maintenanceRecordsFilter: maintenanceRecordsFilter,
    failure: failure,
  );

  factory MaintenanceRecordsState.loadingMore({
    required List<MaintenanceRecord> currentMaintenanceRecords,
    required GetMaintenanceRecordsCursorUsecaseParams maintenanceRecordsFilter,
    Cursor? cursor,
  }) => MaintenanceRecordsState(
    maintenanceRecords: currentMaintenanceRecords,
    maintenanceRecordsFilter: maintenanceRecordsFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  // * Factory methods untuk mutation states
  factory MaintenanceRecordsState.creating({
    required List<MaintenanceRecord> currentMaintenanceRecords,
    required GetMaintenanceRecordsCursorUsecaseParams maintenanceRecordsFilter,
    Cursor? cursor,
  }) => MaintenanceRecordsState(
    maintenanceRecords: currentMaintenanceRecords,
    maintenanceRecordsFilter: maintenanceRecordsFilter,
    cursor: cursor,
    mutation: const MaintenanceRecordMutationState(
      type: MutationType.create,
      isLoading: true,
    ),
  );

  factory MaintenanceRecordsState.updating({
    required List<MaintenanceRecord> currentMaintenanceRecords,
    required GetMaintenanceRecordsCursorUsecaseParams maintenanceRecordsFilter,
    Cursor? cursor,
  }) => MaintenanceRecordsState(
    maintenanceRecords: currentMaintenanceRecords,
    maintenanceRecordsFilter: maintenanceRecordsFilter,
    cursor: cursor,
    mutation: const MaintenanceRecordMutationState(
      type: MutationType.update,
      isLoading: true,
    ),
  );

  factory MaintenanceRecordsState.deleting({
    required List<MaintenanceRecord> currentMaintenanceRecords,
    required GetMaintenanceRecordsCursorUsecaseParams maintenanceRecordsFilter,
    Cursor? cursor,
  }) => MaintenanceRecordsState(
    maintenanceRecords: currentMaintenanceRecords,
    maintenanceRecordsFilter: maintenanceRecordsFilter,
    cursor: cursor,
    mutation: const MaintenanceRecordMutationState(
      type: MutationType.delete,
      isLoading: true,
    ),
  );

  factory MaintenanceRecordsState.mutationSuccess({
    required List<MaintenanceRecord> maintenanceRecords,
    required GetMaintenanceRecordsCursorUsecaseParams maintenanceRecordsFilter,
    required MutationType mutationType,
    required String message,
    Cursor? cursor,
  }) => MaintenanceRecordsState(
    maintenanceRecords: maintenanceRecords,
    maintenanceRecordsFilter: maintenanceRecordsFilter,
    cursor: cursor,
    mutation: MaintenanceRecordMutationState(
      type: mutationType,
      successMessage: message,
    ),
  );

  factory MaintenanceRecordsState.mutationError({
    required List<MaintenanceRecord> currentMaintenanceRecords,
    required GetMaintenanceRecordsCursorUsecaseParams maintenanceRecordsFilter,
    required MutationType mutationType,
    required Failure failure,
    Cursor? cursor,
  }) => MaintenanceRecordsState(
    maintenanceRecords: currentMaintenanceRecords,
    maintenanceRecordsFilter: maintenanceRecordsFilter,
    cursor: cursor,
    mutation: MaintenanceRecordMutationState(
      type: mutationType,
      failure: failure,
    ),
  );

  MaintenanceRecordsState copyWith({
    List<MaintenanceRecord>? maintenanceRecords,
    GetMaintenanceRecordsCursorUsecaseParams? maintenanceRecordsFilter,
    bool? isLoading,
    bool? isLoadingMore,
    ValueGetter<MaintenanceRecordMutationState?>? mutation,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return MaintenanceRecordsState(
      maintenanceRecords: maintenanceRecords ?? this.maintenanceRecords,
      maintenanceRecordsFilter:
          maintenanceRecordsFilter ?? this.maintenanceRecordsFilter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      mutation: mutation != null ? mutation() : this.mutation,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  // * Helper untuk clear mutation state setelah handled
  MaintenanceRecordsState clearMutation() {
    return copyWith(mutation: () => null);
  }

  @override
  List<Object?> get props {
    return [
      maintenanceRecords,
      maintenanceRecordsFilter,
      isLoading,
      isLoadingMore,
      mutation,
      failure,
      cursor,
    ];
  }
}
