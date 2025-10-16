import 'dart:convert';

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
  final ScheduleStatus? status;
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
    this.status,
    this.createdBy,
    this.fromDate,
    this.toDate,
    this.sortBy,
    this.sortOrder,
    this.cursor,
    this.limit,
  });

  GetMaintenanceSchedulesCursorUsecaseParams copyWith({
    String? search,
    String? assetId,
    MaintenanceScheduleType? maintenanceType,
    ScheduleStatus? status,
    String? createdBy,
    String? fromDate,
    String? toDate,
    MaintenanceScheduleSortBy? sortBy,
    SortOrder? sortOrder,
    String? cursor,
    int? limit,
  }) {
    return GetMaintenanceSchedulesCursorUsecaseParams(
      search: search ?? this.search,
      assetId: assetId ?? this.assetId,
      maintenanceType: maintenanceType ?? this.maintenanceType,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      cursor: cursor ?? this.cursor,
      limit: limit ?? this.limit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (assetId != null) 'assetId': assetId,
      if (maintenanceType != null) 'maintenanceType': maintenanceType!.value,
      if (status != null) 'status': status!.value,
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
      status: map['status'] != null
          ? ScheduleStatus.values.firstWhere((e) => e.value == map['status'])
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
      'GetMaintenanceSchedulesCursorUsecaseParams(search: $search, assetId: $assetId, maintenanceType: $maintenanceType, status: $status, createdBy: $createdBy, fromDate: $fromDate, toDate: $toDate, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';

  @override
  List<Object?> get props => [
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
