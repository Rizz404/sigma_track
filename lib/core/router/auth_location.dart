import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/feature/auth/presentation/screens/forgot_password_screen.dart';
import 'package:sigma_track/feature/auth/presentation/screens/login_screen.dart';
import 'package:sigma_track/feature/auth/presentation/screens/register_screen.dart';

/// Handles authentication-related routes
/// Supports: login, register, and forgot password screens
class AuthLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
    RouteConstant.login,
    RouteConstant.register,
    RouteConstant.forgotPassword,
  ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = <BeamPage>[];

    // Login screen
    if (state.uri.path == RouteConstant.login ||
        state.uri.path == RouteConstant.auth) {
      pages.add(
        const BeamPage(
          key: ValueKey('login'),
          title: 'Login - Sigma Track',
          child: LoginScreen(),
        ),
      );
    }

    // Register screen
    if (state.uri.path == RouteConstant.register) {
      pages.add(
        const BeamPage(
          key: ValueKey('register'),
          title: 'Register - Sigma Track',
          child: RegisterScreen(),
        ),
      );
    }

    // Forgot password screen
    if (state.uri.path == RouteConstant.forgotPassword) {
      pages.add(
        const BeamPage(
          key: ValueKey('forgot-password'),
          title: 'Forgot Password - Sigma Track',
          child: ForgotPasswordScreen(),
        ),
      );
    }

    // Default to login if no pages matched
    if (pages.isEmpty) {
      pages.add(
        const BeamPage(
          key: ValueKey('login'),
          title: 'Login - Sigma Track',
          child: LoginScreen(),
        ),
      );
    }

    return pages;
  }
}
