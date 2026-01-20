import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/common_providers.dart';
import 'package:sigma_track/di/service_providers.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/get_current_auth_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/login_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/logout_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/register_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/reset_password_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/verify_reset_code_usecase.dart';
import 'package:sigma_track/feature/auth/presentation/providers/auth_state.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';

// Todo: Nanti samain pattern state dan notifier kayak yang udah ada, jangan async
// * Global Auth Notifier Provider
// * Dipindahkan ke DI layer karena dibutuhkan oleh router & global concerns
final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<AuthState> {
  late GetCurrentAuthUsecase _getCurrentAuthUsecase;
  late LoginUsecase _loginUsecase;
  late RegisterUsecase _registerUsecase;
  late ForgotPasswordUsecase _forgotPasswordUsecase;
  late VerifyResetCodeUsecase _verifyResetCodeUsecase;
  late ResetPasswordUsecase _resetPasswordUsecase;
  late LogoutUsecase _logoutUsecase;

  @override
  FutureOr<AuthState> build() async {
    _getCurrentAuthUsecase = ref.read(getCurrentAuthUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _registerUsecase = ref.read(registerUsecaseProvider);
    _forgotPasswordUsecase = ref.read(forgotPasswordUsecaseProvider);
    _verifyResetCodeUsecase = ref.read(verifyResetCodeUsecaseProvider);
    _resetPasswordUsecase = ref.read(resetPasswordUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);

    final result = await _getCurrentAuthUsecase.call(NoParams());

    return result.fold(
      (failure) => AuthState.unauthenticated(failure: failure),
      (success) {
        final auth = success.data!;
        // * Auth punya nullable fields, check isAuthenticated
        if (!auth.isAuthenticated) {
          return AuthState.unauthenticated();
        }
        return AuthState.authenticated(user: auth.user!, success: success);
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
      (success) async {
        // * Invalidate current user provider untuk refresh data
        ref.invalidate(currentUserNotifierProvider);

        // * Sync locale dengan preferredLang user
        await ref
            .read(localeProvider.notifier)
            .syncFromUserLanguage(success.data!.preferredLang);

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
      (success) async {
        // * Invalidate current user provider untuk refresh data user baru
        ref.invalidate(currentUserNotifierProvider);

        // * Sync locale dengan preferredLang user
        final user = success.data!.user;
        await ref
            .read(localeProvider.notifier)
            .syncFromUserLanguage(user.preferredLang);

        state = AsyncData(
          AuthState.authenticated(user: success.data!.user, success: success),
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

  Future<void> verifyResetCode(VerifyResetCodeUsecaseParams params) async {
    state = const AsyncLoading();

    final result = await _verifyResetCodeUsecase.call(params);

    result.fold(
      (failure) {
        state = AsyncData(AuthState.unauthenticated(failure: failure));
      },
      (success) {
        state = AsyncData(AuthState.unauthenticated(success: success));
      },
    );
  }

  Future<void> resetPassword(ResetPasswordUsecaseParams params) async {
    state = const AsyncLoading();

    final result = await _resetPasswordUsecase.call(params);

    result.fold(
      (failure) {
        state = AsyncData(AuthState.unauthenticated(failure: failure));
      },
      (success) {
        // * ActionSuccess, wrap dalam ItemSuccess untuk compatibility
        state = AsyncData(
          AuthState.unauthenticated(
            success: ItemSuccess(message: success.message, data: null),
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      // * Clear FCM token first
      final fcmManager = ref.read(fcmTokenManagerProvider);
      await fcmManager.clearToken();

      final result = await _logoutUsecase.call(NoParams());

      result.fold(
        (failure) {
          state = AsyncData(AuthState.unauthenticated(failure: failure));
        },
        (success) {
          this.logInfo('Logout successful, all data cleared');

          // * Invalidate current user provider untuk clear cached data
          ref.invalidate(currentUserNotifierProvider);

          state = AsyncData(AuthState.unauthenticated());
        },
      );
    } catch (e, s) {
      this.logError('Logout error', e, s);

      // * Tetap invalidate meskipun error
      ref.invalidate(currentUserNotifierProvider);

      state = AsyncData(AuthState.unauthenticated());
    }
  }

  // * Update user data in auth state (for sync after profile update)
  void updateUserData(User updatedUser) {
    state.whenData((authState) {
      if (authState.status == AuthStatus.authenticated) {
        state = AsyncData(authState.copyWith(user: () => updatedUser));
      }
    });
  }
}
