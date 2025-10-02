import 'package:beamer/beamer.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/router/admin_location.dart';
import 'package:sigma_track/core/router/auth_location.dart';
import 'package:sigma_track/core/router/user_location.dart';

class AppRouter {
  static BeamerDelegate createRouterDelegate({
    required bool Function() isAuthenticated,
    required bool Function() isAdmin,
  }) {
    return BeamerDelegate(
      initialPath: RouteConstant.home,
      locationBuilder: BeamerLocationBuilder(
        beamLocations: [AuthLocation(), UserLocation(), AdminLocation()],
      ),
      guards: [
        BeamGuard(
          pathPatterns: [
            RouteConstant.login,
            RouteConstant.register,
            RouteConstant.forgotPassword,
          ],
          guardNonMatching: true,
          check: (context, location) => isAuthenticated(),
          beamToNamed: (origin, target) => RouteConstant.login,
        ),
        BeamGuard(
          pathPatterns: [RouteConstant.admin + '/*'],
          check: (context, location) => isAdmin(),
          beamToNamed: (origin, target) => RouteConstant.home,
        ),
      ],
    );
  }
}
