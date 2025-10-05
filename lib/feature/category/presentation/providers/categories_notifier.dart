import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/feature/category/domain/usecases/create_category_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/delete_category_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_categories_cursor_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/update_category_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/categories_state.dart';

class CategoriesNotifier extends AutoDisposeNotifier<CategoriesState> {
  GetCategoriesCursorUsecase get _getCategoriesCursorUsecase =>
      ref.watch(getCategoriesCursorUsecaseProvider);
  CreateCategoryUsecase get _createCategoryUsecase =>
      ref.watch(createCategoryUsecaseProvider);
  UpdateCategoryUsecase get _updateCategoryUsecase =>
      ref.watch(updateCategoryUsecaseProvider);
  DeleteCategoryUsecase get _deleteCategoryUsecase =>
      ref.watch(deleteCategoryUsecaseProvider);

  @override
  CategoriesState build() {
    this.logPresentation('Initializing CategoriesNotifier');
    _initializeCategories();
    return CategoriesState.initial();
  }

  Future<void> _initializeCategories() async {
    state = await _loadCategories(categoriesFilter: CategoriesFilter());
  }

  Future<CategoriesState> _loadCategories({
    required CategoriesFilter categoriesFilter,
    List<Category>? currentCategories,
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

    state = await _loadCategories(categoriesFilter: newFilter);
  }

  Future<void> updateFilter(CategoriesFilter newFilter) async {
    this.logPresentation('Updating filter');

    final filterWithResetCursor = newFilter.copyWith(cursor: () => null);
    state = await _loadCategories(categoriesFilter: filterWithResetCursor);
  }

  Future<void> loadMore() async {
    if (state.cursor == null || !state.cursor!.hasNextPage) {
      this.logPresentation('No more pages to load');
      return;
    }

    if (state.isLoadingMore == true) {
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

    final result = await _createCategoryUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to create category', failure);
        state = state.copyWith(failure: () => failure, message: () => null);
      },
      (success) {
        this.logData('Category created successfully');
        final newCategory = success.data;
        if (newCategory != null) {
          state = state.copyWith(
            categories: [newCategory, ...state.categories],
            mutatedCategory: () => newCategory,
            message: () => success.message ?? 'Category created',
            failure: () => null,
          );
        }
      },
    );
  }

  Future<void> updateCategory(UpdateCategoryUsecaseParams params) async {
    this.logPresentation('Updating category: ${params.id}');

    final result = await _updateCategoryUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to update category', failure);
        state = state.copyWith(failure: () => failure, message: () => null);
      },
      (success) {
        this.logData('Category updated successfully');
        final updatedCategory = success.data;
        if (updatedCategory != null) {
          final updatedCategories = state.categories.map((category) {
            return category.id == updatedCategory.id
                ? updatedCategory
                : category;
          }).toList();

          state = state.copyWith(
            categories: updatedCategories,
            mutatedCategory: () => updatedCategory,
            message: () => success.message ?? 'Category updated',
            failure: () => null,
          );
        }
      },
    );
  }

  Future<void> deleteCategory(DeleteCategoryUsecaseParams params) async {
    this.logPresentation('Deleting category: ${params.id}');

    final deletedCategory = state.categories.firstWhere(
      (category) => category.id == params.id,
      orElse: () => throw StateError('Category not found'),
    );

    // * Optimistic: Remove dulu dari UI
    final updatedCategories = state.categories
        .where((c) => c.id != params.id)
        .toList();
    state = state.copyWith(categories: updatedCategories);

    final result = await _deleteCategoryUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete category', failure);
        // * Revert: Tambah balik kalau gagal
        state = state.copyWith(
          categories: [...state.categories, deletedCategory],
          failure: () => failure,
          message: () => null,
        );
      },
      (success) {
        this.logData('Category deleted successfully');
        state = state.copyWith(
          message: () => success.message ?? 'Category deleted',
          failure: () => null,
          mutatedCategory: () => null,
        );
      },
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
