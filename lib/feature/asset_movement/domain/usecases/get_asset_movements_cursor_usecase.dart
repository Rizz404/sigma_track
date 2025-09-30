import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';

class GetAssetMovementsCursorUsecase
    implements
        Usecase<
          CursorPaginatedSuccess<AssetMovement>,
          GetAssetMovementsCursorUsecaseParams
        > {
  final AssetMovementRepository _assetMovementRepository;

  GetAssetMovementsCursorUsecase(this._assetMovementRepository);

  @override
  Future<Either<Failure, CursorPaginatedSuccess<AssetMovement>>> call(
    GetAssetMovementsCursorUsecaseParams params,
  ) async {
    return await _assetMovementRepository.getAssetMovementsCursor(params);
  }
}

class GetAssetMovementsCursorUsecaseParams extends Equatable {
  final String? cursor;
  final int limit;
  final String? search;
  final String? sortBy;
  final String? sortOrder;
  final String? assetId;
  final String? fromLocationId;
  final String? toLocationId;
  final String? movedById;
  final DateTime? startDate;
  final DateTime? endDate;

  GetAssetMovementsCursorUsecaseParams({
    this.cursor,
    this.limit = 10,
    this.search,
    this.sortBy,
    this.sortOrder,
    this.assetId,
    this.fromLocationId,
    this.toLocationId,
    this.movedById,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      if (cursor != null) 'cursor': cursor,
      'limit': limit,
      if (search != null) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (assetId != null) 'assetId': assetId,
      if (fromLocationId != null) 'fromLocationId': fromLocationId,
      if (toLocationId != null) 'toLocationId': toLocationId,
      if (movedById != null) 'movedById': movedById,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
    };
  }

  factory GetAssetMovementsCursorUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return GetAssetMovementsCursorUsecaseParams(
      cursor: map['cursor'],
      limit: map['limit']?.toInt() ?? 10,
      search: map['search'],
      sortBy: map['sortBy'],
      sortOrder: map['sortOrder'],
      assetId: map['assetId'],
      fromLocationId: map['fromLocationId'],
      toLocationId: map['toLocationId'],
      movedById: map['movedById'],
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'])
          : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetAssetMovementsCursorUsecaseParams.fromJson(String source) =>
      GetAssetMovementsCursorUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    cursor,
    limit,
    search,
    sortBy,
    sortOrder,
    assetId,
    fromLocationId,
    toLocationId,
    movedById,
    startDate,
    endDate,
  ];
}
