import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/mappers/cursor_mapper.dart';
import 'package:sigma_track/core/mappers/pagination_mapper.dart';
import 'package:sigma_track/core/network/models/api_error_response.dart';
import 'package:sigma_track/feature/category/data/datasources/category_remote_datasource.dart';
import 'package:sigma_track/feature/category/data/mapper/category_mappers.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/entities/category_statistics.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';
import 'package:sigma_track/feature/category/domain/usecases/check_category_code_exists_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/check_category_exists_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/count_categories_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/create_category_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/delete_category_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_categories_cursor_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_categories_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_category_by_code_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_category_by_id_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/update_category_usecase.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDatasource _categoryRemoteDatasource;

  CategoryRepositoryImpl(this._categoryRemoteDatasource);

  @override
  Future<Either<Failure, ItemSuccess<Category>>> createCategory(
    CreateCategoryUsecaseParams params,
  ) async {
    try {
      final response = await _categoryRemoteDatasource.createCategory(params);
      final category = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: category));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<Category>>> getCategories(
    GetCategoriesUsecaseParams params,
  ) async {
    try {
      final response = await _categoryRemoteDatasource.getCategories(params);
      final categories = response.data
          .map((model) => model.toEntity())
          .toList();
      return Right(
        OffsetPaginatedSuccess(
          message: response.message,
          data: categories,
          pagination: response.pagination.toEntity(),
        ),
      );
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<CategoryStatistics>>>
  getCategoriesStatistics() async {
    try {
      final response = await _categoryRemoteDatasource
          .getCategoriesStatistics();
      final statistics = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: statistics));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CursorPaginatedSuccess<Category>>> getCategoriesCursor(
    GetCategoriesCursorUsecaseParams params,
  ) async {
    try {
      final response = await _categoryRemoteDatasource.getCategoriesCursor(
        params,
      );
      final categories = response.data
          .map((model) => model.toEntity())
          .toList();
      return Right(
        CursorPaginatedSuccess(
          message: response.message,
          data: categories,
          cursor: response.cursor.toEntity(),
        ),
      );
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<int>>> countCategories(
    CountCategoriesUsecaseParams params,
  ) async {
    try {
      final response = await _categoryRemoteDatasource.countCategories(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Category>>> getCategoryByCode(
    GetCategoryByCodeUsecaseParams params,
  ) async {
    try {
      final response = await _categoryRemoteDatasource.getCategoryByCode(
        params,
      );
      final category = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: category));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<bool>>> checkCategoryCodeExists(
    CheckCategoryCodeExistsUsecaseParams params,
  ) async {
    try {
      final response = await _categoryRemoteDatasource.checkCategoryCodeExists(
        params,
      );
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<bool>>> checkCategoryExists(
    CheckCategoryExistsUsecaseParams params,
  ) async {
    try {
      final response = await _categoryRemoteDatasource.checkCategoryExists(
        params,
      );
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Category>>> getCategoryById(
    GetCategoryByIdUsecaseParams params,
  ) async {
    try {
      final response = await _categoryRemoteDatasource.getCategoryById(params);
      final category = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: category));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Category>>> updateCategory(
    UpdateCategoryUsecaseParams params,
  ) async {
    try {
      final response = await _categoryRemoteDatasource.updateCategory(params);
      final category = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: category));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> deleteCategory(
    DeleteCategoryUsecaseParams params,
  ) async {
    try {
      final response = await _categoryRemoteDatasource.deleteCategory(params);
      return Right(ActionSuccess(message: response.message));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
