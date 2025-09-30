import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
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
  final int? limit;
  final String? cursor;
  final String? search;
  final String? sortBy;
  final String? sortOrder;
  final String? categoryId;
  final String? locationId;
  final String? assignedToId;
  final String? status;
  final String? condition;

  const GetAssetsCursorUsecaseParams({
    this.limit,
    this.cursor,
    this.search,
    this.sortBy,
    this.sortOrder,
    this.categoryId,
    this.locationId,
    this.assignedToId,
    this.status,
    this.condition,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (limit != null) map['limit'] = limit;
    if (cursor != null) map['cursor'] = cursor;
    if (search != null) map['search'] = search;
    if (sortBy != null) map['sortBy'] = sortBy;
    if (sortOrder != null) map['sortOrder'] = sortOrder;
    if (categoryId != null) map['categoryId'] = categoryId;
    if (locationId != null) map['locationId'] = locationId;
    if (assignedToId != null) map['assignedToId'] = assignedToId;
    if (status != null) map['status'] = status;
    if (condition != null) map['condition'] = condition;
    return map;
  }

  @override
  List<Object?> get props => [
    limit,
    cursor,
    search,
    sortBy,
    sortOrder,
    categoryId,
    locationId,
    assignedToId,
    status,
    condition,
  ];
}
