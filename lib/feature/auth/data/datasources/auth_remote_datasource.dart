import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/feature/auth/data/models/login_response_model.dart';
import 'package:sigma_track/feature/auth/data/models/verify_reset_code_response_model.dart';
import 'package:sigma_track/feature/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/login_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/register_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/reset_password_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/verify_reset_code_usecase.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<ApiResponse<UserModel>> register(RegisterUsecaseParams params);
  Future<ApiResponse<LoginResponseModel>> login(LoginUsecaseParams params);
  Future<ApiResponse<dynamic>> forgotPassword(
    ForgotPasswordUsecaseParams params,
  );
  Future<ApiResponse<VerifyResetCodeResponseModel>> verifyResetCode(
    VerifyResetCodeUsecaseParams params,
  );
  Future<ApiResponse<dynamic>> resetPassword(ResetPasswordUsecaseParams params);
  Future<ApiResponse<LoginResponseModel>> refreshToken(String refreshToken);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient _dioClient;

  AuthRemoteDatasourceImpl(this._dioClient);

  @override
  Future<ApiResponse<UserModel>> register(RegisterUsecaseParams params) async {
    this.logData('register called');
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
  Future<ApiResponse<LoginResponseModel>> login(
    LoginUsecaseParams params,
  ) async {
    this.logData('login called');
    try {
      final response = await _dioClient.post(
        ApiConstant.authLogin,
        data: params.toMap(),
        fromJson: (json) => LoginResponseModel.fromMap(json),
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
    this.logData('forgotPassword called');
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

  @override
  Future<ApiResponse<LoginResponseModel>> refreshToken(
    String refreshToken,
  ) async {
    this.logData('refreshToken called');
    try {
      final response = await _dioClient.post(
        ApiConstant.authRefreshToken,
        data: {'refreshToken': refreshToken},
        fromJson: (json) => LoginResponseModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<VerifyResetCodeResponseModel>> verifyResetCode(
    VerifyResetCodeUsecaseParams params,
  ) async {
    this.logData('verifyResetCode called');
    try {
      final response = await _dioClient.post(
        ApiConstant.authVerifyResetCode,
        data: params.toMap(),
        fromJson: (json) => VerifyResetCodeResponseModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<dynamic>> resetPassword(
    ResetPasswordUsecaseParams params,
  ) async {
    this.logData('resetPassword called');
    try {
      final response = await _dioClient.post(
        ApiConstant.authResetPassword,
        data: params.toMap(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
