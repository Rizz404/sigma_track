import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/feature/auth/domain/entities/auth.dart';
import 'package:sigma_track/feature/auth/domain/entities/login_response.dart';
import 'package:sigma_track/feature/auth/domain/entities/verify_reset_code_response.dart';
import 'package:sigma_track/feature/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/login_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/register_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/reset_password_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/verify_reset_code_usecase.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, ItemSuccess<User>>> register(
    RegisterUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<LoginResponse>>> login(
    LoginUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<dynamic>>> forgotPassword(
    ForgotPasswordUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<VerifyResetCodeResponse>>> verifyResetCode(
    VerifyResetCodeUsecaseParams params,
  );
  Future<Either<Failure, ActionSuccess>> resetPassword(
    ResetPasswordUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<Auth>>> getCurrentAuth();
  Future<Either<Failure, ActionSuccess>> logout();
  Future<Either<Failure, ItemSuccess<LoginResponse>>> refreshToken(
    String refreshToken,
  );
}
