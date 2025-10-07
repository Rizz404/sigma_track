import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/network/models/api_error_response.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/feature/auth/data/datasources/auth_local_datasource.dart';
import 'package:sigma_track/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sigma_track/feature/auth/data/mapper/auth_mappers.dart';
import 'package:sigma_track/feature/auth/domain/entities/auth.dart';
import 'package:sigma_track/feature/auth/domain/entities/login_response.dart';
import 'package:sigma_track/feature/auth/domain/repositories/auth_repository.dart';
import 'package:sigma_track/feature/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/login_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/register_usecase.dart';
import 'package:sigma_track/feature/user/data/mapper/user_mappers.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;
  final AuthLocalDatasource _authLocalDatasource;

  AuthRepositoryImpl(this._authRemoteDatasource, this._authLocalDatasource);

  @override
  Future<Either<Failure, ItemSuccess<User>>> register(
    RegisterUsecaseParams params,
  ) async {
    try {
      final response = await _authRemoteDatasource.register(params);
      final user = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: user));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<LoginResponse>>> login(
    LoginUsecaseParams params,
  ) async {
    try {
      final response = await _authRemoteDatasource.login(params);
      final loginResponse = response.data.toEntity();

      await _authLocalDatasource.saveAccessToken(loginResponse.accessToken);
      await _authLocalDatasource.saveRefreshToken(loginResponse.refreshToken);
      await _authLocalDatasource.saveUser(response.data.user);

      return Right(ItemSuccess(message: response.message, data: loginResponse));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<dynamic>>> forgotPassword(
    ForgotPasswordUsecaseParams params,
  ) async {
    try {
      final response = await _authRemoteDatasource.forgotPassword(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Auth>>> getCurrentAuth() async {
    try {
      final accessToken = await _authLocalDatasource.getAccessToken();
      final refreshToken = await _authLocalDatasource.getRefreshToken();
      final userModel = await _authLocalDatasource.getUser();

      // * Auth dengan nullable fields, jadi bisa return Auth kosong/partial
      final auth = Auth(
        user: userModel?.toEntity(),
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      return Right(
        ItemSuccess(
          message: auth.isAuthenticated
              ? 'Authentication data retrieved'
              : 'No authentication data',
          data: auth,
        ),
      );
    } catch (e) {
      return Left(
        NetworkFailure(message: 'Failed to get auth data: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> logout() async {
    try {
      this.logData('Logout: Starting logout process');
      await _authLocalDatasource.deleteAccessToken();
      await _authLocalDatasource.deleteRefreshToken();
      await _authLocalDatasource.deleteUser();
      this.logData('Logout: Successfully cleared all auth data');

      return const Right(ActionSuccess(message: 'Logout successful'));
    } catch (e, s) {
      this.logError('Logout failed', e, s);
      return Left(NetworkFailure(message: 'Failed to logout: ${e.toString()}'));
    }
  }
}
