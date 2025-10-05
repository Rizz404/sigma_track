import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';

class ScanLogsFilter extends Equatable {
  final String? search;
  final ScanMethodType? scanMethod;
  final ScanResultType? scanResult;
  final String? scannedBy;
  final String? assetId;
  final String? dateFrom;
  final String? dateTo;
  final bool? hasCoordinates;
  final ScanLogSortBy? sortBy;
  final SortOrder? sortOrder;
  final String? cursor;
  final int? limit;

  ScanLogsFilter({
    this.search,
    this.scanMethod,
    this.scanResult,
    this.scannedBy,
    this.assetId,
    this.dateFrom,
    this.dateTo,
    this.hasCoordinates,
    this.sortBy,
    this.sortOrder,
    this.cursor,
    this.limit,
  });

  ScanLogsFilter copyWith({
    ValueGetter<String?>? search,
    ValueGetter<ScanMethodType?>? scanMethod,
    ValueGetter<ScanResultType?>? scanResult,
    ValueGetter<String?>? scannedBy,
    ValueGetter<String?>? assetId,
    ValueGetter<String?>? dateFrom,
    ValueGetter<String?>? dateTo,
    ValueGetter<bool?>? hasCoordinates,
    ValueGetter<ScanLogSortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<String?>? cursor,
    ValueGetter<int?>? limit,
  }) {
    return ScanLogsFilter(
      search: search != null ? search() : this.search,
      scanMethod: scanMethod != null ? scanMethod() : this.scanMethod,
      scanResult: scanResult != null ? scanResult() : this.scanResult,
      scannedBy: scannedBy != null ? scannedBy() : this.scannedBy,
      assetId: assetId != null ? assetId() : this.assetId,
      dateFrom: dateFrom != null ? dateFrom() : this.dateFrom,
      dateTo: dateTo != null ? dateTo() : this.dateTo,
      hasCoordinates: hasCoordinates != null
          ? hasCoordinates()
          : this.hasCoordinates,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortOrder: sortOrder != null ? sortOrder() : this.sortOrder,
      cursor: cursor != null ? cursor() : this.cursor,
      limit: limit != null ? limit() : this.limit,
    );
  }

  @override
  List<Object?> get props {
    return [
      search,
      scanMethod,
      scanResult,
      scannedBy,
      assetId,
      dateFrom,
      dateTo,
      hasCoordinates,
      sortBy,
      sortOrder,
      cursor,
      limit,
    ];
  }

  @override
  String toString() {
    return 'ScanLogsFilter(search: $search, scanMethod: $scanMethod, scanResult: $scanResult, scannedBy: $scannedBy, assetId: $assetId, dateFrom: $dateFrom, dateTo: $dateTo, hasCoordinates: $hasCoordinates, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';
  }
}

class ScanLogsState extends Equatable {
  final List<ScanLog> scanLogs;
  final ScanLog? mutatedScanLog;
  final ScanLogsFilter scanLogsFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isMutating;
  final String? message;
  final Failure? failure;
  final Cursor? cursor;

  const ScanLogsState({
    this.scanLogs = const [],
    this.mutatedScanLog,
    required this.scanLogsFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isMutating = false,
    this.message,
    this.failure,
    this.cursor,
  });

  factory ScanLogsState.initial() =>
      ScanLogsState(scanLogsFilter: ScanLogsFilter(), isLoading: true);

  factory ScanLogsState.loading({
    required ScanLogsFilter scanLogsFilter,
    List<ScanLog>? currentScanLogs,
  }) => ScanLogsState(
    scanLogs: currentScanLogs ?? const [],
    scanLogsFilter: scanLogsFilter,
    isLoading: true,
  );

  factory ScanLogsState.success({
    required List<ScanLog> scanLogs,
    required ScanLogsFilter scanLogsFilter,
    Cursor? cursor,
    String? message,
    ScanLog? mutatedScanLog,
  }) => ScanLogsState(
    scanLogs: scanLogs,
    scanLogsFilter: scanLogsFilter,
    cursor: cursor,
    message: message,
    mutatedScanLog: mutatedScanLog,
  );

  factory ScanLogsState.error({
    required Failure failure,
    required ScanLogsFilter scanLogsFilter,
    List<ScanLog>? currentScanLogs,
  }) => ScanLogsState(
    scanLogs: currentScanLogs ?? const [],
    scanLogsFilter: scanLogsFilter,
    failure: failure,
  );

  factory ScanLogsState.loadingMore({
    required List<ScanLog> currentScanLogs,
    required ScanLogsFilter scanLogsFilter,
    Cursor? cursor,
  }) => ScanLogsState(
    scanLogs: currentScanLogs,
    scanLogsFilter: scanLogsFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  ScanLogsState copyWith({
    List<ScanLog>? scanLogs,
    ValueGetter<ScanLog?>? mutatedScanLog,
    ScanLogsFilter? scanLogsFilter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isMutating,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return ScanLogsState(
      scanLogs: scanLogs ?? this.scanLogs,
      mutatedScanLog: mutatedScanLog != null
          ? mutatedScanLog()
          : this.mutatedScanLog,
      scanLogsFilter: scanLogsFilter ?? this.scanLogsFilter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMutating: isMutating ?? this.isMutating,
      message: message != null ? message() : this.message,
      failure: failure != null ? failure() : this.failure,
      cursor: cursor != null ? cursor() : this.cursor,
    );
  }

  @override
  List<Object?> get props {
    return [
      scanLogs,
      mutatedScanLog,
      scanLogsFilter,
      isLoading,
      isLoadingMore,
      isMutating,
      message,
      failure,
      cursor,
    ];
  }
}
