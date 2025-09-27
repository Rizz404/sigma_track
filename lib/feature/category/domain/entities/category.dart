import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String parentID;
  final String categoryCode;
  final String categoryName;
  final String description;
  final List<Category> children;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CategoryTranslation> translations;

  const Category({
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
