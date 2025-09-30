import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/feature/auth/data/models/auth_model.dart';
import 'package:sigma_track/feature/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/login_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/register_usecase.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<ApiResponse<UserModel>> register(RegisterUsecaseParams params);
  Future<ApiResponse<AuthModel>> login(LoginUsecaseParams params);
  Future<ApiResponse<dynamic>> forgotPassword(
    ForgotPasswordUsecaseParams params,
  );
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _dioClient;

  AuthRemoteDatasourceImpl(this._dioClient);

  @override
  Future<ApiResponse<UserModel>> register(RegisterUsecaseParams params) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.authRegister,
        data: params.toMap(),
        fromJson: (json) => UserModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<AuthModel>> login(LoginUsecaseParams params) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.authLogin,
        data: params.toMap(),
        fromJson: (json) => AuthModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<dynamic>> forgotPassword(
    ForgotPasswordUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.authForgotPassword,
        data: params.toMap(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
