import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class ExportAssetDataMatrixUsecase
    implements
        Usecase<ItemSuccess<Uint8List>, ExportAssetDataMatrixUsecaseParams> {
  final AssetRepository _assetRepository;

  ExportAssetDataMatrixUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<Uint8List>>> call(
    ExportAssetDataMatrixUsecaseParams params,
  ) async {
    return await _assetRepository.exportAssetDataMatrix(params);
  }
}

class ExportAssetDataMatrixUsecaseParams extends Equatable {
  final ExportFormat format;
  final String? searchQuery;
  final AssetStatus? status;
  final AssetCondition? condition;
  final String? categoryId;
  final String? locationId;
  final String? assignedTo;
  final String? brand;
  final String? model;
  final AssetSortBy? sortBy;
  final SortOrder? sortOrder;
  final bool includeDataMatrixImage;

  const ExportAssetDataMatrixUsecaseParams({
    required this.format,
    this.searchQuery,
    this.status,
    this.condition,
    this.categoryId,
    this.locationId,
    this.assignedTo,
    this.brand,
    this.model,
    this.sortBy,
    this.sortOrder,
    this.includeDataMatrixImage = false,
  });

  ExportAssetDataMatrixUsecaseParams copyWith({
    ExportFormat? format,
    String? searchQuery,
    AssetStatus? status,
    AssetCondition? condition,
    String? categoryId,
    String? locationId,
    String? assignedTo,
    String? brand,
    String? model,
    AssetSortBy? sortBy,
    SortOrder? sortOrder,
    bool? includeDataMatrixImage,
  }) {
    return ExportAssetDataMatrixUsecaseParams(
      format: format ?? this.format,
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      condition: condition ?? this.condition,
      categoryId: categoryId ?? this.categoryId,
      locationId: locationId ?? this.locationId,
      assignedTo: assignedTo ?? this.assignedTo,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      includeDataMatrixImage:
          includeDataMatrixImage ?? this.includeDataMatrixImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'format': format.value,
      if (searchQuery != null) 'searchQuery': searchQuery,
      if (status != null) 'status': status!.value,
      if (condition != null) 'condition': condition!.value,
      if (categoryId != null) 'categoryId': categoryId,
      if (locationId != null) 'locationId': locationId,
      if (assignedTo != null) 'assignedTo': assignedTo,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
      'includeDataMatrixImage': includeDataMatrixImage,
    };
  }

  factory ExportAssetDataMatrixUsecaseParams.fromMap(Map<String, dynamic> map) {
    return ExportAssetDataMatrixUsecaseParams(
      format: ExportFormat.values.firstWhere((e) => e.value == map['format']),
      searchQuery: map['searchQuery'],
      status: map['status'] != null
          ? AssetStatus.values.firstWhere((e) => e.value == map['status'])
          : null,
      condition: map['condition'] != null
          ? AssetCondition.values.firstWhere((e) => e.value == map['condition'])
          : null,
      categoryId: map['categoryId'],
      locationId: map['locationId'],
      assignedTo: map['assignedTo'],
      brand: map['brand'],
      model: map['model'],
      sortBy: map['sortBy'] != null
          ? AssetSortBy.values.firstWhere((e) => e.value == map['sortBy'])
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.values.firstWhere((e) => e.value == map['sortOrder'])
          : null,
      includeDataMatrixImage: map['includeDataMatrixImage'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExportAssetDataMatrixUsecaseParams.fromJson(String source) =>
      ExportAssetDataMatrixUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'ExportAssetDataMatrixUsecaseParams(format: $format, searchQuery: $searchQuery, status: $status, condition: $condition, categoryId: $categoryId, locationId: $locationId, assignedTo: $assignedTo, brand: $brand, model: $model, sortBy: $sortBy, sortOrder: $sortOrder, includeDataMatrixImage: $includeDataMatrixImage)';

  @override
  List<Object?> get props => [
    format,
    searchQuery,
    status,
    condition,
    categoryId,
    locationId,
    assignedTo,
    brand,
    model,
    sortBy,
    sortOrder,
    includeDataMatrixImage,
  ];
}
