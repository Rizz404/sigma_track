import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';

class GetCategoryByIdUsecase
    implements Usecase<ItemSuccess<Category>, GetCategoryByIdUsecaseParams> {
  final CategoryRepository _categoryRepository;

  GetCategoryByIdUsecase(this._categoryRepository);

  @override
  Future<Either<Failure, ItemSuccess<Category>>> call(
    GetCategoryByIdUsecaseParams params,
  ) async {
    return await _categoryRepository.getCategoryById(params);
  }
}

class GetCategoryByIdUsecaseParams extends Equatable {
  final String id;

  GetCategoryByIdUsecaseParams({required this.id});

  GetCategoryByIdUsecaseParams copyWith({String? id}) {
    return GetCategoryByIdUsecaseParams(id: id ?? this.id);
  }

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory GetCategoryByIdUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetCategoryByIdUsecaseParams(id: map['id'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory GetCategoryByIdUsecaseParams.fromJson(String source) =>
      GetCategoryByIdUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() => 'GetCategoryByIdUsecaseParams(id: $id)';

  @override
  List<Object> get props => [id];
}
