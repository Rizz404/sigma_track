import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class CountAssetsUsecase implements Usecase<ItemSuccess<int>, NoParams> {
  final AssetRepository _assetRepository;

  CountAssetsUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(NoParams params) async {
    return await _assetRepository.countAssets();
  }
}
