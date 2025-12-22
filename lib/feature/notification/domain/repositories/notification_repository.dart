import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification_statistics.dart';
import 'package:sigma_track/feature/notification/domain/usecases/bulk_create_notifications_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/check_notification_exists_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/count_notifications_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/create_notification_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/get_notifications_cursor_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/get_notification_by_id_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/mark_notifications_as_read_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/mark_notifications_as_unread_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/update_notification_usecase.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_response.dart';

abstract class NotificationRepository {
  Future<Either<Failure, ItemSuccess<Notification>>> createNotification(
    CreateNotificationUsecaseParams params,
  );
  Future<Either<Failure, OffsetPaginatedSuccess<Notification>>>
  getNotifications(GetNotificationsUsecaseParams params);
  Future<Either<Failure, ItemSuccess<NotificationStatistics>>>
  getNotificationsStatistics();
  Future<Either<Failure, CursorPaginatedSuccess<Notification>>>
  getNotificationsCursor(GetNotificationsCursorUsecaseParams params);
  Future<Either<Failure, ItemSuccess<int>>> countNotifications(
    CountNotificationsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<bool>>> checkNotificationExists(
    CheckNotificationExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<Notification>>> getNotificationById(
    GetNotificationByIdUsecaseParams params,
  );
  Future<Either<Failure, ActionSuccess>> markNotificationsAsRead(
    MarkNotificationsAsReadUsecaseParams params,
  );
  Future<Either<Failure, ActionSuccess>> markNotificationsAsUnread(
    MarkNotificationsAsUnreadUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<Notification>>> updateNotification(
    UpdateNotificationUsecaseParams params,
  );
  Future<Either<Failure, ActionSuccess>> deleteNotification(
    DeleteNotificationUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<BulkCreateNotificationsResponse>>>
  createManyNotifications(BulkCreateNotificationsParams params);
  Future<Either<Failure, ItemSuccess<BulkDeleteResponse>>>
  deleteManyNotifications(BulkDeleteParams params);
}
