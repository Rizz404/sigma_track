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
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/create_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/update_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_record_providers.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_schedule_providers.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_records_state.dart';
import 'package:sigma_track/feature/maintenance/presentation/validators/maintenance_record_upsert_validator.dart';
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

class MaintenanceRecordUpsertScreen extends ConsumerStatefulWidget {
  final MaintenanceRecord? maintenanceRecord;
  final String? maintenanceRecordId;

  const MaintenanceRecordUpsertScreen({
    super.key,
    this.maintenanceRecord,
    this.maintenanceRecordId,
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
    final performedById = formData['performedById'] as String;
    final actualCost = formData['actualCost'] != null
        ? double.tryParse(formData['actualCost'] as String)
        : null;

    if (_isEdit) {
      final maintenanceRecordId =
          _fetchedMaintenanceRecord?.id ?? widget.maintenanceRecord!.id;
      final params = UpdateMaintenanceRecordUsecaseParams(
        id: maintenanceRecordId,
        scheduleId: scheduleId,
        assetId: assetId,
        maintenanceDate: maintenanceDate,
        performedByUserId: performedById,
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
        performedByUserId: performedById,
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
                  'Failed to load translations',
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
      if (next.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      if (!next.isMutating && next.message != null && next.failure == null) {
        AppToast.success(
          next.message ?? 'Maintenance record saved successfully',
        );
        context.pop();
      } else if (next.failure != null) {
        if (next.failure is ValidationFailure) {
          setState(
            () => validationErrors = (next.failure as ValidationFailure).errors,
          );
        } else {
          this.logError('Maintenance record mutation error', next.failure);
          AppToast.error(next.failure?.message ?? 'Operation failed');
        }
      }
    });

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(
          title: _isEdit
              ? 'Edit Maintenance Record'
              : 'Create Maintenance Record',
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
            const AppText(
              'Maintenance Record Information',
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppSearchField<MaintenanceSchedule>(
              name: 'scheduleId',
              label: 'Maintenance Schedule',
              hintText: 'Search and select maintenance schedule',
              initialValue: widget.maintenanceRecord?.scheduleId,
              enableAutocomplete: true,
              onSearch: _searchMaintenanceSchedules,
              itemDisplayMapper: (schedule) => schedule.title,
              itemValueMapper: (schedule) => schedule.id,
              itemSubtitleMapper: (schedule) => schedule.asset.assetName,
              itemIcon: Icons.schedule,
              validator: MaintenanceRecordUpsertValidator.validateScheduleId,
            ),
            const SizedBox(height: 16),
            AppSearchField<Asset>(
              name: 'assetId',
              label: 'Asset',
              hintText: 'Search and select asset',
              initialValue: widget.maintenanceRecord?.assetId,
              enableAutocomplete: true,
              onSearch: _searchAssets,
              itemDisplayMapper: (asset) => asset.assetTag,
              itemValueMapper: (asset) => asset.id,
              itemSubtitleMapper: (asset) => asset.assetName,
              itemIcon: Icons.inventory,
              validator: MaintenanceRecordUpsertValidator.validateAssetId,
            ),
            const SizedBox(height: 16),
            AppDateTimePicker(
              name: 'maintenanceDate',
              label: 'Maintenance Date',
              initialValue: widget.maintenanceRecord?.maintenanceDate,
              validator:
                  MaintenanceRecordUpsertValidator.validateMaintenanceDate,
            ),
            const SizedBox(height: 16),
            AppSearchField<User>(
              name: 'performedById',
              label: 'Performed By',
              hintText: 'Search and select user who performed the maintenance',
              initialValue: widget.maintenanceRecord?.performedByUserId,
              enableAutocomplete: true,
              onSearch: _searchUsers,
              itemDisplayMapper: (user) => user.name,
              itemValueMapper: (user) => user.id,
              itemSubtitleMapper: (user) => user.email,
              itemIcon: Icons.person,
              validator: MaintenanceRecordUpsertValidator.validatePerformedById,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'actualCost',
              label: 'Actual Cost',
              placeHolder: 'Enter actual cost (optional)',
              initialValue: widget.maintenanceRecord?.actualCost?.toString(),
              type: AppTextFieldType.priceUS,
              validator: MaintenanceRecordUpsertValidator.validateActualCost,
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
              _buildTranslationFields('en', 'English'),
              const SizedBox(height: 12),
              _buildTranslationFields('ja', 'Japanese'),
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
            label: 'Title',
            placeHolder: 'Enter title in $langName',
            initialValue: translation?.title,
            validator: MaintenanceRecordUpsertValidator.validateTitle,
          ),
          const SizedBox(height: 12),
          AppTextField(
            name: '${langCode}_notes',
            label: 'Notes',
            placeHolder: 'Enter notes in $langName',
            initialValue: translation?.notes,
            type: AppTextFieldType.multiline,
            validator: MaintenanceRecordUpsertValidator.validateNotes,
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
