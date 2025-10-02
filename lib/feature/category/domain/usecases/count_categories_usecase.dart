import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';

class CountCategoriesUsecase
    implements Usecase<ItemSuccess<int>, CountCategoriesUsecaseParams> {
  final CategoryRepository _categoryRepository;

  CountCategoriesUsecase(this._categoryRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(
    CountCategoriesUsecaseParams params,
  ) async {
    return await _categoryRepository.countCategories(params);
  }
}

class CountCategoriesUsecaseParams extends Equatable {
  final String? search;
  final bool? hasParent;

  CountCategoriesUsecaseParams({this.search, this.hasParent});

  CountCategoriesUsecaseParams copyWith({String? search, bool? hasParent}) {
    return CountCategoriesUsecaseParams(
      search: search ?? this.search,
      hasParent: hasParent ?? this.hasParent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (hasParent != null) 'hasParent': hasParent,
    };
  }

  factory CountCategoriesUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CountCategoriesUsecaseParams(
      search: map['search'],
      hasParent: map['hasParent'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CountCategoriesUsecaseParams.fromJson(String source) =>
      CountCategoriesUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'CountCategoriesUsecaseParams(search: $search, hasParent: $hasParent)';

  @override
  List<Object?> get props => [search, hasParent];
}
