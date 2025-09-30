import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_record_repository.dart';

class GetMaintenanceRecordsUsecase
    implements
        Usecase<
          OffsetPaginatedSuccess<MaintenanceRecord>,
          GetMaintenanceRecordsUsecaseParams
        > {
  final MaintenanceRecordRepository _maintenanceRecordRepository;

  GetMaintenanceRecordsUsecase(this._maintenanceRecordRepository);

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<MaintenanceRecord>>> call(
    GetMaintenanceRecordsUsecaseParams params,
  ) async {
    return await _maintenanceRecordRepository.getMaintenanceRecords(params);
  }
}

class GetMaintenanceRecordsUsecaseParams extends Equatable {
  final int page;
  final int limit;
  final String? search;
  final String? sortBy;
  final String? sortOrder;
  final String? assetId;
  final String? performedByUserId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? scheduleId;

  GetMaintenanceRecordsUsecaseParams({
    this.page = 1,
    this.limit = 10,
    this.search,
    this.sortBy,
    this.sortOrder,
    this.assetId,
    this.performedByUserId,
    this.startDate,
    this.endDate,
    this.scheduleId,
  });

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'limit': limit,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (assetId != null) 'assetId': assetId,
      if (performedByUserId != null) 'performedByUserId': performedByUserId,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      if (scheduleId != null) 'scheduleId': scheduleId,
    };
  }

  factory GetMaintenanceRecordsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetMaintenanceRecordsUsecaseParams(
      page: map['page']?.toInt() ?? 1,
      limit: map['limit']?.toInt() ?? 10,
      search: map['search'],
      sortBy: map['sortBy'],
      sortOrder: map['sortOrder'],
      assetId: map['assetId'],
      performedByUserId: map['performedByUserId'],
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      scheduleId: map['scheduleId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GetMaintenanceRecordsUsecaseParams.fromJson(String source) =>
      GetMaintenanceRecordsUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    page,
    limit,
    search,
    sortBy,
    sortOrder,
    assetId,
    performedByUserId,
    startDate,
    endDate,
    scheduleId,
  ];
}
