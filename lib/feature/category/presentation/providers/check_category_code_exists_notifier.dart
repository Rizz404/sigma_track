import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/category/domain/usecases/check_category_code_exists_usecase.dart';
import 'package:sigma_track/feature/category/presentation/providers/state/category_boolean_state.dart';

class CheckCategoryCodeExistsNotifier
    extends AutoDisposeFamilyNotifier<CategoryBooleanState, String> {
  CheckCategoryCodeExistsUsecase get _checkCategoryCodeExistsUsecase =>
      ref.watch(checkCategoryCodeExistsUsecaseProvider);

  @override
  CategoryBooleanState build(String code) {
    this.logPresentation('Checking if category code exists: $code');
    _checkCodeExists(code);
    return CategoryBooleanState.initial();
  }

  Future<void> _checkCodeExists(String code) async {
    state = CategoryBooleanState.loading();

    final result = await _checkCategoryCodeExistsUsecase.call(
      CheckCategoryCodeExistsUsecaseParams(code: code),
    );

    result.fold(
      (failure) {
        this.logError('Failed to check category code', failure);
        state = CategoryBooleanState.error(failure);
      },
      (success) {
        this.logData('Category code exists: ${success.data}');
        state = CategoryBooleanState.success(success.data ?? false);
      },
    );
  }

  Future<void> refresh() async {
    await _checkCodeExists(arg);
  }
}
