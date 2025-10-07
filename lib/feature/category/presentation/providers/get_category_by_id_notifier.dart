import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_category_by_id_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/category_detail_state.dart';

class GetCategoryByIdNotifier
    extends AutoDisposeFamilyNotifier<CategoryDetailState, String> {
  GetCategoryByIdUsecase get _getCategoryByIdUsecase =>
      ref.watch(getCategoryByIdUsecaseProvider);

  @override
  CategoryDetailState build(String id) {
    this.logPresentation('Loading category by id: $id');
    _loadCategory(id);
    return CategoryDetailState.initial();
  }

  Future<void> _loadCategory(String id) async {
    state = CategoryDetailState.loading();

    final result = await _getCategoryByIdUsecase.call(
      GetCategoryByIdUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load category by id', failure);
        state = CategoryDetailState.error(failure);
      },
      (success) {
        this.logData('Category loaded by id: ${success.data?.categoryName}');
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
