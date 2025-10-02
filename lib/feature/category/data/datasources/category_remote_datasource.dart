import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/network/models/api_cursor_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_offset_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/feature/category/data/models/category_model.dart';
import 'package:sigma_track/feature/category/data/models/category_statistics_model.dart';
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

abstract class CategoryRemoteDatasource {
  Future<ApiResponse<CategoryModel>> createCategory(
    CreateCategoryUsecaseParams params,
  );
  Future<ApiOffsetPaginationResponse<CategoryModel>> getCategories(
    GetCategoriesUsecaseParams params,
  );
  Future<ApiResponse<CategoryStatisticsModel>> getCategoriesStatistics();
  Future<ApiCursorPaginationResponse<CategoryModel>> getCategoriesCursor(
    GetCategoriesCursorUsecaseParams params,
  );
  Future<ApiResponse<int>> countCategories(CountCategoriesUsecaseParams params);
  Future<ApiResponse<CategoryModel>> getCategoryByCode(
    GetCategoryByCodeUsecaseParams params,
  );
  Future<ApiResponse<bool>> checkCategoryCodeExists(
    CheckCategoryCodeExistsUsecaseParams params,
  );
  Future<ApiResponse<bool>> checkCategoryExists(
    CheckCategoryExistsUsecaseParams params,
  );
  Future<ApiResponse<CategoryModel>> getCategoryById(
    GetCategoryByIdUsecaseParams params,
  );
  Future<ApiResponse<CategoryModel>> updateCategory(
    UpdateCategoryUsecaseParams params,
  );
  Future<ApiResponse<dynamic>> deleteCategory(
    DeleteCategoryUsecaseParams params,
  );
}

class CategoryRemoteDatasourceImpl implements CategoryRemoteDatasource {
  final DioClient _dioClient;

  CategoryRemoteDatasourceImpl(this._dioClient);

  @override
  Future<ApiResponse<CategoryModel>> createCategory(
    CreateCategoryUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.createCategory,
        data: params.toMap(),
        fromJson: (json) => CategoryModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiOffsetPaginationResponse<CategoryModel>> getCategories(
    GetCategoriesUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithOffset(
        ApiConstant.getCategories,
        queryParameters: params.toMap(),
        fromJson: (json) => CategoryModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<CategoryStatisticsModel>> getCategoriesStatistics() async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getCategoriesStatistics,
        fromJson: (json) => CategoryStatisticsModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiCursorPaginationResponse<CategoryModel>> getCategoriesCursor(
    GetCategoriesCursorUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithCursor(
        ApiConstant.getCategoriesCursor,
        queryParameters: params.toMap(),
        fromJson: (json) => CategoryModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<int>> countCategories(
    CountCategoriesUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.countCategories,
        queryParameters: params.toMap(),
        fromJson: (json) => json as int,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<CategoryModel>> getCategoryByCode(
    GetCategoryByCodeUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getCategoryByCode(params.code),
        fromJson: (json) => CategoryModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkCategoryCodeExists(
    CheckCategoryCodeExistsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.checkCategoryCodeExists(params.code),
        fromJson: (json) => json as bool,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkCategoryExists(
    CheckCategoryExistsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.checkCategoryExists(params.id),
        fromJson: (json) => json as bool,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<CategoryModel>> getCategoryById(
    GetCategoryByIdUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getCategoryById(params.id),
        fromJson: (json) => CategoryModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<CategoryModel>> updateCategory(
    UpdateCategoryUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.put(
        ApiConstant.updateCategory(params.id),
        data: params.toMap(),
        fromJson: (json) => CategoryModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<dynamic>> deleteCategory(
    DeleteCategoryUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.delete(
        ApiConstant.deleteCategory(params.id),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
