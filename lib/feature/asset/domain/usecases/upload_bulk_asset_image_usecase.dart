import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/entities/upload_bulk_asset_image_response.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class UploadBulkAssetImageUsecase
    implements
        Usecase<
          ItemSuccess<UploadBulkAssetImageResponse>,
          UploadBulkAssetImageUsecaseParams
        > {
  final AssetRepository _assetRepository;

  UploadBulkAssetImageUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<UploadBulkAssetImageResponse>>> call(
    UploadBulkAssetImageUsecaseParams params,
  ) async {
    return await _assetRepository.uploadBulkAssetImage(params);
  }
}

class UploadBulkAssetImageUsecaseParams extends Equatable {
  final List<String> assetIds;
  final List<String> filePaths;

  const UploadBulkAssetImageUsecaseParams({
    required this.assetIds,
    required this.filePaths,
  });

  UploadBulkAssetImageUsecaseParams copyWith({
    List<String>? assetIds,
    List<String>? filePaths,
  }) {
    return UploadBulkAssetImageUsecaseParams(
      assetIds: assetIds ?? this.assetIds,
      filePaths: filePaths ?? this.filePaths,
    );
  }

  Map<String, dynamic> toMap() {
    return {'assetIds': assetIds, 'filePaths': filePaths};
  }

  factory UploadBulkAssetImageUsecaseParams.fromMap(Map<String, dynamic> map) {
    return UploadBulkAssetImageUsecaseParams(
      assetIds: List<String>.from(map['assetIds'] ?? []),
      filePaths: List<String>.from(map['filePaths'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory UploadBulkAssetImageUsecaseParams.fromJson(String source) =>
      UploadBulkAssetImageUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'UploadBulkAssetImageUsecaseParams(assetIds: $assetIds, filesCount: ${filePaths.length})';

  @override
  List<Object> get props => [assetIds, filePaths];
}
