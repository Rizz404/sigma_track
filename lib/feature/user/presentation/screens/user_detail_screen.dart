import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
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
  User? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    if (_user == null && widget.id != null) {
      _fetchUser();
    }
  }

  Future<void> _fetchUser() async {
    setState(() => _isLoading = true);
    // TODO: Implement fetch user logic
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  void _handleEdit() {
    if (_user == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(RouteConstant.adminUserUpsert, extra: _user);
    } else {
      AppToast.warning('Only admin can edit users');
    }
  }

  void _handleDelete() async {
    if (_user == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) {
      AppToast.warning('Only admin can delete users');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText('Delete User', style: AppTextStyle.titleMedium),
        content: AppText(
          'Are you sure you want to delete "${_user!.fullName}"?',
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const AppText('Cancel'),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: 'Delete',
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
          .deleteUser(DeleteUserUsecaseParams(id: _user!.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<UsersState>(usersProvider, (previous, next) {
      if (!next.isMutating && next.message != null && next.failure == null) {
        AppToast.success(next.message ?? 'Operation successful');
        if (previous?.isMutating == true) {
          context.pop();
        }
      } else if (next.failure != null) {
        this.logError('User mutation error', next.failure);
        AppToast.error(next.failure?.message ?? 'Operation failed');
      }
    });

    final isLoading = _isLoading || _user == null;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(title: isLoading ? 'User Detail' : _user!.fullName),
      endDrawer: const AppEndDrawer(),
      body: Skeletonizer(
        enabled: isLoading,
        child: Column(
          children: [
            Expanded(
              child: ScreenWrapper(
                child: isLoading ? _buildLoadingContent() : _buildContent(),
              ),
            ),
            if (!isLoading && isAdmin)
              AppDetailActionButtons(
                onEdit: _handleEdit,
                onDelete: _handleDelete,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingContent() {
    final dummyUser = User.dummy();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('User Information', [
            _buildInfoRow('Name', dummyUser.name),
            _buildInfoRow('Email', dummyUser.email),
            _buildInfoRow('Full Name', dummyUser.fullName),
            _buildInfoRow('Role', dummyUser.role.name),
            _buildInfoRow('Employee ID', dummyUser.employeeId ?? '-'),
            _buildInfoRow('Preferred Language', dummyUser.preferredLang),
            _buildInfoRow('Active', dummyUser.isActive ? 'Yes' : 'No'),
          ]),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('User Information', [
            _buildInfoRow('Name', _user!.name),
            _buildInfoRow('Email', _user!.email),
            _buildInfoRow('Full Name', _user!.fullName),
            _buildInfoRow('Role', _user!.role.name),
            _buildInfoRow('Employee ID', _user!.employeeId ?? '-'),
            _buildInfoRow('Preferred Language', _user!.preferredLang),
            _buildInfoRow('Active', _user!.isActive ? 'Yes' : 'No'),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Metadata', [
            _buildInfoRow('Created At', _formatDateTime(_user!.createdAt)),
            _buildInfoRow('Updated At', _formatDateTime(_user!.updatedAt)),
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
