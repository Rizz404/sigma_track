import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/get_current_auth_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/login_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/register_usecase.dart';
import 'package:sigma_track/feature/auth/presentation/providers/auth_state.dart';
import 'package:sigma_track/feature/user/data/mapper/user_mappers.dart';

class AuthNotifier extends AsyncNotifier<AuthState> {
  late GetCurrentAuthUsecase _getCurrentAuthUsecase;
  late LoginUsecase _loginUsecase;
  late RegisterUsecase _registerUsecase;
  late ForgotPasswordUsecase _forgotPasswordUsecase;

  @override
  FutureOr<AuthState> build() async {
    _getCurrentAuthUsecase = ref.read(getCurrentAuthUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _registerUsecase = ref.read(registerUsecaseProvider);
    _forgotPasswordUsecase = ref.read(forgotPasswordUsecaseProvider);

    final result = await _getCurrentAuthUsecase.call(NoParams());

    return result.fold(
      (failure) => AuthState.unauthenticated(failure: failure),
      (success) {
        final auth = success.data!;
        // * Auth punya nullable fields, check isAuthenticated
        if (!auth.isAuthenticated) {
          return AuthState.unauthenticated();
        }
        return AuthState.authenticated(
          user: auth.user!.toEntity(),
          success: success,
        );
      },
    );
  }

  Future<void> register(RegisterUsecaseParams params) async {
    state = const AsyncLoading();

    final result = await _registerUsecase.call(params);

    result.fold(
      (failure) {
        state = AsyncData(AuthState.unauthenticated(failure: failure));
      },
      (success) {
        state = AsyncData(
          AuthState.authenticated(user: success.data, success: success),
        );
      },
    );
  }

  Future<void> login(LoginUsecaseParams params) async {
    state = const AsyncLoading();

    final result = await _loginUsecase.call(params);

    result.fold(
      (failure) {
        state = AsyncData(AuthState.unauthenticated(failure: failure));
      },
      (success) {
        state = AsyncData(
          AuthState.authenticated(
            user: success.data!.user.toEntity(),
            success: success,
          ),
        );
      },
    );
  }

  Future<void> forgotPassword(ForgotPasswordUsecaseParams params) async {
    state = const AsyncLoading();

    final result = await _forgotPasswordUsecase.call(params);

    result.fold(
      (failure) {
        state = AsyncData(AuthState.unauthenticated(failure: failure));
      },
      (success) {
        state = AsyncData(AuthState.unauthenticated(success: success));
      },
    );
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      state = AsyncData(AuthState.unauthenticated());
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
