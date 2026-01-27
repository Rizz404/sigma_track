import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/network/models/api_cursor_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_offset_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';
import 'package:sigma_track/feature/user/data/models/user_statistics_model.dart';
import 'package:sigma_track/feature/user/data/models/user_personal_statistics_model.dart';
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
import 'package:sigma_track/feature/user/domain/usecases/change_current_user_password_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/change_user_password_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/update_current_user_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/update_user_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/export_user_list_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/bulk_create_users_usecase.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_response.dart';

abstract class UserRemoteDatasource {
  Future<ApiResponse<UserModel>> createUser(CreateUserUsecaseParams params);
  Future<ApiOffsetPaginationResponse<UserModel>> getUsers(
    GetUsersUsecaseParams params,
  );
  Future<ApiResponse<UserStatisticsModel>> getUsersStatistics();
  Future<ApiResponse<UserPersonalStatisticsModel>> getUserPersonalStatistics();
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
  Future<ApiResponse<UserModel>> getCurrentUser();
  Future<ApiResponse<UserModel>> updateUser(UpdateUserUsecaseParams params);
  Future<ApiResponse<UserModel>> updateCurrentUser(
    UpdateCurrentUserUsecaseParams params,
  );
  Future<ApiResponse<dynamic>> deleteUser(DeleteUserUsecaseParams params);
  Future<ApiResponse<dynamic>> changeUserPassword(
    ChangeUserPasswordUsecaseParams params,
  );
  Future<ApiResponse<dynamic>> changeCurrentUserPassword(
    ChangeCurrentUserPasswordUsecaseParams params,
  );
  Future<ApiResponse<Uint8List>> exportUserList(
    ExportUserListUsecaseParams params,
  );
  Future<ApiResponse<BulkCreateUsersResponse>> createManyUsers(
    BulkCreateUsersParams params,
  );
  Future<ApiResponse<BulkDeleteResponse>> deleteManyUsers(
    BulkDeleteParams params,
  );
}

class UserRemoteDatasourceImpl implements UserRemoteDatasource {
  final DioClient _dioClient;

  UserRemoteDatasourceImpl(this._dioClient);

  @override
  Future<ApiResponse<UserModel>> createUser(
    CreateUserUsecaseParams params,
  ) async {
    this.logData('createUser called');
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
    this.logData('getUsers called');
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
    this.logData('getUsersStatistics called');
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
  Future<ApiResponse<UserPersonalStatisticsModel>>
  getUserPersonalStatistics() async {
    this.logData('getUserPersonalStatistics called');
    try {
      final response = await _dioClient.get(
        ApiConstant.getUserProfileStatistics,
        fromJson: (json) => UserPersonalStatisticsModel.fromMap(json),
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
    this.logData('getUsersCursor called');
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
    this.logData('countUsers called');
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
    this.logData('getUserByName called');
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
    this.logData('getUserByEmail called');
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
    this.logData('checkUserNameExists called');
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
    this.logData('checkUserEmailExists called');
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
    this.logData('checkUserExists called');
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
    this.logData('getUserById called');
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
  Future<ApiResponse<UserModel>> getCurrentUser() async {
    this.logData('getUserById called');
    try {
      final response = await _dioClient.get(
        ApiConstant.getUserProfile,
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
    this.logData('updateUser called');
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
  Future<ApiResponse<UserModel>> updateCurrentUser(
    UpdateCurrentUserUsecaseParams params,
  ) async {
    this.logData('updateUser called');
    try {
      final formData = dio.FormData();
      final map = params.toMap();
      for (final entry in map.entries) {
        if (entry.key == 'avatarFile' && entry.value != null) {
          formData.files.add(
            MapEntry(
              'avatar',
              await dio.MultipartFile.fromFile(entry.value as String),
            ),
          );
        } else if (entry.key == 'avatarUrl' &&
            entry.value != null &&
            map['avatarFile'] == null) {
          formData.fields.add(MapEntry('avatar', entry.value.toString()));
        } else if (entry.value != null && entry.key != 'avatarFile') {
          formData.fields.add(MapEntry(entry.key, entry.value.toString()));
        }
      }
      final response = await _dioClient.patch(
        ApiConstant.updateUserProfile,
        data: formData,
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
    this.logData('deleteUser called');
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

  @override
  Future<ApiResponse<dynamic>> changeUserPassword(
    ChangeUserPasswordUsecaseParams params,
  ) async {
    this.logData('changeUserPassword called');
    try {
      final response = await _dioClient.patch(
        ApiConstant.changeUserPassword(params.id),
        data: params.toMap(),
        fromJson: (json) => json,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<dynamic>> changeCurrentUserPassword(
    ChangeCurrentUserPasswordUsecaseParams params,
  ) async {
    this.logData('changeCurrentUserPassword called');
    try {
      final response = await _dioClient.patch(
        ApiConstant.changeCurrentUserPassword,
        data: params.toMap(),
        fromJson: (json) => json,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<Uint8List>> exportUserList(
    ExportUserListUsecaseParams params,
  ) async {
    this.logData('exportUserList called');
    try {
      final response = await _dioClient.postForBinary(
        ApiConstant.exportUserList,
        data: params.toMap(),
        options: dio.Options(responseType: dio.ResponseType.bytes),
        fromData: (data) => data as Uint8List,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<BulkCreateUsersResponse>> createManyUsers(
    BulkCreateUsersParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.bulkCreateUsers,
        data: params.toMap(),
        fromJson: (json) => BulkCreateUsersResponse.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<BulkDeleteResponse>> deleteManyUsers(
    BulkDeleteParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.bulkDeleteUsers,
        data: params.toMap(),
        fromJson: (json) => BulkDeleteResponse.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
