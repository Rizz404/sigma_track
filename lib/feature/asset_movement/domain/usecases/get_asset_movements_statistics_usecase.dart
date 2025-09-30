import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement_statistics.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';

class GetAssetMovementsStatisticsUsecase
    implements Usecase<ItemSuccess<AssetMovementStatistics>, NoParams> {
  final AssetMovementRepository _assetMovementRepository;

  GetAssetMovementsStatisticsUsecase(this._assetMovementRepository);

  @override
  Future<Either<Failure, ItemSuccess<AssetMovementStatistics>>> call(
    NoParams params,
  ) async {
    return await _assetMovementRepository.getAssetMovementsStatistics();
  }
}
