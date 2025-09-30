import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class CheckAssetSerialExistsUsecase
    implements Usecase<ItemSuccess<bool>, CheckAssetSerialExistsUsecaseParams> {
  final AssetRepository _assetRepository;

  CheckAssetSerialExistsUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<bool>>> call(
    CheckAssetSerialExistsUsecaseParams params,
  ) async {
    return await _assetRepository.checkAssetSerialExists(params);
  }
}

class CheckAssetSerialExistsUsecaseParams extends Equatable {
  final String serial;

  const CheckAssetSerialExistsUsecaseParams({
    required this.serial,
  });

  @override
  List<Object> get props => [serial];
}
