import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';

/// * Staff Shell dengan bottom navigation untuk Dashboard, Scan, dan Profile
class StaffShell extends StatefulWidget {
  const StaffShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<StaffShell> createState() => _StaffShellState();
}

class _StaffShellState extends State<StaffShell> {
  DateTime? _lastBackPressed;

  Future<bool> _onWillPop(BuildContext context) async {
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final isOnDashboard = currentRoute == RouteConstant.staffDashboard;

    if (!isOnDashboard) {
      widget.navigationShell.goBranch(0, initialLocation: true);
      return false;
    }

    final now = DateTime.now();
    const backPressDuration = Duration(seconds: 2);

    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > backPressDuration) {
      _lastBackPressed = now;
      AppToast.info(context.l10n.shellDoubleBackToExitApp);
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop(context);
        if (shouldPop && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: widget.navigationShell,
        endDrawer: const AppEndDrawer(),
        endDrawerEnableOpenDragGesture: false,
        bottomNavigationBar: NavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: (index) {
            widget.navigationShell.goBranch(
              index,
              initialLocation: index == widget.navigationShell.currentIndex,
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
      ),
    );
  }
}
