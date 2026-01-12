import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset_image.dart'
    as entity;
import 'package:sigma_track/feature/asset/domain/usecases/delete_asset_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/assets_state.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/create_scan_log_usecase.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/scan_log_providers.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_detail_action_buttons.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_image.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AssetDetailScreen extends ConsumerStatefulWidget {
  final Asset? asset;
  final String? id;
  final String? assetTag;

  const AssetDetailScreen({super.key, this.asset, this.id, this.assetTag});

  @override
  ConsumerState<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends ConsumerState<AssetDetailScreen> {
  // * Flag to track if scan log was already created (prevent duplicate on re-render)
  bool _scanLogCreated = false;

  Future<void> _createScanLog({
    required String assetId,
    required String scannedValue,
  }) async {
    try {
      // * Get current user
      final currentUserState = ref.read(currentUserNotifierProvider);
      if (currentUserState.user == null) {
        this.logError('Cannot create scan log: user not found');
        return;
      }

      // * Get current location
      Position? position;
      try {
        position = await _getCurrentLocation();
      } catch (e) {
        this.logInfo('Location unavailable: $e');
      }

      // * Create scan log
      final scanLogNotifier = ref.read(scanLogsProvider.notifier);
      await scanLogNotifier.createScanLog(
        CreateScanLogUsecaseParams(
          assetId: assetId,
          scannedValue: scannedValue,
          scanMethod: ScanMethodType.manualInput,
          scannedById: currentUserState.user!.id,
          scanTimestamp: DateTime.now(),
          scanLocationLat: position?.latitude,
          scanLocationLng: position?.longitude,
          scanResult: ScanResultType.success,
        ),
      );

      this.logInfo('Scan log created successfully');
    } catch (e, s) {
      this.logError('Failed to create scan log', e, s);
      // ! Don't show error to user, log creation is not critical
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // * Check if location services enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services disabled');
    }

    // * Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions permanently denied');
    }

    // * Get position
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 5),
      ),
    );
  }

  void _handleEdit(Asset asset) {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(RouteConstant.adminAssetUpsert, extra: asset);
    } else {
      AppToast.warning(context.l10n.assetOnlyAdminCanEdit);
    }
  }

  void _handleCopy(Asset asset) {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(
        RouteConstant.adminAssetUpsert,
        extra: {'copyFromAsset': asset},
      );
    } else {
      AppToast.warning(context.l10n.assetOnlyAdminCanEdit);
    }
  }

  void _handleDelete(Asset asset) async {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) {
      AppToast.warning(context.l10n.assetOnlyAdminCanDelete);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.assetDeleteAsset,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.assetDeleteConfirmation(asset.assetName),
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(context.l10n.assetCancel),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.assetDelete,
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(assetsProvider.notifier)
          .deleteAsset(DeleteAssetUsecaseParams(id: asset.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Determine asset source: extra > fetch by id > fetch by tag
    Asset? asset = widget.asset;
    bool isLoading = false;
    String? errorMessage;

    // * If no asset from extra, fetch by id or tag
    if (asset == null && widget.id != null) {
      final state = ref.watch(getAssetByIdProvider(widget.id!));
      asset = state.asset;
      isLoading = state.isLoading;
      errorMessage = state.failure?.message;

      // * Create scan log once when asset is fetched (not from extra)
      if (asset != null && !_scanLogCreated) {
        _scanLogCreated = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _createScanLog(assetId: asset!.id, scannedValue: asset.assetTag);
        });
      }
    } else if (asset == null && widget.assetTag != null) {
      final state = ref.watch(getAssetByTagProvider(widget.assetTag!));
      asset = state.asset;
      isLoading = state.isLoading;
      errorMessage = state.failure?.message;

      // * Create scan log once when asset is fetched (not from extra)
      if (asset != null && !_scanLogCreated) {
        _scanLogCreated = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _createScanLog(assetId: asset!.id, scannedValue: asset.assetTag);
        });
      }
    }

    // * Listen only for delete operation
    ref.listen<AssetsState>(assetsProvider, (previous, next) {
      if (next.mutation?.type == MutationType.delete) {
        if (next.hasMutationSuccess) {
          AppToast.success(
            next.mutationMessage ?? context.l10n.assetDeletedSuccess,
          );
          context.pop();
        } else if (next.hasMutationError) {
          this.logError('Delete error', next.mutationFailure);
          AppToast.error(
            next.mutationFailure?.message ?? context.l10n.assetDeletedFailed,
          );
        }
      }
    });

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(title: asset?.assetName ?? context.l10n.assetDetail),
      endDrawer: const AppEndDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: _buildBody(
        asset: asset,
        isLoading: isLoading,
        isAdmin: isAdmin,
        errorMessage: errorMessage,
      ),
    );
  }

  Widget _buildBody({
    required Asset? asset,
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
              text: context.l10n.assetCancel,
              onPressed: () => context.pop(),
            ),
          ],
        ),
      );
    }

    return Skeletonizer(
      enabled: isLoading || asset == null,
      child: Column(
        children: [
          Expanded(
            child: ScreenWrapper(
              child: isLoading || asset == null
                  ? _buildLoadingContent()
                  : _buildContent(asset),
            ),
          ),
          if (!isLoading && asset != null && isAdmin)
            AppDetailActionButtons(
              onEdit: () => _handleEdit(asset),
              onDelete: () => _handleDelete(asset),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    final dummyAsset = Asset.dummy();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context.l10n.assetInformation, [
            _buildInfoRow(context.l10n.assetName, dummyAsset.assetName),
            _buildInfoRow(
              context.l10n.assetCategory,
              dummyAsset.category?.categoryName ?? '-',
            ),
            _buildInfoRow(context.l10n.assetBrand, dummyAsset.brand ?? '-'),
            _buildInfoRow(context.l10n.assetModel, dummyAsset.model ?? '-'),
            _buildInfoRow(
              context.l10n.assetSerialNumber,
              dummyAsset.serialNumber ?? '-',
            ),
            _buildInfoRow(context.l10n.assetStatus, dummyAsset.status.name),
            _buildInfoRow(
              context.l10n.assetCondition,
              dummyAsset.condition.name,
            ),
            _buildInfoRow(
              context.l10n.assetLocation,
              dummyAsset.location?.locationName ?? '-',
            ),
            _buildInfoRow(
              context.l10n.assetAssignedTo,
              dummyAsset.assignedTo?.fullName ?? '-',
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard(context.l10n.assetPurchaseInformation, [
            _buildInfoRow(
              context.l10n.assetPurchaseDate,
              dummyAsset.purchaseDate != null
                  ? _formatDateTime(dummyAsset.purchaseDate!)
                  : '-',
            ),
            _buildInfoRow(
              context.l10n.assetPurchasePrice,
              dummyAsset.purchasePrice != null
                  ? '\$${dummyAsset.purchasePrice}'
                  : '-',
            ),
            _buildInfoRow(
              context.l10n.assetVendorName,
              dummyAsset.vendorName ?? '-',
            ),
            _buildInfoRow(
              context.l10n.assetWarrantyEnd,
              dummyAsset.warrantyEnd != null
                  ? _formatDateTime(dummyAsset.warrantyEnd!)
                  : '-',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildContent(Asset asset) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 0. Asset Images Gallery (NEW!)
          if (asset.images != null && asset.images!.isNotEmpty) ...[
            _buildImageGallery(asset.images!),
            const SizedBox(height: 16),
          ],

          // 1. Info Utama Dulu
          _buildInfoCard(context.l10n.assetInformation, [
            _buildInfoRow(context.l10n.assetTag, asset.assetTag),
            _buildInfoRow(context.l10n.assetName, asset.assetName),
            _buildInfoRow(
              context.l10n.assetCategory,
              asset.category?.categoryName ?? '-',
            ),
            _buildInfoRow(context.l10n.assetBrand, asset.brand ?? '-'),
            _buildInfoRow(context.l10n.assetModel, asset.model ?? '-'),
            _buildInfoRow(
              context.l10n.assetSerialNumber,
              asset.serialNumber ?? '-',
            ),
            _buildInfoRow(context.l10n.assetStatus, asset.status.name),
            _buildInfoRow(context.l10n.assetCondition, asset.condition.name),
            _buildInfoRow(
              context.l10n.assetLocation,
              asset.location?.locationName ?? '-',
            ),
            _buildInfoRow(
              context.l10n.assetAssignedTo,
              asset.assignedTo?.fullName ?? '-',
            ),
          ]),

          const SizedBox(height: 24),

          // 2. Section Quick Actions (Card/Button Style)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AppText(
              context.l10n.assetQuickActions,
              style: AppTextStyle.titleMedium,
            ),
          ),
          const SizedBox(height: 12),
          _buildQuickActionsMenu(asset),

          const SizedBox(height: 24),

          // 3. Info Tambahan
          _buildInfoCard(context.l10n.assetPurchaseInformation, [
            _buildInfoRow(
              context.l10n.assetPurchaseDate,
              asset.purchaseDate != null
                  ? _formatDateTime(asset.purchaseDate!)
                  : '-',
            ),
            _buildInfoRow(
              context.l10n.assetPurchasePrice,
              asset.purchasePrice != null ? '\$${asset.purchasePrice}' : '-',
            ),
            _buildInfoRow(
              context.l10n.assetVendorName,
              asset.vendorName ?? '-',
            ),
            _buildInfoRow(
              context.l10n.assetWarrantyEnd,
              asset.warrantyEnd != null
                  ? _formatDateTime(asset.warrantyEnd!)
                  : '-',
            ),
          ]),

          const SizedBox(height: 16),

          _buildInfoCard(context.l10n.assetMetadata, [
            _buildInfoRow(
              context.l10n.assetCreatedAt,
              _formatDateTime(asset.createdAt),
            ),
            _buildInfoRow(
              context.l10n.assetUpdatedAt,
              _formatDateTime(asset.updatedAt),
            ),
          ]),

          if (asset.dataMatrixImageUrl.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(context.l10n.assetDataMatrixImage, [
              AppImage(
                imageUrl: asset.dataMatrixImageUrl,
                size: ImageSize.fullWidth,
                shape: ImageShape.rectangle,
                fit: BoxFit.contain,
              ),
            ]),
          ],
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

  Widget _buildQuickActionsMenu(Asset asset) {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    final actions = [
      _ActionItem(
        icon: Icons.report_problem_rounded,
        label: context.l10n.assetReportIssue,
        color: context.semantic.warning, // * Highlight color", "StartLine": 525
        onTap: () => context.push(
          RouteConstant.issueReportUpsert,
          extra: {'prePopulatedAsset': asset},
        ),
      ),
      _ActionItem(
        icon: Icons.person_outline_rounded,
        label: context.l10n.assetMoveToUser,
        onTap: () {
          final route = isAdmin
              ? RouteConstant.adminAssetMovementUpsertForUser
              : RouteConstant.staffAssetMovementUpsertForUser;
          context.push(route, extra: {'prePopulatedAsset': asset});
        },
      ),
      _ActionItem(
        icon: Icons.location_on_outlined,
        label: context.l10n.assetMoveToLocation,
        onTap: () {
          final route = isAdmin
              ? RouteConstant.adminAssetMovementUpsertForLocation
              : RouteConstant.staffAssetMovementUpsertForLocation;
          context.push(route, extra: {'prePopulatedAsset': asset});
        },
      ),
      if (isAdmin) ...[
        _ActionItem(
          icon: Icons.calendar_month_outlined,
          label: context.l10n.assetScheduleMaintenance,
          onTap: () => context.push(
            RouteConstant.adminMaintenanceScheduleUpsert,
            extra: {'prePopulatedAsset': asset},
          ),
        ),
        _ActionItem(
          icon: Icons.build_circle_outlined,
          label: context.l10n.assetRecordMaintenance,
          onTap: () => context.push(
            RouteConstant.adminMaintenanceRecordUpsert,
            extra: {'prePopulatedAsset': asset},
          ),
        ),
        _ActionItem(
          icon: Icons.content_copy,
          label: context.l10n.assetCopyAsset,
          onTap: () => _handleCopy(asset),
        ),
      ],
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = actions[index];
          final activeColor = item.color ?? Theme.of(context).primaryColor;

          return Material(
            color: context.colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.colors.border, width: 1),
            ),
            child: InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 100,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, color: activeColor, size: 26),
                    const SizedBox(height: 8),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      // Manual styling biar pas ukurannya
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageGallery(List<entity.AssetImage> images) {
    // * Sort images by displayOrder and primary flag
    final sortedImages = List<entity.AssetImage>.from(images)
      ..sort((a, b) {
        if (a.isPrimary && !b.isPrimary) return -1;
        if (!a.isPrimary && b.isPrimary) return 1;
        return a.displayOrder.compareTo(b.displayOrder);
      });

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
            Row(
              children: [
                AppText(
                  context.l10n.assetImages,
                  style: AppTextStyle.titleMedium,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AppText(
                    '${images.length}',
                    style: AppTextStyle.labelSmall,
                    color: context.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sortedImages.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final image = sortedImages[index];
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: image.isPrimary
                                  ? context.colorScheme.primary
                                  : context.colors.border,
                              width: image.isPrimary ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: image.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color:
                                  context.colorScheme.surfaceContainerHighest,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color:
                                  context.colorScheme.surfaceContainerHighest,
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        ),
                      ),
                      if (image.isPrimary)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: AppText(
                              context.l10n.assetPrimaryImage,
                              style: AppTextStyle.labelSmall,
                              color: context.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
}
