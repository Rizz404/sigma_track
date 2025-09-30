import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class GetAssetByIdUsecase
    implements Usecase<ItemSuccess<Asset>, GetAssetByIdUsecaseParams> {
  final AssetRepository _assetRepository;

  GetAssetByIdUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<Asset>>> call(
    GetAssetByIdUsecaseParams params,
  ) async {
    return await _assetRepository.getAssetById(params);
  }
}

class GetAssetByIdUsecaseParams extends Equatable {
  final String id;

  const GetAssetByIdUsecaseParams({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
