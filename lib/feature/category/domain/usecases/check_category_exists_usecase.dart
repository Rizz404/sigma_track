import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';

class CheckCategoryExistsUsecase
    implements Usecase<ItemSuccess<bool>, CheckCategoryExistsUsecaseParams> {
  final CategoryRepository _categoryRepository;

  CheckCategoryExistsUsecase(this._categoryRepository);

  @override
  Future<Either<Failure, ItemSuccess<bool>>> call(
    CheckCategoryExistsUsecaseParams params,
  ) async {
    return await _categoryRepository.checkCategoryExists(params);
  }
}

class CheckCategoryExistsUsecaseParams extends Equatable {
  final String id;

  CheckCategoryExistsUsecaseParams({required this.id});

  CheckCategoryExistsUsecaseParams copyWith({String? id}) {
    return CheckCategoryExistsUsecaseParams(id: id ?? this.id);
  }

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory CheckCategoryExistsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CheckCategoryExistsUsecaseParams(id: map['id'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory CheckCategoryExistsUsecaseParams.fromJson(String source) =>
      CheckCategoryExistsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() => 'CheckCategoryExistsUsecaseParams(id: $id)';

  @override
  List<Object> get props => [id];
}
