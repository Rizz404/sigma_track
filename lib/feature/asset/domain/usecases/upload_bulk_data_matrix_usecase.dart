import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/entities/upload_bulk_data_matrix_response.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class UploadBulkDataMatrixUsecase
    implements
        Usecase<
          ItemSuccess<UploadBulkDataMatrixResponse>,
          UploadBulkDataMatrixUsecaseParams
        > {
  final AssetRepository _assetRepository;

  UploadBulkDataMatrixUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<UploadBulkDataMatrixResponse>>> call(
    UploadBulkDataMatrixUsecaseParams params,
  ) async {
    return await _assetRepository.uploadBulkDataMatrix(params);
  }
}

class UploadBulkDataMatrixUsecaseParams extends Equatable {
  final List<String> assetTags;
  final List<String> filePaths;

  const UploadBulkDataMatrixUsecaseParams({
    required this.assetTags,
    required this.filePaths,
  });

  UploadBulkDataMatrixUsecaseParams copyWith({
    List<String>? assetTags,
    List<String>? filePaths,
  }) {
    return UploadBulkDataMatrixUsecaseParams(
      assetTags: assetTags ?? this.assetTags,
      filePaths: filePaths ?? this.filePaths,
    );
  }

  Map<String, dynamic> toMap() {
    return {'assetTags': assetTags, 'filePaths': filePaths};
  }

  factory UploadBulkDataMatrixUsecaseParams.fromMap(Map<String, dynamic> map) {
    return UploadBulkDataMatrixUsecaseParams(
      assetTags: List<String>.from(map['assetTags'] ?? []),
      filePaths: List<String>.from(map['filePaths'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory UploadBulkDataMatrixUsecaseParams.fromJson(String source) =>
      UploadBulkDataMatrixUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'UploadBulkDataMatrixUsecaseParams(assetTags: $assetTags, filesCount: ${filePaths.length})';

  @override
  List<Object> get props => [assetTags, filePaths];
}
