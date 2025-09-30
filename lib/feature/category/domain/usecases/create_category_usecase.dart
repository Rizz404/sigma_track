import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';

class CreateCategoryUsecase
    implements Usecase<ItemSuccess<Category>, CreateCategoryUsecaseParams> {
  final CategoryRepository _categoryRepository;

  CreateCategoryUsecase(this._categoryRepository);

  @override
  Future<Either<Failure, ItemSuccess<Category>>> call(
    CreateCategoryUsecaseParams params,
  ) async {
    return await _categoryRepository.createCategory(params);
  }
}

class CreateCategoryUsecaseParams extends Equatable {
  final String parentId;
  final String categoryCode;
  final List<CreateCategoryTranslation> translations;

  CreateCategoryUsecaseParams({
    required this.parentId,
    required this.categoryCode,
    required this.translations,
  });

  Map<String, dynamic> toMap() {
    return {
      'parentId': parentId,
      'categoryCode': categoryCode,
      'translations': translations.map((x) => x.toMap()).toList(),
    };
  }

  factory CreateCategoryUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CreateCategoryUsecaseParams(
      parentId: map['parentId'] ?? '',
      categoryCode: map['categoryCode'] ?? '',
      translations: List<CreateCategoryTranslation>.from(
        map['translations']?.map((x) => CreateCategoryTranslation.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateCategoryUsecaseParams.fromJson(String source) =>
      CreateCategoryUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object> get props => [parentId, categoryCode, translations];
}

class CreateCategoryTranslation extends Equatable {
  final String langCode;
  final String categoryName;
  final String description;

  CreateCategoryTranslation({
    required this.langCode,
    required this.categoryName,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'langCode': langCode,
      'categoryName': categoryName,
      'description': description,
    };
  }

  factory CreateCategoryTranslation.fromMap(Map<String, dynamic> map) {
    return CreateCategoryTranslation(
      langCode: map['langCode'] ?? '',
      categoryName: map['categoryName'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateCategoryTranslation.fromJson(String source) =>
      CreateCategoryTranslation.fromMap(json.decode(source));

  @override
  List<Object> get props => [langCode, categoryName, description];
}
