import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/entities/delete_bulk_data_matrix_response.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class DeleteBulkDataMatrixUsecase
    implements
        Usecase<
          ItemSuccess<DeleteBulkDataMatrixResponse>,
          DeleteBulkDataMatrixUsecaseParams
        > {
  final AssetRepository _assetRepository;

  DeleteBulkDataMatrixUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<DeleteBulkDataMatrixResponse>>> call(
    DeleteBulkDataMatrixUsecaseParams params,
  ) async {
    return await _assetRepository.deleteBulkDataMatrix(params);
  }
}

class DeleteBulkDataMatrixUsecaseParams extends Equatable {
  final List<String> assetTags;

  const DeleteBulkDataMatrixUsecaseParams({required this.assetTags});

  DeleteBulkDataMatrixUsecaseParams copyWith({List<String>? assetTags}) {
    return DeleteBulkDataMatrixUsecaseParams(
      assetTags: assetTags ?? this.assetTags,
    );
  }

  Map<String, dynamic> toMap() {
    return {'assetTags': assetTags};
  }

  factory DeleteBulkDataMatrixUsecaseParams.fromMap(Map<String, dynamic> map) {
    return DeleteBulkDataMatrixUsecaseParams(
      assetTags: List<String>.from(map['assetTags'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeleteBulkDataMatrixUsecaseParams.fromJson(String source) =>
      DeleteBulkDataMatrixUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'DeleteBulkDataMatrixUsecaseParams(assetTags: $assetTags)';

  @override
  List<Object> get props => [assetTags];
}
