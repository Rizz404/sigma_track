import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';

class CheckAssetMovementExistsUsecase
    implements
        Usecase<ItemSuccess<bool>, CheckAssetMovementExistsUsecaseParams> {
  final AssetMovementRepository _assetMovementRepository;

  CheckAssetMovementExistsUsecase(this._assetMovementRepository);

  @override
  Future<Either<Failure, ItemSuccess<bool>>> call(
    CheckAssetMovementExistsUsecaseParams params,
  ) async {
    return await _assetMovementRepository.checkAssetMovementExists(params);
  }
}

class CheckAssetMovementExistsUsecaseParams extends Equatable {
  final String id;

  CheckAssetMovementExistsUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
