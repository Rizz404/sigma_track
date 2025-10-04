import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/router/app_router.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/get_current_auth_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/login_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/logout_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/register_usecase.dart';
import 'package:sigma_track/feature/auth/presentation/providers/auth_state.dart';
import 'package:sigma_track/feature/user/data/mapper/user_mappers.dart';

/// * ========================================================================
/// * REFRESH LISTENABLE VERSION
/// * ========================================================================
/// *
/// * Approach: Menggunakan refreshListenable untuk trigger router refresh
/// * tanpa recreate router instance
/// *
/// * Keuntungan:
/// * ✅ Router hanya dibuat sekali (saat app start)
/// * ✅ Tidak ada GlobalKey conflict karena keys tetap sama
/// * ✅ Hanya redirect logic yang di-refresh saat auth berubah
/// * ✅ Lebih performant (tidak rebuild widget tree)
/// * ✅ Best practice sesuai dokumentasi GoRouter
/// *
/// * Kekurangan:
/// * ⚠️ Lebih complex setup (butuh ChangeNotifier)
/// * ⚠️ Butuh refactor router configuration
/// *
/// * ========================================================================
/// *
/// * CARA PAKAI:
/// *
/// * 1. Di main.dart, ganti provider:
/// *    ```dart
/// *    final router = ref.watch(routerRefreshListenableProvider);
/// *    ```
/// *
/// * 2. Di widgets, ganti ke provider baru:
/// *    ```dart
/// *    // Before
/// *    ref.read(authNotifierProvider.notifier).logout();
/// *
/// *    // After
/// *    ref.read(authNotifierRefreshListenableProvider.notifier).logout();
/// *    ```
/// *
/// * 3. (Optional) Update app_router.dart GlobalKeys ke static:
/// *    ```dart
/// *    static final GlobalKey<NavigatorState> _rootNavigatorKey = ...
/// *    ```
/// *
/// * Lihat ROUTER_COMPARISON.md untuk detail lengkap
/// *
/// * ========================================================================

/// * Auth Notifier dengan AsyncNotifier pattern
final authNotifierRefreshListenableProvider =
    AsyncNotifierProvider<AuthNotifierRefreshListenable, AuthState>(
      AuthNotifierRefreshListenable.new,
    );

class AuthNotifierRefreshListenable extends AsyncNotifier<AuthState> {
  late GetCurrentAuthUsecase _getCurrentAuthUsecase;
  late LoginUsecase _loginUsecase;
  late RegisterUsecase _registerUsecase;
  late ForgotPasswordUsecase _forgotPasswordUsecase;
  late LogoutUsecase _logoutUsecase;

  @override
  FutureOr<AuthState> build() async {
    _getCurrentAuthUsecase = ref.read(getCurrentAuthUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _registerUsecase = ref.read(registerUsecaseProvider);
    _forgotPasswordUsecase = ref.read(forgotPasswordUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);

    final result = await _getCurrentAuthUsecase.call(NoParams());

    return result.fold(
      (failure) => AuthState.unauthenticated(failure: failure),
      (success) {
        final auth = success.data!;
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

    final result = await _logoutUsecase.call(NoParams());

    result.fold(
      (failure) {
        state = AsyncData(AuthState.unauthenticated(failure: failure));
      },
      (success) {
        state = AsyncData(AuthState.unauthenticated());
      },
    );
  }
}

/// * ChangeNotifier untuk GoRouter refreshListenable
/// * Notify router untuk refresh redirect logic saat auth berubah
class AuthRouterNotifier extends ChangeNotifier {
  final Ref _ref;

  AuthRouterNotifier(this._ref) {
    // * Listen to auth state changes
    _ref.listen<AsyncValue<AuthState>>(authNotifierRefreshListenableProvider, (
      _,
      __,
    ) {
      notifyListeners(); // * Trigger router refresh
    });
  }
}

/// * Router Provider dengan refreshListenable pattern
/// * Router dibuat sekali dan hanya refresh redirect logic
final routerRefreshListenableProvider = Provider<GoRouter>((ref) {
  // * Create auth notifier listenable
  final authRouterNotifier = AuthRouterNotifier(ref);

  // * Get current auth state for initial redirect
  final authState = ref
      .watch(authNotifierRefreshListenableProvider)
      .valueOrNull;
  final isAuthenticated = authState?.status == AuthStatus.authenticated;
  final isAdmin = authState?.user?.role == UserRole.admin;

  // * Create router instance dengan static GlobalKeys
  final appRouter = AppRouter(
    isAuthenticated: isAuthenticated,
    isAdmin: isAdmin,
  );

  return GoRouter(
    navigatorKey: appRouter.router.configuration.navigatorKey,
    initialLocation: RouteConstant.home,
    debugLogDiagnostics: true,
    refreshListenable: authRouterNotifier, // * KEY DIFFERENCE!
    redirect: (context, state) {
      // * Read fresh auth state saat redirect
      final currentAuthState = ref
          .read(authNotifierRefreshListenableProvider)
          .valueOrNull;
      final currentIsAuthenticated =
          currentAuthState?.status == AuthStatus.authenticated;
      final currentIsAdmin = currentAuthState?.user?.role == UserRole.admin;

      final isGoingToAuth = state.matchedLocation.startsWith('/auth');
      final isGoingToAdmin = state.matchedLocation.startsWith('/admin');

      if (!currentIsAuthenticated && !isGoingToAuth) {
        return RouteConstant.login;
      }

      if (currentIsAuthenticated && isGoingToAuth) {
        return currentIsAdmin
            ? RouteConstant.adminDashboard
            : RouteConstant.home;
      }

      if (!currentIsAdmin && isGoingToAdmin) {
        return RouteConstant.home;
      }

      return null;
    },
    routes: appRouter.router.configuration.routes,
  );
});
