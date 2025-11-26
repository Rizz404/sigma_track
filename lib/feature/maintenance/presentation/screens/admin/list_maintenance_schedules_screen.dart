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
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/export_maintenance_schedule_list_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedules_cursor_usecase.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_providers.dart';
import 'package:sigma_track/feature/maintenance/presentation/widgets/export_maintenance_schedules_bottom_sheet.dart';
import 'package:sigma_track/feature/maintenance/presentation/widgets/maintenance_schedule_tile.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_date_time_picker.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_list_bottom_sheet.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListMaintenanceSchedulesScreen extends ConsumerStatefulWidget {
  const ListMaintenanceSchedulesScreen({super.key});

  @override
  ConsumerState<ListMaintenanceSchedulesScreen> createState() =>
      _ListMaintenanceSchedulesScreenState();
}

class _ListMaintenanceSchedulesScreenState
    extends ConsumerState<ListMaintenanceSchedulesScreen> {
  final _scrollController = ScrollController();
  final _filterFormKey = GlobalKey<FormBuilderState>();
  final Set<String> _selectedMaintenanceScheduleIds = {};
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
      ref.read(maintenanceSchedulesProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    _selectedMaintenanceScheduleIds.clear();
    _isSelectMode = false;
    await ref.read(maintenanceSchedulesProvider.notifier).refresh();
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
          context.push(RouteConstant.adminMaintenanceScheduleUpsert);
          this.logPresentation('Create maintenanceSchedule pressed');
        },
        onSelectMany: () {
          Navigator.pop(context);
          setState(() {
            _isSelectMode = true;
            _selectedMaintenanceScheduleIds.clear();
          });
          AppToast.info(context.l10n.maintenanceScheduleSelectToDelete);
        },
        filterSortWidgetBuilder: _buildFilterSortBottomSheet,
        exportWidgetBuilder: _buildExportBottomSheet,
        createTitle: context.l10n.maintenanceScheduleCreateTitle,
        createSubtitle: context.l10n.maintenanceScheduleCreateSubtitle,
        selectManyTitle: context.l10n.maintenanceScheduleSelectManyTitle,
        selectManySubtitle: context.l10n.maintenanceScheduleSelectManySubtitle,
        filterSortTitle: context.l10n.maintenanceScheduleFilterAndSortTitle,
        filterSortSubtitle:
            context.l10n.maintenanceScheduleFilterAndSortSubtitle,
        exportTitle: context.l10n.assetExportTitle,
        exportSubtitle: context.l10n.assetExportSubtitle,
      ),
    );
  }

  Widget _buildExportBottomSheet() {
    final currentFilter = ref
        .read(maintenanceSchedulesProvider)
        .maintenanceSchedulesFilter;

    final params = ExportMaintenanceScheduleListUsecaseParams(
      format: ExportFormat.pdf,
      searchQuery: currentFilter.search,
      maintenanceType: currentFilter.maintenanceType,
      state: currentFilter.state,
      startDate: currentFilter.fromDate != null
          ? DateTime.parse(currentFilter.fromDate!)
          : null,
      endDate: currentFilter.toDate != null
          ? DateTime.parse(currentFilter.toDate!)
          : null,
      sortBy: currentFilter.sortBy,
      sortOrder: currentFilter.sortOrder,
    );

    return ExportMaintenanceSchedulesBottomSheet(initialParams: params);
  }

  Widget _buildFilterSortBottomSheet() {
    final currentFilter = ref
        .read(maintenanceSchedulesProvider)
        .maintenanceSchedulesFilter;

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
                context.l10n.maintenanceScheduleFilterAndSortTitle,
                style: AppTextStyle.titleLarge,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 24),
              AppDropdown<String>(
                name: 'sortBy',
                label: context.l10n.maintenanceScheduleSortBy,
                initialValue: currentFilter.sortBy?.value,
                items: MaintenanceScheduleSortBy.values
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
                label: context.l10n.maintenanceScheduleSortOrder,
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
                name: 'maintenanceType',
                label: context.l10n.maintenanceScheduleMaintenanceType,
                initialValue: currentFilter.maintenanceType?.value,
                items: MaintenanceScheduleType.values
                    .map(
                      (type) => AppDropdownItem<String>(
                        value: type.value,
                        label: type.label,
                        icon: Icon(type.icon, size: 18),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              AppDropdown<String>(
                name: 'state',
                label: context.l10n.maintenanceScheduleState,
                initialValue: currentFilter.state?.value,
                items: ScheduleState.values
                    .map(
                      (state) => AppDropdownItem<String>(
                        value: state.value,
                        label: state.label,
                        icon: Icon(state.icon, size: 18),
                      ),
                    )
                    .toList(),
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
                      text: context.l10n.maintenanceScheduleReset,
                      color: AppButtonColor.secondary,
                      onPressed: () {
                        _filterFormKey.currentState?.reset();
                        final newFilter =
                            GetMaintenanceSchedulesCursorUsecaseParams(
                              search: currentFilter.search,
                              // * Reset semua filter kecuali search
                            );
                        Navigator.pop(context);
                        ref
                            .read(maintenanceSchedulesProvider.notifier)
                            .updateFilter(newFilter);
                        AppToast.success(
                          context.l10n.maintenanceScheduleFilterReset,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text: context.l10n.maintenanceScheduleApply,
                      onPressed: () {
                        if (_filterFormKey.currentState?.saveAndValidate() ??
                            false) {
                          final formData = _filterFormKey.currentState!.value;
                          final sortByStr = formData['sortBy'] as String?;
                          final sortOrderStr = formData['sortOrder'] as String?;
                          final maintenanceTypeStr =
                              formData['maintenanceType'] as String?;
                          final stateStr = formData['state'] as String?;
                          final fromDate = formData['fromDate'] as DateTime?;
                          final toDate = formData['toDate'] as DateTime?;

                          final newFilter =
                              GetMaintenanceSchedulesCursorUsecaseParams(
                                search: currentFilter.search,
                                sortBy: sortByStr != null
                                    ? MaintenanceScheduleSortBy.values
                                          .firstWhere(
                                            (e) => e.value == sortByStr,
                                          )
                                    : null,
                                sortOrder: sortOrderStr != null
                                    ? SortOrder.values.firstWhere(
                                        (e) => e.value == sortOrderStr,
                                      )
                                    : null,
                                maintenanceType: maintenanceTypeStr != null
                                    ? MaintenanceScheduleType.values.firstWhere(
                                        (e) => e.value == maintenanceTypeStr,
                                      )
                                    : null,
                                state: stateStr != null
                                    ? ScheduleState.values.firstWhere(
                                        (e) => e.value == stateStr,
                                      )
                                    : null,
                                fromDate: fromDate?.toIso8601String(),
                                toDate: toDate?.toIso8601String(),
                              );

                          Navigator.pop(context);
                          ref
                              .read(maintenanceSchedulesProvider.notifier)
                              .updateFilter(newFilter);
                          AppToast.success(
                            context.l10n.maintenanceScheduleFilterApplied,
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

  void _toggleSelectMaintenanceSchedule(String maintenanceScheduleId) {
    setState(() {
      if (_selectedMaintenanceScheduleIds.contains(maintenanceScheduleId)) {
        _selectedMaintenanceScheduleIds.remove(maintenanceScheduleId);
      } else {
        _selectedMaintenanceScheduleIds.add(maintenanceScheduleId);
      }
    });
  }

  void _cancelSelectMode() {
    setState(() {
      _isSelectMode = false;
      _selectedMaintenanceScheduleIds.clear();
    });
  }

  Future<void> _deleteSelectedMaintenanceSchedules() async {
    if (_selectedMaintenanceScheduleIds.isEmpty) {
      AppToast.warning(context.l10n.maintenanceScheduleNoSchedulesSelected);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.maintenanceScheduleDeleteSchedules,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.maintenanceScheduleDeleteMultipleConfirmation(
            _selectedMaintenanceScheduleIds.length,
          ),
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(context.l10n.maintenanceScheduleCancel),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.maintenanceScheduleDelete,
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Todo: Implementasi di backend
      AppToast.info(context.l10n.maintenanceScheduleNotImplementedYet);
      _cancelSelectMode();
      await _onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(maintenanceSchedulesProvider);

    ref.listen(maintenanceSchedulesProvider, (previous, next) {
      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(next.mutationMessage!);
      }

      // * Handle mutation error
      if (next.hasMutationError) {
        this.logError(
          'MaintenanceSchedules mutation error',
          next.mutationFailure,
        );
        AppToast.error(next.mutationFailure!.message);
      }
    });

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.maintenanceScheduleManagement),
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
                    : state.maintenanceSchedules.isEmpty
                    ? _buildEmptyState(context)
                    : _buildMaintenanceSchedulesList(
                        state.maintenanceSchedules,
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
                context.l10n.maintenanceScheduleSelectedCount(
                  _selectedMaintenanceScheduleIds.length,
                ),
                style: AppTextStyle.titleMedium,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppButton(
              text: context.l10n.maintenanceScheduleDelete,
              color: AppButtonColor.error,
              isFullWidth: false,
              onPressed: _deleteSelectedMaintenanceSchedules,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return AppSearchField(
      name: 'search',
      hintText: context.l10n.maintenanceScheduleSearch,
      onChanged: (value) {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          ref.read(maintenanceSchedulesProvider.notifier).search(value);
        });
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final dummyMaintenanceSchedules = List.generate(
      6,
      (_) => MaintenanceSchedule.dummy(),
    );
    return Skeletonizer(
      enabled: true,
      child: _buildMaintenanceSchedulesList(dummyMaintenanceSchedules),
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
            context.l10n.maintenanceScheduleNoSchedulesFound,
            style: AppTextStyle.titleMedium,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 8),
          AppText(
            context.l10n.maintenanceScheduleCreateFirstSchedule,
            style: AppTextStyle.bodyMedium,
            color: context.colors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceSchedulesList(
    List<MaintenanceSchedule> maintenanceSchedules, [
    bool isLoadingMore = false,
  ]) {
    final isMutating = ref.watch(
      maintenanceSchedulesProvider.select((state) => state.isMutating),
    );

    final displayMaintenanceSchedules = isLoadingMore
        ? maintenanceSchedules +
              List.generate(2, (_) => MaintenanceSchedule.dummy())
        : maintenanceSchedules;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: displayMaintenanceSchedules.length,
      itemBuilder: (context, index) {
        final maintenanceSchedule = displayMaintenanceSchedules[index];
        final isSkeleton =
            isLoadingMore && index >= maintenanceSchedules.length;
        final isSelected = _selectedMaintenanceScheduleIds.contains(
          maintenanceSchedule.id,
        );

        return Skeletonizer(
          enabled: isSkeleton,
          child: MaintenanceScheduleTile(
            maintenanceSchedule: maintenanceSchedule,
            isDisabled: isMutating,
            isSelected: isSelected,
            onSelect: _isSelectMode
                ? (_) =>
                      _toggleSelectMaintenanceSchedule(maintenanceSchedule.id)
                : null,
            onLongPress: isSkeleton
                ? null
                : () {
                    if (!_isSelectMode) {
                      setState(() {
                        _isSelectMode = true;
                        _selectedMaintenanceScheduleIds.clear();
                        _selectedMaintenanceScheduleIds.add(
                          maintenanceSchedule.id,
                        );
                      });
                      AppToast.info(
                        context.l10n.maintenanceScheduleLongPressToSelect,
                      );
                    }
                  },
            onTap: isSkeleton || _isSelectMode
                ? null
                : () {
                    this.logPresentation(
                      'MaintenanceSchedule tapped: ${maintenanceSchedule.id}',
                    );
                    context.push(
                      RouteConstant.maintenanceScheduleDetail,
                      extra: maintenanceSchedule,
                    );
                  },
          ),
        );
      },
    );
  }
}
