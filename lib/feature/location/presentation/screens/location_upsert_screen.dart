import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sigma_track/core/domain/failure.dart';
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

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() != true) {
      AppToast.warning('Please fill all required fields');
      return;
    }

    final formData = _formKey.currentState!.value;

    final translations = <dynamic>[];
    for (final langCode in ['en', 'id', 'ja']) {
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
      final params = UpdateLocationUsecaseParams(
        id: widget.location!.id,
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
                  'Failed to load translations',
            );
          }
        });
      }
    }

    // * Listen to mutation state
    ref.listen<LocationsState>(locationsProvider, (previous, next) {
      if (next.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      if (!next.isMutating && next.message != null && next.failure == null) {
        AppToast.success(next.message ?? 'Location saved successfully');
        context.pop();
      } else if (next.failure != null) {
        if (next.failure is ValidationFailure) {
          setState(
            () => validationErrors = (next.failure as ValidationFailure).errors,
          );
        } else {
          this.logError('Location mutation error', next.failure);
          AppToast.error(next.failure?.message ?? 'Operation failed');
        }
      }
    });

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(
          title: _isEdit ? 'Edit Location' : 'Create Location',
        ),
        endDrawer: const AppEndDrawer(),
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
            const AppText(
              'Location Information',
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'locationCode',
              label: 'Location Code',
              placeHolder: 'Enter location code (e.g., LOC-001)',
              initialValue: widget.location?.locationCode,
              validator: LocationUpsertValidator.validateLocationCode,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'building',
              label: 'Building (Optional)',
              placeHolder: 'Enter building name',
              initialValue: widget.location?.building,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'floor',
              label: 'Floor (Optional)',
              placeHolder: 'Enter floor number',
              initialValue: widget.location?.floor,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'latitude',
              label: 'Latitude (Optional)',
              placeHolder: 'Enter latitude',
              initialValue: widget.location?.latitude?.toString(),
              validator: LocationUpsertValidator.validateLatitude,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'longitude',
              label: 'Longitude (Optional)',
              placeHolder: 'Enter longitude',
              initialValue: widget.location?.longitude?.toString(),
              validator: LocationUpsertValidator.validateLongitude,
            ),
          ],
        ),
      ),
    );
  }

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
              const AppText(
                'Translations',
                style: AppTextStyle.titleMedium,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 8),
              AppText(
                'Add translations for different languages',
                style: AppTextStyle.bodySmall,
                color: context.colors.textSecondary,
              ),
              const SizedBox(height: 16),
              _buildTranslationFields('en', 'English'),
              const SizedBox(height: 16),
              _buildTranslationFields('id', 'Indonesian'),
              const SizedBox(height: 16),
              _buildTranslationFields('ja', 'Japanese'),
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
        color: context.colors.surfaceVariant.withOpacity(0.3),
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
            label: 'Location Name',
            placeHolder: 'Enter location name',
            initialValue: translation?.locationName,
            validator: langCode == 'en'
                ? LocationUpsertValidator.validateLocationName
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
            color: Colors.black.withOpacity(0.05),
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
                text: 'Cancel',
                variant: AppButtonVariant.outlined,
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                text: _isEdit ? 'Update' : 'Create',
                onPressed: _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
