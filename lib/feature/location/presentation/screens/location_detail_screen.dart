import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/domain/usecases/delete_location_usecase.dart';
import 'package:sigma_track/feature/location/presentation/providers/location_providers.dart';
import 'package:sigma_track/feature/location/presentation/providers/state/locations_state.dart';
import 'package:sigma_track/shared/presentation/widgets/app_detail_action_buttons.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LocationDetailScreen extends ConsumerStatefulWidget {
  final Location? location;
  final String? id;
  final String? locationCode;

  const LocationDetailScreen({
    super.key,
    this.location,
    this.id,
    this.locationCode,
  });

  @override
  ConsumerState<LocationDetailScreen> createState() =>
      _LocationDetailScreenState();
}

class _LocationDetailScreenState extends ConsumerState<LocationDetailScreen> {
  void _handleEdit(Location location) {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(RouteConstant.adminLocationUpsert, extra: location);
    } else {
      AppToast.warning(context.l10n.locationOnlyAdminCanEdit);
    }
  }

  void _handleDelete(Location location) async {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) {
      AppToast.warning(context.l10n.locationOnlyAdminCanDelete);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.locationDeleteLocation,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.locationDeleteConfirmation(location.locationName),
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(context.l10n.locationCancel),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.locationDelete,
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref
          .read(locationsProvider.notifier)
          .deleteLocation(DeleteLocationUsecaseParams(id: location.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Determine location source: extra > fetch by id > fetch by code
    Location? location = widget.location;
    bool isLoading = false;
    String? errorMessage;

    // * If no location from extra, fetch by id or code
    if (location == null && widget.id != null) {
      final state = ref.watch(getLocationByIdProvider(widget.id!));
      location = state.location;
      isLoading = state.isLoading;
      errorMessage = state.failure?.message;
    } else if (location == null && widget.locationCode != null) {
      final state = ref.watch(getLocationByCodeProvider(widget.locationCode!));
      location = state.location;
      isLoading = state.isLoading;
      errorMessage = state.failure?.message;
    }

    // * Listen only for delete operation
    ref.listen<LocationsState>(locationsProvider, (previous, next) {
      if (next.mutation?.type == MutationType.delete) {
        if (next.hasMutationSuccess) {
          AppToast.success(
            next.mutationMessage ?? context.l10n.locationDeleted,
          );
          context.pop();
        } else if (next.hasMutationError) {
          this.logError('Delete error', next.mutationFailure);
          AppToast.error(
            next.mutationFailure?.message ?? context.l10n.locationDeleteFailed,
          );
        }
      }
    });

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(
        title: location?.locationName ?? context.l10n.locationDetail,
      ),
      endDrawer: const AppEndDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: _buildBody(
        location: location,
        isLoading: isLoading,
        isAdmin: isAdmin,
        errorMessage: errorMessage,
      ),
    );
  }

  Widget _buildBody({
    required Location? location,
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
              text: context.l10n.locationCancel,
              onPressed: () => context.pop(),
            ),
          ],
        ),
      );
    }

    return Skeletonizer(
      enabled: isLoading || location == null,
      child: Column(
        children: [
          Expanded(
            child: ScreenWrapper(
              child: isLoading || location == null
                  ? _buildLoadingContent()
                  : _buildContent(location),
            ),
          ),
          if (!isLoading && location != null && isAdmin)
            AppDetailActionButtons(
              onEdit: () => _handleEdit(location),
              onDelete: () => _handleDelete(location),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    final dummyLocation = Location.dummy();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(context.l10n.locationInformation, [
            _buildInfoRow(
              context.l10n.locationCode,
              dummyLocation.locationCode,
            ),
            _buildInfoRow(
              context.l10n.locationName,
              dummyLocation.locationName,
            ),
            if (dummyLocation.building != null)
              _buildInfoRow(
                context.l10n.locationBuilding,
                dummyLocation.building!,
              ),
            if (dummyLocation.floor != null)
              _buildInfoRow(context.l10n.locationFloor, dummyLocation.floor!),
            if (dummyLocation.latitude != null)
              _buildInfoRow(
                context.l10n.locationLatitude,
                dummyLocation.latitude!.toString(),
              ),
            if (dummyLocation.longitude != null)
              _buildInfoRow(
                context.l10n.locationLongitude,
                dummyLocation.longitude!.toString(),
              ),
          ]),
        ],
      ),
    );
  }

  Widget _buildContent(Location location) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (location.latitude != null && location.longitude != null)
            _buildMapCard(location),
          if (location.latitude != null && location.longitude != null)
            const SizedBox(height: 16),
          _buildInfoCard(context.l10n.locationInformation, [
            _buildInfoRow(context.l10n.locationCode, location.locationCode),
            _buildInfoRow(context.l10n.locationName, location.locationName),
            if (location.building != null)
              _buildInfoRow(context.l10n.locationBuilding, location.building!),
            if (location.floor != null)
              _buildInfoRow(context.l10n.locationFloor, location.floor!),
            if (location.latitude != null)
              _buildInfoRow(
                context.l10n.locationLatitude,
                location.latitude!.toString(),
              ),
            if (location.longitude != null)
              _buildInfoRow(
                context.l10n.locationLongitude,
                location.longitude!.toString(),
              ),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard(context.l10n.locationMetadata, [
            _buildInfoRow(
              context.l10n.locationCreatedAt,
              _formatDateTime(location.createdAt),
            ),
            _buildInfoRow(
              context.l10n.locationUpdatedAt,
              _formatDateTime(location.updatedAt),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildMapCard(Location location) {
    return Card(
      color: context.colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 300,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(location.latitude!, location.longitude!),
            zoom: 16,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('location'),
              position: LatLng(location.latitude!, location.longitude!),
              infoWindow: InfoWindow(
                title: location.locationName,
                snippet: location.locationCode,
              ),
            ),
          },
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
        ),
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
