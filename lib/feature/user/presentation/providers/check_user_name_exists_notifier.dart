import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/user/domain/usecases/check_user_name_exists_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/user_boolean_state.dart';

class CheckUserNameExistsNotifier
    extends AutoDisposeFamilyNotifier<UserBooleanState, String> {
  CheckUserNameExistsUsecase get _checkUserNameExistsUsecase =>
      ref.watch(checkUserNameExistsUsecaseProvider);

  @override
  UserBooleanState build(String name) {
    this.logPresentation('Checking if user name exists: $name');
    _checkNameExists(name);
    return UserBooleanState.initial();
  }

  Future<void> _checkNameExists(String name) async {
    state = UserBooleanState.loading();

    final result = await _checkUserNameExistsUsecase.call(
      CheckUserNameExistsUsecaseParams(name: name),
    );

    result.fold(
      (failure) {
        this.logError('Failed to check user name', failure);
        state = UserBooleanState.error(failure);
      },
      (success) {
        this.logData('User name exists: ${success.data}');
        state = UserBooleanState.success(success.data ?? false);
      },
    );
  }

  Future<void> refresh() async {
    await _checkNameExists(arg);
  }
}
