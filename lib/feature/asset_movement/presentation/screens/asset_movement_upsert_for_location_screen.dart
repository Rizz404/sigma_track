import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/enums/language_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/create_asset_movement_for_location_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/update_asset_movement_for_location_usecase.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/asset_movement_providers.dart';
import 'package:sigma_track/feature/asset_movement/presentation/providers/state/asset_movements_state.dart';
import 'package:sigma_track/feature/asset_movement/presentation/validators/asset_movement_upsert_for_location_validator.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/presentation/providers/location_providers.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_date_time_picker.dart';
import 'package:sigma_track/shared/presentation/widgets/app_loader_overlay.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Todo: Asset utama belum berubah setelah movement di backend
class AssetMovementUpsertForLocationScreen extends ConsumerStatefulWidget {
  final AssetMovement? assetMovement;
  final String? assetMovementId;

  const AssetMovementUpsertForLocationScreen({
    super.key,
    this.assetMovement,
    this.assetMovementId,
  });

  @override
  ConsumerState<AssetMovementUpsertForLocationScreen> createState() =>
      _AssetMovementUpsertForLocationScreenState();
}

class _AssetMovementUpsertForLocationScreenState
    extends ConsumerState<AssetMovementUpsertForLocationScreen> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;
  bool get _isEdit =>
      widget.assetMovement != null || widget.assetMovementId != null;
  AssetMovement? _fetchedAssetMovement;
  bool _isLoadingTranslations = false;

  Future<List<Asset>> _searchAssets(String query) async {
    final notifier = ref.read(assetsSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(assetsSearchProvider);
    return state.assets;
  }

  Future<List<Location>> _searchLocations(String query) async {
    final notifier = ref.read(locationsSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(locationsSearchProvider);
    return state.locations;
  }

  Future<List<User>> _searchUsers(String query) async {
    final notifier = ref.read(usersSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(usersSearchProvider);
    return state.users;
  }

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() != true) {
      AppToast.warning('Please fill all required fields');
      return;
    }

    final formData = _formKey.currentState!.value;

    final translations = <dynamic>[];
    for (final langCode in Language.values.map((e) => e.backendCode)) {
      final notes = formData['${langCode}_notes'] as String?;

      if (notes != null && notes.isNotEmpty) {
        if (_isEdit) {
          translations.add(
            UpdateAssetMovementForLocationTranslation(
              langCode: langCode,
              notes: notes,
            ),
          );
        } else {
          translations.add(
            CreateAssetMovementForLocationTranslation(
              langCode: langCode,
              notes: notes,
            ),
          );
        }
      }
    }

    final assetId = formData['assetId'] as String;
    final toLocationId = formData['toLocationId'] as String;
    final movedById = formData['movedById'] as String;
    final movementDate = formData['movementDate'] as DateTime;

    if (_isEdit) {
      final assetMovementId =
          _fetchedAssetMovement?.id ?? widget.assetMovement!.id;
      final params = UpdateAssetMovementForLocationUsecaseParams.fromChanges(
        id: assetMovementId,
        original: _fetchedAssetMovement ?? widget.assetMovement!,
        assetId: assetId,
        toLocationId: toLocationId,
        movedById: movedById,
        movementDate: movementDate,
        translations: translations
            .cast<UpdateAssetMovementForLocationTranslation>(),
      );
      ref
          .read(assetMovementsProvider.notifier)
          .updateAssetMovementForLocation(params);
    } else {
      final params = CreateAssetMovementForLocationUsecaseParams(
        assetId: assetId,
        toLocationId: toLocationId,
        movedById: movedById,
        movementDate: movementDate,
        translations: translations
            .cast<CreateAssetMovementForLocationTranslation>(),
      );
      ref
          .read(assetMovementsProvider.notifier)
          .createAssetMovementForLocation(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Watch asset movement by id provider only when showing translations in edit mode
    if (_isEdit && widget.assetMovement?.id != null) {
      final assetMovementDetailState = ref.watch(
        getAssetMovementByIdProvider(widget.assetMovement!.id),
      );

      // ? Update fetched assetMovement when data changes
      if (assetMovementDetailState.isLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _fetchedAssetMovement = assetMovementDetailState.assetMovement;
            });
          }
        });
      } else if (assetMovementDetailState.assetMovement != null) {
        if (_fetchedAssetMovement?.id !=
            assetMovementDetailState.assetMovement!.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _fetchedAssetMovement = assetMovementDetailState.assetMovement;
                _isLoadingTranslations = false;
                // ! Recreate form key to rebuild form with new data
                _formKey = GlobalKey<FormBuilderState>();
              });
            }
          });
        }
      } else if (assetMovementDetailState.failure != null &&
          _isLoadingTranslations) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _isLoadingTranslations = false);
            AppToast.error(
              assetMovementDetailState.failure?.message ??
                  'Failed to load translations',
            );
          }
        });
      }
    }

    // * Listen to mutation state
    ref.listen<AssetMovementsState>(assetMovementsProvider, (previous, next) {
      if (next.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      if (!next.isMutating && next.message != null && next.failure == null) {
        AppToast.success(next.message ?? 'Asset movement saved successfully');
        context.pop();
      } else if (next.failure != null) {
        if (next.failure is ValidationFailure) {
          setState(
            () => validationErrors = (next.failure as ValidationFailure).errors,
          );
        } else {
          this.logError('Asset movement mutation error', next.failure);
          AppToast.error(next.failure?.message ?? 'Operation failed');
        }
      }
    });

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(
          title: _isEdit
              ? 'Edit Asset Movement to Location'
              : 'Create Asset Movement to Location',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAssetMovementInfoSection(),
                        const SizedBox(height: 24),
                        _buildTranslationsSection(),
                        const SizedBox(height: 24),
                        AppValidationErrors(errors: validationErrors),
                        if (validationErrors != null &&
                            validationErrors!.isNotEmpty)
                          const SizedBox(height: 16),
                        const SizedBox(height: 80),
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

  Widget _buildAssetMovementInfoSection() {
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
              'Asset Movement Information',
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppSearchField<Asset>(
              name: 'assetId',
              label: 'Asset',
              hintText: 'Search and select asset',
              initialValue: widget.assetMovement?.assetId,
              enableAutocomplete: true,
              onSearch: _searchAssets,
              itemDisplayMapper: (asset) => asset.assetTag,
              itemValueMapper: (asset) => asset.id,
              itemSubtitleMapper: (asset) => asset.assetName,
              itemIcon: Icons.inventory,
              validator: (value) =>
                  AssetMovementUpsertForLocationValidator.validateAssetId(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppSearchField<Location>(
              name: 'toLocationId',
              label: 'To Location',
              hintText: 'Search and select to location',
              initialValue: widget.assetMovement?.toLocationId,
              enableAutocomplete: true,
              onSearch: _searchLocations,
              itemDisplayMapper: (location) => location.locationName,
              itemValueMapper: (location) => location.id,
              itemSubtitleMapper: (location) => location.locationCode,
              itemIcon: Icons.location_on,
              validator: (value) =>
                  AssetMovementUpsertForLocationValidator.validateToLocationId(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppSearchField<User>(
              name: 'movedById',
              label: 'Moved By',
              hintText: 'Search and select user who moved the asset',
              initialValue: widget.assetMovement?.movedById,
              enableAutocomplete: true,
              onSearch: _searchUsers,
              itemDisplayMapper: (user) => user.name,
              itemValueMapper: (user) => user.id,
              itemSubtitleMapper: (user) => user.email,
              itemIcon: Icons.person,
              validator: (value) =>
                  AssetMovementUpsertForLocationValidator.validateMovedById(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppDateTimePicker(
              name: 'movementDate',
              label: 'Movement Date',
              initialValue: widget.assetMovement?.movementDate,
              validator: (value) =>
                  AssetMovementUpsertForLocationValidator.validateMovementDate(
                    value,
                    isUpdate: _isEdit,
                  ),
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
              const SizedBox(height: 16),
              _buildTranslationFields('en-US', 'English'),
              const SizedBox(height: 12),
              _buildTranslationFields('ja-JP', 'Japanese'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTranslationFields(String langCode, String langName) {
    // * Use fetched asset movement translations in edit mode
    final assetMovementData = _isEdit
        ? _fetchedAssetMovement
        : widget.assetMovement;
    final translation = assetMovementData?.translations?.firstWhere(
      (t) => t.langCode == langCode,
      orElse: () => AssetMovementTranslation(langCode: langCode, notes: ''),
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
            style: AppTextStyle.bodyMedium,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          AppTextField(
            name: '${langCode}_notes',
            label: 'Notes',
            placeHolder: 'Enter notes in $langName',
            initialValue: translation?.notes,
            type: AppTextFieldType.multiline,
            validator: (value) =>
                AssetMovementUpsertForLocationValidator.validateNotes(
                  value,
                  isUpdate: _isEdit,
                ),
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
        border: Border(top: BorderSide(color: context.colors.border)),
      ),
      child: SafeArea(
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
