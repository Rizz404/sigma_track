import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/network/models/api_cursor_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_offset_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';
import 'package:sigma_track/feature/user/data/models/user_statistics_model.dart';
import 'package:sigma_track/feature/user/domain/usecases/check_user_email_exists_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/check_user_exists_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/check_user_name_exists_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/count_users_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/create_user_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/delete_user_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_user_by_email_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_user_by_name_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_users_cursor_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_users_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/update_user_usecase.dart';

abstract class UserRemoteDatasource {
  Future<ApiResponse<UserModel>> createUser(CreateUserUsecaseParams params);
  Future<ApiOffsetPaginationResponse<UserModel>> getUsers(
    GetUsersUsecaseParams params,
  );
  Future<ApiResponse<UserStatisticsModel>> getUsersStatistics();
  Future<ApiCursorPaginationResponse<UserModel>> getUsersCursor(
    GetUsersCursorUsecaseParams params,
  );
  Future<ApiResponse<int>> countUsers(CountUsersUsecaseParams params);
  Future<ApiResponse<UserModel>> getUserByName(
    GetUserByNameUsecaseParams params,
  );
  Future<ApiResponse<UserModel>> getUserByEmail(
    GetUserByEmailUsecaseParams params,
  );
  Future<ApiResponse<bool>> checkUserNameExists(
    CheckUserNameExistsUsecaseParams params,
  );
  Future<ApiResponse<bool>> checkUserEmailExists(
    CheckUserEmailExistsUsecaseParams params,
  );
  Future<ApiResponse<bool>> checkUserExists(
    CheckUserExistsUsecaseParams params,
  );
  Future<ApiResponse<UserModel>> getUserById(GetUserByIdUsecaseParams params);
  Future<ApiResponse<UserModel>> updateUser(UpdateUserUsecaseParams params);
  Future<ApiResponse<dynamic>> deleteUser(DeleteUserUsecaseParams params);
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final DioClient _dioClient;

  UserRemoteDatasourceImpl(this._dioClient);

  @override
  Future<ApiResponse<UserModel>> createUser(
    CreateUserUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.createUser,
        data: params.toMap(),
        fromJson: (json) => UserModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiOffsetPaginationResponse<UserModel>> getUsers(
    GetUsersUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithOffset(
        ApiConstant.getUsers,
        queryParameters: params.toMap(),
        fromJson: (json) => UserModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<UserStatisticsModel>> getUsersStatistics() async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getUsersStatistics,
        fromJson: (json) => UserStatisticsModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiCursorPaginationResponse<UserModel>> getUsersCursor(
    GetUsersCursorUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithCursor(
        ApiConstant.getUsersCursor,
        queryParameters: params.toMap(),
        fromJson: (json) => UserModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<int>> countUsers(CountUsersUsecaseParams params) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.countUsers,
        queryParameters: params.toMap(),
        fromJson: (json) => json as int,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<UserModel>> getUserByName(
    GetUserByNameUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getUserByName(params.name),
        fromJson: (json) => UserModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<UserModel>> getUserByEmail(
    GetUserByEmailUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getUserByEmail(params.email),
        fromJson: (json) => UserModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkUserNameExists(
    CheckUserNameExistsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.checkUserNameExists(params.name),
        fromJson: (json) => json['exists'] as bool,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkUserEmailExists(
    CheckUserEmailExistsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.checkUserEmailExists(params.email),
        fromJson: (json) => json['exists'] as bool,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkUserExists(
    CheckUserExistsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.checkUserExists(params.id),
        fromJson: (json) => json['exists'] as bool,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<UserModel>> getUserById(
    GetUserByIdUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getUserById(params.id),
        fromJson: (json) => UserModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<UserModel>> updateUser(
    UpdateUserUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.patch(
        ApiConstant.updateUser(params.id),
        data: params.toMap(),
        fromJson: (json) => UserModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<dynamic>> deleteUser(
    DeleteUserUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.delete(
        ApiConstant.deleteUser(params.id),
        fromJson: (json) => json,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
