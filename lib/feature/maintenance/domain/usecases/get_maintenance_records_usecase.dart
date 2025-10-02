import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
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
  final String? search;
  final String? assetId;
  final String? scheduleId;
  final String? performedByUser;
  final String? vendorName;
  final String? fromDate;
  final String? toDate;
  final MaintenanceRecordSortBy? sortBy;
  final SortOrder? sortOrder;
  final int? limit;
  final int? offset;

  const GetMaintenanceRecordsUsecaseParams({
    this.search,
    this.assetId,
    this.scheduleId,
    this.performedByUser,
    this.vendorName,
    this.fromDate,
    this.toDate,
    this.sortBy,
    this.sortOrder,
    this.limit,
    this.offset,
  });

  GetMaintenanceRecordsUsecaseParams copyWith({
    String? search,
    String? assetId,
    String? scheduleId,
    String? performedByUser,
    String? vendorName,
    String? fromDate,
    String? toDate,
    MaintenanceRecordSortBy? sortBy,
    SortOrder? sortOrder,
    int? limit,
    int? offset,
  }) {
    return GetMaintenanceRecordsUsecaseParams(
      search: search ?? this.search,
      assetId: assetId ?? this.assetId,
      scheduleId: scheduleId ?? this.scheduleId,
      performedByUser: performedByUser ?? this.performedByUser,
      vendorName: vendorName ?? this.vendorName,
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
      if (scheduleId != null) 'scheduleId': scheduleId,
      if (performedByUser != null) 'performedByUser': performedByUser,
      if (vendorName != null) 'vendorName': vendorName,
      if (fromDate != null) 'fromDate': fromDate,
      if (toDate != null) 'toDate': toDate,
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
  }

  factory GetMaintenanceRecordsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetMaintenanceRecordsUsecaseParams(
      search: map['search'],
      assetId: map['assetId'],
      scheduleId: map['scheduleId'],
      performedByUser: map['performedByUser'],
      vendorName: map['vendorName'],
      fromDate: map['fromDate'],
      toDate: map['toDate'],
      sortBy: map['sortBy'] != null
          ? MaintenanceRecordSortBy.fromString(map['sortBy'])
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.fromString(map['sortOrder'])
          : null,
      limit: map['limit']?.toInt(),
      offset: map['offset']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetMaintenanceRecordsUsecaseParams.fromJson(String source) =>
      GetMaintenanceRecordsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetMaintenanceRecordsUsecaseParams(search: $search, assetId: $assetId, scheduleId: $scheduleId, performedByUser: $performedByUser, vendorName: $vendorName, fromDate: $fromDate, toDate: $toDate, sortBy: $sortBy, sortOrder: $sortOrder, limit: $limit, offset: $offset)';

  @override
  List<Object?> get props => [
    search,
    assetId,
    scheduleId,
    performedByUser,
    vendorName,
    fromDate,
    toDate,
    sortBy,
    sortOrder,
    limit,
    offset,
  ];
}
