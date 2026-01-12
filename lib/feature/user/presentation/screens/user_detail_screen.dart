import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/domain/usecases/delete_user_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/users_state.dart';
import 'package:sigma_track/shared/presentation/widgets/app_detail_action_buttons.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserDetailScreen extends ConsumerStatefulWidget {
  final User? user;
  final String? id;

  const UserDetailScreen({super.key, this.user, this.id});

  @override
  ConsumerState<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends ConsumerState<UserDetailScreen> {
  void _handleEdit(User user) {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(RouteConstant.adminUserUpsert, extra: user);
    } else {
      AppToast.warning(context.l10n.userOnlyAdminCanEdit);
    }
  }

  void _handleDelete(User user) async {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) {
      AppToast.warning(context.l10n.userOnlyAdminCanDelete);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.userDeleteUser,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.userDeleteSingleConfirmation(user.fullName),
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(context.l10n.userCancel),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.userDelete,
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(usersProvider.notifier)
          .deleteUser(DeleteUserUsecaseParams(id: user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Determine user source: extra > fetch by id
    User? user = widget.user;
    bool isLoading = false;
    String? errorMessage;

    // * If no user from extra, fetch by id
    if (user == null && widget.id != null) {
      final state = ref.watch(getUserByIdProvider(widget.id!));
      user = state.user;
      isLoading = state.isLoading;
      errorMessage = state.failure?.message;
    }

    // * Listen only for delete operation
    ref.listen<UsersState>(usersProvider, (previous, next) {
      if (next.mutation?.type == MutationType.delete) {
        if (next.hasMutationSuccess) {
          AppToast.success(next.mutationMessage ?? context.l10n.userDeleted);
          context.pop();
        } else if (next.hasMutationError) {
          this.logError('Delete error', next.mutationFailure);
          AppToast.error(
            next.mutationFailure?.message ?? context.l10n.userDeleteFailed,
          );
        }
      }
    });

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(title: user?.fullName ?? context.l10n.userDetail),
      endDrawer: const AppEndDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: _buildBody(
        user: user,
        isLoading: isLoading,
        isAdmin: isAdmin,
        errorMessage: errorMessage,
      ),
    );
  }

  Widget _buildBody({
    required User? user,
    required bool isLoading,
    required bool isAdmin,
    String? errorMessage,
  }) {
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(errorMessage, style: AppTextStyle.bodyMedium),
            const SizedBox(height: 16),
            AppButton(
              text: context.l10n.userCancel,
              onPressed: () => context.pop(),
            ),
          ],
        ),
      );
    }

    return Skeletonizer(
      enabled: isLoading || user == null,
      child: Column(
        children: [
          Expanded(
            child: ScreenWrapper(
              child: isLoading || user == null
                  ? _buildLoadingContent()
                  : _buildContent(user),
            ),
          ),
          if (!isLoading && user != null && isAdmin)
            AppDetailActionButtons(
              onEdit: () => _handleEdit(user),
              onDelete: () => _handleDelete(user),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    final dummyUser = User.dummy();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context.l10n.userInformation, [
            _buildInfoRow(context.l10n.userName, dummyUser.name),
            _buildInfoRow(context.l10n.userEmail, dummyUser.email),
            _buildInfoRow(context.l10n.userFullName, dummyUser.fullName),
            _buildInfoRow(context.l10n.userRole, dummyUser.role.value),
            _buildInfoRow(
              context.l10n.userEmployeeId,
              dummyUser.employeeId ?? '-',
            ),
            _buildInfoRow(
              context.l10n.userPreferredLang,
              dummyUser.preferredLang,
            ),
            _buildInfoRow(
              context.l10n.userActive,
              dummyUser.isActive ? context.l10n.userYes : context.l10n.userNo,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildContent(User user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context.l10n.userInformation, [
            _buildInfoRow(context.l10n.userName, user.name),
            _buildInfoRow(context.l10n.userEmail, user.email),
            _buildInfoRow(context.l10n.userFullName, user.fullName),
            _buildInfoRow(context.l10n.userRole, user.role.value),
            _buildInfoRow(context.l10n.userEmployeeId, user.employeeId ?? '-'),
            _buildInfoRow(context.l10n.userPreferredLang, user.preferredLang),
            _buildInfoRow(
              context.l10n.userActive,
              user.isActive ? context.l10n.userYes : context.l10n.userNo,
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard(context.l10n.userMetadata, [
            _buildInfoRow(
              context.l10n.userCreatedAt,
              _formatDateTime(user.createdAt),
            ),
            _buildInfoRow(
              context.l10n.userUpdatedAt,
              _formatDateTime(user.updatedAt),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
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

  Widget _buildInfoRow(String label, String value) {
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
