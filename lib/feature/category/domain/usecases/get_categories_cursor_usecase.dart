import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';

class GetCategoriesCursorUsecase
    implements
        Usecase<
          CursorPaginatedSuccess<Category>,
          GetCategoriesCursorUsecaseParams
        > {
  final CategoryRepository _categoryRepository;

  GetCategoriesCursorUsecase(this._categoryRepository);

  @override
  Future<Either<Failure, CursorPaginatedSuccess<Category>>> call(
    GetCategoriesCursorUsecaseParams params,
  ) async {
    return await _categoryRepository.getCategoriesCursor(params);
  }
}

class GetCategoriesCursorUsecaseParams extends Equatable {
  final String? cursor;
  final int? limit;

  GetCategoriesCursorUsecaseParams({this.cursor, this.limit});

  GetCategoriesCursorUsecaseParams copyWith({String? cursor, int? limit}) {
    return GetCategoriesCursorUsecaseParams(
      cursor: cursor ?? this.cursor,
      limit: limit ?? this.limit,
    );
  }

  Map<String, dynamic> toMap() {
    return {'cursor': cursor, 'limit': limit};
  }

  factory GetCategoriesCursorUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetCategoriesCursorUsecaseParams(
      cursor: map['cursor'],
      limit: map['limit']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetCategoriesCursorUsecaseParams.fromJson(String source) =>
      GetCategoriesCursorUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetCategoriesCursorUsecaseParams(cursor: $cursor, limit: $limit)';

  @override
  List<Object?> get props => [cursor, limit];
}
