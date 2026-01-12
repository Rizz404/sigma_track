import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/entities/image_response.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class GetAvailableAssetImagesCursorUsecase
    implements
        Usecase<
          CursorPaginatedSuccess<ImageResponse>,
          GetAvailableAssetImagesCursorUsecaseParams
        > {
  final AssetRepository _assetRepository;

  GetAvailableAssetImagesCursorUsecase(this._assetRepository);

  @override
  Future<Either<Failure, CursorPaginatedSuccess<ImageResponse>>> call(
    GetAvailableAssetImagesCursorUsecaseParams params,
  ) async {
    return await _assetRepository.getAvailableAssetImages(params);
  }
}

class GetAvailableAssetImagesCursorUsecaseParams extends Equatable {
  final String? cursor;
  final int? limit;

  const GetAvailableAssetImagesCursorUsecaseParams({this.cursor, this.limit});

  GetAvailableAssetImagesCursorUsecaseParams copyWith({
    ValueGetter<String?>? cursor,
    ValueGetter<int?>? limit,
  }) {
    return GetAvailableAssetImagesCursorUsecaseParams(
      cursor: cursor != null ? cursor() : this.cursor,
      limit: limit != null ? limit() : this.limit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
    };
  }

  factory GetAvailableAssetImagesCursorUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return GetAvailableAssetImagesCursorUsecaseParams(
      cursor: map['cursor'],
      limit: map['limit']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetAvailableAssetImagesCursorUsecaseParams.fromJson(String source) =>
      GetAvailableAssetImagesCursorUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetAvailableAssetImagesCursorUsecaseParams(cursor: $cursor, limit: $limit)';

  @override
  List<Object?> get props => [cursor, limit];
}
