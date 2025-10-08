import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/extensions/riverpod_extension.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/notification/domain/usecases/get_notifications_statistics_usecase.dart';
import 'package:sigma_track/feature/notification/presentation/providers/state/notification_statistics_state.dart';

class NotificationStatisticsNotifier
    extends AutoDisposeNotifier<NotificationStatisticsState> {
  GetNotificationsStatisticsUsecase get _getNotificationsStatisticsUsecase =>
      ref.watch(getNotificationsStatisticsUsecaseProvider);

  @override
  NotificationStatisticsState build() {
    // * Cache statistics for 5 minutes (dashboard use case)
    ref.cacheFor(const Duration(minutes: 5));
    this.logPresentation('Loading notification statistics');
    _loadStatistics();
    return NotificationStatisticsState.initial();
  }

  Future<void> _loadStatistics() async {
    state = NotificationStatisticsState.loading();

    final result = await _getNotificationsStatisticsUsecase.call(NoParams());

    result.fold(
      (failure) {
        this.logError('Failed to load notification statistics', failure);
        state = NotificationStatisticsState.error(failure);
      },
      (success) {
        this.logData('Notification statistics loaded');
        if (success.data != null) {
          state = NotificationStatisticsState.success(success.data!);
        } else {
          state = NotificationStatisticsState.error(
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
