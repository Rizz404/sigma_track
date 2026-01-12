import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
// TODO: Google Maps feature disabled temporarily
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/enums/language_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/domain/usecases/create_location_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/update_location_usecase.dart';
import 'package:sigma_track/feature/location/presentation/providers/location_providers.dart';
import 'package:sigma_track/feature/location/presentation/providers/state/locations_state.dart';
import 'package:sigma_track/feature/location/presentation/validators/location_upsert_validator.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_loader_overlay.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';
// TODO: Google Maps feature disabled temporarily
// import 'map_picker_screen.dart';

class LocationUpsertScreen extends ConsumerStatefulWidget {
  final Location? location;
  final String? locationId;

  const LocationUpsertScreen({super.key, this.location, this.locationId});

  @override
  ConsumerState<LocationUpsertScreen> createState() =>
      _LocationUpsertScreenState();
}

class _LocationUpsertScreenState extends ConsumerState<LocationUpsertScreen> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;
  bool get _isEdit => widget.location != null || widget.locationId != null;
  Location? _fetchedLocation;
  bool _isLoadingTranslations = false;
  bool _isLoadingCurrentLocation = false;

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingCurrentLocation = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          AppToast.warning(context.l10n.locationServicesDisabled);
          final openSettings = await _showLocationServiceDialog();
          if (openSettings) {
            await Geolocator.openLocationSettings();
          }
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            AppToast.error(context.l10n.locationPermissionDenied);
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          AppToast.error(context.l10n.locationPermissionPermanentlyDenied);
          final openSettings = await _showPermissionDeniedDialog();
          if (openSettings) {
            await Geolocator.openAppSettings();
          }
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (mounted) {
        _formKey.currentState?.fields['latitude']?.didChange(
          position.latitude.toString(),
        );
        _formKey.currentState?.fields['longitude']?.didChange(
          position.longitude.toString(),
        );
        AppToast.success(context.l10n.locationRetrievedSuccessfully);
        this.logInfo('Location: ${position.latitude}, ${position.longitude}');
      }
    } catch (e, s) {
      this.logError('Failed to get current location', e, s);
      if (mounted) {
        AppToast.error(context.l10n.locationFailedToGetCurrent);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingCurrentLocation = false);
      }
    }
  }

  Future<bool> _showLocationServiceDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: AppText(context.l10n.locationServicesDialogTitle),
            content: AppText(context.l10n.locationServicesDialogMessage),
            actions: [
              AppButton(
                text: context.l10n.locationCancel,
                variant: AppButtonVariant.text,
                onPressed: () => context.pop(false),
              ),
              AppButton(
                text: context.l10n.locationOpenSettings,
                onPressed: () => context.pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _showPermissionDeniedDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: AppText(context.l10n.locationPermissionRequired),
            content: AppText(context.l10n.locationPermissionDialogMessage),
            actions: [
              AppButton(
                text: context.l10n.locationCancel,
                variant: AppButtonVariant.text,
                onPressed: () => context.pop(false),
              ),
              AppButton(
                text: context.l10n.locationOpenSettings,
                onPressed: () => context.pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }

  // TODO: Google Maps feature disabled temporarily
  // Future<void> _pickFromMap() async {
  //   final latitude = _formKey.currentState?.fields['latitude']?.value;
  //   final longitude = _formKey.currentState?.fields['longitude']?.value;

  //   final double? lat = latitude != null ? double.tryParse(latitude) : null;
  //   final double? lng = longitude != null ? double.tryParse(longitude) : null;

  //   final LatLng? result = await Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) =>
  //           MapPickerScreen(initialLatitude: lat, initialLongitude: lng),
  //     ),
  //   );

  //   if (result != null && mounted) {
  //     _formKey.currentState?.fields['latitude']?.didChange(
  //       result.latitude.toString(),
  //     );
  //     _formKey.currentState?.fields['longitude']?.didChange(
  //       result.longitude.toString(),
  //     );
  //     AppToast.success(context.l10n.locationSelectedFromMap);
  //   }
  // }

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() != true) {
      AppToast.warning(context.l10n.locationFillRequiredFields);
      return;
    }

    final formData = _formKey.currentState!.value;

    final translations = <dynamic>[];
    for (final langCode in Language.values.map((e) => e.backendCode)) {
      final locationName = formData['${langCode}_locationName'] as String?;

      if (locationName != null && locationName.isNotEmpty) {
        if (_isEdit) {
          translations.add(
            UpdateLocationTranslation(
              langCode: langCode,
              locationName: locationName,
            ),
          );
        } else {
          translations.add(
            CreateLocationTranslation(
              langCode: langCode,
              locationName: locationName,
            ),
          );
        }
      }
    }

    final locationCode = formData['locationCode'] as String;
    final building = formData['building'] as String?;
    final floor = formData['floor'] as String?;
    final latitude = formData['latitude'] as String?;
    final longitude = formData['longitude'] as String?;

    if (_isEdit) {
      final params = UpdateLocationUsecaseParams.fromChanges(
        id: widget.location!.id,
        original: _fetchedLocation ?? widget.location!,
        locationCode: locationCode,
        building: building,
        floor: floor,
        latitude: latitude != null ? double.tryParse(latitude) : null,
        longitude: longitude != null ? double.tryParse(longitude) : null,
        translations: translations.cast<UpdateLocationTranslation>(),
      );
      ref.read(locationsProvider.notifier).updateLocation(params);
    } else {
      final params = CreateLocationUsecaseParams(
        locationCode: locationCode,
        building: building,
        floor: floor,
        latitude: latitude != null ? double.tryParse(latitude) : null,
        longitude: longitude != null ? double.tryParse(longitude) : null,
        translations: translations.cast<CreateLocationTranslation>(),
      );
      ref.read(locationsProvider.notifier).createLocation(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Auto load translations in edit mode
    if (_isEdit && widget.location?.id != null) {
      final locationDetailState = ref.watch(
        getLocationByIdProvider(widget.location!.id),
      );

      // ? Update fetched location when data changes
      if (locationDetailState.isLoading) {
        if (!_isLoadingTranslations) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _isLoadingTranslations = true);
            }
          });
        }
      } else if (locationDetailState.location != null) {
        if (_fetchedLocation?.id != locationDetailState.location!.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _fetchedLocation = locationDetailState.location;
                _isLoadingTranslations = false;
                // ! Recreate form key to rebuild form with new data
                _formKey = GlobalKey<FormBuilderState>();
              });
            }
          });
        }
      } else if (locationDetailState.failure != null &&
          _isLoadingTranslations) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _isLoadingTranslations = false);
            AppToast.error(
              locationDetailState.failure?.message ??
                  context.l10n.locationFailedToLoadTranslations,
            );
          }
        });
      }
    }

    // * Listen to mutation state
    ref.listen<LocationsState>(locationsProvider, (previous, next) {
      // * Handle loading state
      if (next.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(
          next.mutationMessage ?? context.l10n.locationSavedSuccessfully,
        );
        context.pop();
      }

      // * Handle mutation error
      if (next.hasMutationError) {
        if (next.mutationFailure is ValidationFailure) {
          setState(
            () => validationErrors =
                (next.mutationFailure as ValidationFailure).errors,
          );
        } else {
          this.logError('Location mutation error', next.mutationFailure);
          AppToast.error(
            next.mutationFailure?.message ??
                context.l10n.locationOperationFailed,
          );
        }
      }
    });

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(
          title: _isEdit
              ? context.l10n.locationEditLocation
              : context.l10n.locationCreateLocation,
        ),
        endDrawer: const AppEndDrawer(),
        endDrawerEnableOpenDragGesture: false,
        body: Column(
          children: [
            Expanded(
              child: ScreenWrapper(
                child: FormBuilder(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildLocationInfoSection(),
                        const SizedBox(height: 24),
                        _buildTranslationsSection(),
                        const SizedBox(height: 24),
                        AppValidationErrors(errors: validationErrors),
                        if (validationErrors != null &&
                            validationErrors!.isNotEmpty)
                          const SizedBox(height: 16),
                        const SizedBox(
                          height: 80,
                        ), // * Space for sticky buttons
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildStickyActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfoSection() {
    final latitudeValue = _formKey.currentState?.fields['latitude']?.value;
    final longitudeValue = _formKey.currentState?.fields['longitude']?.value;
    final double? currentLat = latitudeValue != null && latitudeValue.isNotEmpty
        ? double.tryParse(latitudeValue)
        : null;
    final double? currentLng =
        longitudeValue != null && longitudeValue.isNotEmpty
        ? double.tryParse(longitudeValue)
        : null;

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
              context.l10n.locationInformation,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            // TODO: Google Maps feature disabled temporarily
            // if (currentLat != null && currentLng != null) ...[
            //   _buildMapPreview(currentLat, currentLng),
            //   const SizedBox(height: 16),
            // ],
            AppTextField(
              name: 'locationCode',
              label: context.l10n.locationCode,
              placeHolder: context.l10n.locationEnterLocationCode,
              initialValue: widget.location?.locationCode,
              validator: (value) =>
                  LocationUpsertValidator.validateLocationCode(
                    context,
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'building',
              label: context.l10n.locationBuildingOptional,
              placeHolder: context.l10n.locationEnterBuilding,
              initialValue: widget.location?.building,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'floor',
              label: context.l10n.locationFloorOptional,
              placeHolder: context.l10n.locationEnterFloor,
              initialValue: widget.location?.floor,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    name: 'latitude',
                    label: context.l10n.locationLatitudeOptional,
                    placeHolder: context.l10n.locationEnterLatitude,
                    initialValue: widget.location?.latitude?.toString(),
                    validator: (value) =>
                        LocationUpsertValidator.validateLatitude(
                          context,
                          value,
                          isUpdate: _isEdit,
                        ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    name: 'longitude',
                    label: context.l10n.locationLongitudeOptional,
                    placeHolder: context.l10n.locationEnterLongitude,
                    initialValue: widget.location?.longitude?.toString(),
                    validator: (value) =>
                        LocationUpsertValidator.validateLongitude(
                          context,
                          value,
                          isUpdate: _isEdit,
                        ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppButton(
              text: _isLoadingCurrentLocation
                  ? context.l10n.locationGettingLocation
                  : context.l10n.locationUseCurrentLocation,
              variant: AppButtonVariant.outlined,
              onPressed: _isLoadingCurrentLocation ? null : _getCurrentLocation,
              leadingIcon: _isLoadingCurrentLocation
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location, size: 18),
            ),
            const SizedBox(height: 12),
            // TODO: Google Maps feature disabled temporarily
            // AppButton(
            //   text: context.l10n.locationPickFromMap,
            //   variant: AppButtonVariant.outlined,
            //   onPressed: _pickFromMap,
            //   leadingIcon: const Icon(Icons.map, size: 18),
            // ),
          ],
        ),
      ),
    );
  }

  // TODO: Google Maps feature disabled temporarily
  // Widget _buildMapPreview(double latitude, double longitude) {
  //   return Container(
  //     height: 250,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: context.colors.border),
  //     ),
  //     clipBehavior: Clip.antiAlias,
  //     child: GoogleMap(
  //       initialCameraPosition: CameraPosition(
  //         target: LatLng(latitude, longitude),
  //         zoom: 16,
  //       ),
  //       markers: {
  //         Marker(
  //           markerId: const MarkerId('location'),
  //           position: LatLng(latitude, longitude),
  //         ),
  //       },
  //       zoomControlsEnabled: false,
  //       myLocationButtonEnabled: false,
  //       mapToolbarEnabled: false,
  //     ),
  //   );
  // }

  Widget _buildTranslationsSection() {
    return Skeletonizer(
      enabled: _isLoadingTranslations,
      child: Card(
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
                context.l10n.locationTranslations,
                style: AppTextStyle.titleMedium,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              AppText(
                context.l10n.locationTranslationsSubtitle,
                style: AppTextStyle.bodySmall,
                color: context.colors.textSecondary,
              ),
              const SizedBox(height: 16),
              _buildTranslationFields('en-US', context.l10n.locationEnglish),
              const SizedBox(height: 16),
              _buildTranslationFields('ja-JP', context.l10n.locationJapanese),
              const SizedBox(height: 16),
              _buildTranslationFields('id-ID', context.l10n.locationIndonesian),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTranslationFields(String langCode, String langName) {
    // * Use fetched location translations in edit mode
    final locationData = _isEdit ? _fetchedLocation : widget.location;
    final translation = locationData?.translations?.firstWhere(
      (t) => t.langCode == langCode,
      orElse: () => LocationTranslation(langCode: langCode, locationName: ''),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            langName,
            style: AppTextStyle.titleSmall,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          AppTextField(
            name: '${langCode}_locationName',
            label: context.l10n.locationName,
            placeHolder: context.l10n.locationEnterLocationName,
            initialValue: translation?.locationName,
            validator: langCode == 'en-US'
                ? (value) => LocationUpsertValidator.validateLocationName(
                    context,
                    value,
                    isUpdate: _isEdit,
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStickyActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: context.colors.divider,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                text: context.l10n.locationCancel,
                variant: AppButtonVariant.outlined,
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                text: _isEdit
                    ? context.l10n.locationUpdate
                    : context.l10n.locationCreate,
                onPressed: _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
