import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_current_user_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/change_current_user_password_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/update_current_user_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/current_user_state.dart';

class CurrentUserNotifier extends AutoDisposeNotifier<CurrentUserState> {
  GetCurrentUserUsecase get _getCurrentUserUsecase =>
      ref.watch(getCurrentUserUsecaseProvider);
  UpdateCurrentUserUsecase get _updateCurrentUserUsecase =>
      ref.watch(updateCurrentUserUsecaseProvider);
  ChangeCurrentUserPasswordUsecase get _changeCurrentUserPasswordUsecase =>
      ref.watch(changeCurrentUserPasswordUsecaseProvider);

  @override
  CurrentUserState build() {
    // * Cache current user for 5 minutes (profile/navigation use case)
    ref.cacheFor(const Duration(minutes: 5));
    this.logPresentation('Initializing CurrentUserNotifier');
    _initializeCurrentUser();
    return CurrentUserState.initial();
  }

  Future<void> _initializeCurrentUser() async {
    await _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    this.logPresentation('Loading current user');

    state = CurrentUserState.loading();

    final result = await _getCurrentUserUsecase.call(NoParams());

    result.fold(
      (failure) {
        this.logError('Failed to load current user', failure);
        state = CurrentUserState.error(failure);
      },
      (success) {
        this.logData('Current user loaded: ${success.data?.name}');
        if (success.data != null) {
          state = CurrentUserState.success(
            success.data!,
            message: success.message,
          );
        } else {
          state = CurrentUserState.error(
            const ServerFailure(message: 'Current user not found'),
          );
        }
      },
    );
  }

  Future<void> updateProfile(UpdateCurrentUserUsecaseParams params) async {
    this.logPresentation('Updating current user profile');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _updateCurrentUserUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to update profile', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) async {
        this.logData('Profile updated: ${success.data?.name}');
        if (success.data != null) {
          state = CurrentUserState.success(
            success.data!,
            message: success.message ?? 'Profile updated successfully',
            mutatedUser: success.data,
          );
        } else {
          state = state.copyWith(
            isMutating: false,
            failure: () =>
                const ServerFailure(message: 'Failed to update profile'),
          );
        }
        await refresh();
      },
    );
  }

  Future<void> changePassword(
    ChangeCurrentUserPasswordUsecaseParams params,
  ) async {
    this.logPresentation('Changing current user password');

    state = state.copyWith(
      isMutating: true,
      failure: () => null,
      message: () => null,
    );

    final result = await _changeCurrentUserPasswordUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to change password', failure);
        state = state.copyWith(isMutating: false, failure: () => failure);
      },
      (success) {
        this.logData('Password changed successfully');
        state = state.copyWith(
          message: () => success.message ?? 'Password changed successfully',
          isMutating: false,
        );
        // Note: No refresh needed as password change doesn't affect user data
      },
    );
  }

  Future<void> refresh() async {
    await _loadCurrentUser();
  }

  void reset() {
    state = CurrentUserState.initial();
  }
}
