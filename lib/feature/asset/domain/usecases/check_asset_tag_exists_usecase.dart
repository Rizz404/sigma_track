import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class CheckAssetTagExistsUsecase
    implements Usecase<ItemSuccess<bool>, CheckAssetTagExistsUsecaseParams> {
  final AssetRepository _assetRepository;

  CheckAssetTagExistsUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<bool>>> call(
    CheckAssetTagExistsUsecaseParams params,
  ) async {
    return await _assetRepository.checkAssetTagExists(params);
  }
}

class CheckAssetTagExistsUsecaseParams extends Equatable {
  final String tag;

  const CheckAssetTagExistsUsecaseParams({required this.tag});

  @override
  List<Object> get props => [tag];
}
