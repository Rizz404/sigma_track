import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';

class UpdateCategoryUsecase
    implements Usecase<ItemSuccess<Category>, UpdateCategoryUsecaseParams> {
  final CategoryRepository _categoryRepository;

  UpdateCategoryUsecase(this._categoryRepository);

  @override
  Future<Either<Failure, ItemSuccess<Category>>> call(
    UpdateCategoryUsecaseParams params,
  ) async {
    return await _categoryRepository.updateCategory(params);
  }
}

class UpdateCategoryUsecaseParams extends Equatable {
  final String id;
  final String? parentId;
  final String? categoryCode;
  final List<UpdateCategoryTranslation>? translations;

  UpdateCategoryUsecaseParams({
    required this.id,
    this.parentId,
    this.categoryCode,
    this.translations,
  });

  UpdateCategoryUsecaseParams copyWith({
    String? id,
    String? parentId,
    String? categoryCode,
    List<UpdateCategoryTranslation>? translations,
  }) {
    return UpdateCategoryUsecaseParams(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      categoryCode: categoryCode ?? this.categoryCode,
      translations: translations ?? this.translations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parentId': parentId,
      'categoryCode': categoryCode,
      'translations': translations?.map((x) => x.toMap()).toList(),
    };
  }

  factory UpdateCategoryUsecaseParams.fromMap(Map<String, dynamic> map) {
    return UpdateCategoryUsecaseParams(
      id: map['id'] ?? '',
      parentId: map['parentId'],
      categoryCode: map['categoryCode'],
      translations: map['translations'] != null
          ? List<UpdateCategoryTranslation>.from(
              map['translations']?.map(
                (x) => UpdateCategoryTranslation.fromMap(x),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateCategoryUsecaseParams.fromJson(String source) =>
      UpdateCategoryUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'UpdateCategoryUsecaseParams(id: $id, parentId: $parentId, categoryCode: $categoryCode, translations: $translations)';

  @override
  List<Object?> get props => [id, parentId, categoryCode, translations];
}

class UpdateCategoryTranslation extends Equatable {
  final String? langCode;
  final String? categoryName;
  final String? description;

  UpdateCategoryTranslation({
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

  factory UpdateCategoryTranslation.fromMap(Map<String, dynamic> map) {
    return UpdateCategoryTranslation(
      langCode: map['langCode'],
      categoryName: map['categoryName'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateCategoryTranslation.fromJson(String source) =>
      UpdateCategoryTranslation.fromMap(json.decode(source));

  @override
  List<Object?> get props => [langCode, categoryName, description];

  UpdateCategoryTranslation copyWith({
    ValueGetter<String?>? langCode,
    ValueGetter<String?>? categoryName,
    ValueGetter<String?>? description,
  }) {
    return UpdateCategoryTranslation(
      langCode: langCode != null ? langCode() : this.langCode,
      categoryName: categoryName != null ? categoryName() : this.categoryName,
      description: description != null ? description() : this.description,
    );
  }

  @override
  String toString() =>
      'UpdateCategoryTranslation(langCode: $langCode, categoryName: $categoryName, description: $description)';
}
