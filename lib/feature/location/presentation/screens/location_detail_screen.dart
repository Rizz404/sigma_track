import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
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
  Location? _location;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _location = widget.location;
    if (_location == null &&
        (widget.id != null || widget.locationCode != null)) {
      _fetchLocation();
    }
  }

  Future<void> _fetchLocation() async {
    setState(() => _isLoading = true);

    try {
      if (widget.id != null) {
        // * Watch provider (build method akan fetch otomatis)
        final state = ref.read(getLocationByIdProvider(widget.id!));

        if (state.location != null) {
          setState(() {
            _location = state.location;
            _isLoading = false;
          });
        } else if (state.failure != null) {
          this.logError('Failed to fetch location by id', state.failure);
          AppToast.error(state.failure?.message ?? 'Failed to load location');
          setState(() => _isLoading = false);
        } else {
          // * State masih loading, tunggu dengan listen
          setState(() => _isLoading = false);
        }
      } else if (widget.locationCode != null) {
        // * Watch provider (build method akan fetch otomatis)
        final state = ref.read(getLocationByCodeProvider(widget.locationCode!));

        if (state.location != null) {
          setState(() {
            _location = state.location;
            _isLoading = false;
          });
        } else if (state.failure != null) {
          this.logError('Failed to fetch location by code', state.failure);
          AppToast.error(state.failure?.message ?? 'Failed to load location');
          setState(() => _isLoading = false);
        } else {
          // * State masih loading, tunggu dengan listen
          setState(() => _isLoading = false);
        }
      }
    } catch (e, s) {
      this.logError('Error fetching location', e, s);
      AppToast.error('Failed to load location');
      setState(() => _isLoading = false);
    }
  }

  void _handleEdit() {
    if (_location == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (isAdmin) {
      context.push(RouteConstant.adminLocationUpsert, extra: _location);
    } else {
      AppToast.warning('Only admin can edit locations');
    }
  }

  void _handleDelete() async {
    if (_location == null) return;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    if (!isAdmin) {
      AppToast.warning('Only admin can delete locations');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(
          'Delete Location',
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          'Are you sure you want to delete "${_location!.locationName}"?',
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
          .read(locationsProvider.notifier)
          .deleteLocation(DeleteLocationUsecaseParams(id: _location!.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LocationsState>(locationsProvider, (previous, next) {
      if (!next.isMutating && next.message != null && next.failure == null) {
        AppToast.success(next.message ?? 'Operation successful');
        if (previous?.isMutating == true) {
          context.pop();
        }
      } else if (next.failure != null) {
        this.logError('Location mutation error', next.failure);
        AppToast.error(next.failure?.message ?? 'Operation failed');
      }
    });

    final isLoading = _isLoading || _location == null;

    final authState = ref.read(authNotifierProvider).valueOrNull;
    final isAdmin = authState?.user?.role == UserRole.admin;

    return Scaffold(
      appBar: CustomAppBar(
        title: isLoading ? 'Location Detail' : _location!.locationName,
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
    final dummyLocation = Location.dummy();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Location Information', [
            _buildInfoRow('Location Code', dummyLocation.locationCode),
            _buildInfoRow('Location Name', dummyLocation.locationName),
            if (dummyLocation.building != null)
              _buildInfoRow('Building', dummyLocation.building!),
            if (dummyLocation.floor != null)
              _buildInfoRow('Floor', dummyLocation.floor!),
            if (dummyLocation.latitude != null)
              _buildInfoRow('Latitude', dummyLocation.latitude!.toString()),
            if (dummyLocation.longitude != null)
              _buildInfoRow('Longitude', dummyLocation.longitude!.toString()),
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
          _buildInfoCard('Location Information', [
            _buildInfoRow('Location Code', _location!.locationCode),
            _buildInfoRow('Location Name', _location!.locationName),
            if (_location!.building != null)
              _buildInfoRow('Building', _location!.building!),
            if (_location!.floor != null)
              _buildInfoRow('Floor', _location!.floor!),
            if (_location!.latitude != null)
              _buildInfoRow('Latitude', _location!.latitude!.toString()),
            if (_location!.longitude != null)
              _buildInfoRow('Longitude', _location!.longitude!.toString()),
          ]),
          const SizedBox(height: 16),
          _buildInfoCard('Metadata', [
            _buildInfoRow('Created At', _formatDateTime(_location!.createdAt)),
            _buildInfoRow('Updated At', _formatDateTime(_location!.updatedAt)),
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
