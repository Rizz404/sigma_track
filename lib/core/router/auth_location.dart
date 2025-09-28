import 'package:beamer/beamer.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sigma_track/feature/auth/presentation/screens/forgot_password_screen.dart';
import 'package:sigma_track/feature/auth/presentation/screens/login_screen.dart';
import 'package:sigma_track/feature/auth/presentation/screens/register_screen.dart';

class AuthLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => ['/auth/*'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('register'),
        title: 'Register',
        child: RegisterScreen(),
      ),
      const BeamPage(
        key: ValueKey('login'),
        title: 'Login',
        child: LoginScreen(),
      ),
      const BeamPage(
        key: ValueKey('forgot-password'),
        title: 'Forgot Password',
        child: ForgotPasswordScreen(),
      ),
    ];
  }
}
