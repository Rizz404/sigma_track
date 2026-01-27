import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/mappers/cursor_mapper.dart';
import 'package:sigma_track/core/mappers/pagination_mapper.dart';
import 'package:sigma_track/core/network/models/api_error_response.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/feature/auth/data/datasources/auth_local_datasource.dart';
import 'package:sigma_track/feature/user/data/datasources/user_remote_datasource.dart';
import 'package:sigma_track/feature/user/data/mapper/user_mappers.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/domain/entities/user_statistics.dart';
import 'package:sigma_track/feature/user/domain/entities/user_personal_statistics.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';
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

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource _userRemoteDatasource;
  final AuthLocalDatasource _authLocalDatasource;

  UserRepositoryImpl(this._userRemoteDatasource, this._authLocalDatasource);

  @override
  Future<Either<Failure, ItemSuccess<User>>> createUser(
    CreateUserUsecaseParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.createUser(params);
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
  Future<Either<Failure, OffsetPaginatedSuccess<User>>> getUsers(
    GetUsersUsecaseParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.getUsers(params);
      final users = response.data.map((model) => model.toEntity()).toList();
      return Right(
        OffsetPaginatedSuccess(
          message: response.message,
          data: users,
          pagination: response.pagination.toEntity(),
        ),
      );
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<UserStatistics>>>
  getUsersStatistics() async {
    try {
      final response = await _userRemoteDatasource.getUsersStatistics();
      final statistics = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: statistics));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<UserPersonalStatistics>>>
  getUserPersonalStatistics() async {
    try {
      final response = await _userRemoteDatasource.getUserPersonalStatistics();
      final statistics = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: statistics));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CursorPaginatedSuccess<User>>> getUsersCursor(
    GetUsersCursorUsecaseParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.getUsersCursor(params);
      final users = response.data.map((model) => model.toEntity()).toList();
      return Right(
        CursorPaginatedSuccess(
          message: response.message,
          data: users,
          cursor: response.cursor.toEntity(),
        ),
      );
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<int>>> countUsers(
    CountUsersUsecaseParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.countUsers(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<User>>> getUserByName(
    GetUserByNameUsecaseParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.getUserByName(params);
      final user = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: user));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<User>>> getUserByEmail(
    GetUserByEmailUsecaseParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.getUserByEmail(params);
      final user = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: user));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<bool>>> checkUserNameExists(
    CheckUserNameExistsUsecaseParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.checkUserNameExists(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<bool>>> checkUserEmailExists(
    CheckUserEmailExistsUsecaseParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.checkUserEmailExists(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<bool>>> checkUserExists(
    CheckUserExistsUsecaseParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.checkUserExists(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<User>>> getUserById(
    GetUserByIdUsecaseParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.getUserById(params);
      final user = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: user));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<User>>> getCurrentUser() async {
    try {
      // * Prioritas: local storage dulu untuk hemat request API
      final localUserModel = await _authLocalDatasource.getUser();

      if (localUserModel != null) {
        this.logData('getCurrentUser: Using cached user from local storage');
        final user = localUserModel.toEntity();
        return Right(
          ItemSuccess(message: 'User retrieved from cache', data: user),
        );
      }

      // * Fallback: Fetch dari API jika local tidak ada
      this.logData('getCurrentUser: Fetching from API (no local cache)');
      final response = await _userRemoteDatasource.getCurrentUser();
      final user = response.data.toEntity();

      // * Save ke local storage untuk next time
      await _authLocalDatasource.saveUser(response.data);
      this.logData('getCurrentUser: User saved to local storage');

      return Right(ItemSuccess(message: response.message, data: user));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<User>>> updateUser(
    UpdateUserUsecaseParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.updateUser(params);
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
  Future<Either<Failure, ItemSuccess<User>>> updateCurrentUser(
    UpdateCurrentUserUsecaseParams params,
  ) async {
    try {
      // * Update ke API
      final response = await _userRemoteDatasource.updateCurrentUser(params);
      final user = response.data.toEntity();

      // * Sync ke local storage agar getCurrentUser & getCurrentAuth konsisten
      await _authLocalDatasource.saveUser(response.data);
      this.logData('updateCurrentUser: User synced to local storage');

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
  Future<Either<Failure, ActionSuccess>> deleteUser(
    DeleteUserUsecaseParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.deleteUser(params);
      return Right(ActionSuccess(message: response.message));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> changeUserPassword(
    ChangeUserPasswordUsecaseParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.changeUserPassword(params);
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

  @override
  Future<Either<Failure, ActionSuccess>> changeCurrentUserPassword(
    ChangeCurrentUserPasswordUsecaseParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.changeCurrentUserPassword(
        params,
      );
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

  @override
  Future<Either<Failure, ItemSuccess<Uint8List>>> exportUserList(
    ExportUserListUsecaseParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.exportUserList(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<BulkCreateUsersResponse>>> createManyUsers(
    BulkCreateUsersParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.createManyUsers(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<BulkDeleteResponse>>> deleteManyUsers(
    BulkDeleteParams params,
  ) async {
    try {
      final response = await _userRemoteDatasource.deleteManyUsers(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
