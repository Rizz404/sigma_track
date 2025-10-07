import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_category_by_code_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/category_detail_state.dart';

class GetCategoryByCodeNotifier
    extends AutoDisposeFamilyNotifier<CategoryDetailState, String> {
  GetCategoryByCodeUsecase get _getCategoryByCodeUsecase =>
      ref.watch(getCategoryByCodeUsecaseProvider);

  @override
  CategoryDetailState build(String code) {
    this.logPresentation('Loading category by code: $code');
    _loadCategory(code);
    return CategoryDetailState.initial();
  }

  Future<void> _loadCategory(String code) async {
    state = CategoryDetailState.loading();

    final result = await _getCategoryByCodeUsecase.call(
      GetCategoryByCodeUsecaseParams(code: code),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load category by code', failure);
        state = CategoryDetailState.error(failure);
      },
      (success) {
        this.logData('Category loaded by code: ${success.data?.categoryName}');
        if (success.data != null) {
          state = CategoryDetailState.success(success.data!);
        } else {
          state = CategoryDetailState.error(
            const ServerFailure(message: 'Category not found'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadCategory(arg);
  }
}
