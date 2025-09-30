import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';

class CountAssetMovementsUsecase
    implements Usecase<ItemSuccess<int>, NoParams> {
  final AssetMovementRepository _assetMovementRepository;

  CountAssetMovementsUsecase(this._assetMovementRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(NoParams params) async {
    return await _assetMovementRepository.countAssetMovements();
  }
}
