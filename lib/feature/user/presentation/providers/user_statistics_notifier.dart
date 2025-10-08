import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_users_statistics_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/user_statistics_state.dart';

class UserStatisticsNotifier extends AutoDisposeNotifier<UserStatisticsState> {
  GetUsersStatisticsUsecase get _getUsersStatisticsUsecase =>
      ref.watch(getUsersStatisticsUsecaseProvider);

  @override
  UserStatisticsState build() {
    // * Cache statistics for 5 minutes (dashboard use case)
    ref.cacheFor(const Duration(minutes: 5));
    this.logPresentation('Loading user statistics');
    _loadStatistics();
    return UserStatisticsState.initial();
  }

  Future<void> _loadStatistics() async {
    state = UserStatisticsState.loading();

    final result = await _getUsersStatisticsUsecase.call(NoParams());

    result.fold(
      (failure) {
        this.logError('Failed to load user statistics', failure);
        state = UserStatisticsState.error(failure);
      },
      (success) {
        this.logData('User statistics loaded');
        if (success.data != null) {
          state = UserStatisticsState.success(success.data!);
        } else {
          state = UserStatisticsState.error(
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
