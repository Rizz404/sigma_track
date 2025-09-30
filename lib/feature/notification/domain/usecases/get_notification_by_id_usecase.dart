import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';

class GetNotificationByIdUsecase
    implements
        Usecase<ItemSuccess<Notification>, GetNotificationByIdUsecaseParams> {
  final NotificationRepository _notificationRepository;

  GetNotificationByIdUsecase(this._notificationRepository);

  @override
  Future<Either<Failure, ItemSuccess<Notification>>> call(
    GetNotificationByIdUsecaseParams params,
  ) async {
    return await _notificationRepository.getNotificationById(params);
  }
}

class GetNotificationByIdUsecaseParams extends Equatable {
  final String id;

  const GetNotificationByIdUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
