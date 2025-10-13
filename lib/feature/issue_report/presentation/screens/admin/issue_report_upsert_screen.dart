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
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/create_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/update_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/issue_report_providers.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/state/issue_reports_state.dart';
import 'package:sigma_track/feature/issue_report/presentation/validators/issue_report_upsert_validator.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
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

class IssueReportUpsertScreen extends ConsumerStatefulWidget {
  final IssueReport? issueReport;
  final String? issueReportId;

  const IssueReportUpsertScreen({
    super.key,
    this.issueReport,
    this.issueReportId,
  });

  @override
  ConsumerState<IssueReportUpsertScreen> createState() =>
      _IssueReportUpsertScreenState();
}

class _IssueReportUpsertScreenState
    extends ConsumerState<IssueReportUpsertScreen> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;
  bool get _isEdit =>
      widget.issueReport != null || widget.issueReportId != null;
  IssueReport? _fetchedIssueReport;
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
            UpdateIssueReportTranslation(
              langCode: langCode,
              title: title,
              description: description,
            ),
          );
        } else {
          translations.add(
            CreateIssueReportTranslation(
              langCode: langCode,
              title: title,
              description: description,
            ),
          );
        }
      }
    }

    final assetId = formData['assetId'] as String;
    final reportedById = formData['reportedById'] as String;
    final issueType = formData['issueType'] as String;
    final priority = IssuePriority.values.byName(
      formData['priority'] as String,
    );

    if (_isEdit) {
      final issueReportId = _fetchedIssueReport?.id ?? widget.issueReport!.id;
      final status = IssueStatus.values.byName(formData['status'] as String);
      final resolutionNotes = formData['resolutionNotes'] as String?;
      final params = UpdateIssueReportUsecaseParams(
        id: issueReportId,
        assetId: assetId,
        issueType: issueType,
        priority: priority,
        status: status,
        resolutionNotes: resolutionNotes,
        translations: translations.cast<UpdateIssueReportTranslation>(),
      );
      ref.read(issueReportsProvider.notifier).updateIssueReport(params);
    } else {
      final params = CreateIssueReportUsecaseParams(
        assetId: assetId,
        reportedById: reportedById,
        issueType: issueType,
        priority: priority,
        translations: translations.cast<CreateIssueReportTranslation>(),
      );
      ref.read(issueReportsProvider.notifier).createIssueReport(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    // * Auto load translations in edit mode
    if (_isEdit && widget.issueReport?.id != null) {
      final issueReportDetailState = ref.watch(
        getIssueReportByIdProvider(widget.issueReport!.id),
      );

      // ? Update fetched issueReport when data changes
      if (issueReportDetailState.isLoading) {
        if (!_isLoadingTranslations) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _isLoadingTranslations = true);
            }
          });
        }
      } else if (issueReportDetailState.issueReport != null) {
        if (_fetchedIssueReport?.id != issueReportDetailState.issueReport!.id) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _fetchedIssueReport = issueReportDetailState.issueReport;
                _isLoadingTranslations = false;
                // ! Recreate form key to rebuild form with new data
                _formKey = GlobalKey<FormBuilderState>();
              });
            }
          });
        }
      } else if (issueReportDetailState.failure != null &&
          _isLoadingTranslations) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _isLoadingTranslations = false);
            AppToast.error(
              issueReportDetailState.failure?.message ??
                  'Failed to load translations',
            );
          }
        });
      }
    }

    // * Listen to mutation state
    ref.listen<IssueReportsState>(issueReportsProvider, (previous, next) {
      if (next.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      if (!next.isMutating && next.message != null && next.failure == null) {
        AppToast.success(next.message ?? 'Issue report saved successfully');
        context.pop();
      } else if (next.failure != null) {
        if (next.failure is ValidationFailure) {
          setState(
            () => validationErrors = (next.failure as ValidationFailure).errors,
          );
        } else {
          this.logError('Issue report mutation error', next.failure);
          AppToast.error(next.failure?.message ?? 'Operation failed');
        }
      }
    });

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(
          title: _isEdit ? 'Edit Issue Report' : 'Create Issue Report',
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
                        _buildIssueReportInfoSection(),
                        const SizedBox(height: 24),
                        _buildTranslationsSection(),
                        if (_isEdit) ...[
                          const SizedBox(height: 24),
                          _buildResolutionSection(),
                        ],
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

  Widget _buildIssueReportInfoSection() {
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
              'Issue Report Information',
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppSearchField<Asset>(
              name: 'assetId',
              label: 'Asset',
              hintText: 'Search and select asset',
              initialValue: widget.issueReport?.assetId,
              enableAutocomplete: true,
              onSearch: _searchAssets,
              itemDisplayMapper: (asset) => asset.assetTag,
              itemValueMapper: (asset) => asset.id,
              itemSubtitleMapper: (asset) => asset.assetName,
              itemIcon: Icons.inventory,
              validator: IssueReportUpsertValidator.validateAssetId,
            ),
            const SizedBox(height: 16),
            AppSearchField<User>(
              name: 'reportedById',
              label: 'Reported By',
              hintText: 'Search and select user who reported the issue',
              initialValue: widget.issueReport?.reportedById,
              enableAutocomplete: true,
              onSearch: _searchUsers,
              itemDisplayMapper: (user) => user.name,
              itemValueMapper: (user) => user.id,
              itemSubtitleMapper: (user) => user.email,
              itemIcon: Icons.person,
              validator: IssueReportUpsertValidator.validateReportedById,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'issueType',
              label: 'Issue Type',
              placeHolder: 'Enter issue type (e.g., Hardware, Software)',
              initialValue: widget.issueReport?.issueType,
              validator: IssueReportUpsertValidator.validateIssueType,
            ),
            const SizedBox(height: 16),
            AppDropdown(
              name: 'priority',
              label: 'Priority',
              hintText: 'Select priority',
              items: IssuePriority.values
                  .map(
                    (priority) => AppDropdownItem(
                      value: priority.value,
                      label: priority.label,
                      icon: Icon(priority.icon, size: 18),
                    ),
                  )
                  .toList(),
              initialValue: widget.issueReport?.priority.value,
              validator: IssueReportUpsertValidator.validatePriority,
            ),
            if (_isEdit) ...[
              const SizedBox(height: 16),
              AppDropdown(
                name: 'status',
                label: 'Status',
                hintText: 'Select status',
                items: IssueStatus.values
                    .map(
                      (status) => AppDropdownItem(
                        value: status.value,
                        label: status.label,
                        icon: Icon(status.icon, size: 18),
                      ),
                    )
                    .toList(),
                initialValue: widget.issueReport?.status.value,
                validator: IssueReportUpsertValidator.validateStatus,
              ),
            ],
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
    // * Use fetched issue report translations in edit mode
    final issueReportData = _isEdit ? _fetchedIssueReport : widget.issueReport;
    final translation = issueReportData?.translations?.firstWhere(
      (t) => t.langCode == langCode,
      orElse: () => IssueReportTranslation(
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
            validator: IssueReportUpsertValidator.validateTitle,
          ),
          const SizedBox(height: 12),
          AppTextField(
            name: '${langCode}_description',
            label: 'Description',
            placeHolder: 'Enter description in $langName',
            initialValue: translation?.description,
            type: AppTextFieldType.multiline,
            validator: IssueReportUpsertValidator.validateDescription,
          ),
        ],
      ),
    );
  }

  Widget _buildResolutionSection() {
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
              'Resolution',
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'resolutionNotes',
              label: 'Resolution Notes',
              placeHolder: 'Enter resolution notes',
              initialValue: widget.issueReport?.resolutionNotes,
              type: AppTextFieldType.multiline,
              validator: IssueReportUpsertValidator.validateResolutionNotes,
            ),
          ],
        ),
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
