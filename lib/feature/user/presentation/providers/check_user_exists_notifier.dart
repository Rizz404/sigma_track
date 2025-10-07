import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/user/domain/usecases/check_user_exists_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/user_boolean_state.dart';

class CheckUserExistsNotifier
    extends AutoDisposeFamilyNotifier<UserBooleanState, String> {
  CheckUserExistsUsecase get _checkUserExistsUsecase =>
      ref.watch(checkUserExistsUsecaseProvider);

  @override
  UserBooleanState build(String id) {
    this.logPresentation('Checking if user exists: $id');
    _checkExists(id);
    return UserBooleanState.initial();
  }

  Future<void> _checkExists(String id) async {
    state = UserBooleanState.loading();

    final result = await _checkUserExistsUsecase.call(
      CheckUserExistsUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError('Failed to check user exists', failure);
        state = UserBooleanState.error(failure);
      },
      (success) {
        this.logData('User exists: ${success.data}');
        state = UserBooleanState.success(success.data ?? false);
      },
    );
  }

  Future<void> refresh() async {
    await _checkExists(arg);
  }
}
