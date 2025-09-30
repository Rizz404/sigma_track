import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/network/models/api_error_response.dart';
import 'package:sigma_track/feature/auth/data/datasources/auth_local_datasource.dart';
import 'package:sigma_track/feature/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sigma_track/feature/auth/data/mapper/auth_mappers.dart';
import 'package:sigma_track/feature/auth/domain/entities/auth.dart';
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
  Future<Either<Failure, ItemSuccess<Auth>>> login(
    LoginUsecaseParams params,
  ) async {
    try {
      final response = await _authRemoteDatasource.login(params);
      final auth = response.data.toEntity();

      await _authLocalDatasource.saveAccessToken(auth.accessToken);
      await _authLocalDatasource.saveRefreshToken(auth.refreshToken);
      await _authLocalDatasource.saveUser(response.data.user);

      return Right(ItemSuccess(message: response.message, data: auth));
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
  Future<Either<Failure, ItemSuccess<dynamic>>> forgotPassword(
    ForgotPasswordUsecaseParams params,
  ) async {
    try {
      final response = await _authRemoteDatasource.forgotPassword(params);
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
  Future<Either<Failure, ItemSuccess<Auth>>> getCurrentAuth() async {
    try {
      final accessToken = await _authLocalDatasource.getAccessToken();
      final refreshToken = await _authLocalDatasource.getRefreshToken();
      final userModel = await _authLocalDatasource.getUser();

      if (accessToken == null || refreshToken == null || userModel == null) {
        return const Left(NetworkFailure(message: 'User not authenticated'));
      }

      final auth = Auth(
        user: userModel,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      return Right(
        ItemSuccess(message: 'Authentication data retrieved', data: auth),
      );
    } catch (e) {
      return Left(
        NetworkFailure(message: 'Failed to get auth data: ${e.toString()}'),
      );
    }
  }
}
