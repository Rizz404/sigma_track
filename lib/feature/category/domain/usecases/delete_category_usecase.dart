import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';

class DeleteCategoryUsecase
    implements Usecase<ActionSuccess, DeleteCategoryUsecaseParams> {
  final CategoryRepository _categoryRepository;

  DeleteCategoryUsecase(this._categoryRepository);

  @override
  Future<Either<Failure, ActionSuccess>> call(
    DeleteCategoryUsecaseParams params,
  ) async {
    return await _categoryRepository.deleteCategory(params);
  }
}

class DeleteCategoryUsecaseParams extends Equatable {
  final String id;

  DeleteCategoryUsecaseParams({required this.id});

  DeleteCategoryUsecaseParams copyWith({String? id}) {
    return DeleteCategoryUsecaseParams(id: id ?? this.id);
  }

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory DeleteCategoryUsecaseParams.fromMap(Map<String, dynamic> map) {
    return DeleteCategoryUsecaseParams(id: map['id'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory DeleteCategoryUsecaseParams.fromJson(String source) =>
      DeleteCategoryUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() => 'DeleteCategoryUsecaseParams(id: $id)';

  @override
  List<Object> get props => [id];
}
