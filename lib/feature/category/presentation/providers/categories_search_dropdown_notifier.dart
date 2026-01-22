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
  Future<void> searchParentCategories(String search) async {
    this.logPresentation('Searching root categories: $search');

    final newFilter = state.categoriesFilter.copyWith(
      search: () => search.isEmpty ? null : search,
      hasParent: () => false,
      cursor: () => null,
    );

    state = state.copyWith(isLoading: true);
    state = await _loadCategories(categoriesFilter: newFilter);
  }

  /// Search for non-root categories only (categories with parent)
  Future<void> searchChildCategories(String search) async {
    this.logPresentation('Searching non-root categories: $search');

    final newFilter = state.categoriesFilter.copyWith(
      search: () => search.isEmpty ? null : search,
      hasParent: () => true,
      cursor: () => null,
    );

    state = state.copyWith(isLoading: true);
    state = await _loadCategories(categoriesFilter: newFilter);
  }

  Future<void> loadMore() async {
    if (state.cursor == null || !state.cursor!.hasNextPage) {
      this.logPresentation('No more pages to load');
      return;
    }

    if (state.isLoadingMore) {
      this.logPresentation('Already loading more');
      return;
    }

    this.logPresentation('Loading more categories');

    state = state.copyWith(isLoadingMore: true);

    final newFilter = state.categoriesFilter.copyWith(
      cursor: () => state.cursor?.nextCursor,
    );

    final result = await _getCategoriesCursorUsecase.call(newFilter);

    result.fold(
      (failure) {
        this.logError('Failed to load more categories', failure);
        state = state.copyWith(isLoadingMore: false, failure: () => failure);
      },
      (success) {
        this.logData('More categories loaded: ${success.data?.length ?? 0}');
        state = CategoriesState.success(
          categories: [...state.categories, ...success.data ?? []],
          categoriesFilter: newFilter,
          cursor: success.cursor,
        );
      },
    );
  }

  void clear() {
    this.logPresentation('Clearing search results');
    state = CategoriesState.initial();
  }
}

/// Notifier for root categories only (categories without parent)
class CategoriesParentSearchDropdownNotifier
    extends CategoriesSearchDropdownNotifier {
  @override
  Future<void> _initializeCategories() async {
    state = await _loadCategories(
      categoriesFilter: GetCategoriesCursorUsecaseParams(hasParent: false),
    );
  }

  @override
  Future<void> search(String search) async {
    await searchParentCategories(search);
  }
}

/// Notifier for non-root categories only (categories with parent)
class CategoriesChildSearchDropdownNotifier
    extends CategoriesSearchDropdownNotifier {
  @override
  Future<void> _initializeCategories() async {
    state = await _loadCategories(
      categoriesFilter: GetCategoriesCursorUsecaseParams(hasParent: true),
    );
  }

  @override
  Future<void> search(String search) async {
    await searchChildCategories(search);
  }
}
