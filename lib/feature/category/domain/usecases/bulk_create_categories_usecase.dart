import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';
import 'package:sigma_track/feature/category/domain/usecases/create_category_usecase.dart';

class BulkCreateCategoriesUsecase
    implements
        Usecase<
          ItemSuccess<BulkCreateCategoriesResponse>,
          BulkCreateCategoriesParams
        > {
  final CategoryRepository _categoryRepository;

  BulkCreateCategoriesUsecase(this._categoryRepository);

  @override
  Future<Either<Failure, ItemSuccess<BulkCreateCategoriesResponse>>> call(
    BulkCreateCategoriesParams params,
  ) async {
    return await _categoryRepository.createManyCategories(params);
  }
}

class BulkCreateCategoriesParams extends Equatable {
  final List<CreateCategoryUsecaseParams> categories;

  const BulkCreateCategoriesParams({required this.categories});

  Map<String, dynamic> toMap() {
    return {'categories': categories.map((x) => x.toMap()).toList()};
  }

  factory BulkCreateCategoriesParams.fromMap(Map<String, dynamic> map) {
    return BulkCreateCategoriesParams(
      categories: List<CreateCategoryUsecaseParams>.from(
        (map['categories'] as List).map(
          (x) => CreateCategoryUsecaseParams.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateCategoriesParams.fromJson(String source) =>
      BulkCreateCategoriesParams.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [categories];
}

class BulkCreateCategoriesResponse extends Equatable {
  final List<Category> categories;

  const BulkCreateCategoriesResponse({required this.categories});

  Map<String, dynamic> toMap() {
    return {'categories': categories.map((x) => _categoryToMap(x)).toList()};
  }

  factory BulkCreateCategoriesResponse.fromMap(Map<String, dynamic> map) {
    return BulkCreateCategoriesResponse(
      categories: List<Category>.from(
        (map['categories'] as List).map(
          (x) => _categoryFromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateCategoriesResponse.fromJson(String source) =>
      BulkCreateCategoriesResponse.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [categories];

  static Map<String, dynamic> _categoryToMap(Category category) {
    return {
      'id': category.id,
      'parentId': category.parentId,
      'categoryCode': category.categoryCode,
      'categoryName': category.categoryName,
      'description': category.description,
      'imageUrl': category.imageUrl,
      'createdAt': category.createdAt.toIso8601String(),
      'updatedAt': category.updatedAt.toIso8601String(),
    };
  }

  static Category _categoryFromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? '',
      parentId: map['parentId'],
      categoryCode: map['categoryCode'] ?? '',
      categoryName: map['categoryName'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'],
      createdAt: DateTime.parse(map['createdAt'].toString()),
      updatedAt: DateTime.parse(map['updatedAt'].toString()),
    );
  }
}
