import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
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
  final int? limit;
  final String? cursor;
  final String? sortBy;
  final String? sortDirection;
  final String? search;

  GetScanLogsCursorUsecaseParams({
    this.limit,
    this.cursor,
    this.sortBy,
    this.sortDirection,
    this.search,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (limit != null) map['limit'] = limit;
    if (cursor != null) map['cursor'] = cursor;
    if (sortBy != null) map['sortBy'] = sortBy;
    if (sortDirection != null) map['sortDirection'] = sortDirection;
    if (search != null) map['search'] = search;
    return map;
  }

  factory GetScanLogsCursorUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetScanLogsCursorUsecaseParams(
      limit: map['limit']?.toInt(),
      cursor: map['cursor'],
      sortBy: map['sortBy'],
      sortDirection: map['sortDirection'],
      search: map['search'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GetScanLogsCursorUsecaseParams.fromJson(String source) =>
      GetScanLogsCursorUsecaseParams.fromMap(json.decode(source));

  GetScanLogsCursorUsecaseParams copyWith({
    int? limit,
    String? cursor,
    String? sortBy,
    String? sortDirection,
    String? search,
  }) {
    return GetScanLogsCursorUsecaseParams(
      limit: limit ?? this.limit,
      cursor: cursor ?? this.cursor,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
      search: search ?? this.search,
    );
  }

  @override
  List<Object?> get props {
    return [limit, cursor, sortBy, sortDirection, search];
  }
}
