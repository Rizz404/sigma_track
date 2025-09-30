import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
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
  final int? limit;
  final int? offset;
  final String? search;
  final String? sortBy;
  final String? sortOrder;
  final String? categoryId;
  final String? locationId;
  final String? assignedToId;
  final String? status;
  final String? condition;

  const GetAssetsUsecaseParams({
    this.limit,
    this.offset,
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
    if (offset != null) map['offset'] = offset;
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
    offset,
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
