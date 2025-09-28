import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:sigma_track/core/constants/route_constants.dart';
import 'package:sigma_track/feature/dashboard/presentation/screens/admin_dashboard_screen.dart';

class AppRouter {
  static final BeamerDelegate routerDelegate = BeamerDelegate(
    initialPath: dashboardRoute, // Redirect to dashboard after login
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (context, state, data) =>
            const AdminDashboardScreen(), // Root redirects to dashboard
        dashboardRoute: (context, state, data) => const AdminDashboardScreen(),
        // Add new routes here
        // Example: assetListRoute: (context, state, data) => const AdminAssetListScreen(),
      },
    ),
  );

  static MaterialApp get app => MaterialApp.router(
    routerDelegate: routerDelegate,
    routeInformationParser: BeamerParser(),
    backButtonDispatcher: BeamerBackButtonDispatcher(delegate: routerDelegate),
  );
}
