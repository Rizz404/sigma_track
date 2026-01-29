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
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/shared/presentation/widgets/app_error_state.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/export_issue_report_list_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/get_issue_reports_cursor_usecase.dart';
import 'package:sigma_track/feature/issue_report/presentation/providers/issue_report_providers.dart';
import 'package:sigma_track/feature/issue_report/presentation/widgets/export_issue_reports_bottom_sheet.dart';
import 'package:sigma_track/feature/issue_report/presentation/widgets/issue_report_tile.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_list_bottom_sheet.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListIssueReportsScreen extends ConsumerStatefulWidget {
  const ListIssueReportsScreen({super.key});

  @override
  ConsumerState<ListIssueReportsScreen> createState() =>
      _ListIssueReportsScreenState();
}

class _ListIssueReportsScreenState
    extends ConsumerState<ListIssueReportsScreen> {
  final _scrollController = ScrollController();
  final _filterFormKey = GlobalKey<FormBuilderState>();
  final Set<String> _selectedIssueReportIds = {};
  bool _isSelectMode = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(issueReportsProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _selectedIssueReportIds.clear();
      _isSelectMode = false;
    });
    await ref.read(issueReportsProvider.notifier).refresh();
  }

  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => AppListOptionsBottomSheet(
        onCreate: () {
          Navigator.pop(context);
          context.push(RouteConstant.issueReportUpsert);
          this.logPresentation('Create issueReport pressed');
        },
        onSelectMany: () {
          Navigator.pop(context);
          setState(() {
            _isSelectMode = true;
            _selectedIssueReportIds.clear();
          });
          AppToast.info(context.l10n.issueReportSelectIssueReportsToDelete);
        },
        filterSortWidgetBuilder: _buildFilterSortBottomSheet,
        exportWidgetBuilder: _buildExportBottomSheet,
        createTitle: context.l10n.issueReportCreateIssueReportTitle,
        createSubtitle: context.l10n.issueReportCreateIssueReportSubtitle,
        selectManyTitle: context.l10n.issueReportSelectManyTitle,
        selectManySubtitle: context.l10n.issueReportSelectManySubtitle,
        filterSortTitle: context.l10n.issueReportFilterAndSortTitle,
        filterSortSubtitle: context.l10n.issueReportFilterAndSortSubtitle,
        exportTitle: context.l10n.assetExportTitle,
        exportSubtitle: context.l10n.assetExportSubtitle,
      ),
    );
  }

  Widget _buildExportBottomSheet() {
    final currentFilter = ref.read(issueReportsProvider).issueReportsFilter;

    final params = ExportIssueReportListUsecaseParams(
      format: ExportFormat.pdf,
      searchQuery: currentFilter.search,
      assetId: currentFilter.assetId,
      reportedBy: currentFilter.reportedBy,
      issueType: currentFilter.issueType,
      priority: currentFilter.priority,
      status: currentFilter.status,
      startDate: currentFilter.dateFrom != null
          ? DateTime.parse(currentFilter.dateFrom!)
          : null,
      endDate: currentFilter.dateTo != null
          ? DateTime.parse(currentFilter.dateTo!)
          : null,
      sortBy: currentFilter.sortBy,
      sortOrder: currentFilter.sortOrder,
    );

    return ExportIssueReportsBottomSheet(initialParams: params);
  }

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

  Widget _buildFilterSortBottomSheet() {
    final currentFilter = ref.read(issueReportsProvider).issueReportsFilter;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: FormBuilder(
          key: _filterFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSearchField<Asset>(
                    name: 'assetId',
                    label: context.l10n.issueReportFilterByAsset,
                    hintText: context.l10n.issueReportSearchAssetFilter,
                    enableAutocomplete: true,
                    onSearch: _searchAssets,
                    itemDisplayMapper: (asset) => asset.assetName,
                    itemValueMapper: (asset) => asset.id,
                    itemSubtitleMapper: (asset) => asset.assetTag,
                    itemIcon: Icons.inventory,
                    initialItemsToShow: 5,
                    itemsPerLoadMore: 5,
                    enableLoadMore: true,
                    suggestionsMaxHeight: 300,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSearchField<User>(
                    name: 'reportedBy',
                    label: context.l10n.issueReportFilterByReportedBy,
                    hintText: context.l10n.issueReportSearchUserFilter,
                    enableAutocomplete: true,
                    onSearch: _searchUsers,
                    itemDisplayMapper: (user) => user.fullName,
                    itemValueMapper: (user) => user.id,
                    itemSubtitleMapper: (user) => user.email,
                    itemIcon: Icons.person,
                    initialItemsToShow: 5,
                    itemsPerLoadMore: 5,
                    enableLoadMore: true,
                    suggestionsMaxHeight: 300,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSearchField<User>(
                    name: 'resolvedBy',
                    label: context.l10n.issueReportFilterByResolvedBy,
                    hintText: context.l10n.issueReportSearchUserFilter,
                    enableAutocomplete: true,
                    onSearch: _searchUsers,
                    itemDisplayMapper: (user) => user.fullName,
                    itemValueMapper: (user) => user.id,
                    itemSubtitleMapper: (user) => user.email,
                    itemIcon: Icons.person,
                    initialItemsToShow: 5,
                    itemsPerLoadMore: 5,
                    enableLoadMore: true,
                    suggestionsMaxHeight: 300,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppTextField(
                name: 'issueType',
                label: context.l10n.issueReportIssueType,
                placeHolder: context.l10n.issueReportEnterIssueTypeFilter,
              ),
              const SizedBox(height: 32),
              AppText(
                context.l10n.issueReportFilterAndSortTitle,
                style: AppTextStyle.titleLarge,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 24),
              AppDropdown<String>(
                name: 'sortBy',
                label: context.l10n.issueReportSortBy,
                initialValue: currentFilter.sortBy?.value,
                items: IssueReportSortBy.values
                    .map(
                      (sortBy) => AppDropdownItem<String>(
                        value: sortBy.value,
                        label: sortBy.label,
                        icon: Icon(sortBy.icon, size: 18),
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
                      (order) => AppDropdownItem<String>(
                        value: order.value,
                        label: order.label,
                        icon: Icon(order.icon, size: 18),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              AppDropdown<String>(
                name: 'priority',
                label: context.l10n.issueReportPriority,
                initialValue: currentFilter.priority?.value,
                items: IssuePriority.values
                    .map(
                      (priority) => AppDropdownItem<String>(
                        value: priority.value,
                        label: priority.label,
                        icon: Icon(priority.icon, size: 18),
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
                      (status) => AppDropdownItem<String>(
                        value: status.value,
                        label: status.label,
                        icon: Icon(status.icon, size: 18),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              FormBuilderCheckbox(
                name: 'isResolved',
                title: AppText(context.l10n.issueReportIsResolved),
                initialValue: currentFilter.isResolved ?? false,
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                name: 'dateFrom',
                inputType: InputType.date,
                decoration: InputDecoration(
                  labelText: context.l10n.issueReportDateFrom,
                  border: const OutlineInputBorder(),
                ),
                initialValue: currentFilter.dateFrom != null
                    ? DateTime.parse(currentFilter.dateFrom!)
                    : null,
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                name: 'dateTo',
                inputType: InputType.date,
                decoration: InputDecoration(
                  labelText: context.l10n.issueReportDateTo,
                  border: const OutlineInputBorder(),
                ),
                initialValue: currentFilter.dateTo != null
                    ? DateTime.parse(currentFilter.dateTo!)
                    : null,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: context.l10n.issueReportReset,
                      color: AppButtonColor.secondary,
                      onPressed: () {
                        _filterFormKey.currentState?.reset();
                        final newFilter = GetIssueReportsCursorUsecaseParams(
                          search: currentFilter.search,
                          // * Reset semua filter kecuali search
                        );
                        Navigator.pop(context);
                        ref
                            .read(issueReportsProvider.notifier)
                            .updateFilter(newFilter);
                        AppToast.success(context.l10n.issueReportFilterReset);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text: context.l10n.issueReportApply,
                      onPressed: () {
                        if (_filterFormKey.currentState?.saveAndValidate() ??
                            false) {
                          final formData = _filterFormKey.currentState!.value;
                          final assetId = formData['assetId'] as String?;
                          final reportedBy = formData['reportedBy'] as String?;
                          final resolvedBy = formData['resolvedBy'] as String?;
                          final issueType = formData['issueType'] as String?;
                          final priorityStr = formData['priority'] as String?;
                          final statusStr = formData['status'] as String?;
                          final isResolved = formData['isResolved'] as bool?;
                          final dateFrom = formData['dateFrom'] as DateTime?;
                          final dateTo = formData['dateTo'] as DateTime?;
                          final sortByStr = formData['sortBy'] as String?;
                          final sortOrderStr = formData['sortOrder'] as String?;

                          final newFilter = GetIssueReportsCursorUsecaseParams(
                            search: currentFilter.search,
                            assetId: assetId,
                            reportedBy: reportedBy,
                            resolvedBy: resolvedBy,
                            issueType: issueType,
                            priority: priorityStr != null
                                ? IssuePriority.values.firstWhere(
                                    (e) => e.value == priorityStr,
                                  )
                                : null,
                            status: statusStr != null
                                ? IssueStatus.values.firstWhere(
                                    (e) => e.value == statusStr,
                                  )
                                : null,
                            isResolved: isResolved,
                            dateFrom: dateFrom?.toIso8601String(),
                            dateTo: dateTo?.toIso8601String(),
                            sortBy: sortByStr != null
                                ? IssueReportSortBy.values.firstWhere(
                                    (e) => e.value == sortByStr,
                                  )
                                : null,
                            sortOrder: sortOrderStr != null
                                ? SortOrder.values.firstWhere(
                                    (e) => e.value == sortOrderStr,
                                  )
                                : null,
                          );

                          Navigator.pop(context);
                          ref
                              .read(issueReportsProvider.notifier)
                              .updateFilter(newFilter);
                          AppToast.success(
                            context.l10n.issueReportFilterApplied,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleSelectIssueReport(String issueReportId) {
    setState(() {
      if (_selectedIssueReportIds.contains(issueReportId)) {
        _selectedIssueReportIds.remove(issueReportId);
      } else {
        _selectedIssueReportIds.add(issueReportId);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      final state = ref.read(issueReportsProvider);
      final allIds = state.issueReports.map((i) => i.id).toSet();

      if (_selectedIssueReportIds.containsAll(allIds)) {
        _selectedIssueReportIds.clear();
      } else {
        _selectedIssueReportIds.addAll(allIds);
      }
    });
  }

  void _cancelSelectMode() {
    setState(() {
      _isSelectMode = false;
      _selectedIssueReportIds.clear();
    });
  }

  Future<void> _deleteSelectedIssueReports() async {
    if (_selectedIssueReportIds.isEmpty) {
      AppToast.warning(context.l10n.issueReportNoIssueReportsSelected);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.issueReportDeleteIssueReports,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.issueReportDeleteMultipleConfirmation(
            _selectedIssueReportIds.length,
          ),
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(context.l10n.issueReportCancel),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.issueReportDelete,
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ref
          .read(issueReportsProvider.notifier)
          .deleteManyIssueReports(_selectedIssueReportIds.toList());
      _cancelSelectMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(issueReportsProvider);

    ref.listen(issueReportsProvider, (previous, next) {
      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(next.mutationMessage!);
      }

      // * Handle mutation error
      if (next.hasMutationError) {
        this.logError('IssueReports mutation error', next.mutationFailure);
        AppToast.error(next.mutationFailure!.message);
      }
    });

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.issueReportManagement),
      endDrawer: const AppEndDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: ScreenWrapper(
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: context.colorScheme.primary,
                child: state.isLoading
                    ? _buildLoadingState(context)
                    : state.failure != null
                    ? _buildErrorState(context, state.failure!)
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
      floatingActionButton: _isSelectMode
          ? null
          : FloatingActionButton(
              onPressed: state.isMutating ? null : _showOptionsBottomSheet,
              backgroundColor: state.isMutating
                  ? context.colors.surfaceVariant
                  : context.colorScheme.primary,
              child: state.isMutating
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.colors.textSecondary,
                      ),
                    )
                  : const Icon(Icons.menu),
            ),
      bottomNavigationBar: _isSelectMode ? _buildSelectionBar(context) : null,
    );
  }

  Widget _buildSelectionBar(BuildContext context) {
    final state = ref.watch(issueReportsProvider);
    final allIds = state.issueReports.map((i) => i.id).toSet();
    final isAllSelected =
        allIds.isNotEmpty && _selectedIssueReportIds.containsAll(allIds);

    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: _cancelSelectMode,
            ),
            IconButton(
              icon: Icon(
                isAllSelected ? Icons.deselect : Icons.select_all,
                color: Colors.white,
              ),
              onPressed: _toggleSelectAll,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppText(
                context.l10n.issueReportSelectedCount(
                  _selectedIssueReportIds.length,
                ),
                style: AppTextStyle.titleMedium,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppButton(
              text: context.l10n.issueReportDelete,
              color: AppButtonColor.error,
              isFullWidth: false,
              onPressed: _deleteSelectedIssueReports,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return AppSearchField(
      name: 'search',
      hintText: context.l10n.issueReportSearchIssueReports,
      onDebouncedChanged: (value) {
        ref.read(issueReportsProvider.notifier).search(value);
      },
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
          Icon(Icons.assessment, size: 80, color: context.colors.textDisabled),
          const SizedBox(height: 16),
          AppText(
            context.l10n.issueReportNoIssueReportsFound,
            style: AppTextStyle.titleMedium,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 8),
          AppText(
            context.l10n.issueReportCreateFirstIssueReport,
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
      issueReportsProvider.select((state) => state.isMutating),
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
        final isSelected = _selectedIssueReportIds.contains(issueReport.id);

        return Skeletonizer(
          enabled: isSkeleton,
          child: IssueReportTile(
            issueReport: issueReport,
            isDisabled: isMutating,
            isSelected: isSelected,
            onSelect: _isSelectMode
                ? (_) => _toggleSelectIssueReport(issueReport.id)
                : null,
            onLongPress: isSkeleton
                ? null
                : () {
                    if (!_isSelectMode) {
                      setState(() {
                        _isSelectMode = true;
                        _selectedIssueReportIds.clear();
                        _selectedIssueReportIds.add(issueReport.id);
                      });
                      AppToast.info(context.l10n.issueReportLongPressToSelect);
                    }
                  },
            onTap: isSkeleton || _isSelectMode
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

  Widget _buildErrorState(BuildContext context, Failure failure) {
    return AppErrorState(
      title: context.l10n.issueReportFailedToLoadData,
      description: failure.message,
      onRetry: _onRefresh,
    );
  }
}
