import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_avatar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserDetailProfileScreen extends ConsumerWidget {
  const UserDetailProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(currentUserNotifierProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(currentUserNotifierProvider.notifier).refresh();
        },
        child: Skeletonizer(
          enabled: userState.isLoading,
          child: ScreenWrapper(
            child: userState.isLoading
                ? _buildLoadingContent(context)
                : userState.user != null
                ? _buildContent(context, userState.user!)
                : _buildErrorContent(context, userState.failure?.message),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    final dummyUser = User.dummy();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(context, dummyUser),
          const SizedBox(height: 16),
          _buildInfoCard(context, context.l10n.userPersonalInformation, [
            _buildInfoRow(
              context,
              context.l10n.userFullName,
              dummyUser.fullName,
            ),
            _buildInfoRow(context, context.l10n.userUsername, dummyUser.name),
            _buildInfoRow(context, context.l10n.userEmail, dummyUser.email),
            _buildInfoRow(
              context,
              context.l10n.userEmployeeId,
              dummyUser.employeeId ?? '-',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, User user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(context, user),
          const SizedBox(height: 16),
          _buildInfoCard(context, context.l10n.userPersonalInformation, [
            _buildInfoRow(context, context.l10n.userFullName, user.fullName),
            _buildInfoRow(context, context.l10n.userUsername, user.name),
            _buildInfoRow(context, context.l10n.userEmail, user.email),
            _buildInfoRow(
              context,
              context.l10n.userEmployeeId,
              user.employeeId ?? '-',
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard(context, context.l10n.userAccountDetails, [
            _buildInfoRow(
              context,
              context.l10n.userRole,
              user.role.name.toUpperCase(),
            ),
            _buildInfoRow(
              context,
              context.l10n.userStatus,
              user.isActive
                  ? context.l10n.userActive
                  : context.l10n.userInactive,
            ),
            _buildInfoRow(
              context,
              context.l10n.userPreferredLang,
              user.preferredLang,
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard(context, context.l10n.userMetadata, [
            _buildInfoRow(
              context,
              context.l10n.userCreatedAt,
              _formatDateTime(user.createdAt),
            ),
            _buildInfoRow(
              context,
              context.l10n.userUpdatedAt,
              _formatDateTime(user.updatedAt),
            ),
          ]),
          const SizedBox(height: 16),
          _buildProfileActions(context, user),
        ],
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, String? errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: context.semantic.error),
          const SizedBox(height: 16),
          AppText(
            errorMessage ?? context.l10n.userFailedToLoadProfile,
            style: AppTextStyle.bodyLarge,
            color: context.semantic.error,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, User user) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: context.colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: context.colors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _showAvatarDialog(context, user.avatarUrl),
                child: AppAvatar(
                  size: AvatarSize.xxxLarge,
                  imageUrl: user.avatarUrl,
                  backgroundColor: context.colorScheme.primary.withValues(
                    alpha: 0.1,
                  ),
                  placeholder: Icon(
                    Icons.person,
                    size: 50,
                    color: context.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppText(
                user.fullName,
                style: AppTextStyle.headlineSmall,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              AppText(
                user.email,
                style: AppTextStyle.bodyMedium,
                color: context.colors.textSecondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: context.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: AppText(
                  user.role.name.toUpperCase(),
                  style: AppTextStyle.labelMedium,
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Card(
      color: context.colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.colors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              title,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: AppText(
              label,
              style: AppTextStyle.bodyMedium,
              color: context.colors.textSecondary,
            ),
          ),
          Expanded(
            flex: 3,
            child: AppText(
              value,
              style: AppTextStyle.bodyMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showAvatarDialog(BuildContext context, String? imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
              child: Center(
                child: imageUrl != null
                    ? AppAvatar(
                        imageUrl: imageUrl,
                        size: AvatarSize.xxxLarge,
                        shape: AvatarShape.rectangle,
                        fit: BoxFit.contain,
                      )
                    : const Icon(Icons.person, size: 100, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildProfileActions(BuildContext context, User user) {
    // * Determine routes based on user role
    final isAdmin = user.role == UserRole.admin;
    final isStaff = user.role == UserRole.staff;
    final updateProfileRoute = isAdmin
        ? RouteConstant.adminUserUpdateProfile
        : isStaff
        ? RouteConstant.staffUserUpdateProfile
        : RouteConstant.userUpdateProfile;
    final changePasswordRoute = isAdmin
        ? RouteConstant.adminUserChangePassword
        : isStaff
        ? RouteConstant.staffUserChangePassword
        : RouteConstant.userChangePassword;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppButton(
              text: context.l10n.userUpdateProfile,
              onPressed: () => context.push(updateProfileRoute, extra: user),
            ),
            const SizedBox(height: 12),
            AppButton(
              text: context.l10n.userChangePassword,
              variant: AppButtonVariant.outlined,
              leadingIcon: const Icon(Icons.lock_outline, size: 18),
              onPressed: () => context.push(changePasswordRoute),
            ),
          ],
        ),
      ),
    );
  }
}
