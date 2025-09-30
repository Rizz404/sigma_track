import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';

class DeleteNotificationUsecase
    implements Usecase<ActionSuccess, DeleteNotificationUsecaseParams> {
  final NotificationRepository _notificationRepository;

  DeleteNotificationUsecase(this._notificationRepository);

  @override
  Future<Either<Failure, ActionSuccess>> call(
    DeleteNotificationUsecaseParams params,
  ) async {
    return await _notificationRepository.deleteNotification(params);
  }
}

class DeleteNotificationUsecaseParams extends Equatable {
  final String id;

  const DeleteNotificationUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
