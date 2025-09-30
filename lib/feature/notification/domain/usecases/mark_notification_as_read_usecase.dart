import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';

class MarkNotificationAsReadUsecase
    implements
        Usecase<
          ItemSuccess<Notification>,
          MarkNotificationAsReadUsecaseParams
        > {
  final NotificationRepository _notificationRepository;

  MarkNotificationAsReadUsecase(this._notificationRepository);

  @override
  Future<Either<Failure, ItemSuccess<Notification>>> call(
    MarkNotificationAsReadUsecaseParams params,
  ) async {
    return await _notificationRepository.markNotificationAsRead(params);
  }
}

class MarkNotificationAsReadUsecaseParams extends Equatable {
  final String id;

  const MarkNotificationAsReadUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
