import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification_statistics.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';

class GetNotificationsStatisticsUsecase
    implements Usecase<ItemSuccess<NotificationStatistics>, NoParams> {
  final NotificationRepository _notificationRepository;

  GetNotificationsStatisticsUsecase(this._notificationRepository);

  @override
  Future<Either<Failure, ItemSuccess<NotificationStatistics>>> call(
    NoParams params,
  ) async {
    return await _notificationRepository.getNotificationsStatistics();
  }
}
