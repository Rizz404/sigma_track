import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';

class CountAssetMovementsUsecase
    implements Usecase<ItemSuccess<int>, CountAssetMovementsUsecaseParams> {
  final AssetMovementRepository _assetMovementRepository;

  CountAssetMovementsUsecase(this._assetMovementRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(
    CountAssetMovementsUsecaseParams params,
  ) async {
    return await _assetMovementRepository.countAssetMovements(params);
  }
}

class CountAssetMovementsUsecaseParams extends Equatable {
  final String? assetId;
  final String? dateFrom;

  const CountAssetMovementsUsecaseParams({this.assetId, this.dateFrom});

  CountAssetMovementsUsecaseParams copyWith({
    String? assetId,
    String? dateFrom,
  }) {
    return CountAssetMovementsUsecaseParams(
      assetId: assetId ?? this.assetId,
      dateFrom: dateFrom ?? this.dateFrom,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (assetId != null) 'assetId': assetId,
      if (dateFrom != null) 'dateFrom': dateFrom,
    };
  }

  factory CountAssetMovementsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CountAssetMovementsUsecaseParams(
      assetId: map['assetId'],
      dateFrom: map['dateFrom'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CountAssetMovementsUsecaseParams.fromJson(String source) =>
      CountAssetMovementsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'CountAssetMovementsUsecaseParams(assetId: $assetId, dateFrom: $dateFrom)';

  @override
  List<Object?> get props => [assetId, dateFrom];
}
