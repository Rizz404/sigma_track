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
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/shared/presentation/widgets/app_error_state.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_locations_cursor_usecase.dart';
import 'package:sigma_track/feature/location/presentation/providers/location_providers.dart';
import 'package:sigma_track/feature/location/presentation/widgets/location_card.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_list_bottom_sheet.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListLocationsScreen extends ConsumerStatefulWidget {
  const ListLocationsScreen({super.key});

  @override
  ConsumerState<ListLocationsScreen> createState() =>
      _ListLocationsScreenState();
}

class _ListLocationsScreenState extends ConsumerState<ListLocationsScreen> {
  final _scrollController = ScrollController();
  final _filterFormKey = GlobalKey<FormBuilderState>();
  final Set<String> _selectedLocationIds = {};
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
      ref.read(locationsProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    _selectedLocationIds.clear();
    _isSelectMode = false;
    await ref.read(locationsProvider.notifier).refresh();
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
          context.push(RouteConstant.adminLocationUpsert);
          this.logPresentation('Create location pressed');
        },
        onSelectMany: () {
          Navigator.pop(context);
          setState(() {
            _isSelectMode = true;
            _selectedLocationIds.clear();
          });
          AppToast.info(context.l10n.locationSelectLocationsToDelete);
        },
        filterSortWidgetBuilder: _buildFilterSortBottomSheet,
        createTitle: context.l10n.locationCreateLocationTitle,
        createSubtitle: context.l10n.locationCreateLocationSubtitle,
        selectManyTitle: context.l10n.locationSelectManyTitle,
        selectManySubtitle: context.l10n.locationSelectManySubtitle,
        filterSortTitle: context.l10n.locationFilterAndSortTitle,
        filterSortSubtitle: context.l10n.locationFilterAndSortSubtitle,
      ),
    );
  }

  Widget _buildFilterSortBottomSheet() {
    final currentFilter = ref.read(locationsProvider).locationsFilter;

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
                context.l10n.locationFilterAndSortTitle,
                style: AppTextStyle.titleLarge,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 24),
              AppDropdown<String>(
                name: 'sortBy',
                label: context.l10n.locationSortBy,
                initialValue: currentFilter.sortBy?.value,
                items: LocationSortBy.values
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
                label: context.l10n.locationSortOrder,
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
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: context.l10n.locationReset,
                      color: AppButtonColor.secondary,
                      onPressed: () {
                        _filterFormKey.currentState?.reset();
                        final newFilter = GetLocationsCursorUsecaseParams(
                          search: currentFilter.search,
                          // * Reset semua filter kecuali search
                        );
                        Navigator.pop(context);
                        ref
                            .read(locationsProvider.notifier)
                            .updateFilter(newFilter);
                        AppToast.success(context.l10n.locationFilterReset);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text: context.l10n.locationApply,
                      onPressed: () {
                        if (_filterFormKey.currentState?.saveAndValidate() ??
                            false) {
                          final formData = _filterFormKey.currentState!.value;
                          final sortByStr = formData['sortBy'] as String?;
                          final sortOrderStr = formData['sortOrder'] as String?;

                          final newFilter = GetLocationsCursorUsecaseParams(
                            search: currentFilter.search,
                            sortBy: sortByStr != null
                                ? LocationSortBy.values.firstWhere(
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
                              .read(locationsProvider.notifier)
                              .updateFilter(newFilter);
                          AppToast.success(context.l10n.locationFilterApplied);
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

  void _toggleSelectLocation(String locationId) {
    setState(() {
      if (_selectedLocationIds.contains(locationId)) {
        _selectedLocationIds.remove(locationId);
      } else {
        _selectedLocationIds.add(locationId);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      final state = ref.read(locationsProvider);
      final allIds = state.locations.map((l) => l.id).toSet();

      if (_selectedLocationIds.containsAll(allIds)) {
        _selectedLocationIds.clear();
      } else {
        _selectedLocationIds.addAll(allIds);
      }
    });
  }

  void _cancelSelectMode() {
    setState(() {
      _isSelectMode = false;
      _selectedLocationIds.clear();
    });
  }

  Future<void> _deleteSelectedLocations() async {
    if (_selectedLocationIds.isEmpty) {
      AppToast.warning(context.l10n.locationNoLocationsSelected);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.locationDeleteLocations,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.locationDeleteMultipleConfirmation(
            _selectedLocationIds.length,
          ),
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(context.l10n.locationCancel),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.locationDelete,
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ref
          .read(locationsProvider.notifier)
          .deleteManyLocations(_selectedLocationIds.toList());
      _cancelSelectMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationsProvider);

    ref.listen(locationsProvider, (previous, next) {
      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(next.mutationMessage!);
      }

      // * Handle mutation error
      if (next.hasMutationError) {
        this.logError('Locations mutation error', next.mutationFailure);
        AppToast.error(next.mutationFailure!.message);
      }
    });

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.locationManagement),
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
                    : state.locations.isEmpty
                    ? _buildEmptyState(context)
                    : _buildLocationsGrid(state.locations, state.isLoadingMore),
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
    final state = ref.watch(locationsProvider);
    final allIds = state.locations.map((l) => l.id).toSet();
    final isAllSelected =
        allIds.isNotEmpty && _selectedLocationIds.containsAll(allIds);

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
                context.l10n.locationSelectedCount(_selectedLocationIds.length),
                style: AppTextStyle.titleMedium,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppButton(
              text: context.l10n.locationDelete,
              color: AppButtonColor.error,
              isFullWidth: false,
              onPressed: _deleteSelectedLocations,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return AppSearchField(
      name: 'search',
      hintText: context.l10n.locationSearchLocations,
      onChanged: (value) {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          ref.read(locationsProvider.notifier).search(value);
        });
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final dummyLocations = List.generate(10, (_) => Location.dummy());
    return Skeletonizer(
      enabled: true,
      child: _buildLocationsGrid(dummyLocations),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_city_outlined,
            size: 80,
            color: context.colors.textDisabled,
          ),
          const SizedBox(height: 16),
          AppText(
            context.l10n.locationNoLocationsFound,
            style: AppTextStyle.titleMedium,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 8),
          AppText(
            context.l10n.locationCreateFirstLocation,
            style: AppTextStyle.bodyMedium,
            color: context.colors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationsGrid(
    List<Location> locations, [
    bool isLoadingMore = false,
  ]) {
    final isMutating = ref.watch(
      locationsProvider.select((state) => state.isMutating),
    );

    final displayLocations = isLoadingMore
        ? locations + List.generate(2, (_) => Location.dummy())
        : locations;

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: displayLocations.length,
      itemBuilder: (context, index) {
        final location = displayLocations[index];
        final isSkeleton = isLoadingMore && index >= locations.length;
        final isSelected = _selectedLocationIds.contains(location.id);

        return Skeletonizer(
          enabled: isSkeleton,
          child: LocationCard(
            location: location,
            isDisabled: isMutating,
            isSelected: isSelected,
            onSelect: _isSelectMode
                ? (_) => _toggleSelectLocation(location.id)
                : null,
            onLongPress: isSkeleton
                ? null
                : () {
                    if (!_isSelectMode) {
                      setState(() {
                        _isSelectMode = true;
                        _selectedLocationIds.clear();
                        _selectedLocationIds.add(location.id);
                      });
                      AppToast.info(context.l10n.locationLongPressToSelect);
                    }
                  },
            onTap: isSkeleton || _isSelectMode
                ? null
                : () {
                    this.logPresentation('Location tapped: ${location.id}');
                    context.push(RouteConstant.locationDetail, extra: location);
                  },
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, Failure failure) {
    return AppErrorState(
      title: context.l10n.locationFailedToLoadData,
      description: failure.message,
      onRetry: _onRefresh,
    );
  }
}
