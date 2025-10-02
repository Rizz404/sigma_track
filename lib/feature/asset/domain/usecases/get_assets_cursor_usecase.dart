import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class GetAssetsCursorUsecase
    implements
        Usecase<CursorPaginatedSuccess<dynamic>, GetAssetsCursorUsecaseParams> {
  final AssetRepository _assetRepository;

  GetAssetsCursorUsecase(this._assetRepository);

  @override
  Future<Either<Failure, CursorPaginatedSuccess<dynamic>>> call(
    GetAssetsCursorUsecaseParams params,
  ) async {
    return await _assetRepository.getAssetsCursor(params);
  }
}

class GetAssetsCursorUsecaseParams extends Equatable {
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
  final String? cursor;
  final int? limit;

  const GetAssetsCursorUsecaseParams({
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
    this.cursor,
    this.limit,
  });

  GetAssetsCursorUsecaseParams copyWith({
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
    String? cursor,
    int? limit,
  }) {
    return GetAssetsCursorUsecaseParams(
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
      cursor: cursor ?? this.cursor,
      limit: limit ?? this.limit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (status != null) 'status': status!.value,
      if (condition != null) 'condition': condition!.value,
      if (categoryId != null) 'categoryId': categoryId,
      if (locationId != null) 'locationId': locationId,
      if (assignedTo != null) 'assignedTo': assignedTo,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
    };
  }

  factory GetAssetsCursorUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetAssetsCursorUsecaseParams(
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
      cursor: map['cursor'],
      limit: map['limit']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetAssetsCursorUsecaseParams.fromJson(String source) =>
      GetAssetsCursorUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetAssetsCursorUsecaseParams(search: $search, status: $status, condition: $condition, categoryId: $categoryId, locationId: $locationId, assignedTo: $assignedTo, brand: $brand, model: $model, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';

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
    cursor,
    limit,
  ];
}
