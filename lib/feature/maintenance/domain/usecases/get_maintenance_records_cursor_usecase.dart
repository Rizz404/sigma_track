import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_record_repository.dart';

class GetMaintenanceRecordsCursorUsecase
    implements
        Usecase<
          CursorPaginatedSuccess<MaintenanceRecord>,
          GetMaintenanceRecordsCursorUsecaseParams
        > {
  final MaintenanceRecordRepository _maintenanceRecordRepository;

  GetMaintenanceRecordsCursorUsecase(this._maintenanceRecordRepository);

  @override
  Future<Either<Failure, CursorPaginatedSuccess<MaintenanceRecord>>> call(
    GetMaintenanceRecordsCursorUsecaseParams params,
  ) async {
    return await _maintenanceRecordRepository.getMaintenanceRecordsCursor(
      params,
    );
  }
}

class GetMaintenanceRecordsCursorUsecaseParams extends Equatable {
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

  const GetMaintenanceRecordsCursorUsecaseParams({
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

  GetMaintenanceRecordsCursorUsecaseParams copyWith({
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
    return GetMaintenanceRecordsCursorUsecaseParams(
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
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
    };
  }

  factory GetMaintenanceRecordsCursorUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return GetMaintenanceRecordsCursorUsecaseParams(
      search: map['search'],
      assetId: map['assetId'],
      scheduleId: map['scheduleId'],
      performedByUser: map['performedByUser'],
      vendorName: map['vendorName'],
      fromDate: map['fromDate'],
      toDate: map['toDate'],
      sortBy: map['sortBy'] != null
          ? MaintenanceRecordSortBy.values.firstWhere(
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

  factory GetMaintenanceRecordsCursorUsecaseParams.fromJson(String source) =>
      GetMaintenanceRecordsCursorUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetMaintenanceRecordsCursorUsecaseParams(search: $search, assetId: $assetId, scheduleId: $scheduleId, performedByUser: $performedByUser, vendorName: $vendorName, fromDate: $fromDate, toDate: $toDate, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';

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
    cursor,
    limit,
  ];
}
