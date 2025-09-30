import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';

class GetAssetMovementByIdUsecase
    implements
        Usecase<ItemSuccess<AssetMovement>, GetAssetMovementByIdUsecaseParams> {
  final AssetMovementRepository _assetMovementRepository;

  GetAssetMovementByIdUsecase(this._assetMovementRepository);

  @override
  Future<Either<Failure, ItemSuccess<AssetMovement>>> call(
    GetAssetMovementByIdUsecaseParams params,
  ) async {
    return await _assetMovementRepository.getAssetMovementById(params);
  }
}

class GetAssetMovementByIdUsecaseParams extends Equatable {
  final String id;

  GetAssetMovementByIdUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
