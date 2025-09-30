import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';

class CountNotificationsUsecase implements Usecase<ItemSuccess<int>, NoParams> {
  final NotificationRepository _notificationRepository;

  CountNotificationsUsecase(this._notificationRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(NoParams params) async {
    return await _notificationRepository.countNotifications();
  }
}
