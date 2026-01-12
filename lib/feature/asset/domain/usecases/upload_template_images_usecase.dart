import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/entities/upload_template_images_response.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class UploadTemplateImagesUsecase
    implements
        Usecase<
          ItemSuccess<UploadTemplateImagesResponse>,
          UploadTemplateImagesUsecaseParams
        > {
  final AssetRepository _assetRepository;

  UploadTemplateImagesUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<UploadTemplateImagesResponse>>> call(
    UploadTemplateImagesUsecaseParams params,
  ) async {
    return await _assetRepository.uploadTemplateImages(params);
  }
}

class UploadTemplateImagesUsecaseParams extends Equatable {
  final List<String> filePaths;

  const UploadTemplateImagesUsecaseParams({required this.filePaths});

  UploadTemplateImagesUsecaseParams copyWith({List<String>? filePaths}) {
    return UploadTemplateImagesUsecaseParams(
      filePaths: filePaths ?? this.filePaths,
    );
  }

  Map<String, dynamic> toMap() {
    return {'filePaths': filePaths};
  }

  factory UploadTemplateImagesUsecaseParams.fromMap(Map<String, dynamic> map) {
    return UploadTemplateImagesUsecaseParams(
      filePaths: List<String>.from(map['filePaths'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory UploadTemplateImagesUsecaseParams.fromJson(String source) =>
      UploadTemplateImagesUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'UploadTemplateImagesUsecaseParams(filesCount: ${filePaths.length})';

  @override
  List<Object> get props => [filePaths];
}
