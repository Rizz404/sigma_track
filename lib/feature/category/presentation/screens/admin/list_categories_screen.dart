import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/usecases/delete_category_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/category_providers.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/categories_state.dart';
import 'package:sigma_track/feature/category/presentation/widgets/category_card.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/custom_app_bar.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:go_router/go_router.dart';

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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      ref.read(categoresProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    _selectedCategoryIds.clear();
    _isSelectMode = false;
    await ref.read(categoresProvider.notifier).refresh();
  }

  void _showOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _OptionsBottomSheet(
        onCreateCategory: () {
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
        onShowFilterSort: _showFilterSortBottomSheet,
      ),
    );
  }

  void _showFilterSortBottomSheet() {
    Navigator.pop(context);
    final currentFilter = ref.read(categoresProvider).categoriesFilter;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _FilterSortBottomSheet(
        currentFilter: currentFilter,
        onApply: (filter) {
          Navigator.pop(context);
          ref.read(categoresProvider.notifier).updateFilter(filter);
          AppToast.success('Filter applied');
        },
        formKey: _filterFormKey,
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
      // * Delete categories one by one
      for (final categoryId in _selectedCategoryIds) {
        await ref
            .read(categoresProvider.notifier)
            .deleteCategory(DeleteCategoryUsecaseParams(id: categoryId));
      }
      _cancelSelectMode();
      await _onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoresProvider);

    ref.listen(categoresProvider, (previous, next) {
      if (next.message != null) {
        AppToast.success(next.message!);
      }

      if (next.failure != null) {
        this.logError('Categories error', next.failure);
        AppToast.error(next.failure!.message);
      }
    });

    return Scaffold(
      appBar: _isSelectMode
          ? AppBar(
              title: AppText(
                '${_selectedCategoryIds.length} selected',
                color: context.colorScheme.surface,
              ),
              backgroundColor: context.colorScheme.primary,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: _cancelSelectMode,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteSelectedCategories,
                ),
                const SizedBox(width: 8),
              ],
            )
          : const CustomAppBar(title: 'Category Management'),
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
    );
  }

  Widget _buildSearchBar() {
    return AppSearchField(
      name: 'search',
      controller: _searchController,
      hintText: 'Search categories...',
      onChanged: (value) {
        ref.read(categoresProvider.notifier).search(value);
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
      categoresProvider.select((state) => state.isMutating),
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

class _OptionsBottomSheet extends StatelessWidget {
  final VoidCallback onCreateCategory;
  final VoidCallback onSelectMany;
  final VoidCallback onShowFilterSort;

  const _OptionsBottomSheet({
    required this.onCreateCategory,
    required this.onSelectMany,
    required this.onShowFilterSort,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.colors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            AppText(
              'Options',
              style: AppTextStyle.titleLarge,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 24),
            _OptionTile(
              icon: Icons.add_circle_outline,
              title: 'Create Category',
              subtitle: 'Add a new category',
              onTap: onCreateCategory,
            ),
            const SizedBox(height: 12),
            _OptionTile(
              icon: Icons.checklist,
              title: 'Select Many',
              subtitle: 'Select multiple categories to delete',
              onTap: onSelectMany,
            ),
            const SizedBox(height: 12),
            _OptionTile(
              icon: Icons.filter_list,
              title: 'Filter & Sort',
              subtitle: 'Customize category display',
              onTap: onShowFilterSort,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: context.colors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: context.colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    style: AppTextStyle.titleSmall,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    subtitle,
                    style: AppTextStyle.bodySmall,
                    color: context.colors.textSecondary,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: context.colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSortBottomSheet extends StatelessWidget {
  final CategoriesFilter currentFilter;
  final Function(CategoriesFilter) onApply;
  final GlobalKey<FormBuilderState> formKey;

  const _FilterSortBottomSheet({
    required this.currentFilter,
    required this.onApply,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: FormBuilder(
          key: formKey,
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
                'Filter & Sort',
                style: AppTextStyle.titleLarge,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 24),
              AppDropdown<String>(
                name: 'sortBy',
                label: 'Sort By',
                initialValue: currentFilter.sortBy?.value ?? 'categoryName',
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
                initialValue: currentFilter.sortOrder?.value ?? 'asc',
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
              AppDropdown<String>(
                name: 'hasParent',
                label: 'Category Type',
                initialValue: currentFilter.hasParent == null
                    ? 'all'
                    : currentFilter.hasParent!
                    ? 'child'
                    : 'parent',
                items: const [
                  AppDropdownItem(
                    value: 'all',
                    label: 'All Categories',
                    icon: Icon(Icons.list, size: 18),
                  ),
                  AppDropdownItem(
                    value: 'parent',
                    label: 'Parent Only',
                    icon: Icon(Icons.folder, size: 18),
                  ),
                  AppDropdownItem(
                    value: 'child',
                    label: 'Child Only',
                    icon: Icon(Icons.folder_open, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Reset',
                      variant: AppButtonVariant.outlined,
                      onPressed: () {
                        formKey.currentState?.reset();
                        onApply(CategoriesFilter());
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: AppButton(
                      text: 'Apply',
                      onPressed: () {
                        final formData = formKey.currentState?.value;
                        if (formData != null) {
                          final sortByStr = formData['sortBy'] as String?;
                          final sortOrderStr = formData['sortOrder'] as String?;
                          final hasParentStr = formData['hasParent'] as String?;

                          onApply(
                            CategoriesFilter(
                              search: currentFilter.search,
                              sortBy: sortByStr != null
                                  ? CategorySortBy.fromString(sortByStr)
                                  : null,
                              sortOrder: sortOrderStr != null
                                  ? SortOrder.fromString(sortOrderStr)
                                  : null,
                              hasParent: hasParentStr == 'all'
                                  ? null
                                  : hasParentStr == 'child',
                            ),
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
}
