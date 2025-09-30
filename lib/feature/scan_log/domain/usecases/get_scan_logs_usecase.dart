import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
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
  final int? limit;
  final int? offset;
  final String? sortBy;
  final String? sortDirection;
  final String? search;

  GetScanLogsUsecaseParams({
    this.limit,
    this.offset,
    this.sortBy,
    this.sortDirection,
    this.search,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (limit != null) map['limit'] = limit;
    if (offset != null) map['offset'] = offset;
    if (sortBy != null) map['sortBy'] = sortBy;
    if (sortDirection != null) map['sortDirection'] = sortDirection;
    if (search != null) map['search'] = search;
    return map;
  }

  factory GetScanLogsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetScanLogsUsecaseParams(
      limit: map['limit']?.toInt(),
      offset: map['offset']?.toInt(),
      sortBy: map['sortBy'],
      sortDirection: map['sortDirection'],
      search: map['search'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GetScanLogsUsecaseParams.fromJson(String source) =>
      GetScanLogsUsecaseParams.fromMap(json.decode(source));

  GetScanLogsUsecaseParams copyWith({
    int? limit,
    int? offset,
    String? sortBy,
    String? sortDirection,
    String? search,
  }) {
    return GetScanLogsUsecaseParams(
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props {
    return [limit, offset, sortBy, sortDirection, search];
  }
}
