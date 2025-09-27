import 'dart:convert';

import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String parentID;
  final String categoryCode;
  final String categoryName;
  final String description;
  final List<CategoryModel> children;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CategoryTranslationModel> translations;

  const CategoryModel({
    required this.id,
    required this.parentID,
    required this.categoryCode,
    required this.categoryName,
    required this.description,
    required this.children,
    required this.createdAt,
    required this.updatedAt,
    required this.translations,
  });

  @override
  List<Object> get props {
    return [
      id,
      parentID,
      categoryCode,
      categoryName,
      description,
      children,
      createdAt,
      updatedAt,
      translations,
    ];
  }

  CategoryModel copyWith({
    String? id,
    String? parentID,
    String? categoryCode,
    String? categoryName,
    String? description,
    List<CategoryModel>? children,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<CategoryTranslationModel>? translations,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      parentID: parentID ?? this.parentID,
      categoryCode: categoryCode ?? this.categoryCode,
      categoryName: categoryName ?? this.categoryName,
      description: description ?? this.description,
      children: children ?? this.children,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      translations: translations ?? this.translations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parentID': parentID,
      'categoryCode': categoryCode,
      'categoryName': categoryName,
      'description': description,
      'children': children.map((x) => x.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'translations': translations.map((x) => x.toMap()).toList(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      parentID: map['parentID'] ?? '',
      categoryCode: map['categoryCode'] ?? '',
      categoryName: map['categoryName'] ?? '',
      description: map['description'] ?? '',
      children: List<CategoryModel>.from(
        map['children']?.map((x) => CategoryModel.fromMap(x)),
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      translations: List<CategoryTranslationModel>.from(
        map['translations']?.map((x) => CategoryTranslationModel.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CategoryModel(id: $id, parentID: $parentID, categoryCode: $categoryCode, categoryName: $categoryName, description: $description, children: $children, createdAt: $createdAt, updatedAt: $updatedAt, translations: $translations)';
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
      langCode: map['langCode'] ?? '',
      categoryName: map['categoryName'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryTranslationModel.fromJson(String source) =>
      CategoryTranslationModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CategoryTranslationModel(langCode: $langCode, categoryName: $categoryName, description: $description)';
}
