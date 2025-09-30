import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/di/datasource_providers.dart';
import 'package:sigma_track/feature/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/get_current_auth_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/login_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/register_usecase.dart';

final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LoginUsecase(authRepository);
});

final getCurrentAuthUsecaseProvider = Provider<GetCurrentAuthUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GetCurrentAuthUsecase(authRepository);
});

final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository);
});

final forgotPasswordUsecaseProvider = Provider<ForgotPasswordUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return ForgotPasswordUsecase(authRepository);
});
