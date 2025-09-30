import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class GetAssetByTagUsecase
    implements Usecase<ItemSuccess<Asset>, GetAssetByTagUsecaseParams> {
  final AssetRepository _assetRepository;

  GetAssetByTagUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<Asset>>> call(
    GetAssetByTagUsecaseParams params,
  ) async {
    return await _assetRepository.getAssetByTag(params);
  }
}

class GetAssetByTagUsecaseParams extends Equatable {
  final String tag;

  const GetAssetByTagUsecaseParams({required this.tag});

  @override
  List<Object> get props => [tag];
}
