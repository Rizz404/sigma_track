import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_categories_cursor_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/categories_state.dart';

class CategoriesSearchDropdownNotifier
    extends AutoDisposeNotifier<CategoriesState> {
  GetCategoriesCursorUsecase get _getCategoriesCursorUsecase =>
      ref.watch(getCategoriesCursorUsecaseProvider);

  @override
  CategoriesState build() {
    // * Cache search results for 2 minutes (dropdown use case)
    ref.cacheFor(const Duration(minutes: 2));
    this.logPresentation('Initializing CategoriesSearchDropdownNotifier');
    _initializeCategories();
    return CategoriesState.initial();
  }

  Future<void> _initializeCategories() async {
    state = await _loadCategories(
      categoriesFilter: GetCategoriesCursorUsecaseParams(),
    );
  }

  Future<CategoriesState> _loadCategories({
    required GetCategoriesCursorUsecaseParams categoriesFilter,
  }) async {
    this.logPresentation('Loading categories with filter: $categoriesFilter');

    final result = await _getCategoriesCursorUsecase.call(
      GetCategoriesCursorUsecaseParams(
        search: categoriesFilter.search,
        parentId: categoriesFilter.parentId,
        hasParent: categoriesFilter.hasParent,
        sortBy: categoriesFilter.sortBy,
        sortOrder: categoriesFilter.sortOrder,
        cursor: categoriesFilter.cursor,
        limit: categoriesFilter.limit,
      ),
    );

    return result.fold(
      (failure) {
        this.logError('Failed to load categories', failure);
        return CategoriesState.error(
          failure: failure,
          categoriesFilter: categoriesFilter,
          currentCategories: null,
        );
      },
      (success) {
        this.logData('Categories loaded: ${success.data?.length ?? 0} items');
        return CategoriesState.success(
          categories: success.data ?? [],
          categoriesFilter: categoriesFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  Future<void> search(String search) async {
    this.logPresentation('Searching categories: $search');

    final newFilter = state.categoriesFilter.copyWith(
      search: () => search.isEmpty ? null : search,
      cursor: () => null,
    );

    state = state.copyWith(isLoading: true);
    state = await _loadCategories(categoriesFilter: newFilter);
  }

  /// Search for root categories only (categories without parent)
  Future<void> searchRootCategories(String search) async {
    this.logPresentation('Searching root categories: $search');

    final newFilter = state.categoriesFilter.copyWith(
      search: () => search.isEmpty ? null : search,
      hasParent: () => false,
      cursor: () => null,
    );

    state = state.copyWith(isLoading: true);
    state = await _loadCategories(categoriesFilter: newFilter);
  }

  void clear() {
    this.logPresentation('Clearing search results');
    state = CategoriesState.initial();
  }
}

/// Notifier for root categories only (categories without parent)
class CategoriesRootSearchDropdownNotifier
    extends CategoriesSearchDropdownNotifier {
  @override
  Future<void> search(String search) async {
    await searchRootCategories(search);
  }
}
