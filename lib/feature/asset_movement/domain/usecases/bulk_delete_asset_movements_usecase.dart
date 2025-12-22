import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_response.dart';

class BulkDeleteAssetMovementsUsecase
    implements Usecase<ItemSuccess<BulkDeleteResponse>, BulkDeleteParams> {
  final AssetMovementRepository _assetMovementRepository;

  BulkDeleteAssetMovementsUsecase(this._assetMovementRepository);

  @override
  Future<Either<Failure, ItemSuccess<BulkDeleteResponse>>> call(
    BulkDeleteParams params,
  ) async {
    return await _assetMovementRepository.deleteManyAssetMovements(params);
  }
}
