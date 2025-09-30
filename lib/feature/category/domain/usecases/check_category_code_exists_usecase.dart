import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';

class CheckCategoryCodeExistsUsecase
    implements
        Usecase<ItemSuccess<bool>, CheckCategoryCodeExistsUsecaseParams> {
  final CategoryRepository _categoryRepository;

  CheckCategoryCodeExistsUsecase(this._categoryRepository);

  @override
  Future<Either<Failure, ItemSuccess<bool>>> call(
    CheckCategoryCodeExistsUsecaseParams params,
  ) async {
    return await _categoryRepository.checkCategoryCodeExists(params);
  }
}

class CheckCategoryCodeExistsUsecaseParams extends Equatable {
  final String code;

  CheckCategoryCodeExistsUsecaseParams({required this.code});

  CheckCategoryCodeExistsUsecaseParams copyWith({String? code}) {
    return CheckCategoryCodeExistsUsecaseParams(code: code ?? this.code);
  }

  Map<String, dynamic> toMap() {
    return {'code': code};
  }

  factory CheckCategoryCodeExistsUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return CheckCategoryCodeExistsUsecaseParams(code: map['code'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory CheckCategoryCodeExistsUsecaseParams.fromJson(String source) =>
      CheckCategoryCodeExistsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() => 'CheckCategoryCodeExistsUsecaseParams(code: $code)';

  @override
  List<Object> get props => [code];
}
