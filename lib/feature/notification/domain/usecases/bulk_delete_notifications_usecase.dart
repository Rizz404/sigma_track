import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_response.dart';

class BulkDeleteNotificationsUsecase
    implements Usecase<ItemSuccess<BulkDeleteResponse>, BulkDeleteParams> {
  final NotificationRepository _notificationRepository;

  BulkDeleteNotificationsUsecase(this._notificationRepository);

  @override
  Future<Either<Failure, ItemSuccess<BulkDeleteResponse>>> call(
    BulkDeleteParams params,
  ) async {
    return await _notificationRepository.deleteManyNotifications(params);
  }
}
