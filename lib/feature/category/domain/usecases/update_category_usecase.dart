import 'dart:convert';
import 'dart:io';

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
  final String? imageUrl;
  final File? imageFile;

  UpdateCategoryUsecaseParams({
    required this.id,
    this.parentId,
    this.categoryCode,
    this.translations,
    this.imageUrl,
    this.imageFile,
  });

  /// * Factory method to create params with only changed fields
  factory UpdateCategoryUsecaseParams.fromChanges({
    required String id,
    required Category original,
    String? parentId,
    String? categoryCode,
    List<UpdateCategoryTranslation>? translations,
    String? imageUrl,
    File? imageFile,
  }) {
    return UpdateCategoryUsecaseParams(
      id: id,
      parentId: parentId != original.parentId ? parentId : null,
      categoryCode: categoryCode != original.categoryCode ? categoryCode : null,
      translations: _areTranslationsEqual(original.translations, translations)
          ? null
          : translations,
      imageUrl: imageUrl != original.imageUrl ? imageUrl : null,
      imageFile: imageFile,
    );
  }

  /// * Helper method to compare translations
  static bool _areTranslationsEqual(
    List<CategoryTranslation>? original,
    List<UpdateCategoryTranslation>? updated,
  ) {
    if (updated == null) return true;
    if (original == null || original.length != updated.length) return false;

    for (final upd in updated) {
      final orig = original.cast<CategoryTranslation?>().firstWhere(
        (o) => o?.langCode == upd.langCode,
        orElse: () => null,
      );
      if (orig == null) return false;
      if (orig.categoryName != upd.categoryName ||
          orig.description != upd.description) {
        return false;
      }
    }
    return true;
  }

  UpdateCategoryUsecaseParams copyWith({
    String? id,
    String? parentId,
    String? categoryCode,
    List<UpdateCategoryTranslation>? translations,
    ValueGetter<String?>? imageUrl,
    ValueGetter<File?>? imageFile,
  }) {
    return UpdateCategoryUsecaseParams(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      categoryCode: categoryCode ?? this.categoryCode,
      translations: translations ?? this.translations,
      imageUrl: imageUrl != null ? imageUrl() : this.imageUrl,
      imageFile: imageFile != null ? imageFile() : this.imageFile,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (parentId != null) 'parentId': parentId,
      if (categoryCode != null) 'categoryCode': categoryCode,
      if (translations != null)
        'translations': translations!.map((x) => x.toMap()).toList(),
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (imageFile != null) 'imageFile': imageFile!.path,
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
      imageUrl: map['imageUrl'],
      imageFile: map['imageFile'] != null ? File(map['imageFile']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateCategoryUsecaseParams.fromJson(String source) =>
      UpdateCategoryUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'UpdateCategoryUsecaseParams(id: $id, parentId: $parentId, categoryCode: $categoryCode, translations: $translations, imageUrl: $imageUrl, imageFile: $imageFile)';

  @override
  List<Object?> get props => [
    id,
    parentId,
    categoryCode,
    translations,
    imageUrl,
    imageFile,
  ];
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
