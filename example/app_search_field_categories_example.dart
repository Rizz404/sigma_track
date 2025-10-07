import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/presentation/providers/category_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';

class AppSearchFieldCategoriesExample extends ConsumerStatefulWidget {
  const AppSearchFieldCategoriesExample({super.key});

  @override
  ConsumerState<AppSearchFieldCategoriesExample> createState() =>
      _AppSearchFieldCategoriesExampleState();
}

class _AppSearchFieldCategoriesExampleState
    extends ConsumerState<AppSearchFieldCategoriesExample> {
  // * Method untuk search categories menggunakan notifier
  Future<List<Category>> _searchCategories(String query) async {
    final notifier = ref.read(categoriesProvider.notifier);

    // Trigger search di notifier
    await notifier.search(query);

    // Return categories dari state
    final state = ref.read(categoriesProvider);
    return state.categories;
  }

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Search Categories Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // * Example 1: Basic autocomplete dengan categories
            Text(
              '1. Autocomplete with Categories (Default)',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            AppSearchField<Category>(
              name: 'category_search',
              hintText: 'Search categories...',
              label: 'Select Category',
              enableAutocomplete: true,
              onSearch: _searchCategories,
              itemDisplayMapper: (category) => category.categoryName,
              itemValueMapper: (category) => category.id,
              onItemSelected: (category) {
                debugPrint(
                  'Selected: ${category.categoryName} (${category.id})',
                );
              },
              initialItemsToShow: 5,
              itemsPerLoadMore: 5,
              enableLoadMore: true,
            ),
            const SizedBox(height: 24),

            // * Example 2: Custom item builder untuk categories
            Text(
              '2. Autocomplete with Custom Category Item',
              style: context.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            AppSearchField<Category>(
              name: 'category_search_custom',
              hintText: 'Search categories...',
              label: 'Select Category (Custom)',
              enableAutocomplete: true,
              onSearch: _searchCategories,
              itemDisplayMapper: (category) => category.categoryName,
              itemValueMapper: (category) => category.id,
              itemBuilder: (context, category) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // * Category icon/avatar
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.category_outlined,
                          color: context.colors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.categoryName,
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (category.description.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                category.description,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              onItemSelected: (category) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected: ${category.categoryName}')),
                );
              },
              initialItemsToShow: 5,
              itemsPerLoadMore: 5,
              enableLoadMore: true,
              suggestionsMaxHeight: 400,
            ),
            const SizedBox(height: 24),

            // * Display current state info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current State Info:',
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Categories: ${categoriesState.categories.length}',
                    style: context.textTheme.bodyMedium,
                  ),
                  Text(
                    'Loading: ${categoriesState.isLoading}',
                    style: context.textTheme.bodyMedium,
                  ),
                  Text(
                    'Loading More: ${categoriesState.isLoadingMore}',
                    style: context.textTheme.bodyMedium,
                  ),
                  Text(
                    'Has Next Page: ${categoriesState.cursor?.hasNextPage ?? false}',
                    style: context.textTheme.bodyMedium,
                  ),
                  if (categoriesState.categoriesFilter.search != null)
                    Text(
                      'Search Query: "${categoriesState.categoriesFilter.search}"',
                      style: context.textTheme.bodyMedium,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
