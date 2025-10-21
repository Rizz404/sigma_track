import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
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
  final String? search;
  final String? assetId;
  final String? fromLocationId;
  final String? toLocationId;
  final String? fromUserId;
  final String? toUserId;
  final String? movedBy;
  final String? dateFrom;
  final String? dateTo;
  final AssetMovementSortBy? sortBy;
  final SortOrder? sortOrder;
  final String? cursor;
  final int? limit;

  const GetAssetMovementsCursorUsecaseParams({
    this.search,
    this.assetId,
    this.fromLocationId,
    this.toLocationId,
    this.fromUserId,
    this.toUserId,
    this.movedBy,
    this.dateFrom,
    this.dateTo,
    this.sortBy,
    this.sortOrder,
    this.cursor,
    this.limit,
  });

  GetAssetMovementsCursorUsecaseParams copyWith({
    ValueGetter<String?>? search,
    ValueGetter<String?>? assetId,
    ValueGetter<String?>? fromLocationId,
    ValueGetter<String?>? toLocationId,
    ValueGetter<String?>? fromUserId,
    ValueGetter<String?>? toUserId,
    ValueGetter<String?>? movedBy,
    ValueGetter<String?>? dateFrom,
    ValueGetter<String?>? dateTo,
    ValueGetter<AssetMovementSortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<String?>? cursor,
    ValueGetter<int?>? limit,
  }) {
    return GetAssetMovementsCursorUsecaseParams(
      search: search != null ? search() : this.search,
      assetId: assetId != null ? assetId() : this.assetId,
      fromLocationId: fromLocationId != null
          ? fromLocationId()
          : this.fromLocationId,
      toLocationId: toLocationId != null ? toLocationId() : this.toLocationId,
      fromUserId: fromUserId != null ? fromUserId() : this.fromUserId,
      toUserId: toUserId != null ? toUserId() : this.toUserId,
      movedBy: movedBy != null ? movedBy() : this.movedBy,
      dateFrom: dateFrom != null ? dateFrom() : this.dateFrom,
      dateTo: dateTo != null ? dateTo() : this.dateTo,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortOrder: sortOrder != null ? sortOrder() : this.sortOrder,
      cursor: cursor != null ? cursor() : this.cursor,
      limit: limit != null ? limit() : this.limit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (assetId != null) 'assetId': assetId,
      if (fromLocationId != null) 'fromLocationId': fromLocationId,
      if (toLocationId != null) 'toLocationId': toLocationId,
      if (fromUserId != null) 'fromUserId': fromUserId,
      if (toUserId != null) 'toUserId': toUserId,
      if (movedBy != null) 'movedBy': movedBy,
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
    };
  }

  factory GetAssetMovementsCursorUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return GetAssetMovementsCursorUsecaseParams(
      search: map['search'],
      assetId: map['assetId'],
      fromLocationId: map['fromLocationId'],
      toLocationId: map['toLocationId'],
      fromUserId: map['fromUserId'],
      toUserId: map['toUserId'],
      movedBy: map['movedBy'],
      dateFrom: map['dateFrom'],
      dateTo: map['dateTo'],
      sortBy: map['sortBy'] != null
          ? AssetMovementSortBy.values.firstWhere(
              (e) => e.value == map['sortBy'],
            )
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.values.firstWhere((e) => e.value == map['sortOrder'])
          : null,
      cursor: map['cursor'],
      limit: map['limit']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetAssetMovementsCursorUsecaseParams.fromJson(String source) =>
      GetAssetMovementsCursorUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetAssetMovementsCursorUsecaseParams(search: $search, assetId: $assetId, fromLocationId: $fromLocationId, toLocationId: $toLocationId, fromUserId: $fromUserId, toUserId: $toUserId, movedBy: $movedBy, dateFrom: $dateFrom, dateTo: $dateTo, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';

  @override
  List<Object?> get props => [
    search,
    assetId,
    fromLocationId,
    toLocationId,
    fromUserId,
    toUserId,
    movedBy,
    dateFrom,
    dateTo,
    sortBy,
    sortOrder,
    cursor,
    limit,
  ];
}
