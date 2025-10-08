import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_current_user_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/user_detail_state.dart';

class GetCurrentUserNotifier extends AutoDisposeNotifier<UserDetailState> {
  GetCurrentUserUsecase get _getCurrentUserUsecase =>
      ref.watch(getCurrentUserUsecaseProvider);

  @override
  UserDetailState build() {
    // * Cache current user for 5 minutes (profile/navigation use case)
    ref.cacheFor(const Duration(minutes: 5));
    this.logPresentation('Loading current user');
    _loadCurrentUser();
    return UserDetailState.initial();
  }

  Future<void> _loadCurrentUser() async {
    state = UserDetailState.loading();

    final result = await _getCurrentUserUsecase.call(NoParams());

    result.fold(
      (failure) {
        this.logError('Failed to load current user', failure);
        state = UserDetailState.error(failure);
      },
      (success) {
        this.logData('Current user loaded: ${success.data?.name}');
        if (success.data != null) {
          state = UserDetailState.success(success.data!);
        } else {
          state = UserDetailState.error(
            const ServerFailure(message: 'Current user not found'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadCurrentUser();
  }
}
