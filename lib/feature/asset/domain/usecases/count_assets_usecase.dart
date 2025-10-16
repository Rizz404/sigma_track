import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class CountAssetsUsecase
    implements Usecase<ItemSuccess<int>, CountAssetsUsecaseParams> {
  final AssetRepository _assetRepository;

  CountAssetsUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(
    CountAssetsUsecaseParams params,
  ) async {
    return await _assetRepository.countAssets(params);
  }
}

class CountAssetsUsecaseParams extends Equatable {
  final AssetStatus? status;
  final AssetCondition? condition;

  const CountAssetsUsecaseParams({this.status, this.condition});

  CountAssetsUsecaseParams copyWith({
    AssetStatus? status,
    AssetCondition? condition,
  }) {
    return CountAssetsUsecaseParams(
      status: status ?? this.status,
      condition: condition ?? this.condition,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (status != null) 'status': status!.toString(),
      if (condition != null) 'condition': condition!.toString(),
    };
  }

  factory CountAssetsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CountAssetsUsecaseParams(
      status: map['status'] != null
          ? AssetStatus.values.firstWhere((e) => e.value == map['status'])
          : null,
      condition: map['condition'] != null
          ? AssetCondition.values.firstWhere((e) => e.value == map['condition'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CountAssetsUsecaseParams.fromJson(String source) =>
      CountAssetsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'CountAssetsUsecaseParams(status: $status, condition: $condition)';

  @override
  List<Object?> get props => [status, condition];
}
