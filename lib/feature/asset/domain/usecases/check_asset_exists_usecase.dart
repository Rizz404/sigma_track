import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class CheckAssetExistsUsecase
    implements Usecase<ItemSuccess<bool>, CheckAssetExistsUsecaseParams> {
  final AssetRepository _assetRepository;

  CheckAssetExistsUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<bool>>> call(
    CheckAssetExistsUsecaseParams params,
  ) async {
    return await _assetRepository.checkAssetExists(params);
  }
}

class CheckAssetExistsUsecaseParams extends Equatable {
  final String id;

  const CheckAssetExistsUsecaseParams({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
