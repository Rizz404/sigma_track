import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/navigation_extension.dart';

class AdminShell extends StatelessWidget {
  final Widget child;

  const AdminShell({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final currentPath = Beamer.of(context).configuration.location;
    if (currentPath == RouteConstant.adminScanAsset) return 1;
    if (currentPath == RouteConstant.adminUserDetailProfile) return 2;
    return 0; // Default: Dashboard
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.toAdminDashboard();
        break;
      case 1:
        context.toAdminScanAsset();
        break;
      case 2:
        context.toAdminUserDetailProfile();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _getCurrentIndex(context),
            onDestinationSelected: (index) => _onItemTapped(context, index),
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.dashboard_outlined),
                selectedIcon: const Icon(Icons.dashboard),
                label: Text(context.l10n.dashboard),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.qr_code_scanner_outlined),
                selectedIcon: const Icon(Icons.qr_code_scanner),
                label: Text(context.l10n.scanAsset),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: Text(context.l10n.profile),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
