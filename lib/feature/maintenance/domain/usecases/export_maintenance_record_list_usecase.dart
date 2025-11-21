import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_record_repository.dart';

class ExportMaintenanceRecordListUsecase
    implements
        Usecase<
          ItemSuccess<Uint8List>,
          ExportMaintenanceRecordListUsecaseParams
        > {
  final MaintenanceRecordRepository _maintenanceRecordRepository;

  ExportMaintenanceRecordListUsecase(this._maintenanceRecordRepository);

  @override
  Future<Either<Failure, ItemSuccess<Uint8List>>> call(
    ExportMaintenanceRecordListUsecaseParams params,
  ) async {
    return await _maintenanceRecordRepository.exportMaintenanceRecordList(
      params,
    );
  }
}

class ExportMaintenanceRecordListUsecaseParams extends Equatable {
  final ExportFormat format;
  final String? searchQuery;
  final String? assetId;
  final String? scheduleId;
  final String? performedBy;
  final DateTime? startDate;
  final DateTime? endDate;
  final MaintenanceRecordSortBy? sortBy;
  final SortOrder? sortOrder;

  const ExportMaintenanceRecordListUsecaseParams({
    required this.format,
    this.searchQuery,
    this.assetId,
    this.scheduleId,
    this.performedBy,
    this.startDate,
    this.endDate,
    this.sortBy,
    this.sortOrder,
  });

  ExportMaintenanceRecordListUsecaseParams copyWith({
    ExportFormat? format,
    String? searchQuery,
    String? assetId,
    String? scheduleId,
    String? performedBy,
    DateTime? startDate,
    DateTime? endDate,
    MaintenanceRecordSortBy? sortBy,
    SortOrder? sortOrder,
  }) {
    return ExportMaintenanceRecordListUsecaseParams(
      format: format ?? this.format,
      searchQuery: searchQuery ?? this.searchQuery,
      assetId: assetId ?? this.assetId,
      scheduleId: scheduleId ?? this.scheduleId,
      performedBy: performedBy ?? this.performedBy,
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
      if (scheduleId != null) 'scheduleId': scheduleId,
      if (performedBy != null) 'performedBy': performedBy,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
    };
  }

  factory ExportMaintenanceRecordListUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return ExportMaintenanceRecordListUsecaseParams(
      format: ExportFormat.values.firstWhere((e) => e.value == map['format']),
      searchQuery: map['searchQuery'],
      assetId: map['assetId'],
      scheduleId: map['scheduleId'],
      performedBy: map['performedBy'],
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      sortBy: map['sortBy'] != null
          ? MaintenanceRecordSortBy.values.firstWhere(
              (e) => e.value == map['sortBy'],
            )
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.values.firstWhere((e) => e.value == map['sortOrder'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExportMaintenanceRecordListUsecaseParams.fromJson(String source) =>
      ExportMaintenanceRecordListUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'ExportMaintenanceRecordListUsecaseParams(format: $format, searchQuery: $searchQuery, assetId: $assetId, scheduleId: $scheduleId, performedBy: $performedBy, startDate: $startDate, endDate: $endDate, sortBy: $sortBy, sortOrder: $sortOrder)';

  @override
  List<Object?> get props => [
    format,
    searchQuery,
    assetId,
    scheduleId,
    performedBy,
    startDate,
    endDate,
    sortBy,
    sortOrder,
  ];
}
