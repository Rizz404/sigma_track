import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/extensions/model_parsing_extension.dart';

class CategoryModel extends Equatable {
  final String id;
  final String? parentId;
  final String categoryCode;
  final String categoryName;
  final String description;
  final CategoryModel? parent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CategoryTranslationModel>? translations;

  const CategoryModel({
    required this.id,
    required this.parentId,
    required this.categoryCode,
    required this.categoryName,
    required this.description,
    this.parent,
    required this.createdAt,
    required this.updatedAt,
    required this.translations,
  });

  @override
  List<Object?> get props {
    return [
      id,
      parentId,
      categoryCode,
      categoryName,
      description,
      parent,
      createdAt,
      updatedAt,
      translations,
    ];
  }

  CategoryModel copyWith({
    String? id,
    ValueGetter<String?>? parentId,
    String? categoryCode,
    String? categoryName,
    String? description,
    ValueGetter<CategoryModel?>? parent,
    DateTime? createdAt,
    DateTime? updatedAt,
    ValueGetter<List<CategoryTranslationModel>?>? translations,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      parentId: parentId != null ? parentId() : this.parentId,
      categoryCode: categoryCode ?? this.categoryCode,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      parent: parent != null ? parent() : this.parent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      translations: translations != null ? translations() : this.translations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parentId': parentId,
      'categoryCode': categoryCode,
      'categoryName': categoryName,
      'description': description,
      'parent': parent,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'translations': translations?.map((x) => x.toMap()).toList() ?? [],
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map.getField<String>('id'),
      parentId: map.getFieldOrNull<String>('parentId'),
      categoryCode: map.getField<String>('categoryCode'),
      categoryName: map.getField<String>('categoryName'),
      description: map.getField<String>('description'),
      parent: map.getFieldOrNull<Map<String, dynamic>>('parent') != null
          ? CategoryModel.fromMap(map.getField<Map<String, dynamic>>('parent'))
          : null,
      createdAt: map.getField<DateTime>('createdAt'),
      updatedAt: map.getField<DateTime>('updatedAt'),
      translations: List<CategoryTranslationModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('translations')
                ?.map(
                  (x) => CategoryTranslationModel.fromMap(
                    x as Map<String, dynamic>,
                  ),
                ) ??
            [],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryModel(id: $id, parentId: $parentId, categoryCode: $categoryCode, categoryName: $categoryName, description: $description, parent: $parent, createdAt: $createdAt, updatedAt: $updatedAt, translations: $translations)';
  }
}

class CategoryTranslationModel extends Equatable {
  final String langCode;
  final String categoryName;
  final String description;

  const CategoryTranslationModel({
    required this.langCode,
    required this.categoryName,
    required this.description,
  });

  @override
  List<Object> get props => [langCode, categoryName, description];

  CategoryTranslationModel copyWith({
    String? langCode,
    String? categoryName,
    String? description,
  }) {
    return CategoryTranslationModel(
      langCode: langCode ?? this.langCode,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'langCode': langCode,
      'categoryName': categoryName,
      'description': description,
    };
  }

  factory CategoryTranslationModel.fromMap(Map<String, dynamic> map) {
    return CategoryTranslationModel(
      langCode: map.getField<String>('langCode'),
      categoryName: map.getField<String>('categoryName'),
      description: map.getField<String>('description'),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryTranslationModel.fromJson(String source) =>
      CategoryTranslationModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CategoryTranslationModel(langCode: $langCode, categoryName: $categoryName, description: $description)';
}
