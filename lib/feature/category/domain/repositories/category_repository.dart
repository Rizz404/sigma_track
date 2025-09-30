import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/entities/category_statistics.dart';
import 'package:sigma_track/feature/category/domain/usecases/check_category_code_exists_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/check_category_exists_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/create_category_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/delete_category_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_categories_cursor_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_categories_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_category_by_code_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_category_by_id_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/update_category_usecase.dart';

abstract class CategoryRepository {
  Future<Either<Failure, ItemSuccess<Category>>> createCategory(
    CreateCategoryUsecaseParams params,
  );
  Future<Either<Failure, OffsetPaginatedSuccess<Category>>> getCategories(
    GetCategoriesUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<CategoryStatistics>>>
  getCategoriesStatistics();
  Future<Either<Failure, CursorPaginatedSuccess<Category>>> getCategoriesCursor(
    GetCategoriesCursorUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<int>>> countCategories();
  Future<Either<Failure, ItemSuccess<Category>>> getCategoryByCode(
    GetCategoryByCodeUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<bool>>> checkCategoryCodeExists(
    CheckCategoryCodeExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<bool>>> checkCategoryExists(
    CheckCategoryExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<Category>>> getCategoryById(
    GetCategoryByIdUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<Category>>> updateCategory(
    UpdateCategoryUsecaseParams params,
  );
  Future<Either<Failure, ActionSuccess>> deleteCategory(
    DeleteCategoryUsecaseParams params,
  );
}
