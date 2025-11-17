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
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_cursor_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/feature/asset/presentation/widgets/asset_tile.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text_field.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MyListAssetsScreen extends ConsumerStatefulWidget {
  const MyListAssetsScreen({super.key});

  @override
  ConsumerState<MyListAssetsScreen> createState() => _MyListAssetsScreenState();
}

class _MyListAssetsScreenState extends ConsumerState<MyListAssetsScreen> {
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
      ref.read(myAssetsProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(myAssetsProvider.notifier).refresh();
  }

  void _applyFilter() {
    if (_filterFormKey.currentState?.saveAndValidate() ?? false) {
      final formData = _filterFormKey.currentState!.value;

      final newFilter = GetAssetsCursorUsecaseParams(
        status: formData['status'] != null
            ? AssetStatus.values.firstWhere(
                (e) => e.value == formData['status'],
              )
            : null,
        condition: formData['condition'] != null
            ? AssetCondition.values.firstWhere(
                (e) => e.value == formData['condition'],
              )
            : null,
        brand: formData['brand']?.isNotEmpty == true ? formData['brand'] : null,
        model: formData['model']?.isNotEmpty == true ? formData['model'] : null,
        sortBy: formData['sortBy'] != null
            ? AssetSortBy.values.firstWhere(
                (e) => e.value == formData['sortBy'],
              )
            : null,
        sortOrder: formData['sortOrder'] != null
            ? SortOrder.values.firstWhere(
                (e) => e.value == formData['sortOrder'],
              )
            : null,
      );

      ref.read(myAssetsProvider.notifier).updateFilter(newFilter);
    }
  }

  void _showFilterBottomSheet() {
    final currentFilter = ref.read(myAssetsProvider).assetsFilter;

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
                      context.l10n.assetFiltersAndSorting,
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
                        name: 'status',
                        label: context.l10n.assetStatus,
                        initialValue: currentFilter.status?.value,
                        items: AssetStatus.values
                            .map(
                              (status) => AppDropdownItem(
                                value: status.value,
                                label: status.label,
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
                              (condition) => AppDropdownItem(
                                value: condition.value,
                                label: condition.label,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        name: 'brand',
                        label: context.l10n.assetBrandLabel,
                        placeHolder: context.l10n.assetEnterBrandFilter,
                        initialValue: currentFilter.brand,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        name: 'model',
                        label: context.l10n.assetModelLabel,
                        placeHolder: context.l10n.assetEnterModelFilter,
                        initialValue: currentFilter.model,
                      ),
                      const SizedBox(height: 16),
                      AppDropdown<String>(
                        name: 'sortBy',
                        label: context.l10n.assetSortBy,
                        initialValue: currentFilter.sortBy?.value,
                        items: AssetSortBy.values
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
                        label: context.l10n.assetSortOrder,
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
                        text: context.l10n.assetApplyFilters,
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
    final state = ref.watch(myAssetsProvider);

    ref.listen(myAssetsProvider, (previous, next) {
      // * Handle mutation success
      if (next.hasMutationSuccess) {
        AppToast.success(next.mutationMessage!);
      }

      // * Handle mutation error
      if (next.hasMutationError) {
        this.logError('MyAssets mutation error', next.mutationFailure);
        AppToast.error(next.mutationFailure!.message);
      }
    });

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.assetMyAssets),
      endDrawer: const AppEndDrawer(),
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
                    : state.assets.isEmpty
                    ? _buildEmptyState(context)
                    : _buildAssetsList(state.assets, state.isLoadingMore),
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
      hintText: context.l10n.assetSearchMyAssets,
      onChanged: (value) {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          ref.read(myAssetsProvider.notifier).search(value);
        });
      },
    );
  }

  Widget _buildFilterButton() {
    final currentFilter = ref.watch(myAssetsProvider).assetsFilter;
    final hasActiveFilters =
        currentFilter.status != null ||
        currentFilter.condition != null ||
        currentFilter.brand != null ||
        currentFilter.model != null ||
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
                    ? context.l10n.assetFiltersApplied
                    : context.l10n.assetFilterAndSortTitle,
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
            context.l10n.assetNoAssignedAssets,
            style: AppTextStyle.bodyMedium,
            color: context.colors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildAssetsList(List<Asset> assets, [bool isLoadingMore = false]) {
    final isMutating = ref.watch(
      myAssetsProvider.select((state) => state.isMutating),
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

        return Skeletonizer(
          enabled: isSkeleton,
          child: AssetTile(
            asset: asset,
            isDisabled: isMutating,
            onTap: isSkeleton
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
