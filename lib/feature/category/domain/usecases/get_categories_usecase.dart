import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';

class GetCategoriesUsecase
    implements
        Usecase<OffsetPaginatedSuccess<Category>, GetCategoriesUsecaseParams> {
  final CategoryRepository _categoryRepository;

  GetCategoriesUsecase(this._categoryRepository);

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<Category>>> call(
    GetCategoriesUsecaseParams params,
  ) async {
    return await _categoryRepository.getCategories(params);
  }
}

class GetCategoriesUsecaseParams extends Equatable {
  final int? limit;
  final int? offset;

  GetCategoriesUsecaseParams({this.limit, this.offset});

  GetCategoriesUsecaseParams copyWith({int? limit, int? offset}) {
    return GetCategoriesUsecaseParams(
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  Map<String, dynamic> toMap() {
    return {'limit': limit, 'offset': offset};
  }

  factory GetCategoriesUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetCategoriesUsecaseParams(
      limit: map['limit']?.toInt(),
      offset: map['offset']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetCategoriesUsecaseParams.fromJson(String source) =>
      GetCategoriesUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetCategoriesUsecaseParams(limit: $limit, offset: $offset)';

  @override
  List<Object?> get props => [limit, offset];
}
