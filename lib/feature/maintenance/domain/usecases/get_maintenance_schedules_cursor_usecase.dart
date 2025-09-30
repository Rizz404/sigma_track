import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
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
  final String? cursor;
  final int limit;
  final String? search;
  final String? sortBy;
  final String? sortOrder;
  final String? assetId;
  final MaintenanceScheduleType? maintenanceType;
  final ScheduleStatus? status;
  final String? createdById;
  final DateTime? startDate;
  final DateTime? endDate;

  GetMaintenanceSchedulesCursorUsecaseParams({
    this.cursor,
    this.limit = 10,
    this.search,
    this.sortBy,
    this.sortOrder,
    this.assetId,
    this.maintenanceType,
    this.status,
    this.createdById,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      if (cursor != null) 'cursor': cursor,
      'limit': limit,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (assetId != null) 'assetId': assetId,
      if (maintenanceType != null) 'maintenanceType': maintenanceType!.name,
      if (status != null) 'status': status!.name,
      if (createdById != null) 'createdById': createdById,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
    };
  }

  factory GetMaintenanceSchedulesCursorUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return GetMaintenanceSchedulesCursorUsecaseParams(
      cursor: map['cursor'],
      limit: map['limit']?.toInt() ?? 10,
      search: map['search'],
      sortBy: map['sortBy'],
      sortOrder: map['sortOrder'],
      assetId: map['assetId'],
      maintenanceType: map['maintenanceType'] != null
          ? MaintenanceScheduleType.values.byName(map['maintenanceType'])
          : null,
      status: map['status'] != null
          ? ScheduleStatus.values.byName(map['status'])
          : null,
      createdById: map['createdById'],
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetMaintenanceSchedulesCursorUsecaseParams.fromJson(String source) =>
      GetMaintenanceSchedulesCursorUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    cursor,
    limit,
    search,
    sortBy,
    sortOrder,
    assetId,
    maintenanceType,
    status,
    createdById,
    startDate,
    endDate,
  ];
}
