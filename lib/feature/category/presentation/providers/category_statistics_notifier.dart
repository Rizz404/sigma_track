import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_categories_statistics_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/category_statistics_state.dart';

class CategoryStatisticsNotifier
    extends AutoDisposeNotifier<CategoryStatisticsState> {
  GetCategoriesStatisticsUsecase get _getCategoriesStatisticsUsecase =>
      ref.watch(getCategoriesStatisticsUsecaseProvider);

  @override
  CategoryStatisticsState build() {
    // * Cache statistics for 5 minutes (dashboard use case)
    ref.cacheFor(const Duration(minutes: 5));
    this.logPresentation('Loading category statistics');
    _loadStatistics();
    return CategoryStatisticsState.initial();
  }

  Future<void> _loadStatistics() async {
    state = CategoryStatisticsState.loading();

    final result = await _getCategoriesStatisticsUsecase.call(NoParams());

    result.fold(
      (failure) {
        this.logError('Failed to load category statistics', failure);
        state = CategoryStatisticsState.error(failure);
      },
      (success) {
        this.logData('Category statistics loaded');
        if (success.data != null) {
          state = CategoryStatisticsState.success(success.data!);
        } else {
          state = CategoryStatisticsState.error(
            const ServerFailure(message: 'No statistics data'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadStatistics();
  }
}
