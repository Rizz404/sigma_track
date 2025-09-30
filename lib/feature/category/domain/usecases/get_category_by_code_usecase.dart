import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';

class GetCategoryByCodeUsecase
    implements Usecase<ItemSuccess<Category>, GetCategoryByCodeUsecaseParams> {
  final CategoryRepository _categoryRepository;

  GetCategoryByCodeUsecase(this._categoryRepository);

  @override
  Future<Either<Failure, ItemSuccess<Category>>> call(
    GetCategoryByCodeUsecaseParams params,
  ) async {
    return await _categoryRepository.getCategoryByCode(params);
  }
}

class GetCategoryByCodeUsecaseParams extends Equatable {
  final String code;

  GetCategoryByCodeUsecaseParams({required this.code});

  GetCategoryByCodeUsecaseParams copyWith({String? code}) {
    return GetCategoryByCodeUsecaseParams(code: code ?? this.code);
  }

  Map<String, dynamic> toMap() {
    return {'code': code};
  }

  factory GetCategoryByCodeUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetCategoryByCodeUsecaseParams(code: map['code'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory GetCategoryByCodeUsecaseParams.fromJson(String source) =>
      GetCategoryByCodeUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() => 'GetCategoryByCodeUsecaseParams(code: $code)';

  @override
  List<Object> get props => [code];
}
