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

class GetMaintenanceSchedulesUsecase
    implements
        Usecase<
          OffsetPaginatedSuccess<MaintenanceSchedule>,
          GetMaintenanceSchedulesUsecaseParams
        > {
  final MaintenanceScheduleRepository _maintenanceScheduleRepository;

  GetMaintenanceSchedulesUsecase(this._maintenanceScheduleRepository);

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<MaintenanceSchedule>>> call(
    GetMaintenanceSchedulesUsecaseParams params,
  ) async {
    return await _maintenanceScheduleRepository.getMaintenanceSchedules(params);
  }
}

class GetMaintenanceSchedulesUsecaseParams extends Equatable {
  final String? search;
  final String? assetId;
  final MaintenanceScheduleType? maintenanceType;
  final ScheduleState? state;
  final String? createdBy;
  final String? fromDate;
  final String? toDate;
  final MaintenanceScheduleSortBy? sortBy;
  final SortOrder? sortOrder;
  final int? limit;
  final int? offset;

  const GetMaintenanceSchedulesUsecaseParams({
    this.search,
    this.assetId,
    this.maintenanceType,
    this.state,
    this.createdBy,
    this.fromDate,
    this.toDate,
    this.sortBy,
    this.sortOrder,
    this.limit,
    this.offset,
  });

  GetMaintenanceSchedulesUsecaseParams copyWith({
    String? search,
    String? assetId,
    MaintenanceScheduleType? maintenanceType,
    ScheduleState? state,
    String? createdBy,
    String? fromDate,
    String? toDate,
    MaintenanceScheduleSortBy? sortBy,
    SortOrder? sortOrder,
    int? limit,
    int? offset,
  }) {
    return GetMaintenanceSchedulesUsecaseParams(
      search: search ?? this.search,
      assetId: assetId ?? this.assetId,
      maintenanceType: maintenanceType ?? this.maintenanceType,
      state: state ?? this.state,
      createdBy: createdBy ?? this.createdBy,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
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
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
  }

  factory GetMaintenanceSchedulesUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return GetMaintenanceSchedulesUsecaseParams(
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
      limit: map['limit']?.toInt(),
      offset: map['offset']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetMaintenanceSchedulesUsecaseParams.fromJson(String source) =>
      GetMaintenanceSchedulesUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetMaintenanceSchedulesUsecaseParams(search: $search, assetId: $assetId, maintenanceType: $maintenanceType, state: $state, createdBy: $createdBy, fromDate: $fromDate, toDate: $toDate, sortBy: $sortBy, sortOrder: $sortOrder, limit: $limit, offset: $offset)';

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
    limit,
    offset,
  ];
}
