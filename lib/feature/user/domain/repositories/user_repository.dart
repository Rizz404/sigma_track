import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/domain/entities/user_statistics.dart';
import 'package:sigma_track/feature/user/domain/entities/user_personal_statistics.dart';
import 'package:sigma_track/feature/user/domain/usecases/bulk_create_users_usecase.dart';
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
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_response.dart';

abstract class UserRepository {
  Future<Either<Failure, ItemSuccess<User>>> createUser(
    CreateUserUsecaseParams params,
  );
  Future<Either<Failure, OffsetPaginatedSuccess<User>>> getUsers(
    GetUsersUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<UserStatistics>>> getUsersStatistics();
  Future<Either<Failure, CursorPaginatedSuccess<User>>> getUsersCursor(
    GetUsersCursorUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<int>>> countUsers(
    CountUsersUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<User>>> getUserByName(
    GetUserByNameUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<User>>> getUserByEmail(
    GetUserByEmailUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<bool>>> checkUserNameExists(
    CheckUserNameExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<bool>>> checkUserEmailExists(
    CheckUserEmailExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<bool>>> checkUserExists(
    CheckUserExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<User>>> getUserById(
    GetUserByIdUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<User>>> getCurrentUser();
  Future<Either<Failure, ItemSuccess<User>>> updateUser(
    UpdateUserUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<User>>> updateCurrentUser(
    UpdateCurrentUserUsecaseParams params,
  );
  Future<Either<Failure, ActionSuccess>> deleteUser(
    DeleteUserUsecaseParams params,
  );
  Future<Either<Failure, ActionSuccess>> changeUserPassword(
    ChangeUserPasswordUsecaseParams params,
  );
  Future<Either<Failure, ActionSuccess>> changeCurrentUserPassword(
    ChangeCurrentUserPasswordUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<Uint8List>>> exportUserList(
    ExportUserListUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<BulkCreateUsersResponse>>> createManyUsers(
    BulkCreateUsersParams params,
  );
  Future<Either<Failure, ItemSuccess<BulkDeleteResponse>>> deleteManyUsers(
    BulkDeleteParams params,
  );
  Future<Either<Failure, ItemSuccess<UserPersonalStatistics>>>
  getUserPersonalStatistics();
}
