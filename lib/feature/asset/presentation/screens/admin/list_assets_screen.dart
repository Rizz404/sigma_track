import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/feature/asset/presentation/providers/state/assets_state.dart';
import 'package:sigma_track/feature/asset/presentation/widgets/asset_tile.dart';
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
          AppToast.info('Select assets to delete');
        },
        filterSortWidgetBuilder: _buildFilterSortBottomSheet,
        createTitle: 'Create Asset',
        createSubtitle: 'Add a new asset',
        selectManyTitle: 'Select Many',
        selectManySubtitle: 'Select multiple assets to delete',
        filterSortTitle: 'Filter & Sort',
        filterSortSubtitle: 'Customize asset display',
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
                    label: 'Filter by Category',
                    hintText: 'Search category...',
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
                    label: 'Filter by Location',
                    hintText: 'Search location...',
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
                    label: 'Filter by Assigned To',
                    hintText: 'Search user...',
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
                label: 'Brand',
                placeHolder: 'Enter brand...',
              ),
              const SizedBox(height: 16),
              AppTextField(
                name: 'model',
                label: 'Model',
                placeHolder: 'Enter model...',
              ),
              const SizedBox(height: 32),
              const AppText(
                'Filter & Sort',
                style: AppTextStyle.titleLarge,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 24),
              AppDropdown<String>(
                name: 'sortBy',
                label: 'Sort By',
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
                label: 'Sort Order',
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
                label: 'Status',
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
                label: 'Condition',
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
                      text: 'Reset',
                      color: AppButtonColor.secondary,
                      onPressed: () {
                        _filterFormKey.currentState?.reset();
                        final newFilter = AssetsFilter(
                          search: currentFilter.search,
                          // * Reset semua filter kecuali search
                        );
                        Navigator.pop(context);
                        ref
                            .read(assetsProvider.notifier)
                            .updateFilter(newFilter);
                        AppToast.success('Filter reset');
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text: 'Apply',
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

                          final newFilter = AssetsFilter(
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
                          AppToast.success('Filter applied');
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

  void _toggleSelectAsset(String assetId) {
    setState(() {
      if (_selectedAssetIds.contains(assetId)) {
        _selectedAssetIds.remove(assetId);
      } else {
        _selectedAssetIds.add(assetId);
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
      AppToast.warning('No assets selected');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText('Delete Assets', style: AppTextStyle.titleMedium),
        content: AppText(
          'Are you sure you want to delete ${_selectedAssetIds.length} assets?',
          style: AppTextStyle.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const AppText('Cancel'),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: 'Delete',
            color: AppButtonColor.error,
            isFullWidth: false,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      // Todo: Implementasi di backend
      AppToast.info('Not implemented yet');
      _cancelSelectMode();
      await _onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assetsProvider);

    ref.listen(assetsProvider, (previous, next) {
      if (next.message != null) {
        AppToast.success(next.message!);
      }

      if (next.failure != null) {
        this.logError('Assets error', next.failure);
        AppToast.error(next.failure!.message);
      }
    });

    return Scaffold(
      appBar: const CustomAppBar(title: 'Asset Management'),
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
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.1),
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
                '${_selectedAssetIds.length} selected',
                style: AppTextStyle.titleMedium,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppButton(
              text: 'Delete',
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
      hintText: 'Search assets...',
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
            'No assets found',
            style: AppTextStyle.titleMedium,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 8),
          AppText(
            'Create your first asset to get started',
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
                      AppToast.info('Long press to select more assets');
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
}
