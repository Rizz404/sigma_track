import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/get_issue_reports_cursor_usecase.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/issue_report_providers.dart';
import 'package:sigma_track/feature/issue_report/presentation/widgets/issue_report_tile.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyListIssueReportsScreen extends ConsumerStatefulWidget {
  const MyListIssueReportsScreen({super.key});

  @override
  ConsumerState<MyListIssueReportsScreen> createState() =>
      _MyListIssueReportsScreenState();
}

class _MyListIssueReportsScreenState
    extends ConsumerState<MyListIssueReportsScreen> {
  final _scrollController = ScrollController();
  final _filterFormKey = GlobalKey<FormBuilderState>();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(myIssueReportsProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(myIssueReportsProvider.notifier).refresh();
  }

  void _applyFilter() {
    if (_filterFormKey.currentState?.saveAndValidate() ?? false) {
      final formData = _filterFormKey.currentState!.value;

      final newFilter = GetIssueReportsCursorUsecaseParams(
        priority: formData['priority'] != null
            ? IssuePriority.values.firstWhere(
                (e) => e.value == formData['priority'],
              )
            : null,
        status: formData['status'] != null
            ? IssueStatus.values.firstWhere(
                (e) => e.value == formData['status'],
              )
            : null,
        issueType: formData['issueType']?.isNotEmpty == true
            ? formData['issueType']
            : null,
        sortBy: formData['sortBy'] != null
            ? IssueReportSortBy.values.firstWhere(
                (e) => e.value == formData['sortBy'],
              )
            : null,
        sortOrder: formData['sortOrder'] != null
            ? SortOrder.values.firstWhere(
                (e) => e.value == formData['sortOrder'],
              )
            : null,
      );

      ref.read(myIssueReportsProvider.notifier).updateFilter(newFilter);
    }
  }

  void _showFilterBottomSheet() {
    final currentFilter = ref.read(myIssueReportsProvider).issueReportsFilter;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      context.l10n.issueReportFiltersAndSorting,
                      style: AppTextStyle.titleMedium,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: FormBuilder(
                  key: _filterFormKey,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      AppDropdown<String>(
                        name: 'priority',
                        label: context.l10n.issueReportPriority,
                        initialValue: currentFilter.priority?.value,
                        items: IssuePriority.values
                            .map(
                              (priority) => AppDropdownItem(
                                value: priority.value,
                                label: priority.label,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      AppDropdown<String>(
                        name: 'status',
                        label: context.l10n.issueReportStatus,
                        initialValue: currentFilter.status?.value,
                        items: IssueStatus.values
                            .map(
                              (status) => AppDropdownItem(
                                value: status.value,
                                label: status.label,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        name: 'issueType',
                        label: context.l10n.issueReportIssueType,
                        placeHolder:
                            context.l10n.issueReportEnterIssueTypeFilter,
                        initialValue: currentFilter.issueType,
                      ),
                      const SizedBox(height: 16),
                      AppDropdown<String>(
                        name: 'sortBy',
                        label: context.l10n.issueReportSortBy,
                        initialValue: currentFilter.sortBy?.value,
                        items: IssueReportSortBy.values
                            .map(
                              (sortBy) => AppDropdownItem(
                                value: sortBy.value,
                                label: sortBy.value,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      AppDropdown<String>(
                        name: 'sortOrder',
                        label: context.l10n.issueReportSortOrder,
                        initialValue: currentFilter.sortOrder?.value,
                        items: SortOrder.values
                            .map(
                              (sortOrder) => AppDropdownItem(
                                value: sortOrder.value,
                                label: sortOrder.label,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        text: context.l10n.issueReportApplyFilters,
                        onPressed: () {
                          _applyFilter();
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myIssueReportsProvider);

    ref.listen(myIssueReportsProvider, (previous, next) {
      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(next.mutationMessage!);
      }

      // * Handle mutation error
      if (next.hasMutationError) {
        this.logError('MyIssueReports mutation error', next.mutationFailure);
        AppToast.error(next.mutationFailure!.message);
      }
    });

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.issueReportMyIssueReports),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteConstant.issueReportUpsert),
        tooltip: context.l10n.issueReportCreateIssueReportTooltip,
        child: const Icon(Icons.add),
      ),
      body: ScreenWrapper(
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 12),
            _buildFilterButton(),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: context.colorScheme.primary,
                child: state.isLoading
                    ? _buildLoadingState(context)
                    : state.issueReports.isEmpty
                    ? _buildEmptyState(context)
                    : _buildIssueReportsList(
                        state.issueReports,
                        state.isLoadingMore,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return AppSearchField(
      name: 'search',
      hintText: context.l10n.issueReportSearchMyIssueReports,
      onChanged: (value) {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          ref.read(myIssueReportsProvider.notifier).search(value);
        });
      },
    );
  }

  Widget _buildFilterButton() {
    final currentFilter = ref.watch(myIssueReportsProvider).issueReportsFilter;
    final hasActiveFilters =
        currentFilter.priority != null ||
        currentFilter.status != null ||
        currentFilter.issueType != null ||
        currentFilter.sortBy != null ||
        currentFilter.sortOrder != null;

    return InkWell(
      onTap: _showFilterBottomSheet,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: hasActiveFilters
                ? context.colorScheme.primary
                : context.colors.border,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.filter_list,
              color: hasActiveFilters
                  ? context.colorScheme.primary
                  : context.colors.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppText(
                hasActiveFilters
                    ? context.l10n.issueReportFiltersApplied
                    : context.l10n.issueReportFilterAndSort,
                style: AppTextStyle.bodyMedium,
                color: hasActiveFilters
                    ? context.colorScheme.primary
                    : context.colors.textSecondary,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: hasActiveFilters
                  ? context.colorScheme.primary
                  : context.colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final dummyIssueReports = List.generate(10, (_) => IssueReport.dummy());
    return Skeletonizer(
      enabled: true,
      child: _buildIssueReportsList(dummyIssueReports),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.report_problem,
            size: 80,
            color: context.colors.textDisabled,
          ),
          const SizedBox(height: 16),
          AppText(
            context.l10n.issueReportNoIssueReportsFoundEmpty,
            style: AppTextStyle.titleMedium,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 8),
          AppText(
            context.l10n.issueReportYouHaveNoReportedIssues,
            style: AppTextStyle.bodyMedium,
            color: context.colors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildIssueReportsList(
    List<IssueReport> issueReports, [
    bool isLoadingMore = false,
  ]) {
    final isMutating = ref.watch(
      myIssueReportsProvider.select((state) => state.isMutating),
    );

    final displayIssueReports = isLoadingMore
        ? issueReports + List.generate(2, (_) => IssueReport.dummy())
        : issueReports;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: displayIssueReports.length,
      itemBuilder: (context, index) {
        final issueReport = displayIssueReports[index];
        final isSkeleton = isLoadingMore && index >= issueReports.length;

        return Skeletonizer(
          enabled: isSkeleton,
          child: IssueReportTile(
            issueReport: issueReport,
            isDisabled: isMutating,
            onTap: isSkeleton
                ? null
                : () {
                    this.logPresentation(
                      'IssueReport tapped: ${issueReport.id}',
                    );
                    context.push(
                      RouteConstant.issueReportDetail,
                      extra: issueReport,
                    );
                  },
          ),
        );
      },
    );
  }
}
