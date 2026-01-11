import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/entities/delete_bulk_asset_image_response.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class DeleteBulkAssetImageUsecase
    implements
        Usecase<
          ItemSuccess<DeleteBulkAssetImageResponse>,
          DeleteBulkAssetImageUsecaseParams
        > {
  final AssetRepository _assetRepository;

  DeleteBulkAssetImageUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<DeleteBulkAssetImageResponse>>> call(
    DeleteBulkAssetImageUsecaseParams params,
  ) async {
    return await _assetRepository.deleteBulkAssetImage(params);
  }
}

class DeleteBulkAssetImageUsecaseParams extends Equatable {
  final List<String> assetImageIds;

  const DeleteBulkAssetImageUsecaseParams({required this.assetImageIds});

  DeleteBulkAssetImageUsecaseParams copyWith({List<String>? assetImageIds}) {
    return DeleteBulkAssetImageUsecaseParams(
      assetImageIds: assetImageIds ?? this.assetImageIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {'assetImageIds': assetImageIds};
  }

  factory DeleteBulkAssetImageUsecaseParams.fromMap(Map<String, dynamic> map) {
    return DeleteBulkAssetImageUsecaseParams(
      assetImageIds: List<String>.from(map['assetImageIds'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeleteBulkAssetImageUsecaseParams.fromJson(String source) =>
      DeleteBulkAssetImageUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'DeleteBulkAssetImageUsecaseParams(assetImageIds: $assetImageIds)';

  @override
  List<Object> get props => [assetImageIds];
}
