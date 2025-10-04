import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/di/common_providers.dart';
import 'package:sigma_track/feature/auth/presentation/providers/auth_state.dart';

/// * End Drawer dengan konten berbeda berdasarkan role user
class AppEndDrawer extends ConsumerWidget {
  const AppEndDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Drawer(
      child: authState.when(
        data: (state) {
          if (state.status != AuthStatus.authenticated) {
            return _buildUnauthenticatedDrawer(context);
          }

          final isAdmin = state.user?.role == UserRole.admin;
          return isAdmin
              ? _buildAdminDrawer(context, ref, state)
              : _buildUserDrawer(context, ref, state);
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: context.colorScheme.primary),
        ),
        error: (_, __) => _buildUnauthenticatedDrawer(context),
      ),
    );
  }

  Widget _buildUnauthenticatedDrawer(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Please login first',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildUserDrawer(
    BuildContext context,
    WidgetRef ref,
    AuthState state,
  ) {
    return SafeArea(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          _buildUserInfo(context, state),
          const Divider(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerTile(
                  context: context,
                  icon: Icons.home,
                  title: context.l10n.home,
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.home);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.qr_code_scanner,
                  title: 'Scan Asset',
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.scanAsset);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.inventory_2,
                  title: 'My Assets',
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.myAssets);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.myNotifications);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.person,
                  title: context.l10n.profile,
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.userDetailProfile);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          _buildSettingsSection(context, ref),
          _buildLogoutButton(context, ref),
        ],
      ),
    );
  }

  Widget _buildAdminDrawer(
    BuildContext context,
    WidgetRef ref,
    AuthState state,
  ) {
    return SafeArea(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          _buildUserInfo(context, state),
          const Divider(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerTile(
                  context: context,
                  icon: Icons.dashboard,
                  title: context.l10n.dashboard,
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.adminDashboard);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.qr_code_scanner,
                  title: 'Scan Asset',
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.adminScanAsset);
                  },
                ),
                const Divider(),
                // * Management Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    'Management',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.inventory_2,
                  title: 'Assets',
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.adminAssets);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.swap_horiz,
                  title: 'Asset Movements',
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.adminAssetMovements);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.category,
                  title: 'Categories',
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.adminCategories);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.location_on,
                  title: 'Locations',
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.adminLocations);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.people,
                  title: 'Users',
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.adminUsers);
                  },
                ),
                const Divider(),
                // * Maintenance Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    'Maintenance',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.schedule,
                  title: 'Maintenance Schedules',
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.adminMaintenanceSchedules);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.history,
                  title: 'Maintenance Records',
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.adminMaintenanceRecords);
                  },
                ),
                const Divider(),
                // * Reports Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    'Reports',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.report_problem,
                  title: 'Issue Reports',
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.adminIssueReports);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.history_toggle_off,
                  title: 'Scan Logs',
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.adminScanLogs);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.adminNotifications);
                  },
                ),
                const Divider(),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.person,
                  title: context.l10n.profile,
                  onTap: () {
                    context.pop();
                    context.go(RouteConstant.adminUserDetailProfile);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          _buildSettingsSection(context, ref),
          _buildLogoutButton(context, ref),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: context.colorScheme.primaryContainer),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.track_changes,
            size: 48,
            color: context.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(height: 8),
          Text(
            'Sigma Track',
            style: context.textTheme.titleLarge?.copyWith(
              color: context.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, AuthState state) {
    final user = state.user;
    if (user == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: context.colorScheme.primaryContainer,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.email,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: context.colorScheme.onSurface),
      title: Text(title, style: context.textTheme.bodyLarge),
      onTap: onTap,
    );
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // * Theme Switcher
        ListTile(
          leading: Icon(
            Icons.brightness_6,
            color: context.colorScheme.onSurface,
          ),
          title: Text('Theme', style: context.textTheme.bodyLarge),
          trailing: _buildThemeSwitch(context, ref),
        ),
        // * Language Switcher
        ListTile(
          leading: Icon(Icons.language, color: context.colorScheme.onSurface),
          title: Text('Language', style: context.textTheme.bodyLarge),
          trailing: _buildLanguageDropdown(context, ref),
        ),
      ],
    );
  }

  Widget _buildThemeSwitch(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system && context.isDarkMode);

    return Switch(
      value: isDark,
      onChanged: (value) {
        ref
            .read(themeProvider.notifier)
            .changeTheme(value ? ThemeMode.dark : ThemeMode.light);
      },
    );
  }

  Widget _buildLanguageDropdown(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return DropdownButton<Locale>(
      value: currentLocale,
      underline: const SizedBox.shrink(),
      items: [
        DropdownMenuItem(
          value: const Locale('en'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🇬🇧'),
              const SizedBox(width: 8),
              Text('English', style: context.textTheme.bodyMedium),
            ],
          ),
        ),
        DropdownMenuItem(
          value: const Locale('id'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🇮🇩'),
              const SizedBox(width: 8),
              Text('Indonesia', style: context.textTheme.bodyMedium),
            ],
          ),
        ),
        DropdownMenuItem(
          value: const Locale('ja'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🇯🇵'),
              const SizedBox(width: 8),
              Text('日本語', style: context.textTheme.bodyMedium),
            ],
          ),
        ),
      ],
      onChanged: (Locale? newLocale) {
        if (newLocale != null) {
          ref.read(localeProvider.notifier).changeLocale(newLocale);
        }
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () {
            context.pop();
            ref.read(authNotifierProvider.notifier).logout();
          },
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: FilledButton.styleFrom(
            backgroundColor: context.colorScheme.error,
            foregroundColor: context.colorScheme.onError,
          ),
        ),
      ),
    );
  }
}
