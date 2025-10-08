import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String? parentId;
  final String categoryCode;
  final String categoryName;
  final String description;
  final Category? parent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CategoryTranslation>? translations;

  const Category({
    required this.id,
    this.parentId,
    required this.categoryCode,
    required this.categoryName,
    required this.description,
    this.parent,
    required this.createdAt,
    required this.updatedAt,
    this.translations,
  });

  factory Category.dummy() => Category(
    id: '',
    categoryCode: '',
    categoryName: '',
    description: '',
    createdAt: DateTime(0),
    updatedAt: DateTime(0),
  );

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
}

class CategoryTranslation extends Equatable {
  final String langCode;
  final String categoryName;
  final String description;

  const CategoryTranslation({
    required this.langCode,
    required this.categoryName,
    required this.description,
  });

  @override
  List<Object> get props => [langCode, categoryName, description];
}
