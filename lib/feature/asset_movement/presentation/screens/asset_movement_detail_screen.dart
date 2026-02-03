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
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/delete_asset_movement_usecase.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/asset_movement_providers.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movements_state.dart';
import 'package:sigma_track/shared/presentation/widgets/app_detail_action_buttons.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AssetMovementDetailScreen extends ConsumerStatefulWidget {
  final AssetMovement? assetMovement;
  final String? id;

  const AssetMovementDetailScreen({super.key, this.assetMovement, this.id});

  @override
  ConsumerState<AssetMovementDetailScreen> createState() =>
      _AssetMovementDetailScreenState();
}

class _AssetMovementDetailScreenState
    extends ConsumerState<AssetMovementDetailScreen> {
  AssetMovement? _currentAssetMovement;

  Future<void> _handleEdit(AssetMovement assetMovement) async {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;
    final isStaff = authState?.user?.role == UserRole.staff;

    if (!isAdmin && !isStaff) {
      AppToast.warning(context.l10n.assetMovementOnlyAdminCanEdit);
      return;
    }

    await _showEditAssetMovementDialog(assetMovement);
  }

  Future<void> _showEditAssetMovementDialog(AssetMovement assetMovement) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.assetMovementEditAssetMovement,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.assetMovementSelectMovementType,
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final result = await context.push<AssetMovement?>(
                RouteConstant.adminAssetMovementUpsertForLocation,
                extra: assetMovement,
              );
              if (result != null && mounted) {
                setState(() {
                  _currentAssetMovement = result;
                });
              }
            },
            child: AppText(context.l10n.assetMovementForLocation),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.assetMovementForUser,
            isFullWidth: false,
            onPressed: () async {
              Navigator.pop(context);
              final result = await context.push<AssetMovement?>(
                RouteConstant.adminAssetMovementUpsertForUser,
                extra: assetMovement,
              );
              if (result != null && mounted) {
                setState(() {
                  _currentAssetMovement = result;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  void _handleDelete(AssetMovement assetMovement) async {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;
    final isStaff = authState?.user?.role == UserRole.staff;

    if (!isAdmin && !isStaff) {
      AppToast.warning(context.l10n.assetMovementOnlyAdminCanDelete);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.assetMovementDeleteAssetMovement,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.assetMovementDeleteConfirmation,
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(context.l10n.assetMovementCancel),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.assetMovementDelete,
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(assetMovementsProvider.notifier)
          .deleteAssetMovement(
            DeleteAssetMovementUsecaseParams(id: assetMovement.id),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Determine assetMovement source: current state > extra > fetch by id
    AssetMovement? assetMovement =
        _currentAssetMovement ?? widget.assetMovement;
    bool isLoading = false;
    String? errorMessage;

    // * If no assetMovement from state or extra, fetch by id
    if (assetMovement == null && widget.id != null) {
      final state = ref.watch(getAssetMovementByIdProvider(widget.id!));
      assetMovement = state.assetMovement;
      isLoading = state.isLoading;
      errorMessage = state.failure?.message;
    }

    // * Listen only for delete operation
    ref.listen<AssetMovementsState>(assetMovementsProvider, (previous, next) {
      if (next.mutation?.type == MutationType.delete) {
        if (next.hasMutationSuccess) {
          AppToast.success(
            next.mutationMessage ?? context.l10n.assetMovementDelete,
          );
          context.pop();
        } else if (next.hasMutationError) {
          this.logError('Delete error', next.mutationFailure);
          AppToast.error(
            next.mutationFailure?.message ??
                context.l10n.assetMovementOperationFailed,
          );
        }
      }
    });

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;
    final isStaff = authState?.user?.role == UserRole.staff;

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.assetMovementDetail),
      endDrawer: const AppEndDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: _buildBody(
        assetMovement: assetMovement,
        isLoading: isLoading,
        isAdmin: isAdmin,
        isStaff: isStaff,
        errorMessage: errorMessage,
      ),
    );
  }

  Widget _buildBody({
    required AssetMovement? assetMovement,
    required bool isLoading,
    required bool isAdmin,
    required bool isStaff,
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
              text: context.l10n.assetMovementCancel,
              onPressed: () => context.pop(),
            ),
          ],
        ),
      );
    }

    return Skeletonizer(
      enabled: isLoading || assetMovement == null,
      child: Column(
        children: [
          Expanded(
            child: ScreenWrapper(
              child: isLoading || assetMovement == null
                  ? _buildLoadingContent()
                  : _buildContent(assetMovement),
            ),
          ),
          if (!isLoading && assetMovement != null && (isAdmin || isStaff))
            AppDetailActionButtons(
              onEdit: () => _handleEdit(assetMovement),
              onDelete: () => _handleDelete(assetMovement),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    final dummyMovement = AssetMovement.dummy();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context.l10n.assetMovementInformation, [
            _buildInfoRow(
              context.l10n.assetMovementAsset,
              dummyMovement.asset?.assetName ?? context.l10n.assetMovementAsset,
            ),
            _buildInfoRow(
              context.l10n.assetMovementFromLocation,
              dummyMovement.fromLocation?.locationName ?? '-',
            ),
            _buildInfoRow(
              context.l10n.assetMovementToLocation,
              dummyMovement.toLocation?.locationName ?? '-',
            ),
            _buildInfoRow(
              context.l10n.assetMovementFromUser,
              dummyMovement.fromUser?.fullName ?? '-',
            ),
            _buildInfoRow(
              context.l10n.assetMovementToUser,
              dummyMovement.toUser?.fullName ?? '-',
            ),
            _buildInfoRow(
              context.l10n.assetMovementMovedBy,
              dummyMovement.movedBy?.fullName ?? '-',
            ),
            _buildInfoRow(
              context.l10n.assetMovementMovementDate,
              _formatDateTime(dummyMovement.movementDate),
            ),
            _buildInfoRow(
              context.l10n.assetMovementNotes,
              dummyMovement.notes ?? '-',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildContent(AssetMovement assetMovement) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context.l10n.assetMovementInformation, [
            _buildInfoRow(
              context.l10n.assetMovementAsset,
              assetMovement.asset?.assetName ?? context.l10n.assetMovementAsset,
            ),
            _buildInfoRow(
              context.l10n.assetMovementFromLocation,
              assetMovement.fromLocation?.locationName ?? '-',
            ),
            _buildInfoRow(
              context.l10n.assetMovementToLocation,
              assetMovement.toLocation?.locationName ?? '-',
            ),
            _buildInfoRow(
              context.l10n.assetMovementFromUser,
              assetMovement.fromUser?.fullName ?? '-',
            ),
            _buildInfoRow(
              context.l10n.assetMovementToUser,
              assetMovement.toUser?.fullName ?? '-',
            ),
            _buildInfoRow(
              context.l10n.assetMovementMovedBy,
              assetMovement.movedBy?.fullName ?? '-',
            ),
            _buildInfoRow(
              context.l10n.assetMovementMovementDate,
              _formatDateTime(assetMovement.movementDate),
            ),
            _buildTextBlock(
              context.l10n.assetMovementNotes,
              assetMovement.notes,
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard(context.l10n.assetMovementMetadata, [
            _buildInfoRow(
              context.l10n.assetMovementCreatedAt,
              _formatDateTime(assetMovement.createdAt),
            ),
            _buildInfoRow(
              context.l10n.assetMovementUpdatedAt,
              _formatDateTime(assetMovement.updatedAt),
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

  Widget _buildTextBlock(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            label,
            style: AppTextStyle.bodyMedium,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: context.colors.border),
            ),
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
