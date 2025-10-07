import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/category/domain/usecases/check_category_exists_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/category_boolean_state.dart';

class CheckCategoryExistsNotifier
    extends AutoDisposeFamilyNotifier<CategoryBooleanState, String> {
  CheckCategoryExistsUsecase get _checkCategoryExistsUsecase =>
      ref.watch(checkCategoryExistsUsecaseProvider);

  @override
  CategoryBooleanState build(String id) {
    this.logPresentation('Checking if category exists: $id');
    _checkExists(id);
    return CategoryBooleanState.initial();
  }

  Future<void> _checkExists(String id) async {
    state = CategoryBooleanState.loading();

    final result = await _checkCategoryExistsUsecase.call(
      CheckCategoryExistsUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError('Failed to check category exists', failure);
        state = CategoryBooleanState.error(failure);
      },
      (success) {
        this.logData('Category exists: ${success.data}');
        state = CategoryBooleanState.success(success.data ?? false);
      },
    );
  }

  Future<void> refresh() async {
    await _checkExists(arg);
  }
}
