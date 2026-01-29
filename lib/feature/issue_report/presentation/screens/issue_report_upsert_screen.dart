import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/enums/language_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
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
import 'package:sigma_track/shared/presentation/widgets/app_searchable_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class IssueReportUpsertScreen extends ConsumerStatefulWidget {
  final IssueReport? issueReport;
  final String? issueReportId;
  final Asset? prePopulatedAsset;

  const IssueReportUpsertScreen({
    super.key,
    this.issueReport,
    this.issueReportId,
    this.prePopulatedAsset,
  });

  @override
  ConsumerState<IssueReportUpsertScreen> createState() =>
      _IssueReportUpsertScreenState();
}

class _IssueReportUpsertScreenState
    extends ConsumerState<IssueReportUpsertScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;
  bool get _isEdit =>
      widget.issueReport != null || widget.issueReportId != null;
  bool get _hasPrePopulatedAsset => widget.prePopulatedAsset != null;

  void _handleSubmit() {
    if (_formKey.currentState?.saveAndValidate() != true) {
      AppToast.warning(context.l10n.issueReportFillRequiredFields);
      return;
    }

    final formData = _formKey.currentState!.value;

    final translations = <dynamic>[];
    for (final langCode in Language.values.map((e) => e.backendCode)) {
      final title = formData['${langCode}_title'] as String?;
      final description = formData['${langCode}_description'] as String?;

      if (title != null && title.isNotEmpty) {
        if (_isEdit) {
          final resolutionNotes =
              formData['${langCode}_resolutionNotes'] as String?;
          translations.add(
            UpdateIssueReportTranslation(
              langCode: langCode,
              title: title,
              description: description,
              resolutionNotes: resolutionNotes,
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

    // * NEW IMPLEMENTATION: Get current user ID from provider in create mode
    final reportedById = !_isEdit
        ? (ref.read(currentUserNotifierProvider).user?.id ?? '')
        : (formData['reportedById'] as String? ?? '');

    final issueType = formData['issueType'] as String;
    final priority = IssuePriority.values.firstWhere(
      (e) => e.value == formData['priority'],
    );

    if (_isEdit) {
      final issueReportId = widget.issueReport!.id;
      final status = IssueStatus.values.firstWhere(
        (e) => e.value == formData['status'],
      );
      final params = UpdateIssueReportUsecaseParams.fromChanges(
        id: issueReportId,
        original: widget.issueReport!,
        priority: priority,
        status: status,
        resolvedBy: formData['resolvedBy'] as String?,
        translations: translations.cast<UpdateIssueReportTranslation>(),
      );
      ref.read(issueReportsProvider.notifier).updateIssueReport(params);
    } else {
      // * Pastikan reportedById tidak kosong saat create
      if (reportedById.isEmpty) {
        AppToast.warning(context.l10n.issueReportReportedByUserNotFound);
        return;
      }

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
    // * Watch current user provider to ensure data is loaded for 'reportedBy'
    ref.watch(currentUserNotifierProvider);

    // * Listen to mutation state
    ref.listen<IssueReportsState>(issueReportsProvider, (previous, next) {
      // * Handle loading state
      if (next.isMutating) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }

      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(
          next.mutationMessage ?? context.l10n.issueReportSavedSuccessfully,
        );
        context.pop(next.mutation!.updatedIssueReport);
      }

      // * Handle mutation error
      if (next.hasMutationError) {
        if (next.mutationFailure is ValidationFailure) {
          setState(
            () => validationErrors =
                (next.mutationFailure as ValidationFailure).errors,
          );
        } else {
          this.logError('Issue report mutation error', next.mutationFailure);
          AppToast.error(
            next.mutationFailure?.message ??
                context.l10n.issueReportOperationFailed,
          );
        }
      }
    });

    return AppLoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(
          title: _isEdit
              ? context.l10n.issueReportEditIssueReport
              : context.l10n.issueReportCreateIssueReport,
        ),
        endDrawer: const AppEndDrawer(),
        endDrawerEnableOpenDragGesture: false,
        body: ScreenWrapper(
          child: FormBuilder(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIssueReportInfoSection(),
                  const SizedBox(height: 24),
                  _buildTranslationsSection(),
                  const SizedBox(height: 24),
                  AppValidationErrors(errors: validationErrors),
                  if (validationErrors != null && validationErrors!.isNotEmpty)
                    const SizedBox(height: 16),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
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
            AppText(
              context.l10n.issueReportInformation,
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
                        context.l10n.issueReportEditWarning,
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
                final issueReportData = widget.issueReport;

                return AppSearchableDropdown<Asset>(
                  name: 'assetId',
                  label: context.l10n.issueReportAsset,
                  hintText: context.l10n.issueReportSearchAsset,
                  initialValue: _hasPrePopulatedAsset
                      ? widget.prePopulatedAsset
                      : issueReportData?.asset,
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
                      IssueReportUpsertValidator.validateAssetId(
                        value,
                        context: context,
                        isUpdate: _isEdit,
                      ),
                );
              },
            ),
            const SizedBox(height: 16),
            // * OLD IMPLEMENTATION: User dropdown for reported by
            // * Commented out for future reference
            // AppSearchField<User>(
            //   name: 'reportedById',
            //   label: context.l10n.issueReportReportedBy,
            //   hintText: context.l10n.issueReportSearchReportedBy,
            //   initialValue:
            //       (_isEdit ? _fetchedIssueReport?.reportedById : null) ??
            //       widget.issueReport?.reportedById,
            //   enableAutocomplete: true,
            //   onSearch: _searchUsers,
            //   itemDisplayMapper: (user) => user.name,
            //   itemValueMapper: (user) => user.id,
            //   itemSubtitleMapper: (user) => user.email,
            //   itemIcon: Icons.person,
            //   validator: (value) =>
            //       IssueReportUpsertValidator.validateReportedById(
            //         value,
            //         context: context,
            //         isUpdate: _isEdit,
            //       ),
            // ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'issueType',
              label: context.l10n.issueReportIssueType,
              placeHolder: context.l10n.issueReportEnterIssueType,
              initialValue: widget.issueReport?.issueType,
              enabled: !_isEdit, // * Disable saat edit
              validator: (value) =>
                  IssueReportUpsertValidator.validateIssueType(
                    value,
                    context: context,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppDropdown(
              name: 'priority',
              label: context.l10n.issueReportPriority,
              hintText: context.l10n.issueReportSelectPriority,
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
              validator: (value) => IssueReportUpsertValidator.validatePriority(
                value,
                context: context,
                isUpdate: _isEdit,
              ),
            ),
            if (_isEdit) ...[
              const SizedBox(height: 16),
              AppDropdown(
                name: 'status',
                label: context.l10n.issueReportStatus,
                hintText: context.l10n.issueReportSelectStatus,
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
                validator: (value) => IssueReportUpsertValidator.validateStatus(
                  value,
                  context: context,
                  isUpdate: _isEdit,
                ),
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (context) {
                  final usersState = ref.watch(usersSearchDropdownProvider);
                  final issueReportData = widget.issueReport;

                  return AppSearchableDropdown<User>(
                    name: 'resolvedBy',
                    label: context.l10n.issueReportResolvedBy,
                    hintText: context.l10n.issueReportSearchResolvedBy,
                    initialValue: issueReportData?.resolvedBy,
                    items: usersState.users,
                    isLoading: usersState.isLoading,
                    onSearch: (query) {
                      ref
                          .read(usersSearchDropdownProvider.notifier)
                          .search(query);
                    },
                    onLoadMore: () {
                      ref.read(usersSearchDropdownProvider.notifier).loadMore();
                    },
                    hasMore: usersState.cursor?.hasNextPage ?? false,
                    isLoadingMore: usersState.isLoadingMore,
                    itemDisplayMapper: (user) => user.name,
                    itemValueMapper: (user) => user.id,
                    itemSubtitleMapper: (user) => user.email,
                    itemIconMapper: (user) => Icons.person,
                    validator: (value) =>
                        IssueReportUpsertValidator.validateResolvedBy(
                          value,
                          context: context,
                          isUpdate: _isEdit,
                        ),
                  );
                },
              ),
            ],
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
              context.l10n.issueReportTranslations,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            _buildTranslationFields('en-US', context.l10n.issueReportEnglish),
            const SizedBox(height: 12),
            _buildTranslationFields('ja-JP', context.l10n.issueReportJapanese),
            const SizedBox(height: 12),
            _buildTranslationFields(
              'id-ID',
              context.l10n.issueReportIndonesian,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationFields(String langCode, String langName) {
    // * Use fetched issue report translations in edit mode
    // * Use fetched issue report translations in edit mode
    final issueReportData = widget.issueReport;
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
            label: context.l10n.issueReportTitle,
            placeHolder: context.l10n.issueReportEnterTitleIn(langName),
            initialValue: translation?.title,
            validator: (value) => IssueReportUpsertValidator.validateTitle(
              value,
              context: context,
              isUpdate: _isEdit,
            ),
          ),
          const SizedBox(height: 12),
          AppTextField(
            name: '${langCode}_description',
            label: context.l10n.issueReportDescription,
            placeHolder: context.l10n.issueReportEnterDescriptionIn(langName),
            initialValue: translation?.description,
            type: AppTextFieldType.multiline,
            validator: (value) =>
                IssueReportUpsertValidator.validateDescription(
                  value,
                  context: context,
                  isUpdate: _isEdit,
                ),
          ),
          if (_isEdit) ...[
            const SizedBox(height: 12),
            AppTextField(
              name: '${langCode}_resolutionNotes',
              label: context.l10n.issueReportResolutionNotes,
              placeHolder: context.l10n.issueReportEnterResolutionNotesIn(
                langName,
              ),
              initialValue: translation?.resolutionNotes,
              type: AppTextFieldType.multiline,
              validator: (value) =>
                  IssueReportUpsertValidator.validateResolutionNotes(
                    value,
                    context: context,
                    isUpdate: _isEdit,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                text: context.l10n.issueReportCancel,
                variant: AppButtonVariant.outlined,
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                text: _isEdit
                    ? context.l10n.issueReportUpdate
                    : context.l10n.issueReportCreate,
                onPressed: _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
