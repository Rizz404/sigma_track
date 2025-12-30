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
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/app_validation_errors.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Todo: fix belum ada resolved date dan resolved by
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
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  List<ValidationError>? validationErrors;
  bool get _isEdit =>
      widget.issueReport != null || widget.issueReportId != null;
  bool get _hasPrePopulatedAsset => widget.prePopulatedAsset != null;
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
    final issueType = formData['issueType'] as String;
    final priority = IssuePriority.values.firstWhere(
      (e) => e.value == formData['priority'],
    );

    if (_isEdit) {
      final issueReportId = _fetchedIssueReport?.id ?? widget.issueReport!.id;
      final status = IssueStatus.values.firstWhere(
        (e) => e.value == formData['status'],
      );
      final params = UpdateIssueReportUsecaseParams.fromChanges(
        id: issueReportId,
        original: _fetchedIssueReport ?? widget.issueReport!,
        priority: priority,
        status: status,
        resolvedBy: formData['resolvedBy'] as String?,
        translations: translations.cast<UpdateIssueReportTranslation>(),
      );
      ref.read(issueReportsProvider.notifier).updateIssueReport(params);
    } else {
      final params = CreateIssueReportUsecaseParams(
        assetId: assetId,
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
                  context.l10n.issueReportFailedToLoadTranslations,
            );
          }
        });
      }
    }

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
            AppText(
              context.l10n.issueReportInformation,
              style: AppTextStyle.titleMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppSearchField<Asset>(
              name: 'assetId',
              label: context.l10n.issueReportAsset,
              hintText: context.l10n.issueReportSearchAsset,
              initialValue: _hasPrePopulatedAsset
                  ? widget.prePopulatedAsset!.id
                  : ((_isEdit ? _fetchedIssueReport?.assetId : null) ??
                        widget.issueReport?.assetId),
              initialDisplayText: _hasPrePopulatedAsset
                  ? widget.prePopulatedAsset!.assetTag
                  : null,
              enableAutocomplete: true,
              onSearch: _searchAssets,
              itemDisplayMapper: (asset) => asset.assetTag,
              itemValueMapper: (asset) => asset.id,
              itemSubtitleMapper: (asset) => asset.assetName,
              itemIcon: Icons.inventory,
              validator: (value) => IssueReportUpsertValidator.validateAssetId(
                value,
                context: context,
                isUpdate: _isEdit,
              ),
            ),
            const SizedBox(height: 16),
            AppSearchField<User>(
              name: 'reportedById',
              label: context.l10n.issueReportReportedBy,
              hintText: context.l10n.issueReportSearchReportedBy,
              initialValue:
                  (_isEdit ? _fetchedIssueReport?.reportedById : null) ??
                  widget.issueReport?.reportedById,
              enableAutocomplete: true,
              onSearch: _searchUsers,
              itemDisplayMapper: (user) => user.name,
              itemValueMapper: (user) => user.id,
              itemSubtitleMapper: (user) => user.email,
              itemIcon: Icons.person,
              validator: (value) =>
                  IssueReportUpsertValidator.validateReportedById(
                    value,
                    context: context,
                    isUpdate: _isEdit,
                  ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              name: 'issueType',
              label: context.l10n.issueReportIssueType,
              placeHolder: context.l10n.issueReportEnterIssueType,
              initialValue:
                  (_isEdit ? _fetchedIssueReport?.issueType : null) ??
                  widget.issueReport?.issueType,
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
              initialValue:
                  (_isEdit ? _fetchedIssueReport?.priority.value : null) ??
                  widget.issueReport?.priority.value,
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
                initialValue:
                    _fetchedIssueReport?.status.value ??
                    widget.issueReport?.status.value,
                validator: (value) => IssueReportUpsertValidator.validateStatus(
                  value,
                  context: context,
                  isUpdate: _isEdit,
                ),
              ),
              const SizedBox(height: 16),
              AppSearchField<User>(
                name: 'resolvedBy',
                label: context.l10n.issueReportResolvedBy,
                hintText: context.l10n.issueReportSearchResolvedBy,
                initialValue:
                    _fetchedIssueReport?.resolvedById ??
                    widget.issueReport?.resolvedById,
                enableAutocomplete: true,
                onSearch: _searchUsers,
                itemDisplayMapper: (user) => user.name,
                itemValueMapper: (user) => user.id,
                itemSubtitleMapper: (user) => user.email,
                itemIcon: Icons.person,
                validator: (value) =>
                    IssueReportUpsertValidator.validateResolvedBy(
                      value,
                      context: context,
                      isUpdate: _isEdit,
                    ),
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
              AppText(
                context.l10n.issueReportTranslations,
                style: AppTextStyle.titleMedium,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),
              _buildTranslationFields('en-US', context.l10n.issueReportEnglish),
              const SizedBox(height: 12),
              _buildTranslationFields(
                'ja-JP',
                context.l10n.issueReportJapanese,
              ),
              const SizedBox(height: 12),
              _buildTranslationFields(
                'id-ID',
                context.l10n.issueReportIndonesian,
              ),
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
