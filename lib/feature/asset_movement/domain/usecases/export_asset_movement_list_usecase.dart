import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';

class ExportAssetMovementListUsecase
    implements
        Usecase<ItemSuccess<Uint8List>, ExportAssetMovementListUsecaseParams> {
  final AssetMovementRepository _assetMovementRepository;

  ExportAssetMovementListUsecase(this._assetMovementRepository);

  @override
  Future<Either<Failure, ItemSuccess<Uint8List>>> call(
    ExportAssetMovementListUsecaseParams params,
  ) async {
    return await _assetMovementRepository.exportAssetMovementList(params);
  }
}

class ExportAssetMovementListUsecaseParams extends Equatable {
  final ExportFormat format;
  final String? searchQuery;
  final String? assetId;
  final DateTime? startDate;
  final DateTime? endDate;
  final AssetMovementSortBy? sortBy;
  final SortOrder? sortOrder;

  const ExportAssetMovementListUsecaseParams({
    required this.format,
    this.searchQuery,
    this.assetId,
    this.startDate,
    this.endDate,
    this.sortBy,
    this.sortOrder,
  });

  ExportAssetMovementListUsecaseParams copyWith({
    ExportFormat? format,
    String? searchQuery,
    String? assetId,
    DateTime? startDate,
    DateTime? endDate,
    AssetMovementSortBy? sortBy,
    SortOrder? sortOrder,
  }) {
    return ExportAssetMovementListUsecaseParams(
      format: format ?? this.format,
      searchQuery: searchQuery ?? this.searchQuery,
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
      if (assetId != null) 'assetId': assetId,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
    };
  }

  factory ExportAssetMovementListUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return ExportAssetMovementListUsecaseParams(
      format: ExportFormat.values.firstWhere((e) => e.value == map['format']),
      searchQuery: map['searchQuery'],
      assetId: map['assetId'],
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      sortBy: map['sortBy'] != null
          ? AssetMovementSortBy.values.firstWhere(
              (e) => e.value == map['sortBy'],
            )
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.values.firstWhere((e) => e.value == map['sortOrder'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExportAssetMovementListUsecaseParams.fromJson(String source) =>
      ExportAssetMovementListUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'ExportAssetMovementListUsecaseParams(format: $format, searchQuery: $searchQuery, assetId: $assetId, startDate: $startDate, endDate: $endDate, sortBy: $sortBy, sortOrder: $sortOrder)';

  @override
  List<Object?> get props => [
    format,
    searchQuery,
    assetId,
    startDate,
    endDate,
    sortBy,
    sortOrder,
  ];
}
