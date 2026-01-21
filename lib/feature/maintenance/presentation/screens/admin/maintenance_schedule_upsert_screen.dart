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
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/create_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/update_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_schedule_providers.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_schedules_state.dart';
import 'package:sigma_track/feature/maintenance/presentation/validators/maintenance_schedule_upsert_validator.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';

import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_checkbox.dart';
import 'package:sigma_track/shared/presentation/widgets/app_date_time_picker.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_loader_overlay.dart';
import 'package:sigma_track/shared/presentation/widgets/app_searchable_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/app_time_picker.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class MaintenanceScheduleUpsertScreen extends ConsumerStatefulWidget {
  final MaintenanceSchedule? maintenanceSchedule;
  final String? maintenanceId;
  final Asset? prePopulatedAsset;
  final MaintenanceSchedule? copyFromSchedule;

  const MaintenanceScheduleUpsertScreen({
    super.key,
    this.maintenanceSchedule,
    this.maintenanceId,
    this.prePopulatedAsset,
    this.copyFromSchedule,
  });

  @override
  ConsumerState<MaintenanceScheduleUpsertScreen> createState() =>
      _MaintenanceScheduleUpsertScreenState();
}

class _MaintenanceScheduleUpsertScreenState
    extends ConsumerState<MaintenanceScheduleUpsertScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;
  bool get _isEdit =>
      widget.maintenanceSchedule != null || widget.maintenanceId != null;
  bool get _isCopyMode => widget.copyFromSchedule != null;
  bool get _hasPrePopulatedAsset => widget.prePopulatedAsset != null;
  // * Helper to get source schedule for initialization (copy or edit)
  MaintenanceSchedule? get _sourceSchedule =>
      widget.copyFromSchedule ?? widget.maintenanceSchedule;

  TimeOfDay? _parseTimeOfDay(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;
    final parts = timeString.split(':');
    if (parts.length >= 2) {
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    return null;
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
      AppToast.warning(context.l10n.maintenanceScheduleFillRequiredFields);
      return;
    }

    final formData = _formKey.currentState!.value;

    final translations = <dynamic>[];
    for (final langCode in Language.values.map((e) => e.backendCode)) {
      final title = formData['${langCode}_title'] as String?;
      final description = formData['${langCode}_description'] as String?;

      if (title != null && title.isNotEmpty) {
        if (_isEdit) {
          translations.add(
            UpdateMaintenanceScheduleTranslation(
              langCode: langCode,
              title: title,
              description: description,
            ),
          );
        } else {
          translations.add(
            CreateMaintenanceScheduleTranslation(
              langCode: langCode,
              title: title,
              description: description,
            ),
          );
        }
      }
    }

    final assetId = formData['assetId'] as String;
    final maintenanceType = formData['maintenanceType'] as String?;
    final isRecurring = formData['isRecurring'] as bool? ?? false;
    final intervalValue = formData['intervalValue'] as String?;
    final intervalUnit = formData['intervalUnit'] as String?;
    final scheduledTimeData = formData['scheduledTime'] as TimeOfDay?;
    final scheduledTime = scheduledTimeData != null
        ? '${scheduledTimeData.hour.toString().padLeft(2, '0')}:${scheduledTimeData.minute.toString().padLeft(2, '0')}:00'
        : null;
    final nextScheduledDate = formData['nextScheduledDate'] as DateTime;
    final state = formData['state'] as String?;
    final autoComplete = formData['autoComplete'] as bool? ?? false;
    final estimatedCost = formData['estimatedCost'] as String?;

    // * NEW IMPLEMENTATION: Get current user ID from provider in create mode
    final createdById = !_isEdit
        ? (ref.read(currentUserNotifierProvider).user?.id ?? '')
        : (formData['createdById'] as String? ?? '');

    // * Pastikan createdById tidak kosong saat create
    if (!_isEdit && createdById.isEmpty) {
      AppToast.warning('Created by user tidak ditemukan');
      return;
    }

    if (_isEdit) {
      final maintenanceScheduleId = widget.maintenanceSchedule!.id;
      final params = UpdateMaintenanceScheduleUsecaseParams.fromChanges(
        id: maintenanceScheduleId,
        original: widget.maintenanceSchedule!,
        maintenanceType: maintenanceType != null
            ? MaintenanceScheduleType.values.firstWhere(
                (e) => e.value == maintenanceType,
              )
            : null,
        isRecurring: isRecurring,
        intervalValue: intervalValue != null
            ? int.tryParse(intervalValue)
            : null,
        intervalUnit: intervalUnit != null
            ? IntervalUnit.values.firstWhere((e) => e.value == intervalUnit)
            : null,
        scheduledTime: scheduledTime,
        nextScheduledDate: nextScheduledDate,
        state: state != null
            ? ScheduleState.values.firstWhere((e) => e.value == state)
            : null,
        autoComplete: autoComplete,
        estimatedCost: estimatedCost != null
            ? double.tryParse(estimatedCost)
            : null,
        translations: translations.cast<UpdateMaintenanceScheduleTranslation>(),
      );
      ref
          .read(maintenanceSchedulesProvider.notifier)
          .updateMaintenanceSchedule(params);
    } else {
      final params = CreateMaintenanceScheduleUsecaseParams(
        assetId: assetId,
        maintenanceType: maintenanceType != null
            ? MaintenanceScheduleType.values.firstWhere(
                (e) => e.value == maintenanceType,
              )
            : MaintenanceScheduleType.preventive,
        isRecurring: isRecurring,
        intervalValue: intervalValue != null
            ? int.tryParse(intervalValue)
            : null,
        intervalUnit: intervalUnit != null
            ? IntervalUnit.values.firstWhere((e) => e.value == intervalUnit)
            : null,
        scheduledTime: scheduledTime,
        nextScheduledDate: nextScheduledDate,
        autoComplete: autoComplete,
        estimatedCost: estimatedCost != null
            ? double.tryParse(estimatedCost)
            : null,
        createdById: createdById,
        translations: translations.cast<CreateMaintenanceScheduleTranslation>(),
      );
      ref
          .read(maintenanceSchedulesProvider.notifier)
          .createMaintenanceSchedule(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Watch current user provider to ensure data is loaded for 'createdBy'
    ref.watch(currentUserNotifierProvider);

    // * Listen to mutation state
    ref.listen<MaintenanceSchedulesState>(maintenanceSchedulesProvider, (
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
              context.l10n.maintenanceScheduleSavedSuccessfully,
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
            'Maintenance schedule mutation error',
            next.mutationFailure,
          );
          AppToast.error(
            next.mutationFailure?.message ??
                context.l10n.maintenanceScheduleOperationFailed,
          );
        }
      }
    });

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(
          title: _isEdit
              ? context.l10n.maintenanceScheduleEditSchedule
              : context.l10n.maintenanceScheduleCreateSchedule,
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
                        _buildMaintenanceScheduleInfoSection(),
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

  Widget _buildMaintenanceScheduleInfoSection() {
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
              context.l10n.maintenanceScheduleInformation,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (context) {
                final assetsState = ref.watch(assetsSearchDropdownProvider);
                final maintenanceScheduleData = _isCopyMode
                    ? _sourceSchedule
                    : widget.maintenanceSchedule;

                return AppSearchableDropdown<Asset>(
                  name: 'assetId',
                  label: context.l10n.maintenanceScheduleAsset,
                  hintText: context.l10n.maintenanceScheduleSearchAsset,
                  initialValue: _hasPrePopulatedAsset
                      ? widget.prePopulatedAsset
                      : maintenanceScheduleData?.asset,
                  items: assetsState.assets,
                  isLoading: assetsState.isLoading,
                  onSearch: (query) {
                    ref
                        .read(assetsSearchDropdownProvider.notifier)
                        .search(query);
                  },
                  itemDisplayMapper: (asset) => asset.assetTag,
                  itemValueMapper: (asset) => asset.id,
                  itemSubtitleMapper: (asset) => asset.assetName,
                  itemIconMapper: (asset) => Icons.inventory,
                  validator: (value) =>
                      MaintenanceScheduleUpsertValidator.validateAssetId(
                        value,
                        isUpdate: _isEdit,
                      ),
                );
              },
            ),
            const SizedBox(height: 16),
            AppDropdown(
              name: 'maintenanceType',
              label: context.l10n.maintenanceScheduleMaintenanceType,
              hintText: context.l10n.maintenanceScheduleSelectMaintenanceType,
              items: MaintenanceScheduleType.values
                  .map(
                    (type) => AppDropdownItem(
                      value: type.value,
                      label: type.label,
                      icon: Icon(type.icon, size: 18),
                    ),
                  )
                  .toList(),
              initialValue: _sourceSchedule?.maintenanceType.value,
              validator: (value) =>
                  MaintenanceScheduleUpsertValidator.validateMaintenanceType(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppDateTimePicker(
              name: 'nextScheduledDate',
              label: context.l10n.maintenanceScheduleNextScheduledDate,
              initialValue: _sourceSchedule?.nextScheduledDate,
              validator: (value) =>
                  MaintenanceScheduleUpsertValidator.validateNextScheduledDate(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppCheckbox(
              name: 'isRecurring',
              title: AppText(context.l10n.maintenanceScheduleIsRecurring),
              initialValue: _sourceSchedule?.isRecurring ?? false,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'intervalValue',
              label: context.l10n.maintenanceScheduleIntervalValueLabel,
              placeHolder: context.l10n.maintenanceScheduleEnterIntervalValue,
              initialValue: _sourceSchedule?.intervalValue?.toString(),
              type: AppTextFieldType.number,
              validator: (value) =>
                  MaintenanceScheduleUpsertValidator.validateIntervalValue(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppDropdown(
              name: 'intervalUnit',
              label: context.l10n.maintenanceScheduleIntervalUnitLabel,
              hintText: context.l10n.maintenanceScheduleSelectIntervalUnit,
              items: IntervalUnit.values
                  .map(
                    (unit) =>
                        AppDropdownItem(value: unit.value, label: unit.label),
                  )
                  .toList(),
              initialValue: _sourceSchedule?.intervalUnit?.value,
            ),
            const SizedBox(height: 16),
            AppTimePicker(
              name: 'scheduledTime',
              label: context.l10n.maintenanceScheduleScheduledTimeLabel,
              initialValue: _parseTimeOfDay(_sourceSchedule?.scheduledTime),
            ),
            const SizedBox(height: 16),
            if (_isEdit)
              AppDropdown(
                name: 'state',
                label: context.l10n.maintenanceScheduleState,
                hintText: context.l10n.maintenanceScheduleSelectState,
                items: ScheduleState.values
                    .map(
                      (state) => AppDropdownItem(
                        value: state.value,
                        label: state.label,
                        icon: Icon(state.icon, size: 18),
                      ),
                    )
                    .toList(),
                initialValue: widget.maintenanceSchedule?.state.value,
                validator: (value) =>
                    MaintenanceScheduleUpsertValidator.validateState(
                      value,
                      isUpdate: _isEdit,
                    ),
              ),
            if (_isEdit) const SizedBox(height: 16),
            AppCheckbox(
              name: 'autoComplete',
              title: AppText(context.l10n.maintenanceScheduleAutoComplete),
              initialValue: _sourceSchedule?.autoComplete ?? false,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'estimatedCost',
              label: context.l10n.maintenanceScheduleEstimatedCost,
              placeHolder: context.l10n.maintenanceScheduleEnterEstimatedCost,
              initialValue: _sourceSchedule?.estimatedCost?.toString(),
              type: AppTextFieldType.number,
              validator: (value) =>
                  MaintenanceScheduleUpsertValidator.validateEstimatedCost(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            // * OLD IMPLEMENTATION: User dropdown for created by
            // * Commented out for future reference
            // AppSearchField<User>(
            //   name: 'createdById',
            //   label: context.l10n.maintenanceScheduleCreatedBy,
            //   hintText: context.l10n.maintenanceScheduleSearchUser,
            //   initialValue: widget.maintenanceSchedule?.createdById,
            //   enableAutocomplete: true,
            //   onSearch: _searchUsers,
            //   itemDisplayMapper: (user) => user.name,
            //   itemValueMapper: (user) => user.id,
            //   itemSubtitleMapper: (user) => user.email,
            //   itemIcon: Icons.person,
            //   validator: (value) =>
            //       MaintenanceScheduleUpsertValidator.validateCreatedById(
            //         value,
            //         isUpdate: _isEdit,
            //       ),
            // ),
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
              context.l10n.maintenanceScheduleTranslations,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            _buildTranslationFields(
              'en-US',
              context.l10n.maintenanceScheduleEnglish,
            ),
            const SizedBox(height: 12),
            _buildTranslationFields(
              'ja-JP',
              context.l10n.maintenanceScheduleJapanese,
            ),
            const SizedBox(height: 12),
            _buildTranslationFields(
              'id-ID',
              context.l10n.maintenanceScheduleIndonesian,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationFields(String langCode, String langName) {
    // * Use fetched maintenance schedule translations in edit mode, or source in copy
    final maintenanceScheduleData = _sourceSchedule;
    final translation = maintenanceScheduleData?.translations?.firstWhere(
      (t) => t.langCode == langCode,
      orElse: () => MaintenanceScheduleTranslation(
        langCode: langCode,
        title: '',
        description: '',
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
            label: context.l10n.maintenanceScheduleTitle,
            placeHolder: context.l10n.maintenanceScheduleEnterTitle(langName),
            initialValue: translation?.title,
            validator: (value) =>
                MaintenanceScheduleUpsertValidator.validateTitle(
                  value,
                  isUpdate: _isEdit,
                ),
          ),
          const SizedBox(height: 12),
          AppTextField(
            name: '${langCode}_description',
            label: context.l10n.maintenanceScheduleDescription,
            placeHolder: context.l10n.maintenanceScheduleEnterDescription(
              langName,
            ),
            initialValue: translation?.description,
            type: AppTextFieldType.multiline,
            validator: (value) =>
                MaintenanceScheduleUpsertValidator.validateDescription(
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
                text: context.l10n.maintenanceScheduleCancel,
                variant: AppButtonVariant.outlined,
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                text: _isEdit
                    ? context.l10n.maintenanceScheduleUpdate
                    : context.l10n.maintenanceScheduleCreate,
                onPressed: _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
