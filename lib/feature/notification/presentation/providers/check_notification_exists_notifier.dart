import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/notification/domain/usecases/check_notification_exists_usecase.dart';
import 'package:sigma_track/feature/notification/presentation/providers/state/notification_boolean_state.dart';

class CheckNotificationExistsNotifier
    extends AutoDisposeFamilyNotifier<NotificationBooleanState, String> {
  CheckNotificationExistsUsecase get _checkNotificationExistsUsecase =>
      ref.watch(checkNotificationExistsUsecaseProvider);

  @override
  NotificationBooleanState build(String id) {
    this.logPresentation('Checking if notification exists: $id');
    _checkExists(id);
    return NotificationBooleanState.initial();
  }

  Future<void> _checkExists(String id) async {
    state = NotificationBooleanState.loading();

    final result = await _checkNotificationExistsUsecase.call(
      CheckNotificationExistsUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError('Failed to check notification exists', failure);
        state = NotificationBooleanState.error(failure);
      },
      (success) {
        this.logData('Notification exists: ${success.data}');
        state = NotificationBooleanState.success(success.data ?? false);
      },
    );
  }

  Future<void> refresh() async {
    await _checkExists(arg);
  }
}
