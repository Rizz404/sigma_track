import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';

class DeleteAssetMovementUsecase
    implements Usecase<ItemSuccess<dynamic>, DeleteAssetMovementUsecaseParams> {
  final AssetMovementRepository _assetMovementRepository;

  DeleteAssetMovementUsecase(this._assetMovementRepository);

  @override
  Future<Either<Failure, ItemSuccess<dynamic>>> call(
    DeleteAssetMovementUsecaseParams params,
  ) async {
    return await _assetMovementRepository.deleteAssetMovement(params);
  }
}

class DeleteAssetMovementUsecaseParams extends Equatable {
  final String id;

  DeleteAssetMovementUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
