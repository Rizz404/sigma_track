import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/enums/language_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/create_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/update_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_record_providers.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_schedule_providers.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_records_state.dart';
import 'package:sigma_track/feature/maintenance/presentation/validators/maintenance_record_upsert_validator.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';

import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_date_time_picker.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_loader_overlay.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MaintenanceRecordUpsertScreen extends ConsumerStatefulWidget {
  final MaintenanceRecord? maintenanceRecord;
  final String? maintenanceRecordId;
  final Asset? prePopulatedAsset;

  const MaintenanceRecordUpsertScreen({
    super.key,
    this.maintenanceRecord,
    this.maintenanceRecordId,
    this.prePopulatedAsset,
  });

  @override
  ConsumerState<MaintenanceRecordUpsertScreen> createState() =>
      _MaintenanceRecordUpsertScreenState();
}

class _MaintenanceRecordUpsertScreenState
    extends ConsumerState<MaintenanceRecordUpsertScreen> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;
  bool get _isEdit =>
      widget.maintenanceRecord != null || widget.maintenanceRecordId != null;
  bool get _hasPrePopulatedAsset => widget.prePopulatedAsset != null;
  MaintenanceRecord? _fetchedMaintenanceRecord;
  bool _isLoadingTranslations = false;

  Future<List<Asset>> _searchAssets(String query) async {
    final notifier = ref.read(assetsSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(assetsSearchProvider);
    return state.assets;
  }

  Future<List<MaintenanceSchedule>> _searchMaintenanceSchedules(
    String query,
  ) async {
    final notifier = ref.read(maintenanceSchedulesSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(maintenanceSchedulesSearchProvider);
    return state.maintenanceSchedules;
  }

  // * OLD IMPLEMENTATION: Search users function
  // * Commented out but kept for future reference
  // Future<List<User>> _searchUsers(String query) async {
  //   final notifier = ref.read(usersSearchProvider.notifier);
  //   await notifier.search(query);
  //
  //   final state = ref.read(usersSearchProvider);
  //   return state.users;
  // }

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() != true) {
      AppToast.warning(context.l10n.maintenanceRecordFillRequiredFields);
      return;
    }

    final formData = _formKey.currentState!.value;

    final translations = <dynamic>[];
    for (final langCode in Language.values.map((e) => e.backendCode)) {
      final title = formData['${langCode}_title'] as String?;
      final notes = formData['${langCode}_notes'] as String?;

      if (title != null && title.isNotEmpty) {
        if (_isEdit) {
          translations.add(
            UpdateMaintenanceRecordTranslation(
              langCode: langCode,
              title: title,
              notes: notes,
            ),
          );
        } else {
          translations.add(
            CreateMaintenanceRecordTranslation(
              langCode: langCode,
              title: title,
              notes: notes,
            ),
          );
        }
      }
    }

    final scheduleId = formData['scheduleId'] as String;
    final assetId = formData['assetId'] as String;
    final maintenanceDate = formData['maintenanceDate'] as DateTime;
    final completionDate = formData['completionDate'] as DateTime?;
    final durationMinutes = formData['durationMinutes'] as String?;

    // * NEW IMPLEMENTATION: Get current user ID from provider
    final currentUserState = ref.read(currentUserNotifierProvider);
    final performedById = currentUserState.user?.id;

    final performedByVendor = formData['performedByVendor'] as String?;
    final result = formData['result'] as String?;
    final actualCost = formData['actualCost'] != null
        ? double.tryParse(formData['actualCost'] as String)
        : null;

    if (_isEdit) {
      final maintenanceRecordId =
          _fetchedMaintenanceRecord?.id ?? widget.maintenanceRecord!.id;
      final params = UpdateMaintenanceRecordUsecaseParams.fromChanges(
        id: maintenanceRecordId,
        original: _fetchedMaintenanceRecord ?? widget.maintenanceRecord!,
        scheduleId: scheduleId,
        assetId: assetId,
        maintenanceDate: maintenanceDate,
        completionDate: completionDate,
        durationMinutes: durationMinutes != null
            ? int.tryParse(durationMinutes)
            : null,
        performedByUserId: performedById,
        performedByVendor: performedByVendor,
        result: result != null
            ? MaintenanceResult.values.firstWhere((e) => e.value == result)
            : null,
        actualCost: actualCost,
        translations: translations.cast<UpdateMaintenanceRecordTranslation>(),
      );
      ref
          .read(maintenanceRecordsProvider.notifier)
          .updateMaintenanceRecord(params);
    } else {
      final params = CreateMaintenanceRecordUsecaseParams(
        scheduleId: scheduleId,
        assetId: assetId,
        maintenanceDate: maintenanceDate,
        completionDate: completionDate,
        durationMinutes: durationMinutes != null
            ? int.tryParse(durationMinutes)
            : null,
        performedByUserId: performedById,
        performedByVendor: performedByVendor,
        result: result != null
            ? MaintenanceResult.values.firstWhere((e) => e.value == result)
            : MaintenanceResult.success,
        actualCost: actualCost,
        translations: translations.cast<CreateMaintenanceRecordTranslation>(),
      );
      ref
          .read(maintenanceRecordsProvider.notifier)
          .createMaintenanceRecord(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Auto load translations in edit mode
    if (_isEdit && widget.maintenanceRecord?.id != null) {
      final maintenanceRecordDetailState = ref.watch(
        getMaintenanceRecordByIdProvider(widget.maintenanceRecord!.id),
      );

      // ? Update fetched maintenanceRecord when data changes
      if (maintenanceRecordDetailState.isLoading) {
        if (!_isLoadingTranslations) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _isLoadingTranslations = true);
            }
          });
        }
      } else if (maintenanceRecordDetailState.maintenanceRecord != null) {
        if (_fetchedMaintenanceRecord?.id !=
            maintenanceRecordDetailState.maintenanceRecord!.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _fetchedMaintenanceRecord =
                    maintenanceRecordDetailState.maintenanceRecord;
                _isLoadingTranslations = false;
                // ! Recreate form key to rebuild form with new data
                _formKey = GlobalKey<FormBuilderState>();
              });
            }
          });
        }
      } else if (maintenanceRecordDetailState.failure != null &&
          _isLoadingTranslations) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _isLoadingTranslations = false);
            AppToast.error(
              maintenanceRecordDetailState.failure?.message ??
                  context.l10n.maintenanceRecordFailedToLoadTranslations,
            );
          }
        });
      }
    }

    // * Listen to mutation state
    ref.listen<MaintenanceRecordsState>(maintenanceRecordsProvider, (
      previous,
      next,
    ) {
      // * Handle loading state
      if (next.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(
          next.mutationMessage ??
              context.l10n.maintenanceRecordSavedSuccessfully,
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
          this.logError(
            'Maintenance record mutation error',
            next.mutationFailure,
          );
          AppToast.error(
            next.mutationFailure?.message ??
                context.l10n.maintenanceRecordOperationFailed,
          );
        }
      }
    });

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(
          title: _isEdit
              ? context.l10n.maintenanceRecordEditRecord
              : context.l10n.maintenanceRecordCreateRecord,
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
                        _buildMaintenanceRecordInfoSection(),
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

  Widget _buildMaintenanceRecordInfoSection() {
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
              context.l10n.maintenanceRecordInformation,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppSearchField<MaintenanceSchedule>(
              name: 'scheduleId',
              label: context.l10n.maintenanceRecordSchedule,
              hintText: context.l10n.maintenanceRecordSearchSchedule,
              initialValue: widget.maintenanceRecord?.scheduleId,
              enableAutocomplete: true,
              onSearch: _searchMaintenanceSchedules,
              itemDisplayMapper: (schedule) => schedule.title,
              itemValueMapper: (schedule) => schedule.id,
              itemSubtitleMapper: (schedule) =>
                  schedule.asset?.assetName ??
                  context.l10n.maintenanceRecordUnknownAsset,
              itemIcon: Icons.schedule,
              validator: (value) =>
                  MaintenanceRecordUpsertValidator.validateScheduleId(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppSearchField<Asset>(
              name: 'assetId',
              label: context.l10n.maintenanceRecordAsset,
              hintText: context.l10n.maintenanceRecordSearchAsset,
              initialValue: _hasPrePopulatedAsset
                  ? widget.prePopulatedAsset!.id
                  : widget.maintenanceRecord?.assetId,
              initialDisplayText: _hasPrePopulatedAsset
                  ? widget.prePopulatedAsset!.assetTag
                  : null,
              enableAutocomplete: true,
              onSearch: _searchAssets,
              itemDisplayMapper: (asset) => asset.assetTag,
              itemValueMapper: (asset) => asset.id,
              itemSubtitleMapper: (asset) => asset.assetName,
              itemIcon: Icons.inventory,
              validator: (value) =>
                  MaintenanceRecordUpsertValidator.validateAssetId(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppDateTimePicker(
              name: 'maintenanceDate',
              label: context.l10n.maintenanceRecordMaintenanceDate,
              initialValue: widget.maintenanceRecord?.maintenanceDate,
              validator: (value) =>
                  MaintenanceRecordUpsertValidator.validateMaintenanceDate(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppDateTimePicker(
              name: 'completionDate',
              label: context.l10n.maintenanceRecordCompletionDateOptional,
              initialValue: widget.maintenanceRecord?.completionDate,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'durationMinutes',
              label: context.l10n.maintenanceRecordDurationMinutesLabel,
              placeHolder: context.l10n.maintenanceRecordEnterDuration,
              initialValue: widget.maintenanceRecord?.durationMinutes
                  ?.toString(),
              type: AppTextFieldType.number,
            ),
            const SizedBox(height: 16),
            // * OLD IMPLEMENTATION: User dropdown for performed by
            // * Commented out for future reference
            // AppSearchField<User>(
            //   name: 'performedById',
            //   label: context.l10n.maintenanceRecordPerformedByUser,
            //   hintText: context.l10n.maintenanceRecordSearchPerformedByUser,
            //   initialValue: widget.maintenanceRecord?.performedByUserId,
            //   enableAutocomplete: true,
            //   onSearch: _searchUsers,
            //   itemDisplayMapper: (user) => user.name,
            //   itemValueMapper: (user) => user.id,
            //   itemSubtitleMapper: (user) => user.email,
            //   itemIcon: Icons.person,
            // ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'performedByVendor',
              label: context.l10n.maintenanceRecordPerformedByVendorLabel,
              placeHolder: context.l10n.maintenanceRecordEnterVendor,
              initialValue: widget.maintenanceRecord?.performedByVendor,
              validator: (value) =>
                  MaintenanceRecordUpsertValidator.validatePerformedByVendor(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppDropdown(
              name: 'result',
              label: context.l10n.maintenanceRecordResult,
              hintText: context.l10n.maintenanceRecordSelectResult,
              items: MaintenanceResult.values
                  .map(
                    (result) => AppDropdownItem(
                      value: result.value,
                      label: result.label,
                      icon: Icon(result.icon, size: 18),
                    ),
                  )
                  .toList(),
              initialValue: widget.maintenanceRecord?.result.value,
              validator: (value) =>
                  MaintenanceRecordUpsertValidator.validateResult(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'actualCost',
              label: context.l10n.maintenanceRecordActualCostLabel,
              placeHolder: context.l10n.maintenanceRecordEnterActualCost,
              initialValue: widget.maintenanceRecord?.actualCost?.toString(),
              type: AppTextFieldType.priceUS,
              validator: (value) =>
                  MaintenanceRecordUpsertValidator.validateActualCost(
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
              AppText(
                context.l10n.maintenanceRecordTranslations,
                style: AppTextStyle.titleMedium,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),
              _buildTranslationFields(
                'en-US',
                context.l10n.maintenanceRecordEnglish,
              ),
              const SizedBox(height: 12),
              _buildTranslationFields(
                'ja-JP',
                context.l10n.maintenanceRecordJapanese,
              ),
              const SizedBox(height: 12),
              _buildTranslationFields(
                'id-ID',
                context.l10n.maintenanceRecordIndonesian,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTranslationFields(String langCode, String langName) {
    // * Use fetched maintenance record translations in edit mode
    final maintenanceRecordData = _isEdit
        ? _fetchedMaintenanceRecord
        : widget.maintenanceRecord;
    final translation = maintenanceRecordData?.translations?.firstWhere(
      (t) => t.langCode == langCode,
      orElse: () => MaintenanceRecordTranslation(
        langCode: langCode,
        title: '',
        notes: '',
      ),
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
            name: '${langCode}_title',
            label: context.l10n.maintenanceRecordTitle,
            placeHolder: context.l10n.maintenanceRecordEnterTitle(langName),
            initialValue: translation?.title,
            validator: (value) =>
                MaintenanceRecordUpsertValidator.validateTitle(
                  value,
                  isUpdate: _isEdit,
                ),
          ),
          const SizedBox(height: 12),
          AppTextField(
            name: '${langCode}_notes',
            label: context.l10n.maintenanceRecordNotes,
            placeHolder: context.l10n.maintenanceRecordEnterNotes(langName),
            initialValue: translation?.notes,
            type: AppTextFieldType.multiline,
            validator: (value) =>
                MaintenanceRecordUpsertValidator.validateNotes(
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
                text: context.l10n.maintenanceRecordCancel,
                variant: AppButtonVariant.outlined,
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                text: _isEdit
                    ? context.l10n.maintenanceRecordUpdate
                    : context.l10n.maintenanceRecordCreate,
                onPressed: _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
