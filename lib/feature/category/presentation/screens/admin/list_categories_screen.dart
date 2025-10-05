import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/usecases/delete_category_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/category_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class ListCategoriesScreen extends ConsumerStatefulWidget {
  const ListCategoriesScreen({super.key});

  @override
  ConsumerState<ListCategoriesScreen> createState() =>
      _ListCategoriesScreenState();
}

class _ListCategoriesScreenState extends ConsumerState<ListCategoriesScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoresProvider);

    ref.listen(categoresProvider, (previous, next) {
      if (next.message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText(next.message!),
            backgroundColor: context.semantic.success,
          ),
        );
      }

      if (next.failure != null) {
        this.logError('Categories error', next.failure);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppText(next.failure!.message),
            backgroundColor: context.semantic.error,
          ),
        );
      }
    });

    return Scaffold(
      body: ScreenWrapper(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: state.categories.isEmpty
                  ? _buildEmptyState(context)
                  : _buildCategoriesGrid(state.categories),
            ),
            if (state.isLoadingMore == true) ...[
              const SizedBox(height: 8),
              CircularProgressIndicator(color: context.colorScheme.primary),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create category
          this.logPresentation('Create category pressed');
        },
        backgroundColor: context.colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              'Categories',
              style: AppTextStyle.headlineMedium,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 4),
            AppText(
              'Manage product categories',
              style: AppTextStyle.bodyMedium,
              color: context.colors.textSecondary,
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            ref.read(categoresProvider.notifier).refresh();
          },
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh',
        ),
      ],
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

  Widget _buildCategoriesGrid(List<Category> categories) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return _CategoryCard(category: categories[index]);
      },
    );
  }
}

class _CategoryCard extends ConsumerWidget {
  const _CategoryCard({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.colors.border, width: 1),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to category detail
          ref
              .read(categoresProvider.notifier)
              .logPresentation('Category tapped: ${category.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.category,
                      color: context.colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: context.colors.textSecondary,
                      size: 20,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              size: 18,
                              color: context.colors.textPrimary,
                            ),
                            const SizedBox(width: 8),
                            const AppText('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              size: 18,
                              color: context.semantic.error,
                            ),
                            const SizedBox(width: 8),
                            AppText('Delete', color: context.semantic.error),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        // TODO: Navigate to edit
                      } else if (value == 'delete') {
                        _showDeleteDialog(context, ref);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              AppText(
                category.categoryName,
                style: AppTextStyle.titleSmall,
                fontWeight: FontWeight.w600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              AppText(
                category.categoryCode,
                style: AppTextStyle.bodySmall,
                color: context.colors.textSecondary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: context.colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: AppText(
                  '${category.children.length} sub',
                  style: AppTextStyle.labelSmall,
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const AppText('Delete Category'),
        content: AppText(
          'Are you sure you want to delete "${category.categoryName}"?',
          style: AppTextStyle.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: AppText('Cancel', color: context.colors.textSecondary),
          ),
          AppButton(
            text: 'Delete',
            color: AppButtonColor.error,
            size: AppButtonSize.small,
            isFullWidth: false,
            onPressed: () {
              Navigator.pop(dialogContext);
              ref
                  .read(categoresProvider.notifier)
                  .deleteCategory(DeleteCategoryUsecaseParams(id: category.id));
            },
          ),
        ],
      ),
    );
  }
}
