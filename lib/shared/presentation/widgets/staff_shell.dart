import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';

/// * Staff Shell dengan bottom navigation untuk Dashboard, Scan, dan Profile
class StaffShell extends StatelessWidget {
  const StaffShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: navigationShell,
      endDrawer: const AppEndDrawer(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: context.l10n.staffShellBottomNavDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.qr_code_scanner_outlined),
            selectedIcon: const Icon(Icons.qr_code_scanner),
            label: context.l10n.staffShellBottomNavScanAsset,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: context.l10n.staffShellBottomNavProfile,
          ),
        ],
      ),
    );
  }
}
