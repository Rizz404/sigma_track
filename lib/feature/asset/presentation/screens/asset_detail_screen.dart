import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/usecases/delete_asset_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/assets_state.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/create_scan_log_usecase.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/scan_log_providers.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_detail_action_buttons.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
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
  Asset? _asset;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _asset = widget.asset;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_asset == null && (widget.id != null || widget.assetTag != null)) {
        _fetchAsset();
      }
      // ! DO NOT create scan log here for direct asset pass
      // ? Scan log already created in scan_asset_screen.dart before navigation
    });
  }

  Future<void> _fetchAsset() async {
    setState(() => _isLoading = true);

    try {
      if (widget.id != null) {
        // * Fetch by ID
        final notifier = ref.read(getAssetByIdProvider(widget.id!).notifier);
        await notifier.refresh();
        final state = ref.read(getAssetByIdProvider(widget.id!));

        if (state.asset != null) {
          setState(() {
            _asset = state.asset;
            _isLoading = false;
          });

          // * Create scan log for manual view
          await _createScanLog(
            assetId: state.asset!.id,
            scannedValue: state.asset!.assetTag,
          );
        } else if (state.failure != null) {
          this.logError('Failed to fetch asset by id', state.failure);
          AppToast.error(state.failure?.message ?? 'Failed to load asset');
          setState(() => _isLoading = false);
        }
      } else if (widget.assetTag != null) {
        // * Fetch by tag
        final notifier = ref.read(
          getAssetByTagProvider(widget.assetTag!).notifier,
        );
        await notifier.refresh();
        final state = ref.read(getAssetByTagProvider(widget.assetTag!));

        if (state.asset != null) {
          setState(() {
            _asset = state.asset;
            _isLoading = false;
          });

          // * Create scan log for manual view
          await _createScanLog(
            assetId: state.asset!.id,
            scannedValue: state.asset!.assetTag,
          );
        } else if (state.failure != null) {
          this.logError('Failed to fetch asset by tag', state.failure);
          AppToast.error(state.failure?.message ?? 'Failed to load asset');
          setState(() => _isLoading = false);
        }
      }
    } catch (e, s) {
      this.logError('Error fetching asset', e, s);
      AppToast.error('Failed to load asset');
      setState(() => _isLoading = false);
    }
  }

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

  void _handleEdit() {
    if (_asset == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(RouteConstant.adminAssetUpsert, extra: _asset);
    } else {
      AppToast.warning('Only admin can edit assets');
    }
  }

  void _handleDelete() async {
    if (_asset == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) {
      AppToast.warning('Only admin can delete assets');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText('Delete Asset', style: AppTextStyle.titleMedium),
        content: AppText(
          'Are you sure you want to delete "${_asset!.assetName}"?',
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
          .read(assetsProvider.notifier)
          .deleteAsset(DeleteAssetUsecaseParams(id: _asset!.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AssetsState>(assetsProvider, (previous, next) {
      if (!next.isMutating && next.message != null && next.failure == null) {
        AppToast.success(next.message ?? 'Operation successful');
        if (previous?.isMutating == true) {
          context.pop();
        }
      } else if (next.failure != null) {
        this.logError('Asset mutation error', next.failure);
        AppToast.error(next.failure?.message ?? 'Operation failed');
      }
    });

    final isLoading = _isLoading || _asset == null;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(
        title: isLoading ? 'Asset Detail' : _asset!.assetName,
      ),
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
    final dummyAsset = Asset.dummy();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Asset Information', [
            _buildInfoRow('Asset Tag', dummyAsset.assetTag),
            _buildInfoRow('Asset Name', dummyAsset.assetName),
            _buildInfoRow('Category', dummyAsset.category?.categoryName ?? '-'),
            _buildInfoRow('Brand', dummyAsset.brand ?? '-'),
            _buildInfoRow('Model', dummyAsset.model ?? '-'),
            _buildInfoRow('Serial Number', dummyAsset.serialNumber ?? '-'),
            _buildInfoRow('Status', dummyAsset.status.name),
            _buildInfoRow('Condition', dummyAsset.condition.name),
            _buildInfoRow('Location', dummyAsset.location?.locationName ?? '-'),
            _buildInfoRow(
              'Assigned To',
              dummyAsset.assignedTo?.fullName ?? '-',
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Purchase Information', [
            _buildInfoRow(
              'Purchase Date',
              dummyAsset.purchaseDate != null
                  ? _formatDateTime(dummyAsset.purchaseDate!)
                  : '-',
            ),
            _buildInfoRow(
              'Purchase Price',
              dummyAsset.purchasePrice != null
                  ? '\$${dummyAsset.purchasePrice}'
                  : '-',
            ),
            _buildInfoRow('Vendor Name', dummyAsset.vendorName ?? '-'),
            _buildInfoRow(
              'Warranty End',
              dummyAsset.warrantyEnd != null
                  ? _formatDateTime(dummyAsset.warrantyEnd!)
                  : '-',
            ),
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
          _buildInfoCard('Asset Information', [
            _buildInfoRow('Asset Tag', _asset!.assetTag),
            _buildInfoRow('Asset Name', _asset!.assetName),
            _buildInfoRow('Category', _asset!.category?.categoryName ?? '-'),
            _buildInfoRow('Brand', _asset!.brand ?? '-'),
            _buildInfoRow('Model', _asset!.model ?? '-'),
            _buildInfoRow('Serial Number', _asset!.serialNumber ?? '-'),
            _buildInfoRow('Status', _asset!.status.name),
            _buildInfoRow('Condition', _asset!.condition.name),
            _buildInfoRow('Location', _asset!.location?.locationName ?? '-'),
            _buildInfoRow('Assigned To', _asset!.assignedTo?.fullName ?? '-'),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Purchase Information', [
            _buildInfoRow(
              'Purchase Date',
              _asset!.purchaseDate != null
                  ? _formatDateTime(_asset!.purchaseDate!)
                  : '-',
            ),
            _buildInfoRow(
              'Purchase Price',
              _asset!.purchasePrice != null
                  ? '\$${_asset!.purchasePrice}'
                  : '-',
            ),
            _buildInfoRow('Vendor Name', _asset!.vendorName ?? '-'),
            _buildInfoRow(
              'Warranty End',
              _asset!.warrantyEnd != null
                  ? _formatDateTime(_asset!.warrantyEnd!)
                  : '-',
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Metadata', [
            _buildInfoRow('Created At', _formatDateTime(_asset!.createdAt)),
            _buildInfoRow('Updated At', _formatDateTime(_asset!.updatedAt)),
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
