import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_cursor_usecase.dart';

// * State untuk mutation operation yang lebih descriptive
class ScanLogMutationState extends Equatable {
  final MutationType type;
  final bool isLoading;
  final String? successMessage;
  final Failure? failure;

  const ScanLogMutationState({
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

class ScanLogsState extends Equatable {
  final List<ScanLog> scanLogs;
  final GetScanLogsCursorUsecaseParams scanLogsFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final ScanLogMutationState? mutation;
  final Failure? failure;
  final Cursor? cursor;

  const ScanLogsState({
    this.scanLogs = const [],
    required this.scanLogsFilter,
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
  factory ScanLogsState.initial() => const ScanLogsState(
    scanLogsFilter: GetScanLogsCursorUsecaseParams(),
    isLoading: true,
  );

  factory ScanLogsState.loading({
    required GetScanLogsCursorUsecaseParams scanLogsFilter,
    List<ScanLog>? currentScanLogs,
  }) => ScanLogsState(
    scanLogs: currentScanLogs ?? const [],
    scanLogsFilter: scanLogsFilter,
    isLoading: true,
  );

  factory ScanLogsState.success({
    required List<ScanLog> scanLogs,
    required GetScanLogsCursorUsecaseParams scanLogsFilter,
    Cursor? cursor,
  }) => ScanLogsState(
    scanLogs: scanLogs,
    scanLogsFilter: scanLogsFilter,
    cursor: cursor,
  );

  factory ScanLogsState.error({
    required Failure failure,
    required GetScanLogsCursorUsecaseParams scanLogsFilter,
    List<ScanLog>? currentScanLogs,
  }) => ScanLogsState(
    scanLogs: currentScanLogs ?? const [],
    scanLogsFilter: scanLogsFilter,
    failure: failure,
  );

  factory ScanLogsState.loadingMore({
    required List<ScanLog> currentScanLogs,
    required GetScanLogsCursorUsecaseParams scanLogsFilter,
    Cursor? cursor,
  }) => ScanLogsState(
    scanLogs: currentScanLogs,
    scanLogsFilter: scanLogsFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  // * Factory methods untuk mutation states
  factory ScanLogsState.creating({
    required List<ScanLog> currentScanLogs,
    required GetScanLogsCursorUsecaseParams scanLogsFilter,
    Cursor? cursor,
  }) => ScanLogsState(
    scanLogs: currentScanLogs,
    scanLogsFilter: scanLogsFilter,
    cursor: cursor,
    mutation: const ScanLogMutationState(
      type: MutationType.create,
      isLoading: true,
    ),
  );

  factory ScanLogsState.updating({
    required List<ScanLog> currentScanLogs,
    required GetScanLogsCursorUsecaseParams scanLogsFilter,
    Cursor? cursor,
  }) => ScanLogsState(
    scanLogs: currentScanLogs,
    scanLogsFilter: scanLogsFilter,
    cursor: cursor,
    mutation: const ScanLogMutationState(
      type: MutationType.update,
      isLoading: true,
    ),
  );

  factory ScanLogsState.deleting({
    required List<ScanLog> currentScanLogs,
    required GetScanLogsCursorUsecaseParams scanLogsFilter,
    Cursor? cursor,
  }) => ScanLogsState(
    scanLogs: currentScanLogs,
    scanLogsFilter: scanLogsFilter,
    cursor: cursor,
    mutation: const ScanLogMutationState(
      type: MutationType.delete,
      isLoading: true,
    ),
  );

  factory ScanLogsState.mutationSuccess({
    required List<ScanLog> scanLogs,
    required GetScanLogsCursorUsecaseParams scanLogsFilter,
    required MutationType mutationType,
    required String message,
    Cursor? cursor,
  }) => ScanLogsState(
    scanLogs: scanLogs,
    scanLogsFilter: scanLogsFilter,
    cursor: cursor,
    mutation: ScanLogMutationState(type: mutationType, successMessage: message),
  );

  factory ScanLogsState.mutationError({
    required List<ScanLog> currentScanLogs,
    required GetScanLogsCursorUsecaseParams scanLogsFilter,
    required MutationType mutationType,
    required Failure failure,
    Cursor? cursor,
  }) => ScanLogsState(
    scanLogs: currentScanLogs,
    scanLogsFilter: scanLogsFilter,
    cursor: cursor,
    mutation: ScanLogMutationState(type: mutationType, failure: failure),
  );

  ScanLogsState copyWith({
    List<ScanLog>? scanLogs,
    GetScanLogsCursorUsecaseParams? scanLogsFilter,
    bool? isLoading,
    bool? isLoadingMore,
    ValueGetter<ScanLogMutationState?>? mutation,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return ScanLogsState(
      scanLogs: scanLogs ?? this.scanLogs,
      scanLogsFilter: scanLogsFilter ?? this.scanLogsFilter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      mutation: mutation != null ? mutation() : this.mutation,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  // * Helper untuk clear mutation state setelah handled
  ScanLogsState clearMutation() {
    return copyWith(mutation: () => null);
  }

  @override
  List<Object?> get props {
    return [
      scanLogs,
      scanLogsFilter,
      isLoading,
      isLoadingMore,
      mutation,
      failure,
      cursor,
    ];
  }
}
