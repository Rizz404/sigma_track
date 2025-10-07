import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/notification/domain/usecases/count_notifications_usecase.dart';
import 'package:sigma_track/feature/notification/presentation/providers/state/notification_count_state.dart';

class CountNotificationsNotifier
    extends
        AutoDisposeFamilyNotifier<
          NotificationCountState,
          CountNotificationsUsecaseParams
        > {
  CountNotificationsUsecase get _countNotificationsUsecase =>
      ref.watch(countNotificationsUsecaseProvider);

  @override
  NotificationCountState build(CountNotificationsUsecaseParams params) {
    this.logPresentation('Counting notifications with params: $params');
    _countNotifications(params);
    return NotificationCountState.initial();
  }

  Future<void> _countNotifications(CountNotificationsUsecaseParams params) async {
    state = NotificationCountState.loading();

    final result = await _countNotificationsUsecase.call(params);

    result.fold(
      (failure) {
        this.logError('Failed to count notifications', failure);
        state = NotificationCountState.error(failure);
      },
      (success) {
        this.logData('Notifications count: ${success.data}');
        state = NotificationCountState.success(success.data ?? 0);
      },
    );
  }

  Future<void> refresh() async {
    await _countNotifications(arg);
  }
}
