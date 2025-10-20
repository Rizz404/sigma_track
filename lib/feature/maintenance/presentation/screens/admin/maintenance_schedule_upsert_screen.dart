import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/enums/language_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
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
import 'package:sigma_track/feature/user/domain/entities/user.dart';
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

class MaintenanceScheduleUpsertScreen extends ConsumerStatefulWidget {
  final MaintenanceSchedule? maintenanceSchedule;
  final String? maintenanceId;

  const MaintenanceScheduleUpsertScreen({
    super.key,
    this.maintenanceSchedule,
    this.maintenanceId,
  });

  @override
  ConsumerState<MaintenanceScheduleUpsertScreen> createState() =>
      _MaintenanceScheduleUpsertScreenState();
}

class _MaintenanceScheduleUpsertScreenState
    extends ConsumerState<MaintenanceScheduleUpsertScreen> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;
  bool get _isEdit =>
      widget.maintenanceSchedule != null || widget.maintenanceId != null;
  MaintenanceSchedule? _fetchedMaintenanceSchedule;
  bool _isLoadingTranslations = false;

  Future<List<Asset>> _searchAssets(String query) async {
    final notifier = ref.read(assetsSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(assetsSearchProvider);
    return state.assets;
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
    final scheduledDate = formData['scheduledDate'] as DateTime;
    final frequencyMonths = formData['frequencyMonths'] as String?;
    final status = formData['status'] as String?;
    final createdById = formData['createdById'] as String;

    if (_isEdit) {
      final maintenanceScheduleId =
          _fetchedMaintenanceSchedule?.id ?? widget.maintenanceSchedule!.id;
      final params = UpdateMaintenanceScheduleUsecaseParams.fromChanges(
        id: maintenanceScheduleId,
        original: _fetchedMaintenanceSchedule ?? widget.maintenanceSchedule!,
        assetId: assetId,
        maintenanceType: maintenanceType != null
            ? MaintenanceScheduleType.values.firstWhere(
                (e) => e.value == maintenanceType,
              )
            : null,
        scheduledDate: scheduledDate,
        frequencyMonths: frequencyMonths != null
            ? int.tryParse(frequencyMonths)
            : null,
        status: status != null
            ? ScheduleStatus.values.firstWhere((e) => e.value == status)
            : null,
        createdById: createdById,
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
        scheduledDate: scheduledDate,
        frequencyMonths: frequencyMonths != null
            ? int.tryParse(frequencyMonths)
            : null,
        status: status != null
            ? ScheduleStatus.values.firstWhere((e) => e.value == status)
            : ScheduleStatus.scheduled,
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
    // * Auto load translations in edit mode
    if (_isEdit && widget.maintenanceSchedule?.id != null) {
      final maintenanceScheduleDetailState = ref.watch(
        getMaintenanceScheduleByIdProvider(widget.maintenanceSchedule!.id),
      );

      // ? Update fetched maintenanceSchedule when data changes
      if (maintenanceScheduleDetailState.isLoading) {
        if (!_isLoadingTranslations) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _isLoadingTranslations = true);
            }
          });
        }
      } else if (maintenanceScheduleDetailState.maintenanceSchedule != null) {
        if (_fetchedMaintenanceSchedule?.id !=
            maintenanceScheduleDetailState.maintenanceSchedule!.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _fetchedMaintenanceSchedule =
                    maintenanceScheduleDetailState.maintenanceSchedule;
                _isLoadingTranslations = false;
                // ! Recreate form key to rebuild form with new data
                _formKey = GlobalKey<FormBuilderState>();
              });
            }
          });
        }
      } else if (maintenanceScheduleDetailState.failure != null &&
          _isLoadingTranslations) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _isLoadingTranslations = false);
            AppToast.error(
              maintenanceScheduleDetailState.failure?.message ??
                  'Failed to load translations',
            );
          }
        });
      }
    }

    // * Listen to mutation state
    ref.listen<MaintenanceSchedulesState>(maintenanceSchedulesProvider, (
      previous,
      next,
    ) {
      if (next.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      if (!next.isMutating && next.message != null && next.failure == null) {
        AppToast.success(
          next.message ?? 'Maintenance schedule saved successfully',
        );
        context.pop();
      } else if (next.failure != null) {
        if (next.failure is ValidationFailure) {
          setState(
            () => validationErrors = (next.failure as ValidationFailure).errors,
          );
        } else {
          this.logError('Maintenance schedule mutation error', next.failure);
          AppToast.error(next.failure?.message ?? 'Operation failed');
        }
      }
    });

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(
          title: _isEdit
              ? 'Edit Maintenance Schedule'
              : 'Create Maintenance Schedule',
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
            const AppText(
              'Maintenance Schedule Information',
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppSearchField<Asset>(
              name: 'assetId',
              label: 'Asset',
              hintText: 'Search and select asset',
              initialValue: widget.maintenanceSchedule?.assetId,
              enableAutocomplete: true,
              onSearch: _searchAssets,
              itemDisplayMapper: (asset) => asset.assetTag,
              itemValueMapper: (asset) => asset.id,
              itemSubtitleMapper: (asset) => asset.assetName,
              itemIcon: Icons.inventory,
              validator: (value) =>
                  MaintenanceScheduleUpsertValidator.validateAssetId(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppDropdown(
              name: 'maintenanceType',
              label: 'Maintenance Type',
              hintText: 'Select maintenance type',
              items: MaintenanceScheduleType.values
                  .map(
                    (type) => AppDropdownItem(
                      value: type.value,
                      label: type.label,
                      icon: Icon(type.icon, size: 18),
                    ),
                  )
                  .toList(),
              initialValue: widget.maintenanceSchedule?.maintenanceType.value,
              validator: (value) =>
                  MaintenanceScheduleUpsertValidator.validateMaintenanceType(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppDateTimePicker(
              name: 'scheduledDate',
              label: 'Scheduled Date',
              initialValue: widget.maintenanceSchedule?.scheduledDate,
              validator: (value) =>
                  MaintenanceScheduleUpsertValidator.validateScheduledDate(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'frequencyMonths',
              label: 'Frequency (Months)',
              placeHolder: 'Enter frequency in months (optional)',
              initialValue: widget.maintenanceSchedule?.frequencyMonths
                  ?.toString(),
              type: AppTextFieldType.number,
              validator: (value) =>
                  MaintenanceScheduleUpsertValidator.validateFrequencyMonths(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppDropdown(
              name: 'status',
              label: 'Status',
              hintText: 'Select status',
              items: ScheduleStatus.values
                  .map(
                    (status) => AppDropdownItem(
                      value: status.value,
                      label: status.label,
                      icon: Icon(status.icon, size: 18),
                    ),
                  )
                  .toList(),
              initialValue: widget.maintenanceSchedule?.status.value,
              validator: (value) =>
                  MaintenanceScheduleUpsertValidator.validateStatus(
                    value,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppSearchField<User>(
              name: 'createdById',
              label: 'Created By',
              hintText: 'Search and select user who created the schedule',
              initialValue: widget.maintenanceSchedule?.createdById,
              enableAutocomplete: true,
              onSearch: _searchUsers,
              itemDisplayMapper: (user) => user.name,
              itemValueMapper: (user) => user.id,
              itemSubtitleMapper: (user) => user.email,
              itemIcon: Icons.person,
              validator: (value) =>
                  MaintenanceScheduleUpsertValidator.validateCreatedById(
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
    // * Use fetched maintenance schedule translations in edit mode
    final maintenanceScheduleData = _isEdit
        ? _fetchedMaintenanceSchedule
        : widget.maintenanceSchedule;
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
            label: 'Title',
            placeHolder: 'Enter title in $langName',
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
            label: 'Description',
            placeHolder: 'Enter description in $langName',
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
