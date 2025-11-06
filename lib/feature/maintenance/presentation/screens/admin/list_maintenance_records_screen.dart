import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_records_cursor_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_providers.dart';
import 'package:sigma_track/feature/maintenance/presentation/widgets/maintenance_record_tile.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_date_time_picker.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_list_bottom_sheet.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListMaintenanceRecordsScreen extends ConsumerStatefulWidget {
  const ListMaintenanceRecordsScreen({super.key});

  @override
  ConsumerState<ListMaintenanceRecordsScreen> createState() =>
      _ListMaintenanceRecordsScreenState();
}

class _ListMaintenanceRecordsScreenState
    extends ConsumerState<ListMaintenanceRecordsScreen> {
  final _scrollController = ScrollController();
  final _filterFormKey = GlobalKey<FormBuilderState>();
  final Set<String> _selectedMaintenanceRecordIds = {};
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
      ref.read(maintenanceRecordsProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    _selectedMaintenanceRecordIds.clear();
    _isSelectMode = false;
    await ref.read(maintenanceRecordsProvider.notifier).refresh();
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
          context.push(RouteConstant.adminMaintenanceRecordUpsert);
          this.logPresentation('Create maintenanceRecord pressed');
        },
        onSelectMany: () {
          Navigator.pop(context);
          setState(() {
            _isSelectMode = true;
            _selectedMaintenanceRecordIds.clear();
          });
          AppToast.info(context.l10n.maintenanceRecordSelectToDelete);
        },
        filterSortWidgetBuilder: _buildFilterSortBottomSheet,
        createTitle: context.l10n.maintenanceRecordCreateTitle,
        createSubtitle: context.l10n.maintenanceRecordCreateSubtitle,
        selectManyTitle: context.l10n.maintenanceRecordSelectManyTitle,
        selectManySubtitle: context.l10n.maintenanceRecordSelectManySubtitle,
        filterSortTitle: context.l10n.maintenanceRecordFilterAndSortTitle,
        filterSortSubtitle: context.l10n.maintenanceRecordFilterAndSortSubtitle,
      ),
    );
  }

  Widget _buildFilterSortBottomSheet() {
    final currentFilter = ref
        .read(maintenanceRecordsProvider)
        .maintenanceRecordsFilter;

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
              const SizedBox(height: 24),
              AppText(
                context.l10n.maintenanceRecordFilterAndSortTitle,
                style: AppTextStyle.titleLarge,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 24),
              AppDropdown<String>(
                name: 'sortBy',
                label: context.l10n.maintenanceRecordSortBy,
                initialValue: currentFilter.sortBy?.value,
                items: MaintenanceRecordSortBy.values
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
                label: context.l10n.maintenanceRecordSortOrder,
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
              AppTextField(
                name: 'vendorName',
                label: 'Vendor Name',
                placeHolder: 'Enter vendor name...',
                initialValue: currentFilter.vendorName,
              ),
              const SizedBox(height: 16),
              AppDateTimePicker(
                name: 'fromDate',
                label: 'From Date',
                inputType: InputType.date,
                initialValue: currentFilter.fromDate != null
                    ? DateTime.parse(currentFilter.fromDate!)
                    : null,
              ),
              const SizedBox(height: 16),
              AppDateTimePicker(
                name: 'toDate',
                label: 'To Date',
                inputType: InputType.date,
                initialValue: currentFilter.toDate != null
                    ? DateTime.parse(currentFilter.toDate!)
                    : null,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: context.l10n.maintenanceRecordReset,
                      color: AppButtonColor.secondary,
                      onPressed: () {
                        _filterFormKey.currentState?.reset();
                        final newFilter =
                            GetMaintenanceRecordsCursorUsecaseParams(
                              search: currentFilter.search,
                              // * Reset semua filter kecuali search
                            );
                        Navigator.pop(context);
                        ref
                            .read(maintenanceRecordsProvider.notifier)
                            .updateFilter(newFilter);
                        AppToast.success(
                          context.l10n.maintenanceRecordFilterReset,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text: context.l10n.maintenanceRecordApply,
                      onPressed: () {
                        if (_filterFormKey.currentState?.saveAndValidate() ??
                            false) {
                          final formData = _filterFormKey.currentState!.value;
                          final sortByStr = formData['sortBy'] as String?;
                          final sortOrderStr = formData['sortOrder'] as String?;
                          final vendorName = formData['vendorName'] as String?;
                          final fromDate = formData['fromDate'] as DateTime?;
                          final toDate = formData['toDate'] as DateTime?;

                          final newFilter =
                              GetMaintenanceRecordsCursorUsecaseParams(
                                search: currentFilter.search,
                                sortBy: sortByStr != null
                                    ? MaintenanceRecordSortBy.values.firstWhere(
                                        (e) => e.value == sortByStr,
                                      )
                                    : null,
                                sortOrder: sortOrderStr != null
                                    ? SortOrder.values.firstWhere(
                                        (e) => e.value == sortOrderStr,
                                      )
                                    : null,
                                vendorName: vendorName,
                                fromDate: fromDate?.toIso8601String(),
                                toDate: toDate?.toIso8601String(),
                              );

                          Navigator.pop(context);
                          ref
                              .read(maintenanceRecordsProvider.notifier)
                              .updateFilter(newFilter);
                          AppToast.success(
                            context.l10n.maintenanceRecordFilterApplied,
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

  void _toggleSelectMaintenanceRecord(String maintenanceRecordId) {
    setState(() {
      if (_selectedMaintenanceRecordIds.contains(maintenanceRecordId)) {
        _selectedMaintenanceRecordIds.remove(maintenanceRecordId);
      } else {
        _selectedMaintenanceRecordIds.add(maintenanceRecordId);
      }
    });
  }

  void _cancelSelectMode() {
    setState(() {
      _isSelectMode = false;
      _selectedMaintenanceRecordIds.clear();
    });
  }

  Future<void> _deleteSelectedMaintenanceRecords() async {
    if (_selectedMaintenanceRecordIds.isEmpty) {
      AppToast.warning(context.l10n.maintenanceRecordNoRecordsSelected);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.maintenanceRecordDeleteRecords,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.maintenanceRecordDeleteMultipleConfirmation(
            _selectedMaintenanceRecordIds.length,
          ),
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(context.l10n.maintenanceRecordCancel),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.maintenanceRecordDelete,
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Todo: Implementasi di backend
      AppToast.info(context.l10n.maintenanceRecordNotImplementedYet);
      _cancelSelectMode();
      await _onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(maintenanceRecordsProvider);

    ref.listen(maintenanceRecordsProvider, (previous, next) {
      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(next.mutationMessage!);
      }

      // * Handle mutation error
      if (next.hasMutationError) {
        this.logError(
          'MaintenanceRecords mutation error',
          next.mutationFailure,
        );
        AppToast.error(next.mutationFailure!.message);
      }
    });

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.maintenanceRecordManagement),
      endDrawer: const AppEndDrawer(),
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
                    : state.maintenanceRecords.isEmpty
                    ? _buildEmptyState(context)
                    : _buildMaintenanceRecordsList(
                        state.maintenanceRecords,
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
            const SizedBox(width: 8),
            Expanded(
              child: AppText(
                context.l10n.maintenanceRecordSelectedCount(
                  _selectedMaintenanceRecordIds.length,
                ),
                style: AppTextStyle.titleMedium,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppButton(
              text: context.l10n.maintenanceRecordDelete,
              color: AppButtonColor.error,
              isFullWidth: false,
              onPressed: _deleteSelectedMaintenanceRecords,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return AppSearchField(
      name: 'search',
      hintText: context.l10n.maintenanceRecordSearch,
      onChanged: (value) {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          ref.read(maintenanceRecordsProvider.notifier).search(value);
        });
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final dummyMaintenanceRecords = List.generate(
      6,
      (_) => MaintenanceRecord.dummy(),
    );
    return Skeletonizer(
      enabled: true,
      child: _buildMaintenanceRecordsList(dummyMaintenanceRecords),
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
            context.l10n.maintenanceRecordNoRecordsFound,
            style: AppTextStyle.titleMedium,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 8),
          AppText(
            context.l10n.maintenanceRecordCreateFirstRecord,
            style: AppTextStyle.bodyMedium,
            color: context.colors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceRecordsList(
    List<MaintenanceRecord> maintenanceRecords, [
    bool isLoadingMore = false,
  ]) {
    final isMutating = ref.watch(
      maintenanceRecordsProvider.select((state) => state.isMutating),
    );

    final displayMaintenanceRecords = isLoadingMore
        ? maintenanceRecords +
              List.generate(2, (_) => MaintenanceRecord.dummy())
        : maintenanceRecords;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: displayMaintenanceRecords.length,
      itemBuilder: (context, index) {
        final maintenanceRecord = displayMaintenanceRecords[index];
        final isSkeleton = isLoadingMore && index >= maintenanceRecords.length;
        final isSelected = _selectedMaintenanceRecordIds.contains(
          maintenanceRecord.id,
        );

        return Skeletonizer(
          enabled: isSkeleton,
          child: MaintenanceRecordTile(
            maintenanceRecord: maintenanceRecord,
            isDisabled: isMutating,
            isSelected: isSelected,
            onSelect: _isSelectMode
                ? (_) => _toggleSelectMaintenanceRecord(maintenanceRecord.id)
                : null,
            onLongPress: isSkeleton
                ? null
                : () {
                    if (!_isSelectMode) {
                      setState(() {
                        _isSelectMode = true;
                        _selectedMaintenanceRecordIds.clear();
                        _selectedMaintenanceRecordIds.add(maintenanceRecord.id);
                      });
                      AppToast.info(
                        context.l10n.maintenanceRecordLongPressToSelect,
                      );
                    }
                  },
            onTap: isSkeleton || _isSelectMode
                ? null
                : () {
                    this.logPresentation(
                      'MaintenanceRecord tapped: ${maintenanceRecord.id}',
                    );
                    context.push(
                      RouteConstant.maintenanceRecordDetail,
                      extra: maintenanceRecord,
                    );
                  },
          ),
        );
      },
    );
  }
}
