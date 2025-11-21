import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_schedule_repository.dart';

class ExportMaintenanceScheduleListUsecase
    implements
        Usecase<
          ItemSuccess<Uint8List>,
          ExportMaintenanceScheduleListUsecaseParams
        > {
  final MaintenanceScheduleRepository _maintenanceScheduleRepository;

  ExportMaintenanceScheduleListUsecase(this._maintenanceScheduleRepository);

  @override
  Future<Either<Failure, ItemSuccess<Uint8List>>> call(
    ExportMaintenanceScheduleListUsecaseParams params,
  ) async {
    return await _maintenanceScheduleRepository.exportMaintenanceScheduleList(
      params,
    );
  }
}

class ExportMaintenanceScheduleListUsecaseParams extends Equatable {
  final ExportFormat format;
  final String? searchQuery;
  final MaintenanceScheduleType? maintenanceType;
  final ScheduleState? state;
  final String? assetId;
  final DateTime? startDate;
  final DateTime? endDate;
  final MaintenanceScheduleSortBy? sortBy;
  final SortOrder? sortOrder;

  const ExportMaintenanceScheduleListUsecaseParams({
    required this.format,
    this.searchQuery,
    this.maintenanceType,
    this.state,
    this.assetId,
    this.startDate,
    this.endDate,
    this.sortBy,
    this.sortOrder,
  });

  ExportMaintenanceScheduleListUsecaseParams copyWith({
    ExportFormat? format,
    String? searchQuery,
    MaintenanceScheduleType? maintenanceType,
    ScheduleState? state,
    String? assetId,
    DateTime? startDate,
    DateTime? endDate,
    MaintenanceScheduleSortBy? sortBy,
    SortOrder? sortOrder,
  }) {
    return ExportMaintenanceScheduleListUsecaseParams(
      format: format ?? this.format,
      searchQuery: searchQuery ?? this.searchQuery,
      maintenanceType: maintenanceType ?? this.maintenanceType,
      state: state ?? this.state,
      assetId: assetId ?? this.assetId,
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
      if (maintenanceType != null) 'maintenanceType': maintenanceType!.value,
      if (state != null) 'state': state!.value,
      if (assetId != null) 'assetId': assetId,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
    };
  }

  factory ExportMaintenanceScheduleListUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return ExportMaintenanceScheduleListUsecaseParams(
      format: ExportFormat.values.firstWhere((e) => e.value == map['format']),
      searchQuery: map['searchQuery'],
      maintenanceType: map['maintenanceType'] != null
          ? MaintenanceScheduleType.values.firstWhere(
              (e) => e.value == map['maintenanceType'],
            )
          : null,
      state: map['state'] != null
          ? ScheduleState.values.firstWhere((e) => e.value == map['state'])
          : null,
      assetId: map['assetId'],
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      sortBy: map['sortBy'] != null
          ? MaintenanceScheduleSortBy.values.firstWhere(
              (e) => e.value == map['sortBy'],
            )
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.values.firstWhere((e) => e.value == map['sortOrder'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExportMaintenanceScheduleListUsecaseParams.fromJson(String source) =>
      ExportMaintenanceScheduleListUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'ExportMaintenanceScheduleListUsecaseParams(format: $format, searchQuery: $searchQuery, maintenanceType: $maintenanceType, state: $state, assetId: $assetId, startDate: $startDate, endDate: $endDate, sortBy: $sortBy, sortOrder: $sortOrder)';

  @override
  List<Object?> get props => [
    format,
    searchQuery,
    maintenanceType,
    state,
    assetId,
    startDate,
    endDate,
    sortBy,
    sortOrder,
  ];
}
