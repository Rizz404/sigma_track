import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';
import 'package:sigma_track/feature/scan_log/domain/repositories/scan_log_repository.dart';

class GetScanLogsCursorUsecase
    implements
        Usecase<
          CursorPaginatedSuccess<ScanLog>,
          GetScanLogsCursorUsecaseParams
        > {
  final ScanLogRepository _scanLogRepository;

  GetScanLogsCursorUsecase(this._scanLogRepository);

  @override
  Future<Either<Failure, CursorPaginatedSuccess<ScanLog>>> call(
    GetScanLogsCursorUsecaseParams params,
  ) async {
    return await _scanLogRepository.getScanLogsCursor(params);
  }
}

class GetScanLogsCursorUsecaseParams extends Equatable {
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

  const GetScanLogsCursorUsecaseParams({
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

  GetScanLogsCursorUsecaseParams copyWith({
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
    return GetScanLogsCursorUsecaseParams(
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

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (scanMethod != null) 'scanMethod': scanMethod!.value,
      if (scanResult != null) 'scanResult': scanResult!.value,
      if (scannedBy != null) 'scannedBy': scannedBy,
      if (assetId != null) 'assetId': assetId,
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
      if (hasCoordinates != null) 'hasCoordinates': hasCoordinates,
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
    };
  }

  factory GetScanLogsCursorUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetScanLogsCursorUsecaseParams(
      search: map['search'],
      scanMethod: map['scanMethod'] != null
          ? ScanMethodType.values.firstWhere(
              (e) => e.value == map['scanMethod'],
            )
          : null,
      scanResult: map['scanResult'] != null
          ? ScanResultType.values.firstWhere(
              (e) => e.value == map['scanResult'],
            )
          : null,
      scannedBy: map['scannedBy'],
      assetId: map['assetId'],
      dateFrom: map['dateFrom'],
      dateTo: map['dateTo'],
      hasCoordinates: map['hasCoordinates'],
      sortBy: map['sortBy'] != null
          ? ScanLogSortBy.values.firstWhere((e) => e.value == map['sortBy'])
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.values.firstWhere((e) => e.value == map['sortOrder'])
          : null,
      cursor: map['cursor'],
      limit: map['limit']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetScanLogsCursorUsecaseParams.fromJson(String source) =>
      GetScanLogsCursorUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetScanLogsCursorUsecaseParams(search: $search, scanMethod: $scanMethod, scanResult: $scanResult, scannedBy: $scannedBy, assetId: $assetId, dateFrom: $dateFrom, dateTo: $dateTo, hasCoordinates: $hasCoordinates, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';

  @override
  List<Object?> get props => [
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
