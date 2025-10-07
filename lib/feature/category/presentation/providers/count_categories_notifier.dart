import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/category/domain/usecases/count_categories_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/category_count_state.dart';

class CountCategoriesNotifier
    extends
        AutoDisposeFamilyNotifier<
          CategoryCountState,
          CountCategoriesUsecaseParams
        > {
  CountCategoriesUsecase get _countCategoriesUsecase =>
      ref.watch(countCategoriesUsecaseProvider);

  @override
  CategoryCountState build(CountCategoriesUsecaseParams params) {
    this.logPresentation('Counting categories with params: $params');
    _countCategories(params);
    return CategoryCountState.initial();
  }

  Future<void> _countCategories(CountCategoriesUsecaseParams params) async {
    state = CategoryCountState.loading();

    final result = await _countCategoriesUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to count categories', failure);
        state = CategoryCountState.error(failure);
      },
      (success) {
        this.logData('Categories count: ${success.data}');
        state = CategoryCountState.success(success.data ?? 0);
      },
    );
  }

  Future<void> refresh() async {
    await _countCategories(arg);
  }
}
