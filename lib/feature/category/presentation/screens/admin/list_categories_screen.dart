import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/presentation/providers/category_providers.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/categories_state.dart';
import 'package:sigma_track/feature/category/presentation/widgets/category_card.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_checkbox.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown_search.dart';
import 'package:sigma_track/shared/presentation/widgets/app_list_bottom_sheet.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListCategoriesScreen extends ConsumerStatefulWidget {
  const ListCategoriesScreen({super.key});

  @override
  ConsumerState<ListCategoriesScreen> createState() =>
      _ListCategoriesScreenState();
}

class _ListCategoriesScreenState extends ConsumerState<ListCategoriesScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _filterFormKey = GlobalKey<FormBuilderState>();
  final Set<String> _selectedCategoryIds = {};
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
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(categoriesProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    _selectedCategoryIds.clear();
    _isSelectMode = false;
    await ref.read(categoriesProvider.notifier).refresh();
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
          context.push(RouteConstant.adminCategoryUpsert);
          this.logPresentation('Create category pressed');
        },
        onSelectMany: () {
          Navigator.pop(context);
          setState(() {
            _isSelectMode = true;
            _selectedCategoryIds.clear();
          });
          AppToast.info('Select categories to delete');
        },
        filterSortWidgetBuilder: _buildFilterSortBottomSheet,
        createTitle: 'Create Category',
        createSubtitle: 'Add a new category',
        selectManyTitle: 'Select Many',
        selectManySubtitle: 'Select multiple categories to delete',
        filterSortTitle: 'Filter & Sort',
        filterSortSubtitle: 'Customize category display',
      ),
    );
  }

  Widget _buildFilterSortBottomSheet() {
    final currentFilter = ref.read(categoriesProvider).categoriesFilter;

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
                items: const [
                  AppDropdownItem(
                    value: 'categoryName',
                    label: 'Category Name',
                    icon: Icon(Icons.sort_by_alpha, size: 18),
                  ),
                  AppDropdownItem(
                    value: 'categoryCode',
                    label: 'Category Code',
                    icon: Icon(Icons.code, size: 18),
                  ),
                  AppDropdownItem(
                    value: 'createdAt',
                    label: 'Created Date',
                    icon: Icon(Icons.calendar_today, size: 18),
                  ),
                  AppDropdownItem(
                    value: 'updatedAt',
                    label: 'Updated Date',
                    icon: Icon(Icons.update, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppDropdown<String>(
                name: 'sortOrder',
                label: 'Sort Order',
                initialValue: currentFilter.sortOrder?.value,
                items: const [
                  AppDropdownItem(
                    value: 'asc',
                    label: 'Ascending',
                    icon: Icon(Icons.arrow_upward, size: 18),
                  ),
                  AppDropdownItem(
                    value: 'desc',
                    label: 'Descending',
                    icon: Icon(Icons.arrow_downward, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppCheckbox(
                name: 'hasParent',
                title: const AppText('Has Parent'),
                initialValue: currentFilter.hasParent == true,
              ),
              const SizedBox(height: 16),
              AppDropdownSearch<Category>(
                name: 'parentId',
                label: 'Filter by Parent Category',
                hintText: 'Select parent category',
                initialValue: currentFilter.parentId != null
                    ? ref
                          .read(categoriesProvider)
                          .categories
                          .cast<Category?>()
                          .firstWhere(
                            (c) => c?.id == currentFilter.parentId,
                            orElse: () => null,
                          )
                    : null,
                asyncItems: (search) async {
                  // * Load categories for dropdown search
                  await ref
                      .read(categoriesSearchProvider.notifier)
                      .search(search);
                  return ref.read(categoriesSearchProvider).categories;
                },
                itemAsString: (category) => category.categoryName,
                compareFn: (item1, item2) => item1.id == item2.id,
                itemBuilder: (context, category, isDisabled, isSelected) {
                  return ListTile(
                    selected: isSelected,
                    selectedTileColor: context.colorScheme.primary.withOpacity(
                      0.1,
                    ),
                    leading: Icon(
                      Icons.category,
                      color: isSelected
                          ? context.colorScheme.primary
                          : context.colors.textSecondary,
                    ),
                    title: AppText(
                      category.categoryName,
                      style: AppTextStyle.bodyMedium,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    subtitle: AppText(
                      category.categoryCode,
                      style: AppTextStyle.bodySmall,
                      color: context.colors.textTertiary,
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Reset',
                      color: AppButtonColor.secondary,
                      onPressed: () {
                        _filterFormKey.currentState?.reset();
                        final newFilter = CategoriesFilter(
                          search: currentFilter.search,
                          // * Reset semua filter kecuali search
                        );
                        Navigator.pop(context);
                        ref
                            .read(categoriesProvider.notifier)
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
                          final hasParentChecked =
                              formData['hasParent'] as bool? ?? false;
                          final selectedParent =
                              formData['parentId'] as Category?;

                          final hasParentValue = hasParentChecked ? true : null;

                          final newFilter = CategoriesFilter(
                            search: currentFilter.search,
                            sortBy: sortByStr != null
                                ? CategorySortBy.fromString(sortByStr)
                                : null,
                            sortOrder: sortOrderStr != null
                                ? SortOrder.fromString(sortOrderStr)
                                : null,
                            hasParent: hasParentValue,
                            parentId: selectedParent?.id,
                          );

                          Navigator.pop(context);
                          ref
                              .read(categoriesProvider.notifier)
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

  void _toggleSelectCategory(String categoryId) {
    setState(() {
      if (_selectedCategoryIds.contains(categoryId)) {
        _selectedCategoryIds.remove(categoryId);
      } else {
        _selectedCategoryIds.add(categoryId);
      }
    });
  }

  void _cancelSelectMode() {
    setState(() {
      _isSelectMode = false;
      _selectedCategoryIds.clear();
    });
  }

  Future<void> _deleteSelectedCategories() async {
    if (_selectedCategoryIds.isEmpty) {
      AppToast.warning('No categories selected');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(
          'Delete Categories',
          style: AppTextStyle.titleMedium,
        ),
        content: AppText(
          'Are you sure you want to delete ${_selectedCategoryIds.length} categories?',
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
    final state = ref.watch(categoriesProvider);

    ref.listen(categoriesProvider, (previous, next) {
      if (next.message != null) {
        AppToast.success(next.message!);
      }

      if (next.failure != null) {
        this.logError('Categories error', next.failure);
        AppToast.error(next.failure!.message);
      }
    });

    return Scaffold(
      appBar: const CustomAppBar(title: 'Category Management'),
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
                    : state.categories.isEmpty
                    ? _buildEmptyState(context)
                    : _buildCategoriesGrid(
                        state.categories,
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
                '${_selectedCategoryIds.length} selected',
                style: AppTextStyle.titleMedium,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppButton(
              text: 'Delete',
              color: AppButtonColor.error,
              isFullWidth: false,
              onPressed: _deleteSelectedCategories,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return AppSearchField(
      name: 'search',
      controller: _searchController,
      hintText: 'Search categories...',
      onChanged: (value) {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 500), () {
          ref.read(categoriesProvider.notifier).search(value);
        });
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final dummyCategories = List.generate(6, (_) => Category.dummy());
    return Skeletonizer(
      enabled: true,
      child: _buildCategoriesGrid(dummyCategories),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 80,
            color: context.colors.textDisabled,
          ),
          const SizedBox(height: 16),
          AppText(
            'No categories found',
            style: AppTextStyle.titleMedium,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 8),
          AppText(
            'Create your first category to get started',
            style: AppTextStyle.bodyMedium,
            color: context.colors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid(
    List<Category> categories, [
    bool isLoadingMore = false,
  ]) {
    final isMutating = ref.watch(
      categoriesProvider.select((state) => state.isMutating),
    );

    final displayCategories = isLoadingMore
        ? categories + List.generate(2, (_) => Category.dummy())
        : categories;

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: displayCategories.length,
      itemBuilder: (context, index) {
        final category = displayCategories[index];
        final isSkeleton = isLoadingMore && index >= categories.length;
        final isSelected = _selectedCategoryIds.contains(category.id);

        return Skeletonizer(
          enabled: isSkeleton,
          child: CategoryCard(
            category: category,
            isDisabled: isMutating,
            isSelected: isSelected,
            onSelect: _isSelectMode
                ? (_) => _toggleSelectCategory(category.id)
                : null,
            onLongPress: isSkeleton
                ? null
                : () {
                    if (!_isSelectMode) {
                      setState(() {
                        _isSelectMode = true;
                        _selectedCategoryIds.clear();
                        _selectedCategoryIds.add(category.id);
                      });
                      AppToast.info('Long press to select more categories');
                    }
                  },
            onTap: isSkeleton || _isSelectMode
                ? null
                : () {
                    this.logPresentation('Category tapped: ${category.id}');
                    context.push(
                      RouteConstant.adminCategoryDetail,
                      extra: category,
                    );
                  },
          ),
        );
      },
    );
  }
}
