import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/enums/helper_enums.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/usecases/bulk_create_categories_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/bulk_delete_categories_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/create_category_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/delete_category_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_categories_cursor_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/update_category_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/categories_state.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';

class CategoriesNotifier extends AutoDisposeNotifier<CategoriesState> {
  GetCategoriesCursorUsecase get _getCategoriesCursorUsecase =>
      ref.watch(getCategoriesCursorUsecaseProvider);
  CreateCategoryUsecase get _createCategoryUsecase =>
      ref.watch(createCategoryUsecaseProvider);
  UpdateCategoryUsecase get _updateCategoryUsecase =>
      ref.watch(updateCategoryUsecaseProvider);
  DeleteCategoryUsecase get _deleteCategoryUsecase =>
      ref.watch(deleteCategoryUsecaseProvider);
  BulkCreateCategoriesUsecase get _bulkCreateCategoriesUsecase =>
      ref.watch(bulkCreateCategoriesUsecaseProvider);
  BulkDeleteCategoriesUsecase get _bulkDeleteCategoriesUsecase =>
      ref.watch(bulkDeleteCategoriesUsecaseProvider);

  @override
  CategoriesState build() {
    this.logPresentation('Initializing CategoriesNotifier');
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
    List<Category>? currentCategories,
  }) async {
    this.logPresentation('Loading categories with filter: $categoriesFilter');

    final result = await _getCategoriesCursorUsecase.call(categoriesFilter);

    return result.fold(
      (failure) {
        this.logError('Failed to load categories', failure);
        return CategoriesState.error(
          failure: failure,
          categoriesFilter: categoriesFilter,
          currentCategories: currentCategories,
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

  Future<void> updateFilter(GetCategoriesCursorUsecaseParams newFilter) async {
    this.logPresentation(
      'Updating filter - received: sortBy=${newFilter.sortBy}, sortOrder=${newFilter.sortOrder}, hasParent=${newFilter.hasParent}, parentId=${newFilter.parentId}',
    );

    // * Preserve search from current filter
    final filterWithResetCursor = newFilter.copyWith(
      search: () => state.categoriesFilter.search,
      cursor: () => null,
    );

    this.logPresentation('Filter after merge: $filterWithResetCursor');
    state = state.copyWith(isLoading: true);
    state = await _loadCategories(categoriesFilter: filterWithResetCursor);
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

    state = CategoriesState.loadingMore(
      currentCategories: state.categories,
      categoriesFilter: state.categoriesFilter,
      cursor: state.cursor,
    );

    final newFilter = state.categoriesFilter.copyWith(
      cursor: () => state.cursor?.nextCursor,
    );

    final result = await _getCategoriesCursorUsecase.call(
      GetCategoriesCursorUsecaseParams(
        search: newFilter.search,
        parentId: newFilter.parentId,
        hasParent: newFilter.hasParent,
        sortBy: newFilter.sortBy,
        sortOrder: newFilter.sortOrder,
        cursor: newFilter.cursor,
        limit: newFilter.limit,
      ),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load more categories', failure);
        state = CategoriesState.error(
          failure: failure,
          categoriesFilter: newFilter,
          currentCategories: state.categories,
        );
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

  Future<void> createCategory(CreateCategoryUsecaseParams params) async {
    this.logPresentation('Creating category');

    state = CategoriesState.creating(
      currentCategories: state.categories,
      categoriesFilter: state.categoriesFilter,
      cursor: state.cursor,
    );

    final result = await _createCategoryUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create category', failure);
        state = CategoriesState.mutationError(
          currentCategories: state.categories,
          categoriesFilter: state.categoriesFilter,
          mutationType: MutationType.create,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Category created successfully');

        // * Reload categories dengan state sukses
        state = state.copyWith(isLoading: true);
        final newState = await _loadCategories(
          categoriesFilter: state.categoriesFilter,
        );

        // * Set mutation success setelah reload
        state = CategoriesState.mutationSuccess(
          categories: newState.categories,
          categoriesFilter: newState.categoriesFilter,
          mutationType: MutationType.create,
          message: success.message ?? 'Category created',
          cursor: newState.cursor,
        );
      },
    );
  }

  Future<void> updateCategory(UpdateCategoryUsecaseParams params) async {
    this.logPresentation('Updating category: ${params.id}');

    state = CategoriesState.updating(
      currentCategories: state.categories,
      categoriesFilter: state.categoriesFilter,
      cursor: state.cursor,
    );

    final result = await _updateCategoryUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to update category', failure);
        state = CategoriesState.mutationError(
          currentCategories: state.categories,
          categoriesFilter: state.categoriesFilter,
          mutationType: MutationType.update,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Category updated successfully');

        // * Reload categories dengan state sukses
        state = state.copyWith(isLoading: true);
        final newState = await _loadCategories(
          categoriesFilter: state.categoriesFilter,
        );

        // * Set mutation success setelah reload
        state = CategoriesState.mutationSuccess(
          categories: newState.categories,
          categoriesFilter: newState.categoriesFilter,
          mutationType: MutationType.update,
          message: success.message ?? 'Category updated',
          cursor: newState.cursor,
        );
      },
    );
  }

  Future<void> deleteCategory(DeleteCategoryUsecaseParams params) async {
    this.logPresentation('Deleting category: ${params.id}');

    state = CategoriesState.deleting(
      currentCategories: state.categories,
      categoriesFilter: state.categoriesFilter,
      cursor: state.cursor,
    );

    final result = await _deleteCategoryUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete category', failure);
        state = CategoriesState.mutationError(
          currentCategories: state.categories,
          categoriesFilter: state.categoriesFilter,
          mutationType: MutationType.delete,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Category deleted successfully');

        // * Reload categories dengan state sukses
        state = state.copyWith(isLoading: true);
        final newState = await _loadCategories(
          categoriesFilter: state.categoriesFilter,
        );

        // * Set mutation success setelah reload
        state = CategoriesState.mutationSuccess(
          categories: newState.categories,
          categoriesFilter: newState.categoriesFilter,
          mutationType: MutationType.delete,
          message: success.message ?? 'Category deleted',
          cursor: newState.cursor,
        );
      },
    );
  }

  Future<void> createManyCategories(BulkCreateCategoriesParams params) async {
    this.logPresentation('Creating ${params.categories.length} categories');

    state = CategoriesState.creating(
      currentCategories: state.categories,
      categoriesFilter: state.categoriesFilter,
      cursor: state.cursor,
    );

    final result = await _bulkCreateCategoriesUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create categories', failure);
        state = CategoriesState.mutationError(
          currentCategories: state.categories,
          categoriesFilter: state.categoriesFilter,
          mutationType: MutationType.create,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData(
          'Categories created successfully: ${success.data?.categories.length ?? 0}',
        );

        // * Reload categories dengan state sukses
        state = state.copyWith(isLoading: true);
        final newState = await _loadCategories(
          categoriesFilter: state.categoriesFilter,
        );

        // * Set mutation success setelah reload
        state = CategoriesState.mutationSuccess(
          categories: newState.categories,
          categoriesFilter: newState.categoriesFilter,
          mutationType: MutationType.create,
          message: 'Categories created successfully',
          cursor: newState.cursor,
        );
      },
    );
  }

  Future<void> deleteManyCategories(List<String> categoryIds) async {
    this.logPresentation('Deleting ${categoryIds.length} categories');

    state = CategoriesState.deleting(
      currentCategories: state.categories,
      categoriesFilter: state.categoriesFilter,
      cursor: state.cursor,
    );

    final params = BulkDeleteParams(ids: categoryIds);
    final result = await _bulkDeleteCategoriesUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete categories', failure);
        state = CategoriesState.mutationError(
          currentCategories: state.categories,
          categoriesFilter: state.categoriesFilter,
          mutationType: MutationType.delete,
          failure: failure,
          cursor: state.cursor,
        );
      },
      (success) async {
        this.logData('Categories deleted successfully');

        // * Reload categories dengan state sukses
        state = state.copyWith(isLoading: true);
        final newState = await _loadCategories(
          categoriesFilter: state.categoriesFilter,
        );

        // * Set mutation success setelah reload
        state = CategoriesState.mutationSuccess(
          categories: newState.categories,
          categoriesFilter: newState.categoriesFilter,
          mutationType: MutationType.delete,
          message: 'Categories deleted successfully',
          cursor: newState.cursor,
        );
      },
    );
  }

  Future<void> refresh() async {
    // * Preserve current filter when refreshing
    final currentFilter = state.categoriesFilter;
    state = state.copyWith(isLoading: true);
    state = await _loadCategories(categoriesFilter: currentFilter);
  }
}
