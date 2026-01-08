import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/entities/generate_bulk_asset_tags_response.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class GenerateBulkAssetTagsUsecase
    implements
        Usecase<
          ItemSuccess<GenerateBulkAssetTagsResponse>,
          GenerateBulkAssetTagsUsecaseParams
        > {
  final AssetRepository _assetRepository;

  GenerateBulkAssetTagsUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<GenerateBulkAssetTagsResponse>>> call(
    GenerateBulkAssetTagsUsecaseParams params,
  ) async {
    return await _assetRepository.generateBulkAssetTags(params);
  }
}

class GenerateBulkAssetTagsUsecaseParams extends Equatable {
  final String categoryId;
  final int quantity;

  const GenerateBulkAssetTagsUsecaseParams({
    required this.categoryId,
    required this.quantity,
  });

  GenerateBulkAssetTagsUsecaseParams copyWith({
    String? categoryId,
    int? quantity,
  }) {
    return GenerateBulkAssetTagsUsecaseParams(
      categoryId: categoryId ?? this.categoryId,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {'categoryId': categoryId, 'quantity': quantity};
  }

  factory GenerateBulkAssetTagsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GenerateBulkAssetTagsUsecaseParams(
      categoryId: map['categoryId'] ?? '',
      quantity: map['quantity'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GenerateBulkAssetTagsUsecaseParams.fromJson(String source) =>
      GenerateBulkAssetTagsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GenerateBulkAssetTagsUsecaseParams(categoryId: $categoryId, quantity: $quantity)';

  @override
  List<Object> get props => [categoryId, quantity];
}
