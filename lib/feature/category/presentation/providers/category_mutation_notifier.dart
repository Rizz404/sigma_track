import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/category/domain/usecases/create_category_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/delete_category_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/update_category_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/category_mutation_state.dart';

class CategoryMutationNotifier
    extends AutoDisposeNotifier<CategoryMutationState> {
  late CreateCategoryUsecase _createCategoryUsecase;
  late UpdateCategoryUsecase _updateCategoryUsecase;
  late DeleteCategoryUsecase _deleteCategoryUsecase;

  @override
  CategoryMutationState build() {
    _createCategoryUsecase = ref.watch(createCategoryUsecaseProvider);
    _updateCategoryUsecase = ref.watch(updateCategoryUsecaseProvider);
    _deleteCategoryUsecase = ref.watch(deleteCategoryUsecaseProvider);

    return const CategoryMutationState(categoryStatus: CategoryStatus.initial);
  }

  Future<void> createCategory(CreateCategoryUsecaseParams params) async {
    state = state.copyWith(categoryStatus: CategoryStatus.loading);
    this.logPresentation('Creating category: ${params.categoryCode}');

    final result = await _createCategoryUsecase(params);

    result.fold(
      (failure) {
        this.logError('Failed to create category', failure);
        state = CategoryMutationState.error(failure: failure);
      },
      (success) {
        this.logPresentation('Category created: ${success.data?.id}');
        state = CategoryMutationState.success(
          category: success.data,
          message: success.message,
        );
      },
    );
  }

  Future<void> updateCategory(UpdateCategoryUsecaseParams params) async {
    state = state.copyWith(categoryStatus: CategoryStatus.loading);
    this.logPresentation('Updating category: ${params.id}');

    final result = await _updateCategoryUsecase(params);

    result.fold(
      (failure) {
        this.logError('Failed to update category', failure);
        state = CategoryMutationState.error(failure: failure);
      },
      (success) {
        this.logPresentation('Category updated: ${success.data?.id}');
        state = CategoryMutationState.success(
          category: success.data,
          message: success.message,
        );
      },
    );
  }

  Future<void> deleteCategory(DeleteCategoryUsecaseParams params) async {
    state = state.copyWith(categoryStatus: CategoryStatus.loading);
    this.logPresentation('Deleting category: ${params.id}');

    final result = await _deleteCategoryUsecase(params);

    result.fold(
      (failure) {
        this.logError('Failed to delete category', failure);
        state = CategoryMutationState.error(failure: failure);
      },
      (success) {
        this.logPresentation('Category deleted: ${params.id}');
        state = CategoryMutationState.success(message: success.message);
      },
    );
  }

  void reset() {
    state = const CategoryMutationState(categoryStatus: CategoryStatus.initial);
  }
}
