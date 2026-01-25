import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/enums/language_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
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
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_date_time_picker.dart';
import 'package:sigma_track/shared/presentation/widgets/app_loader_overlay.dart';
import 'package:sigma_track/shared/presentation/widgets/app_searchable_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

// Todo: Asset utama belum berubah setelah movement di backend
class AssetMovementUpsertForLocationScreen extends ConsumerStatefulWidget {
  final AssetMovement? assetMovement;
  final String? assetMovementId;
  final Asset? prePopulatedAsset;
  final AssetMovement? copyFromMovement;

  const AssetMovementUpsertForLocationScreen({
    super.key,
    this.assetMovement,
    this.assetMovementId,
    this.prePopulatedAsset,
    this.copyFromMovement,
  });

  @override
  ConsumerState<AssetMovementUpsertForLocationScreen> createState() =>
      _AssetMovementUpsertForLocationScreenState();
}

class _AssetMovementUpsertForLocationScreenState
    extends ConsumerState<AssetMovementUpsertForLocationScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;
  bool get _isEdit =>
      widget.assetMovement != null || widget.assetMovementId != null;
  bool get _isCopyMode => widget.copyFromMovement != null;
  bool get _hasPrePopulatedAsset => widget.prePopulatedAsset != null;
  // * Helper to get source movement for initialization (copy or edit)
  AssetMovement? get _sourceMovement =>
      widget.copyFromMovement ?? widget.assetMovement;

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() != true) {
      AppToast.warning(context.l10n.assetMovementFillRequiredFields);
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

    if (_isEdit) {
      // * EDIT MODE: Hanya kirim id dan translations
      final assetMovementId = widget.assetMovement!.id;
      final params = UpdateAssetMovementForLocationUsecaseParams.fromChanges(
        id: assetMovementId,
        original: widget.assetMovement!,
        translations: translations
            .cast<UpdateAssetMovementForLocationTranslation>(),
      );
      ref
          .read(assetMovementsProvider.notifier)
          .updateAssetMovementForLocation(params);
    } else {
      // * CREATE MODE: Kirim semua field
      final assetId = formData['assetId'] as String;
      final fromLocationId = formData['fromLocationId'] as String?;
      final toLocationId = formData['toLocationId'] as String;
      final movementDate = formData['movementDate'] as DateTime;

      // * Get current user ID from provider
      final currentUserState = ref.read(currentUserNotifierProvider);
      final movedById = currentUserState.user?.id ?? '';

      // * Pastikan movedById tidak kosong
      if (movedById.isEmpty) {
        AppToast.warning('Moved by user tidak ditemukan');
        return;
      }

      final params = CreateAssetMovementForLocationUsecaseParams(
        assetId: assetId,
        fromLocationId: fromLocationId,
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
    // * Watch current user provider to ensure data is loaded for 'movedBy'
    ref.watch(currentUserNotifierProvider);

    // * Listen to mutation state
    ref.listen<AssetMovementsState>(assetMovementsProvider, (previous, next) {
      // * Handle loading state
      if (next.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(
          next.mutationMessage ?? context.l10n.assetMovementSavedSuccessfully,
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
          this.logError('Asset movement mutation error', next.mutationFailure);
          AppToast.error(
            next.mutationFailure?.message ??
                context.l10n.assetMovementOperationFailed,
          );
        }
      }
    });

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(
          title: _isEdit
              ? context.l10n.assetMovementEditAssetMovement
              : context.l10n.assetMovementCreateAssetMovement,
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
            AppText(
              context.l10n.assetMovementInformation,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            // * Info message saat edit mode
            if (_isEdit) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.semantic.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.semantic.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: context.semantic.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppText(
                        'Asset movement information cannot be edited as it is historical data. Only notes can be updated.',
                        style: AppTextStyle.bodySmall,
                        color: context.semantic.warning,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            Builder(
              builder: (context) {
                final assetsState = ref.watch(assetsSearchDropdownProvider);
                final assetMovementData = widget.assetMovement;

                return AppSearchableDropdown<Asset>(
                  name: 'assetId',
                  label: context.l10n.assetMovementAsset,
                  hintText: context.l10n.assetMovementSearchAsset,
                  initialValue: _hasPrePopulatedAsset
                      ? widget.prePopulatedAsset
                      : assetMovementData?.asset,
                  items: assetsState.assets,
                  isLoading: assetsState.isLoading,
                  enabled: !_isEdit, // * Disable saat edit
                  onSearch: (query) {
                    ref
                        .read(assetsSearchDropdownProvider.notifier)
                        .search(query);
                  },
                  onLoadMore: () {
                    ref.read(assetsSearchDropdownProvider.notifier).loadMore();
                  },
                  hasMore: assetsState.cursor?.hasNextPage ?? false,
                  isLoadingMore: assetsState.isLoadingMore,
                  itemDisplayMapper: (asset) => asset.assetTag,
                  itemValueMapper: (asset) => asset.id,
                  itemSubtitleMapper: (asset) => asset.assetName,
                  itemIconMapper: (asset) => Icons.inventory,
                  validator: (value) =>
                      AssetMovementUpsertForLocationValidator.validateAssetId(
                        context,
                        value,
                        isUpdate: _isEdit,
                      ),
                );
              },
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (context) {
                final locationsState = ref.watch(
                  locationsSearchDropdownProvider,
                );
                final assetMovementData = widget.assetMovement;

                return AppSearchableDropdown<Location>(
                  name: 'fromLocationId',
                  label: context.l10n.assetMovementFromLocation,
                  hintText: context.l10n.assetMovementSearchFromLocation,
                  initialValue: assetMovementData?.fromLocation,
                  items: locationsState.locations,
                  isLoading: locationsState.isLoading,
                  enabled: !_isEdit, // * Disable saat edit
                  onSearch: (query) {
                    ref
                        .read(locationsSearchDropdownProvider.notifier)
                        .search(query);
                  },
                  onLoadMore: () {
                    ref
                        .read(locationsSearchDropdownProvider.notifier)
                        .loadMore();
                  },
                  hasMore: locationsState.cursor?.hasNextPage ?? false,
                  isLoadingMore: locationsState.isLoadingMore,
                  itemDisplayMapper: (location) => location.locationName,
                  itemValueMapper: (location) => location.id,
                  itemSubtitleMapper: (location) => location.locationCode,
                  itemIconMapper: (location) => Icons.location_on,
                  validator: (value) =>
                      AssetMovementUpsertForLocationValidator.validateFromLocationId(
                        context,
                        value,
                        isUpdate: _isEdit,
                      ),
                );
              },
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (context) {
                final locationsState = ref.watch(
                  locationsSearchDropdownProvider,
                );
                final assetMovementData = widget.assetMovement;

                return AppSearchableDropdown<Location>(
                  name: 'toLocationId',
                  label: context.l10n.assetMovementToLocation,
                  hintText: context.l10n.assetMovementSearchToLocation,
                  initialValue: assetMovementData?.toLocation,
                  items: locationsState.locations,
                  isLoading: locationsState.isLoading,
                  enabled: !_isEdit, // * Disable saat edit
                  onSearch: (query) {
                    ref
                        .read(locationsSearchDropdownProvider.notifier)
                        .search(query);
                  },
                  onLoadMore: () {
                    ref
                        .read(locationsSearchDropdownProvider.notifier)
                        .loadMore();
                  },
                  hasMore: locationsState.cursor?.hasNextPage ?? false,
                  isLoadingMore: locationsState.isLoadingMore,
                  itemDisplayMapper: (location) => location.locationName,
                  itemValueMapper: (location) => location.id,
                  itemSubtitleMapper: (location) => location.locationCode,
                  itemIconMapper: (location) => Icons.location_on,
                  validator: (value) =>
                      AssetMovementUpsertForLocationValidator.validateToLocationId(
                        context,
                        value,
                        isUpdate: _isEdit,
                      ),
                );
              },
            ),
            const SizedBox(height: 16),
            AppDateTimePicker(
              name: 'movementDate',
              label: context.l10n.assetMovementMovementDate,
              initialValue: _sourceMovement?.movementDate,
              enabled: !_isEdit, // * Disable saat edit
              validator: (value) =>
                  AssetMovementUpsertForLocationValidator.validateMovementDate(
                    context,
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
              context.l10n.assetMovementTranslations,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            _buildTranslationFields('en-US', context.l10n.appEndDrawerEnglish),
            const SizedBox(height: 12),
            _buildTranslationFields('ja-JP', context.l10n.appEndDrawerJapanese),
            const SizedBox(height: 12),
            _buildTranslationFields(
              'id-ID',
              context.l10n.appEndDrawerIndonesian,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationFields(String langCode, String langName) {
    // * Use fetched asset movement translations in edit mode, or source in copy
    // * Use fetched asset movement translations in edit mode, or source in copy
    final assetMovementData = _sourceMovement;
    final translation = assetMovementData?.translations?.firstWhere(
      (t) => t.langCode == langCode,
      orElse: () => AssetMovementTranslation(langCode: langCode, notes: ''),
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
            style: AppTextStyle.bodyMedium,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          AppTextField(
            name: '${langCode}_notes',
            label: context.l10n.assetMovementNotes,
            placeHolder: context.l10n.assetMovementEnterNotes,
            initialValue: translation?.notes,
            type: AppTextFieldType.multiline,
            validator: (value) =>
                AssetMovementUpsertForLocationValidator.validateNotes(
                  context,
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
                text: context.l10n.assetMovementCancel,
                variant: AppButtonVariant.outlined,
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                text: _isEdit
                    ? context.l10n.assetMovementUpdate
                    : context.l10n.assetMovementCreate,
                onPressed: _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
