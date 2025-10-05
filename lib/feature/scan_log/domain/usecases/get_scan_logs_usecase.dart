import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';
import 'package:sigma_track/feature/scan_log/domain/repositories/scan_log_repository.dart';

class GetScanLogsUsecase
    implements
        Usecase<OffsetPaginatedSuccess<ScanLog>, GetScanLogsUsecaseParams> {
  final ScanLogRepository _scanLogRepository;

  GetScanLogsUsecase(this._scanLogRepository);

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<ScanLog>>> call(
    GetScanLogsUsecaseParams params,
  ) async {
    return await _scanLogRepository.getScanLogs(params);
  }
}

class GetScanLogsUsecaseParams extends Equatable {
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
  final int? limit;
  final int? offset;

  const GetScanLogsUsecaseParams({
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
    this.limit,
    this.offset,
  });

  GetScanLogsUsecaseParams copyWith({
    String? search,
    ScanMethodType? scanMethod,
    ScanResultType? scanResult,
    String? scannedBy,
    String? assetId,
    String? dateFrom,
    String? dateTo,
    bool? hasCoordinates,
    ScanLogSortBy? sortBy,
    SortOrder? sortOrder,
    int? limit,
    int? offset,
  }) {
    return GetScanLogsUsecaseParams(
      search: search ?? this.search,
      scanMethod: scanMethod ?? this.scanMethod,
      scanResult: scanResult ?? this.scanResult,
      scannedBy: scannedBy ?? this.scannedBy,
      assetId: assetId ?? this.assetId,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      hasCoordinates: hasCoordinates ?? this.hasCoordinates,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (scanMethod != null) 'scanMethod': scanMethod!.toString(),
      if (scanResult != null) 'scanResult': scanResult!.toString(),
      if (scannedBy != null) 'scannedBy': scannedBy,
      if (assetId != null) 'assetId': assetId,
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
      if (hasCoordinates != null) 'hasCoordinates': hasCoordinates,
      if (sortBy != null) 'sortBy': sortBy!.toString(),
      if (sortOrder != null) 'sortOrder': sortOrder!.toString(),
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
  }

  factory GetScanLogsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetScanLogsUsecaseParams(
      search: map['search'],
      scanMethod: map['scanMethod'] != null
          ? ScanMethodType.fromString(map['scanMethod'])
          : null,
      scanResult: map['scanResult'] != null
          ? ScanResultType.fromString(map['scanResult'])
          : null,
      scannedBy: map['scannedBy'],
      assetId: map['assetId'],
      dateFrom: map['dateFrom'],
      dateTo: map['dateTo'],
      hasCoordinates: map['hasCoordinates'],
      sortBy: map['sortBy'] != null
          ? ScanLogSortBy.fromString(map['sortBy'])
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.fromString(map['sortOrder'])
          : null,
      limit: map['limit']?.toInt(),
      offset: map['offset']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetScanLogsUsecaseParams.fromJson(String source) =>
      GetScanLogsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetScanLogsUsecaseParams(search: $search, scanMethod: $scanMethod, scanResult: $scanResult, scannedBy: $scannedBy, assetId: $assetId, dateFrom: $dateFrom, dateTo: $dateTo, hasCoordinates: $hasCoordinates, sortBy: $sortBy, sortOrder: $sortOrder, limit: $limit, offset: $offset)';

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
    limit,
    offset,
  ];
}
