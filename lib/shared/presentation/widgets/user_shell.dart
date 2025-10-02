import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/navigation_extension.dart';

class UserShell extends StatelessWidget {
  final Widget child;

  const UserShell({super.key, required this.child});

  int _getCurrentIndex(BuildContext context) {
    final currentPath = Beamer.of(context).configuration.location;
    if (currentPath == RouteConstant.scanAsset) return 1;
    if (currentPath == RouteConstant.userDetailProfile) return 2;
    return 0; // Default: Home
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.toHome();
        break;
      case 1:
        context.toScanAsset();
        break;
      case 2:
        context.toUserDetailProfile();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _getCurrentIndex(context),
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: context.l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            selectedIcon: const Icon(Icons.qr_code_scanner),
            label: context.l10n.scanAsset,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: context.l10n.profile,
          ),
        ],
      ),
    );
  }
}
