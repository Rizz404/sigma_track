import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';

class GetAssetMovementsByAssetIdUsecase
    implements
        Usecase<
          OffsetPaginatedSuccess<AssetMovement>,
          GetAssetMovementsByAssetIdUsecaseParams
        > {
  final AssetMovementRepository _assetMovementRepository;

  GetAssetMovementsByAssetIdUsecase(this._assetMovementRepository);

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<AssetMovement>>> call(
    GetAssetMovementsByAssetIdUsecaseParams params,
  ) async {
    return await _assetMovementRepository.getAssetMovementsByAssetId(params);
  }
}

class GetAssetMovementsByAssetIdUsecaseParams extends Equatable {
  final String assetId;
  final int page;
  final int limit;
  final String? search;
  final String? sortBy;
  final String? sortOrder;
  final DateTime? startDate;
  final DateTime? endDate;

  GetAssetMovementsByAssetIdUsecaseParams({
    required this.assetId,
    this.page = 1,
    this.limit = 10,
    this.search,
    this.sortBy,
    this.sortOrder,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'assetId': assetId,
      'page': page,
      'limit': limit,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
    };
  }

  factory GetAssetMovementsByAssetIdUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return GetAssetMovementsByAssetIdUsecaseParams(
      assetId: map['assetId'] ?? '',
      page: map['page']?.toInt() ?? 1,
      limit: map['limit']?.toInt() ?? 10,
      search: map['search'],
      sortBy: map['sortBy'],
      sortOrder: map['sortOrder'],
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetAssetMovementsByAssetIdUsecaseParams.fromJson(String source) =>
      GetAssetMovementsByAssetIdUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    assetId,
    page,
    limit,
    search,
    sortBy,
    sortOrder,
    startDate,
    endDate,
  ];
}
