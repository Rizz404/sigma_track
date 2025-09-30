import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';

class MarkNotificationAsUnreadUsecase
    implements
        Usecase<
          ItemSuccess<Notification>,
          MarkNotificationAsUnreadUsecaseParams
        > {
  final NotificationRepository _notificationRepository;

  MarkNotificationAsUnreadUsecase(this._notificationRepository);

  @override
  Future<Either<Failure, ItemSuccess<Notification>>> call(
    MarkNotificationAsUnreadUsecaseParams params,
  ) async {
    return await _notificationRepository.markNotificationAsUnread(params);
  }
}

class MarkNotificationAsUnreadUsecaseParams extends Equatable {
  final String id;

  const MarkNotificationAsUnreadUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
