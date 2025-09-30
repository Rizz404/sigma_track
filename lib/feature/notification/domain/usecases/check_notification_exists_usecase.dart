import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';

class CheckNotificationExistsUsecase
    implements
        Usecase<ItemSuccess<bool>, CheckNotificationExistsUsecaseParams> {
  final NotificationRepository _notificationRepository;

  CheckNotificationExistsUsecase(this._notificationRepository);

  @override
  Future<Either<Failure, ItemSuccess<bool>>> call(
    CheckNotificationExistsUsecaseParams params,
  ) async {
    return await _notificationRepository.checkNotificationExists(params);
  }
}

class CheckNotificationExistsUsecaseParams extends Equatable {
  final String id;

  const CheckNotificationExistsUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
