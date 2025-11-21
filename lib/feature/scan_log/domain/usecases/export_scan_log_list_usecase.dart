import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/repositories/scan_log_repository.dart';

class ExportScanLogListUsecase
    implements Usecase<ItemSuccess<Uint8List>, ExportScanLogListUsecaseParams> {
  final ScanLogRepository _scanLogRepository;

  ExportScanLogListUsecase(this._scanLogRepository);

  @override
  Future<Either<Failure, ItemSuccess<Uint8List>>> call(
    ExportScanLogListUsecaseParams params,
  ) async {
    return await _scanLogRepository.exportScanLogList(params);
  }
}

class ExportScanLogListUsecaseParams extends Equatable {
  final ExportFormat format;
  final String? searchQuery;
  final String? assetId;
  final String? userId;
  final ScanMethodType? scanMethod;
  final ScanResultType? scanResult;
  final DateTime? startDate;
  final DateTime? endDate;
  final ScanLogSortBy? sortBy;
  final SortOrder? sortOrder;

  const ExportScanLogListUsecaseParams({
    required this.format,
    this.searchQuery,
    this.assetId,
    this.userId,
    this.scanMethod,
    this.scanResult,
    this.startDate,
    this.endDate,
    this.sortBy,
    this.sortOrder,
  });

  ExportScanLogListUsecaseParams copyWith({
    ExportFormat? format,
    String? searchQuery,
    String? assetId,
    String? userId,
    ScanMethodType? scanMethod,
    ScanResultType? scanResult,
    ult,
    DateTime? startDate,
    DateTime? endDate,
    ScanLogSortBy? sortBy,
    SortOrder? sortOrder,
  }) {
    return ExportScanLogListUsecaseParams(
      format: format ?? this.format,
      searchQuery: searchQuery ?? this.searchQuery,
      assetId: assetId ?? this.assetId,
      userId: userId ?? this.userId,
      scanMethod: scanMethod ?? this.scanMethod,
      scanResult: scanResult ?? this.scanResult,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'format': format.value,
      if (searchQuery != null) 'searchQuery': searchQuery,
      if (assetId != null) 'assetId': assetId,
      if (userId != null) 'userId': userId,
      if (scanMethod != null) 'scanMethod': scanMethod!.value,
      if (scanResult != null) 'scanResult': scanResult!.value,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
    };
  }

  factory ExportScanLogListUsecaseParams.fromMap(Map<String, dynamic> map) {
    return ExportScanLogListUsecaseParams(
      format: ExportFormat.values.firstWhere((e) => e.value == map['format']),
      searchQuery: map['searchQuery'],
      assetId: map['assetId'],
      userId: map['userId'],
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
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      sortBy: map['sortBy'] != null
          ? ScanLogSortBy.values.firstWhere((e) => e.value == map['sortBy'])
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.values.firstWhere((e) => e.value == map['sortOrder'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExportScanLogListUsecaseParams.fromJson(String source) =>
      ExportScanLogListUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'ExportScanLogListUsecaseParams(format: $format, searchQuery: $searchQuery, assetId: $assetId, userId: $userId, scanMethod: $scanMethod, scanResult: $scanResult, startDate: $startDate, endDate: $endDate, sortBy: $sortBy, sortOrder: $sortOrder)';

  @override
  List<Object?> get props => [
    format,
    searchQuery,
    assetId,
    userId,
    scanMethod,
    scanResult,
    startDate,
    endDate,
    sortBy,
    sortOrder,
  ];
}
