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
import 'package:sigma_track/shared/presentation/widgets/app_avatar.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

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
            child: AppText(
              'Please login first',
              style: AppTextStyle.bodyMedium,
              color: context.colorScheme.onSurface,
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
                    context.push(RouteConstant.home);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.qr_code_scanner,
                  title: 'Scan Asset',
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.scanAsset);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.inventory_2,
                  title: 'My Assets',
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.myAssets);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.myNotifications);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.report_problem,
                  title: 'My Issue Reports',
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.myIssueReports);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.person,
                  title: context.l10n.profile,
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.userDetailProfile);
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
                    context.push(RouteConstant.adminDashboard);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.qr_code_scanner,
                  title: 'Scan Asset',
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.scanAsset);
                  },
                ),
                const Divider(),
                // * Management Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: AppText(
                    'Management',
                    style: AppTextStyle.labelSmall,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.inventory_2,
                  title: 'Assets',
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.adminAssets);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.swap_horiz,
                  title: 'Asset Movements',
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.adminAssetMovements);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.category,
                  title: 'Categories',
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.adminCategories);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.location_on,
                  title: 'Locations',
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.adminLocations);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.people,
                  title: 'Users',
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.adminUsers);
                  },
                ),
                const Divider(),
                // * Maintenance Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: AppText(
                    'Maintenance',
                    style: AppTextStyle.labelSmall,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.schedule,
                  title: 'Maintenance Schedules',
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.adminMaintenanceSchedules);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.history,
                  title: 'Maintenance Records',
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.adminMaintenanceRecords);
                  },
                ),
                const Divider(),
                // * Reports Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: AppText(
                    'Reports',
                    style: AppTextStyle.labelSmall,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.report_problem,
                  title: 'Issue Reports',
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.adminIssueReports);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.history_toggle_off,
                  title: 'Scan Logs',
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.adminScanLogs);
                  },
                ),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.adminNotifications);
                  },
                ),
                const Divider(),
                _buildDrawerTile(
                  context: context,
                  icon: Icons.person,
                  title: context.l10n.profile,
                  onTap: () {
                    context.pop();
                    context.push(RouteConstant.userDetailProfile);
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
          AppText(
            'Sigma Track',
            style: AppTextStyle.titleLarge,
            color: context.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
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
          AppAvatar(size: AvatarSize.large, imageUrl: user.avatarUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  user.name,
                  style: AppTextStyle.titleMedium,
                  fontWeight: FontWeight.bold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppText(
                  user.email,
                  style: AppTextStyle.bodySmall,
                  color: context.colorScheme.onSurfaceVariant,
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
      title: AppText(title, style: AppTextStyle.bodyLarge),
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
          title: const AppText('Theme', style: AppTextStyle.bodyLarge),
          trailing: _buildThemeSwitch(context, ref),
        ),
        // * Language Switcher
        ListTile(
          leading: Icon(Icons.language, color: context.colorScheme.onSurface),
          title: const AppText('Language', style: AppTextStyle.bodyLarge),
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
        const DropdownMenuItem(
          value: Locale('en'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🇬🇧'),
              const SizedBox(width: 8),
              AppText('English', style: AppTextStyle.bodyMedium),
            ],
          ),
        ),
        // const DropdownMenuItem(
        //   value: Locale('id'),
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       const Text('🇮🇩'),
        //       const SizedBox(width: 8),
        //       AppText('Indonesia', style: AppTextStyle.bodyMedium),
        //     ],
        //   ),
        // ),
        const DropdownMenuItem(
          value: Locale('ja'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🇯🇵'),
              const SizedBox(width: 8),
              AppText('日本語', style: AppTextStyle.bodyMedium),
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
            Navigator.of(context).pop();
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
