import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/di/usecase_providers.dart';
import 'package:sigma_track/feature/notification/domain/usecases/get_notification_by_id_usecase.dart';
import 'package:sigma_track/feature/notification/presentation/providers/state/notification_detail_state.dart';

class GetNotificationByIdNotifier
    extends AutoDisposeFamilyNotifier<NotificationDetailState, String> {
  GetNotificationByIdUsecase get _getNotificationByIdUsecase =>
      ref.watch(getNotificationByIdUsecaseProvider);

  @override
  NotificationDetailState build(String id) {
    this.logPresentation('Loading notification by id: $id');
    _loadNotification(id);
    return NotificationDetailState.initial();
  }

  Future<void> _loadNotification(String id) async {
    state = NotificationDetailState.loading();

    final result = await _getNotificationByIdUsecase.call(
      GetNotificationByIdUsecaseParams(id: id),
    );

    result.fold(
      (failure) {
        this.logError('Failed to load notification by id', failure);
        state = NotificationDetailState.error(failure);
      },
      (success) {
        this.logData('Notification loaded by id: ${success.data?.title}');
        if (success.data != null) {
          state = NotificationDetailState.success(success.data!);
        } else {
          state = NotificationDetailState.error(
            const ServerFailure(message: 'Notification not found'),
          );
        }
      },
    );
  }

  Future<void> refresh() async {
    await _loadNotification(arg);
  }
}
