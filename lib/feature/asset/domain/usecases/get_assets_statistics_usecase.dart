import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset_statistics.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class GetAssetsStatisticsUsecase
    implements Usecase<ItemSuccess<AssetStatistics>, NoParams> {
  final AssetRepository _assetRepository;

  GetAssetsStatisticsUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<AssetStatistics>>> call(
    NoParams params,
  ) async {
    return await _assetRepository.getAssetsStatistics();
  }
}
