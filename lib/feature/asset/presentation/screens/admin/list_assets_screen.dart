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
import 'package:sigma_track/feature/asset/domain/usecases/export_asset_data_matrix_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/export_asset_list_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_cursor_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/feature/asset/presentation/widgets/asset_tile.dart';
import 'package:sigma_track/feature/asset/presentation/widgets/export_type_selection_bottom_sheet.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/presentation/providers/category_providers.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/feature/location/presentation/providers/location_providers.dart';
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

class ListAssetsScreen extends ConsumerStatefulWidget {
  const ListAssetsScreen({super.key});

  @override
  ConsumerState<ListAssetsScreen> createState() => _ListAssetsScreenState();
}

class _ListAssetsScreenState extends ConsumerState<ListAssetsScreen> {
  final _scrollController = ScrollController();
  final _filterFormKey = GlobalKey<FormBuilderState>();
  final Set<String> _selectedAssetIds = {};
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
      ref.read(assetsProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    _selectedAssetIds.clear();
    _isSelectMode = false;
    await ref.read(assetsProvider.notifier).refresh();
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
          context.push(RouteConstant.adminAssetUpsert);
          this.logPresentation('Create asset pressed');
        },
        onSelectMany: () {
          Navigator.pop(context);
          setState(() {
            _isSelectMode = true;
            _selectedAssetIds.clear();
          });
          AppToast.info(context.l10n.assetSelectAssetsToDelete);
        },
        filterSortWidgetBuilder: _buildFilterSortBottomSheet,
        exportWidgetBuilder: _buildExportBottomSheet,
        createTitle: context.l10n.assetCreateAssetTitle,
        createSubtitle: context.l10n.assetCreateAssetSubtitle,
        selectManyTitle: context.l10n.assetSelectManyTitle,
        selectManySubtitle: context.l10n.assetSelectManySubtitle,
        filterSortTitle: context.l10n.assetFilterAndSortTitle,
        filterSortSubtitle: context.l10n.assetFilterAndSortSubtitle,
        exportTitle: context.l10n.assetExportTitle,
        exportSubtitle: context.l10n.assetExportSubtitle,
      ),
    );
  }

  Future<List<Category>> _searchCategories(String query) async {
    final notifier = ref.read(categoriesSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(categoriesSearchProvider);
    return state.categories;
  }

  Future<List<Location>> _searchLocations(String query) async {
    final notifier = ref.read(locationsSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(locationsSearchProvider);
    return state.locations;
  }

  Future<List<User>> _searchUsers(String query) async {
    final notifier = ref.read(usersSearchProvider.notifier);
    await notifier.search(query);

    final state = ref.read(usersSearchProvider);
    return state.users;
  }

  Widget _buildFilterSortBottomSheet() {
    final currentFilter = ref.read(assetsProvider).assetsFilter;

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
                  AppSearchField<Category>(
                    name: 'categoryId',
                    label: context.l10n.assetFilterByCategory,
                    hintText: context.l10n.assetSearchCategory,
                    enableAutocomplete: true,
                    onSearch: _searchCategories,
                    itemDisplayMapper: (category) => category.categoryName,
                    itemValueMapper: (category) => category.id,
                    itemSubtitleMapper: (category) => category.categoryCode,
                    itemIcon: Icons.category,
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
                  AppSearchField<Location>(
                    name: 'locationId',
                    label: context.l10n.assetFilterByLocation,
                    hintText: context.l10n.assetSearchLocation,
                    enableAutocomplete: true,
                    onSearch: _searchLocations,
                    itemDisplayMapper: (location) => location.locationName,
                    itemValueMapper: (location) => location.id,
                    itemSubtitleMapper: (location) => location.locationCode,
                    itemIcon: Icons.location_on,
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
                    name: 'assignedTo',
                    label: context.l10n.assetFilterByAssignedTo,
                    hintText: context.l10n.assetSearchUser,
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
                name: 'brand',
                label: context.l10n.assetBrandLabel,
                placeHolder: context.l10n.assetEnterBrandFilter,
              ),
              const SizedBox(height: 16),
              AppTextField(
                name: 'model',
                label: context.l10n.assetModelLabel,
                placeHolder: context.l10n.assetEnterModelFilter,
              ),
              const SizedBox(height: 32),
              AppText(
                context.l10n.assetFilterAndSortTitle,
                style: AppTextStyle.titleLarge,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 24),
              AppDropdown<String>(
                name: 'sortBy',
                label: context.l10n.assetSortBy,
                initialValue: currentFilter.sortBy?.value,
                items: AssetSortBy.values
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
                label: context.l10n.assetSortOrder,
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
                name: 'status',
                label: context.l10n.assetStatus,
                initialValue: currentFilter.status?.value,
                items: AssetStatus.values
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
              AppDropdown<String>(
                name: 'condition',
                label: context.l10n.assetCondition,
                initialValue: currentFilter.condition?.value,
                items: AssetCondition.values
                    .map(
                      (condition) => AppDropdownItem<String>(
                        value: condition.value,
                        label: condition.label,
                        icon: Icon(condition.icon, size: 18),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: context.l10n.assetReset,
                      color: AppButtonColor.secondary,
                      onPressed: () {
                        _filterFormKey.currentState?.reset();
                        final newFilter = GetAssetsCursorUsecaseParams(
                          search: currentFilter.search,
                          // * Reset semua filter kecuali search
                        );
                        Navigator.pop(context);
                        ref
                            .read(assetsProvider.notifier)
                            .updateFilter(newFilter);
                        AppToast.success(context.l10n.assetFilterReset);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text: context.l10n.assetApply,
                      onPressed: () {
                        if (_filterFormKey.currentState?.saveAndValidate() ??
                            false) {
                          final formData = _filterFormKey.currentState!.value;
                          final sortByStr = formData['sortBy'] as String?;
                          final sortOrderStr = formData['sortOrder'] as String?;
                          final statusStr = formData['status'] as String?;
                          final conditionStr = formData['condition'] as String?;
                          final categoryId = formData['categoryId'] as String?;
                          final locationId = formData['locationId'] as String?;
                          final assignedTo = formData['assignedTo'] as String?;
                          final brand = formData['brand'] as String?;
                          final model = formData['model'] as String?;

                          final newFilter = GetAssetsCursorUsecaseParams(
                            search: currentFilter.search,
                            status: statusStr != null
                                ? AssetStatus.values.firstWhere(
                                    (e) => e.value == statusStr,
                                  )
                                : null,
                            condition: conditionStr != null
                                ? AssetCondition.values.firstWhere(
                                    (e) => e.value == conditionStr,
                                  )
                                : null,
                            categoryId: categoryId,
                            locationId: locationId,
                            assignedTo: assignedTo,
                            brand: brand,
                            model: model,
                            sortBy: sortByStr != null
                                ? AssetSortBy.values.firstWhere(
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
                              .read(assetsProvider.notifier)
                              .updateFilter(newFilter);
                          AppToast.success(context.l10n.assetFilterApplied);
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

  Widget _buildExportBottomSheet() {
    final currentFilter = ref.read(assetsProvider).assetsFilter;

    // * Create export params from current filter
    final listParams = ExportAssetListUsecaseParams(
      format: ExportFormat.pdf, // * Default format
      searchQuery: currentFilter.search,
      status: currentFilter.status,
      condition: currentFilter.condition,
      categoryId: currentFilter.categoryId,
      locationId: currentFilter.locationId,
      assignedTo: currentFilter.assignedTo,
      brand: currentFilter.brand,
      model: currentFilter.model,
      sortBy: currentFilter.sortBy,
      sortOrder: currentFilter.sortOrder,
    );

    final dataMatrixParams = ExportAssetDataMatrixUsecaseParams(
      format: ExportFormat.pdf, // * Data matrix hanya PDF
      searchQuery: currentFilter.search,
      status: currentFilter.status,
      condition: currentFilter.condition,
      categoryId: currentFilter.categoryId,
      locationId: currentFilter.locationId,
      assignedTo: currentFilter.assignedTo,
      brand: currentFilter.brand,
      model: currentFilter.model,
      sortBy: currentFilter.sortBy,
      sortOrder: currentFilter.sortOrder,
    );

    return ExportTypeSelectionBottomSheet(
      listParams: listParams,
      dataMatrixParams: dataMatrixParams,
    );
  }

  void _toggleSelectAsset(String assetId) {
    setState(() {
      if (_selectedAssetIds.contains(assetId)) {
        _selectedAssetIds.remove(assetId);
      } else {
        _selectedAssetIds.add(assetId);
      }
    });
  }

  void _toggleSelectAll() {
    setState(() {
      final state = ref.read(assetsProvider);
      final allIds = state.assets.map((a) => a.id).toSet();

      if (_selectedAssetIds.containsAll(allIds)) {
        _selectedAssetIds.clear();
      } else {
        _selectedAssetIds.addAll(allIds);
      }
    });
  }

  void _cancelSelectMode() {
    setState(() {
      _isSelectMode = false;
      _selectedAssetIds.clear();
    });
  }

  Future<void> _deleteSelectedAssets() async {
    if (_selectedAssetIds.isEmpty) {
      AppToast.warning(context.l10n.assetNoAssetsSelected);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: AppText(
          context.l10n.assetDeleteAssets,
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          context.l10n.assetDeleteMultipleConfirmation(
            _selectedAssetIds.length,
          ),
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: AppText(context.l10n.assetCancel),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: context.l10n.assetDelete,
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ref
          .read(assetsProvider.notifier)
          .deleteManyAssets(_selectedAssetIds.toList());
      _cancelSelectMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assetsProvider);

    ref.listen(assetsProvider, (previous, next) {
      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(next.mutationMessage!);
      }

      // * Handle mutation error
      if (next.hasMutationError) {
        this.logError('Assets mutation error', next.mutationFailure);
        AppToast.error(next.mutationFailure!.message);
      }
    });

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.assetManagement),
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
                    : state.assets.isEmpty
                    ? _buildEmptyState(context)
                    : _buildAssetsList(state.assets, state.isLoadingMore),
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
    final state = ref.watch(assetsProvider);
    final allIds = state.assets.map((a) => a.id).toSet();
    final isAllSelected =
        allIds.isNotEmpty && _selectedAssetIds.containsAll(allIds);

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
                context.l10n.assetSelectedCount(_selectedAssetIds.length),
                style: AppTextStyle.titleMedium,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppButton(
              text: context.l10n.assetDelete,
              color: AppButtonColor.error,
              isFullWidth: false,
              onPressed: _deleteSelectedAssets,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return AppSearchField(
      name: 'search',
      hintText: context.l10n.assetSearchAssets,
      onChanged: (value) {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          ref.read(assetsProvider.notifier).search(value);
        });
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final dummyAssets = List.generate(10, (_) => Asset.dummy());
    return Skeletonizer(enabled: true, child: _buildAssetsList(dummyAssets));
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assessment, size: 80, color: context.colors.textDisabled),
          const SizedBox(height: 16),
          AppText(
            context.l10n.assetNoAssetsFound,
            style: AppTextStyle.titleMedium,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 8),
          AppText(
            context.l10n.assetCreateFirstAsset,
            style: AppTextStyle.bodyMedium,
            color: context.colors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildAssetsList(List<Asset> assets, [bool isLoadingMore = false]) {
    final isMutating = ref.watch(
      assetsProvider.select((state) => state.isMutating),
    );

    final displayAssets = isLoadingMore
        ? assets + List.generate(2, (_) => Asset.dummy())
        : assets;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: displayAssets.length,
      itemBuilder: (context, index) {
        final asset = displayAssets[index];
        final isSkeleton = isLoadingMore && index >= assets.length;
        final isSelected = _selectedAssetIds.contains(asset.id);

        return Skeletonizer(
          enabled: isSkeleton,
          child: AssetTile(
            asset: asset,
            isDisabled: isMutating,
            isSelected: isSelected,
            onSelect: _isSelectMode
                ? (_) => _toggleSelectAsset(asset.id)
                : null,
            onLongPress: isSkeleton
                ? null
                : () {
                    if (!_isSelectMode) {
                      setState(() {
                        _isSelectMode = true;
                        _selectedAssetIds.clear();
                        _selectedAssetIds.add(asset.id);
                      });
                      AppToast.info(context.l10n.assetLongPressToSelect);
                    }
                  },
            onTap: isSkeleton || _isSelectMode
                ? null
                : () {
                    this.logPresentation('Asset tapped: ${asset.id}');
                    context.push(RouteConstant.assetDetail, extra: asset);
                  },
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, Failure failure) {
    return AppErrorState(
      title: context.l10n.assetFailedToLoadData,
      description: failure.message,
      onRetry: _onRefresh,
    );
  }
}
