import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class GetAssetsUsecase
    implements
        Usecase<OffsetPaginatedSuccess<dynamic>, GetAssetsUsecaseParams> {
  final AssetRepository _assetRepository;

  GetAssetsUsecase(this._assetRepository);

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<dynamic>>> call(
    GetAssetsUsecaseParams params,
  ) async {
    return await _assetRepository.getAssets(params);
  }
}

class GetAssetsUsecaseParams extends Equatable {
  final String? search;
  final AssetStatus? status;
  final AssetCondition? condition;
  final String? categoryId;
  final String? locationId;
  final String? assignedTo;
  final String? brand;
  final String? model;
  final AssetSortBy? sortBy;
  final SortOrder? sortOrder;
  final int? limit;
  final int? offset;

  const GetAssetsUsecaseParams({
    this.search,
    this.status,
    this.condition,
    this.categoryId,
    this.locationId,
    this.assignedTo,
    this.brand,
    this.model,
    this.sortBy,
    this.sortOrder,
    this.limit,
    this.offset,
  });

  GetAssetsUsecaseParams copyWith({
    String? search,
    AssetStatus? status,
    AssetCondition? condition,
    String? categoryId,
    String? locationId,
    String? assignedTo,
    String? brand,
    String? model,
    AssetSortBy? sortBy,
    SortOrder? sortOrder,
    int? limit,
    int? offset,
  }) {
    return GetAssetsUsecaseParams(
      search: search ?? this.search,
      status: status ?? this.status,
      condition: condition ?? this.condition,
      categoryId: categoryId ?? this.categoryId,
      locationId: locationId ?? this.locationId,
      assignedTo: assignedTo ?? this.assignedTo,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (status != null) 'status': status!.toString(),
      if (condition != null) 'condition': condition!.toString(),
      if (categoryId != null) 'categoryId': categoryId,
      if (locationId != null) 'locationId': locationId,
      if (assignedTo != null) 'assignedTo': assignedTo,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (sortBy != null) 'sortBy': sortBy!.toString(),
      if (sortOrder != null) 'sortOrder': sortOrder!.toString(),
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
  }

  factory GetAssetsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetAssetsUsecaseParams(
      search: map['search'],
      status: map['status'] != null
          ? AssetStatus.fromString(map['status'])
          : null,
      condition: map['condition'] != null
          ? AssetCondition.fromString(map['condition'])
          : null,
      categoryId: map['categoryId'],
      locationId: map['locationId'],
      assignedTo: map['assignedTo'],
      brand: map['brand'],
      model: map['model'],
      sortBy: map['sortBy'] != null
          ? AssetSortBy.fromString(map['sortBy'])
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.fromString(map['sortOrder'])
          : null,
      limit: map['limit']?.toInt(),
      offset: map['offset']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetAssetsUsecaseParams.fromJson(String source) =>
      GetAssetsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetAssetsUsecaseParams(search: $search, status: $status, condition: $condition, categoryId: $categoryId, locationId: $locationId, assignedTo: $assignedTo, brand: $brand, model: $model, sortBy: $sortBy, sortOrder: $sortOrder, limit: $limit, offset: $offset)';

  @override
  List<Object?> get props => [
    search,
    status,
    condition,
    categoryId,
    locationId,
    assignedTo,
    brand,
    model,
    sortBy,
    sortOrder,
    limit,
    offset,
  ];
}
