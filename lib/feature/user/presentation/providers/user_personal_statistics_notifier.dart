import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_user_personal_statistics_usecase.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/user_personal_statistics_state.dart';

class UserPersonalStatisticsNotifier
    extends AutoDisposeNotifier<UserPersonalStatisticsState> {
  GetUserPersonalStatisticsUseCase get _getUserPersonalStatisticsUseCase =>
      ref.watch(getUserPersonalStatisticsUseCaseProvider);

  @override
  UserPersonalStatisticsState build() {
    // * Cache statistics for 5 minutes (dashboard use case)
    ref.cacheFor(const Duration(minutes: 5));
    this.logPresentation('Loading user personal statistics');
    _loadStatistics();
    return UserPersonalStatisticsState.initial();
  }

  Future<void> _loadStatistics() async {
    state = UserPersonalStatisticsState.loading();

    final result = await _getUserPersonalStatisticsUseCase.call(NoParams());

    result.fold(
      (failure) {
        this.logError('Failed to load user personal statistics', failure);
        state = UserPersonalStatisticsState.error(failure);
      },
      (success) {
        this.logData('User personal statistics loaded');
        if (success.data != null) {
          state = UserPersonalStatisticsState.success(success.data!);
        } else {
          state = UserPersonalStatisticsState.error(
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
