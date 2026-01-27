import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/shared/presentation/widgets/app_error_state.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/export_scan_log_list_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_cursor_usecase.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/scan_log_providers.dart';
import 'package:sigma_track/feature/scan_log/presentation/widgets/export_scan_logs_bottom_sheet.dart';
import 'package:sigma_track/feature/scan_log/presentation/widgets/scan_log_tile.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_list_bottom_sheet.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListScanLogsScreen extends ConsumerStatefulWidget {
  const ListScanLogsScreen({super.key});

  @override
  ConsumerState<ListScanLogsScreen> createState() => _ListScanLogsScreenState();
}

class _ListScanLogsScreenState extends ConsumerState<ListScanLogsScreen> {
  final _scrollController = ScrollController();
  final _filterFormKey = GlobalKey<FormBuilderState>();
  final Set<String> _selectedScanLogIds = {};
  bool _isSelectMode = false;
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
      ref.read(scanLogsProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    _selectedScanLogIds.clear();
    _isSelectMode = false;
    await ref.read(scanLogsProvider.notifier).refresh();
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
        onSelectMany: () {
          Navigator.pop(context);
          setState(() {
            _isSelectMode = true;
            _selectedScanLogIds.clear();
          });
          AppToast.info(context.l10n.scanLogSelectScanLogsToDelete);
        },
        filterSortWidgetBuilder: _buildFilterSortBottomSheet,
        exportWidgetBuilder: _buildExportBottomSheet,
        createTitle: context.l10n.scanLogCreateScanLog,
        createSubtitle: context.l10n.scanLogCreateScanLogSubtitle,
        selectManyTitle: context.l10n.scanLogSelectMany,
        selectManySubtitle: context.l10n.scanLogSelectManySubtitle,
        filterSortTitle: context.l10n.scanLogFilterAndSort,
        filterSortSubtitle: context.l10n.scanLogFilterAndSortSubtitle,
        exportTitle: context.l10n.assetExportTitle,
        exportSubtitle: context.l10n.assetExportSubtitle,
      ),
    );
  }

  Widget _buildExportBottomSheet() {
    final currentFilter = ref.read(scanLogsProvider).scanLogsFilter;

    final params = ExportScanLogListUsecaseParams(
      format: ExportFormat.pdf,
      searchQuery: currentFilter.search,
      assetId: currentFilter.assetId,
      userId: currentFilter.scannedBy,
      scanMethod: currentFilter.scanMethod,
      scanResult: currentFilter.scanResult,
      startDate: currentFilter.dateFrom != null
          ? DateTime.parse(currentFilter.dateFrom!)
          : null,
      endDate: currentFilter.dateTo != null
          ? DateTime.parse(currentFilter.dateTo!)
          : null,
      sortBy: currentFilter.sortBy,
      sortOrder: currentFilter.sortOrder,
    );

    return ExportScanLogsBottomSheet(initialParams: params);
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
    final currentFilter = ref.read(scanLogsProvider).scanLogsFilter;

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
                    label: context.l10n.scanLogFilterByAsset,
                    hintText: context.l10n.scanLogSearchAsset,
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
                    name: 'scannedBy',
                    label: context.l10n.scanLogFilterByScannedBy,
                    hintText: context.l10n.scanLogSearchUser,
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
              const SizedBox(height: 32),
              AppText(
                context.l10n.scanLogFiltersAndSorting,
                style: AppTextStyle.titleLarge,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 24),
              AppDropdown<String>(
                name: 'sortBy',
                label: context.l10n.scanLogSortBy,
                initialValue: currentFilter.sortBy?.value,
                items: ScanLogSortBy.values
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
                label: context.l10n.scanLogSortOrder,
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
                name: 'scanMethod',
                label: context.l10n.scanLogScanMethod,
                initialValue: currentFilter.scanMethod?.value,
                items: ScanMethodType.values
                    .map(
                      (method) => AppDropdownItem<String>(
                        value: method.value,
                        label: method.label,
                        icon: Icon(method.icon, size: 18),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              AppDropdown<String>(
                name: 'scanResult',
                label: context.l10n.scanLogScanResult,
                initialValue: currentFilter.scanResult?.value,
                items: ScanResultType.values
                    .map(
                      (result) => AppDropdownItem<String>(
                        value: result.value,
                        label: result.label,
                        icon: Icon(result.icon, size: 18),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              FormBuilderCheckbox(
                name: 'hasCoordinates',
                title: AppText(context.l10n.scanLogHasCoordinates),
                initialValue: currentFilter.hasCoordinates ?? false,
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                name: 'dateFrom',
                inputType: InputType.date,
                decoration: InputDecoration(
                  labelText: context.l10n.scanLogDateFrom,
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
                  labelText: context.l10n.scanLogDateTo,
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
                      text: context.l10n.scanLogReset,
                      color: AppButtonColor.secondary,
                      onPressed: () {
                        _filterFormKey.currentState?.reset();
                        final newFilter = GetScanLogsCursorUsecaseParams(
                          search: currentFilter.search,
                          // * Reset semua filter kecuali search
                        );
                        Navigator.pop(context);
                        ref
                            .read(scanLogsProvider.notifier)
                            .updateFilter(newFilter);
                        AppToast.success(context.l10n.scanLogFilterReset);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text: context.l10n.scanLogApply,
                      onPressed: () {
                        if (_filterFormKey.currentState?.saveAndValidate() ??
                            false) {
                          final formData = _filterFormKey.currentState!.value;
                          final assetId = formData['assetId'] as String?;
                          final scannedBy = formData['scannedBy'] as String?;
                          final scanMethodStr =
                              formData['scanMethod'] as String?;
                          final scanResultStr =
                              formData['scanResult'] as String?;
                          final hasCoordinates =
                              formData['hasCoordinates'] as bool?;
                          final dateFrom = formData['dateFrom'] as DateTime?;
                          final dateTo = formData['dateTo'] as DateTime?;
                          final sortByStr = formData['sortBy'] as String?;
                          final sortOrderStr = formData['sortOrder'] as String?;

                          final newFilter = GetScanLogsCursorUsecaseParams(
                            search: currentFilter.search,
                            assetId: assetId,
                            scannedBy: scannedBy,
                            scanMethod: scanMethodStr != null
                                ? ScanMethodType.values.firstWhere(
                                    (e) => e.value == scanMethodStr,
                                  )
                                : null,
                            scanResult: scanResultStr != null
                                ? ScanResultType.values.firstWhere(
                                    (e) => e.value == scanResultStr,
                                  )
                                : null,
                            hasCoordinates: hasCoordinates,
                            dateFrom: dateFrom?.toIso8601String(),
                            dateTo: dateTo?.toIso8601String(),
                            sortBy: sortByStr != null
                                ? ScanLogSortBy.values.firstWhere(
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
                              .read(scanLogsProvider.notifier)
                              .updateFilter(newFilter);
                          AppToast.success(context.l10n.scanLogFilterApplied);
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

  void _toggleSelectScanLog(String scanLogId) {
    setState(() {
      if (_selectedScanLogIds.contains(scanLogId)) {
        _selectedScanLogIds.remove(scanLogId);
      } else {
        _selectedScanLogIds.add(scanLogId);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      final state = ref.read(scanLogsProvider);
      final allIds = state.scanLogs.map((s) => s.id).toSet();

      if (_selectedScanLogIds.containsAll(allIds)) {
        _selectedScanLogIds.clear();
      } else {
        _selectedScanLogIds.addAll(allIds);
      }
    });
  }

  void _cancelSelectMode() {
    setState(() {
      _isSelectMode = false;
      _selectedScanLogIds.clear();
    });
  }

  Future<void> _deleteSelectedScanLogs() async {
    if (_selectedScanLogIds.isEmpty) {
      AppToast.warning(context.l10n.scanLogNoScanLogsSelected);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.scanLogDeleteScanLog,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.scanLogDeleteMultipleConfirmation(
            _selectedScanLogIds.length,
          ),
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(context.l10n.scanLogCancel),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.scanLogDelete,
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ref
          .read(scanLogsProvider.notifier)
          .deleteManyScanLogs(_selectedScanLogIds.toList());
      _cancelSelectMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scanLogsProvider);

    ref.listen(scanLogsProvider, (previous, next) {
      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(next.mutationMessage!);
      }

      // * Handle mutation error
      if (next.hasMutationError) {
        this.logError('ScanLogs mutation error', next.mutationFailure);
        AppToast.error(next.mutationFailure!.message);
      }
    });

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.scanLogManagement),
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
                    : state.scanLogs.isEmpty
                    ? _buildEmptyState(context)
                    : _buildScanLogsList(state.scanLogs, state.isLoadingMore),
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
    final state = ref.watch(scanLogsProvider);
    final allIds = state.scanLogs.map((s) => s.id).toSet();
    final isAllSelected =
        allIds.isNotEmpty && _selectedScanLogIds.containsAll(allIds);

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
                context.l10n.scanLogSelectedCount(_selectedScanLogIds.length),
                style: AppTextStyle.titleMedium,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppButton(
              text: context.l10n.scanLogDelete,
              color: AppButtonColor.error,
              isFullWidth: false,
              onPressed: _deleteSelectedScanLogs,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return AppSearchField(
      name: 'search',
      hintText: context.l10n.scanLogSearchScanLogs,
      onChanged: (value) {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          ref.read(scanLogsProvider.notifier).search(value);
        });
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final dummyScanLogs = List.generate(10, (_) => ScanLog.dummy());
    return Skeletonizer(
      enabled: true,
      child: _buildScanLogsList(dummyScanLogs),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.data_array, size: 80, color: context.colors.textDisabled),
          const SizedBox(height: 16),
          AppText(
            context.l10n.scanLogNoScanLogsFound,
            style: AppTextStyle.titleMedium,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 8),
          AppText(
            context.l10n.scanLogCreateFirstScanLog,
            style: AppTextStyle.bodyMedium,
            color: context.colors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildScanLogsList(
    List<ScanLog> scanLogs, [
    bool isLoadingMore = false,
  ]) {
    final isMutating = ref.watch(
      scanLogsProvider.select((state) => state.isMutating),
    );

    final displayScanLogs = isLoadingMore
        ? scanLogs + List.generate(2, (_) => ScanLog.dummy())
        : scanLogs;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),

      itemCount: displayScanLogs.length,
      itemBuilder: (context, index) {
        final scanLog = displayScanLogs[index];
        final isSkeleton = isLoadingMore && index >= scanLogs.length;
        final isSelected = _selectedScanLogIds.contains(scanLog.id);

        return Skeletonizer(
          enabled: isSkeleton,
          child: ScanLogTile(
            scanLog: scanLog,
            isDisabled: isMutating,
            isSelected: isSelected,
            onSelect: _isSelectMode
                ? (_) => _toggleSelectScanLog(scanLog.id)
                : null,
            onLongPress: isSkeleton
                ? null
                : () {
                    if (!_isSelectMode) {
                      setState(() {
                        _isSelectMode = true;
                        _selectedScanLogIds.clear();
                        _selectedScanLogIds.add(scanLog.id);
                      });
                      AppToast.info(context.l10n.scanLogLongPressToSelect);
                    }
                  },
            onTap: isSkeleton || _isSelectMode
                ? null
                : () {
                    this.logPresentation('ScanLog tapped: ${scanLog.id}');
                    context.push(RouteConstant.scanLogDetail, extra: scanLog);
                  },
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, Failure failure) {
    return AppErrorState(
      title: 'Gagal Memuat Data',
      description: failure.message,
      onRetry: _onRefresh,
    );
  }
}
