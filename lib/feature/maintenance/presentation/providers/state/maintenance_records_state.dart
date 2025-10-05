import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';

class MaintenanceRecordsFilter extends Equatable {
  final String? search;
  final String? assetId;
  final String? scheduleId;
  final String? performedByUser;
  final String? vendorName;
  final String? fromDate;
  final String? toDate;
  final MaintenanceRecordSortBy? sortBy;
  final SortOrder? sortOrder;
  final String? cursor;
  final int? limit;

  MaintenanceRecordsFilter({
    this.search,
    this.assetId,
    this.scheduleId,
    this.performedByUser,
    this.vendorName,
    this.fromDate,
    this.toDate,
    this.sortBy,
    this.sortOrder,
    this.cursor,
    this.limit,
  });

  MaintenanceRecordsFilter copyWith({
    ValueGetter<String?>? search,
    ValueGetter<String?>? assetId,
    ValueGetter<String?>? scheduleId,
    ValueGetter<String?>? performedByUser,
    ValueGetter<String?>? vendorName,
    ValueGetter<String?>? fromDate,
    ValueGetter<String?>? toDate,
    ValueGetter<MaintenanceRecordSortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<String?>? cursor,
    ValueGetter<int?>? limit,
  }) {
    return MaintenanceRecordsFilter(
      search: search != null ? search() : this.search,
      assetId: assetId != null ? assetId() : this.assetId,
      scheduleId: scheduleId != null ? scheduleId() : this.scheduleId,
      performedByUser: performedByUser != null
          ? performedByUser()
          : this.performedByUser,
      vendorName: vendorName != null ? vendorName() : this.vendorName,
      fromDate: fromDate != null ? fromDate() : this.fromDate,
      toDate: toDate != null ? toDate() : this.toDate,
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
      assetId,
      scheduleId,
      performedByUser,
      vendorName,
      fromDate,
      toDate,
      sortBy,
      sortOrder,
      cursor,
      limit,
    ];
  }

  @override
  String toString() {
    return 'MaintenanceRecordsFilter(search: $search, assetId: $assetId, scheduleId: $scheduleId, performedByUser: $performedByUser, vendorName: $vendorName, fromDate: $fromDate, toDate: $toDate, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';
  }
}

class MaintenanceRecordsState extends Equatable {
  final List<MaintenanceRecord> maintenanceRecords;
  final MaintenanceRecord? mutatedMaintenanceRecord;
  final MaintenanceRecordsFilter maintenanceRecordsFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isMutating;
  final String? message;
  final Failure? failure;
  final Cursor? cursor;

  const MaintenanceRecordsState({
    this.maintenanceRecords = const [],
    this.mutatedMaintenanceRecord,
    required this.maintenanceRecordsFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isMutating = false,
    this.message,
    this.failure,
    this.cursor,
  });

  factory MaintenanceRecordsState.initial() => MaintenanceRecordsState(
    maintenanceRecordsFilter: MaintenanceRecordsFilter(),
    isLoading: true,
  );

  factory MaintenanceRecordsState.loading({
    required MaintenanceRecordsFilter maintenanceRecordsFilter,
    List<MaintenanceRecord>? currentMaintenanceRecords,
  }) => MaintenanceRecordsState(
    maintenanceRecords: currentMaintenanceRecords ?? const [],
    maintenanceRecordsFilter: maintenanceRecordsFilter,
    isLoading: true,
  );

  factory MaintenanceRecordsState.success({
    required List<MaintenanceRecord> maintenanceRecords,
    required MaintenanceRecordsFilter maintenanceRecordsFilter,
    Cursor? cursor,
    String? message,
    MaintenanceRecord? mutatedMaintenanceRecord,
  }) => MaintenanceRecordsState(
    maintenanceRecords: maintenanceRecords,
    maintenanceRecordsFilter: maintenanceRecordsFilter,
    cursor: cursor,
    message: message,
    mutatedMaintenanceRecord: mutatedMaintenanceRecord,
  );

  factory MaintenanceRecordsState.error({
    required Failure failure,
    required MaintenanceRecordsFilter maintenanceRecordsFilter,
    List<MaintenanceRecord>? currentMaintenanceRecords,
  }) => MaintenanceRecordsState(
    maintenanceRecords: currentMaintenanceRecords ?? const [],
    maintenanceRecordsFilter: maintenanceRecordsFilter,
    failure: failure,
  );

  factory MaintenanceRecordsState.loadingMore({
    required List<MaintenanceRecord> currentMaintenanceRecords,
    required MaintenanceRecordsFilter maintenanceRecordsFilter,
    Cursor? cursor,
  }) => MaintenanceRecordsState(
    maintenanceRecords: currentMaintenanceRecords,
    maintenanceRecordsFilter: maintenanceRecordsFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  MaintenanceRecordsState copyWith({
    List<MaintenanceRecord>? maintenanceRecords,
    ValueGetter<MaintenanceRecord?>? mutatedMaintenanceRecord,
    MaintenanceRecordsFilter? maintenanceRecordsFilter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isMutating,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return MaintenanceRecordsState(
      maintenanceRecords: maintenanceRecords ?? this.maintenanceRecords,
      mutatedMaintenanceRecord: mutatedMaintenanceRecord != null
          ? mutatedMaintenanceRecord()
          : this.mutatedMaintenanceRecord,
      maintenanceRecordsFilter:
          maintenanceRecordsFilter ?? this.maintenanceRecordsFilter,
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
      maintenanceRecords,
      mutatedMaintenanceRecord,
      maintenanceRecordsFilter,
      isLoading,
      isLoadingMore,
      isMutating,
      message,
      failure,
      cursor,
    ];
  }
}
