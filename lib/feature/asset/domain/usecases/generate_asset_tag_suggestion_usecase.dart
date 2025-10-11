import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/asset/domain/entities/generate_asset_tag_response.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

class GenerateAssetTagSuggestionUsecase
    implements
        Usecase<
          ItemSuccess<GenerateAssetTagResponse>,
          GenerateAssetTagSuggestionUsecaseParams
        > {
  final AssetRepository _assetRepository;

  GenerateAssetTagSuggestionUsecase(this._assetRepository);

  @override
  Future<Either<Failure, ItemSuccess<GenerateAssetTagResponse>>> call(
    GenerateAssetTagSuggestionUsecaseParams params,
  ) {
    return _assetRepository.generateAssetTagSuggestion(params);
  }
}

class GenerateAssetTagSuggestionUsecaseParams extends Equatable {
  final String categoryId;
  GenerateAssetTagSuggestionUsecaseParams({required this.categoryId});

  GenerateAssetTagSuggestionUsecaseParams copyWith({String? categoryId}) {
    return GenerateAssetTagSuggestionUsecaseParams(
      categoryId: categoryId ?? this.categoryId,
    );
  }

  Map<String, dynamic> toMap() {
    return {'categoryId': categoryId};
  }

  factory GenerateAssetTagSuggestionUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return GenerateAssetTagSuggestionUsecaseParams(
      categoryId: map['categoryId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GenerateAssetTagSuggestionUsecaseParams.fromJson(String source) =>
      GenerateAssetTagSuggestionUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GenerateAssetTagSuggestionUsecaseParams(categoryId: $categoryId)';

  @override
  List<Object> get props => [categoryId];
}
