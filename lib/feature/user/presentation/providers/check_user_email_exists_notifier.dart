import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/user/domain/usecases/check_user_email_exists_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/user_boolean_state.dart';

class CheckUserEmailExistsNotifier
    extends AutoDisposeFamilyNotifier<UserBooleanState, String> {
  CheckUserEmailExistsUsecase get _checkUserEmailExistsUsecase =>
      ref.watch(checkUserEmailExistsUsecaseProvider);

  @override
  UserBooleanState build(String email) {
    // * Cache validation for 30 seconds (form validation use case)
    ref.cacheFor(const Duration(seconds: 30));
    this.logPresentation('Checking if user email exists: $email');
    _checkEmailExists(email);
    return UserBooleanState.initial();
  }

  Future<void> _checkEmailExists(String email) async {
    state = UserBooleanState.loading();

    final result = await _checkUserEmailExistsUsecase.call(
      CheckUserEmailExistsUsecaseParams(email: email),
    );

    result.fold(
      (failure) {
        this.logError('Failed to check user email', failure);
        state = UserBooleanState.error(failure);
      },
      (success) {
        this.logData('User email exists: ${success.data}');
        state = UserBooleanState.success(success.data ?? false);
      },
    );
  }

  Future<void> refresh() async {
    await _checkEmailExists(arg);
  }
}
