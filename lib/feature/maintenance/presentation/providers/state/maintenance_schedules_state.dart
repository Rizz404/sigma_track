import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';

class MaintenanceSchedulesFilter extends Equatable {
  final String? search;
  final String? assetId;
  final MaintenanceScheduleType? maintenanceType;
  final ScheduleStatus? status;
  final String? createdBy;
  final String? fromDate;
  final String? toDate;
  final MaintenanceScheduleSortBy? sortBy;
  final SortOrder? sortOrder;
  final String? cursor;
  final int? limit;

  MaintenanceSchedulesFilter({
    this.search,
    this.assetId,
    this.maintenanceType,
    this.status,
    this.createdBy,
    this.fromDate,
    this.toDate,
    this.sortBy,
    this.sortOrder,
    this.cursor,
    this.limit,
  });

  MaintenanceSchedulesFilter copyWith({
    ValueGetter<String?>? search,
    ValueGetter<String?>? assetId,
    ValueGetter<MaintenanceScheduleType?>? maintenanceType,
    ValueGetter<ScheduleStatus?>? status,
    ValueGetter<String?>? createdBy,
    ValueGetter<String?>? fromDate,
    ValueGetter<String?>? toDate,
    ValueGetter<MaintenanceScheduleSortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<String?>? cursor,
    ValueGetter<int?>? limit,
  }) {
    return MaintenanceSchedulesFilter(
      search: search != null ? search() : this.search,
      assetId: assetId != null ? assetId() : this.assetId,
      maintenanceType: maintenanceType != null
          ? maintenanceType()
          : this.maintenanceType,
      status: status != null ? status() : this.status,
      createdBy: createdBy != null ? createdBy() : this.createdBy,
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
      maintenanceType,
      status,
      createdBy,
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
    return 'MaintenanceSchedulesFilter(search: $search, assetId: $assetId, maintenanceType: $maintenanceType, status: $status, createdBy: $createdBy, fromDate: $fromDate, toDate: $toDate, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';
  }
}

class MaintenanceSchedulesState extends Equatable {
  final List<MaintenanceSchedule> maintenanceSchedules;
  final MaintenanceSchedule? mutatedMaintenanceSchedule;
  final MaintenanceSchedulesFilter maintenanceSchedulesFilter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isMutating;
  final String? message;
  final Failure? failure;
  final Cursor? cursor;

  const MaintenanceSchedulesState({
    this.maintenanceSchedules = const [],
    this.mutatedMaintenanceSchedule,
    required this.maintenanceSchedulesFilter,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isMutating = false,
    this.message,
    this.failure,
    this.cursor,
  });

  factory MaintenanceSchedulesState.initial() => MaintenanceSchedulesState(
    maintenanceSchedulesFilter: MaintenanceSchedulesFilter(),
    isLoading: true,
  );

  factory MaintenanceSchedulesState.loading({
    required MaintenanceSchedulesFilter maintenanceSchedulesFilter,
    List<MaintenanceSchedule>? currentMaintenanceSchedules,
  }) => MaintenanceSchedulesState(
    maintenanceSchedules: currentMaintenanceSchedules ?? const [],
    maintenanceSchedulesFilter: maintenanceSchedulesFilter,
    isLoading: true,
  );

  factory MaintenanceSchedulesState.success({
    required List<MaintenanceSchedule> maintenanceSchedules,
    required MaintenanceSchedulesFilter maintenanceSchedulesFilter,
    Cursor? cursor,
    String? message,
    MaintenanceSchedule? mutatedMaintenanceSchedule,
  }) => MaintenanceSchedulesState(
    maintenanceSchedules: maintenanceSchedules,
    maintenanceSchedulesFilter: maintenanceSchedulesFilter,
    cursor: cursor,
    message: message,
    mutatedMaintenanceSchedule: mutatedMaintenanceSchedule,
  );

  factory MaintenanceSchedulesState.error({
    required Failure failure,
    required MaintenanceSchedulesFilter maintenanceSchedulesFilter,
    List<MaintenanceSchedule>? currentMaintenanceSchedules,
  }) => MaintenanceSchedulesState(
    maintenanceSchedules: currentMaintenanceSchedules ?? const [],
    maintenanceSchedulesFilter: maintenanceSchedulesFilter,
    failure: failure,
  );

  factory MaintenanceSchedulesState.loadingMore({
    required List<MaintenanceSchedule> currentMaintenanceSchedules,
    required MaintenanceSchedulesFilter maintenanceSchedulesFilter,
    Cursor? cursor,
  }) => MaintenanceSchedulesState(
    maintenanceSchedules: currentMaintenanceSchedules,
    maintenanceSchedulesFilter: maintenanceSchedulesFilter,
    cursor: cursor,
    isLoadingMore: true,
  );

  MaintenanceSchedulesState copyWith({
    List<MaintenanceSchedule>? maintenanceSchedules,
    ValueGetter<MaintenanceSchedule?>? mutatedMaintenanceSchedule,
    MaintenanceSchedulesFilter? maintenanceSchedulesFilter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isMutating,
    ValueGetter<String?>? message,
    ValueGetter<Failure?>? failure,
    ValueGetter<Cursor?>? cursor,
  }) {
    return MaintenanceSchedulesState(
      maintenanceSchedules: maintenanceSchedules ?? this.maintenanceSchedules,
      mutatedMaintenanceSchedule: mutatedMaintenanceSchedule != null
          ? mutatedMaintenanceSchedule()
          : this.mutatedMaintenanceSchedule,
      maintenanceSchedulesFilter:
          maintenanceSchedulesFilter ?? this.maintenanceSchedulesFilter,
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
      maintenanceSchedules,
      mutatedMaintenanceSchedule,
      maintenanceSchedulesFilter,
      isLoading,
      isLoadingMore,
      isMutating,
      message,
      failure,
      cursor,
    ];
  }
}
