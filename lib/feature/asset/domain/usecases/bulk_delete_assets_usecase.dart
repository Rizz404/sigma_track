import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_response.dart';

class BulkDeleteAssetsUsecase
    implements Usecase<ItemSuccess<BulkDeleteResponse>, BulkDeleteParams> {
  final AssetRepository _assetRepository;

  BulkDeleteAssetsUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<BulkDeleteResponse>>> call(
    BulkDeleteParams params,
  ) async {
    return await _assetRepository.deleteManyAssets(params);
  }
}
