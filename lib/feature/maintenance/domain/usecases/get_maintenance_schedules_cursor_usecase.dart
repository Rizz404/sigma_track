import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_schedule_repository.dart';

class GetMaintenanceSchedulesCursorUsecase
    implements
        Usecase<
          CursorPaginatedSuccess<MaintenanceSchedule>,
          GetMaintenanceSchedulesCursorUsecaseParams
        > {
  final MaintenanceScheduleRepository _maintenanceScheduleRepository;

  GetMaintenanceSchedulesCursorUsecase(this._maintenanceScheduleRepository);

  @override
  Future<Either<Failure, CursorPaginatedSuccess<MaintenanceSchedule>>> call(
    GetMaintenanceSchedulesCursorUsecaseParams params,
  ) async {
    return await _maintenanceScheduleRepository.getMaintenanceSchedulesCursor(
      params,
    );
  }
}

class GetMaintenanceSchedulesCursorUsecaseParams extends Equatable {
  final String? search;
  final String? assetId;
  final MaintenanceScheduleType? maintenanceType;
  final ScheduleState? state;
  final String? createdBy;
  final String? fromDate;
  final String? toDate;
  final MaintenanceScheduleSortBy? sortBy;
  final SortOrder? sortOrder;
  final String? cursor;
  final int? limit;

  const GetMaintenanceSchedulesCursorUsecaseParams({
    this.search,
    this.assetId,
    this.maintenanceType,
    this.state,
    this.createdBy,
    this.fromDate,
    this.toDate,
    this.sortBy,
    this.sortOrder,
    this.cursor,
    this.limit,
  });

  GetMaintenanceSchedulesCursorUsecaseParams copyWith({
    ValueGetter<String?>? search,
    ValueGetter<String?>? assetId,
    ValueGetter<MaintenanceScheduleType?>? maintenanceType,
    ValueGetter<ScheduleState?>? state,
    ValueGetter<String?>? createdBy,
    ValueGetter<String?>? fromDate,
    ValueGetter<String?>? toDate,
    ValueGetter<MaintenanceScheduleSortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<String?>? cursor,
    ValueGetter<int?>? limit,
  }) {
    return GetMaintenanceSchedulesCursorUsecaseParams(
      search: search != null ? search() : this.search,
      assetId: assetId != null ? assetId() : this.assetId,
      maintenanceType: maintenanceType != null
          ? maintenanceType()
          : this.maintenanceType,
      state: state != null ? state() : this.state,
      createdBy: createdBy != null ? createdBy() : this.createdBy,
      fromDate: fromDate != null ? fromDate() : this.fromDate,
      toDate: toDate != null ? toDate() : this.toDate,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortOrder: sortOrder != null ? sortOrder() : this.sortOrder,
      cursor: cursor != null ? cursor() : this.cursor,
      limit: limit != null ? limit() : this.limit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (assetId != null) 'assetId': assetId,
      if (maintenanceType != null) 'maintenanceType': maintenanceType!.value,
      if (state != null) 'state': state!.value,
      if (createdBy != null) 'createdBy': createdBy,
      if (fromDate != null) 'fromDate': fromDate,
      if (toDate != null) 'toDate': toDate,
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
    };
  }

  factory GetMaintenanceSchedulesCursorUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return GetMaintenanceSchedulesCursorUsecaseParams(
      search: map['search'],
      assetId: map['assetId'],
      maintenanceType: map['maintenanceType'] != null
          ? MaintenanceScheduleType.values.firstWhere(
              (e) => e.value == map['maintenanceType'],
            )
          : null,
      state: map['state'] != null
          ? ScheduleState.values.firstWhere((e) => e.value == map['state'])
          : null,
      createdBy: map['createdBy'],
      fromDate: map['fromDate'],
      toDate: map['toDate'],
      sortBy: map['sortBy'] != null
          ? MaintenanceScheduleSortBy.values.firstWhere(
              (e) => e.value == map['sortBy'],
            )
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.values.firstWhere((e) => e.value == map['sortOrder'])
          : null,
      cursor: map['cursor'],
      limit: map['limit']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetMaintenanceSchedulesCursorUsecaseParams.fromJson(String source) =>
      GetMaintenanceSchedulesCursorUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetMaintenanceSchedulesCursorUsecaseParams(search: $search, assetId: $assetId, maintenanceType: $maintenanceType, state: $state, createdBy: $createdBy, fromDate: $fromDate, toDate: $toDate, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';

  @override
  List<Object?> get props => [
    search,
    assetId,
    maintenanceType,
    state,
    createdBy,
    fromDate,
    toDate,
    sortBy,
    sortOrder,
    cursor,
    limit,
  ];
}
