import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class DeleteAssetUsecase
    implements Usecase<ActionSuccess, DeleteAssetUsecaseParams> {
  final AssetRepository _assetRepository;

  DeleteAssetUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ActionSuccess>> call(
    DeleteAssetUsecaseParams params,
  ) async {
    return await _assetRepository.deleteAsset(params);
  }
}

class DeleteAssetUsecaseParams extends Equatable {
  final String id;

  const DeleteAssetUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
