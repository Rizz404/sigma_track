import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/mappers/cursor_mapper.dart';
import 'package:sigma_track/core/mappers/pagination_mapper.dart';
import 'package:sigma_track/core/network/models/api_error_response.dart';
import 'package:sigma_track/feature/notification/data/datasources/notification_remote_datasource.dart';
import 'package:sigma_track/feature/notification/data/mapper/notification_mappers.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification_statistics.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';
import 'package:sigma_track/feature/notification/domain/usecases/check_notification_exists_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/count_notifications_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/create_notification_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/get_notifications_cursor_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/get_notification_by_id_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/mark_notification_as_unread_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/update_notification_usecase.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDatasource _notificationRemoteDatasource;

  NotificationRepositoryImpl(this._notificationRemoteDatasource);

  @override
  Future<Either<Failure, ItemSuccess<Notification>>> createNotification(
    CreateNotificationUsecaseParams params,
  ) async {
    try {
      final response = await _notificationRemoteDatasource.createNotification(
        params,
      );
      final notification = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: notification));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      } else {
        return Left(ServerFailure(message: apiError.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<Notification>>>
  getNotifications(GetNotificationsUsecaseParams params) async {
    try {
      final response = await _notificationRemoteDatasource.getNotifications(
        params,
      );
      final notifications = response.data
          .map((model) => model.toEntity())
          .toList();
      final pagination = response.pagination.toEntity();
      return Right(
        OffsetPaginatedSuccess(
          message: response.message,
          data: notifications,
          pagination: pagination,
        ),
      );
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<NotificationStatistics>>>
  getNotificationsStatistics() async {
    try {
      final response = await _notificationRemoteDatasource
          .getNotificationsStatistics();
      final statistics = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: statistics));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CursorPaginatedSuccess<Notification>>>
  getNotificationsCursor(GetNotificationsCursorUsecaseParams params) async {
    try {
      final response = await _notificationRemoteDatasource
          .getNotificationsCursor(params);
      final notifications = response.data
          .map((model) => model.toEntity())
          .toList();
      final cursor = response.cursor.toEntity();
      return Right(
        CursorPaginatedSuccess(
          message: response.message,
          data: notifications,
          cursor: cursor,
        ),
      );
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<int>>> countNotifications(
    CountNotificationsUsecaseParams params,
  ) async {
    try {
      final response = await _notificationRemoteDatasource.countNotifications(
        params,
      );
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<bool>>> checkNotificationExists(
    CheckNotificationExistsUsecaseParams params,
  ) async {
    try {
      final response = await _notificationRemoteDatasource
          .checkNotificationExists(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Notification>>> getNotificationById(
    GetNotificationByIdUsecaseParams params,
  ) async {
    try {
      final response = await _notificationRemoteDatasource.getNotificationById(
        params,
      );
      final notification = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: notification));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Notification>>> markNotificationAsRead(
    MarkNotificationAsReadUsecaseParams params,
  ) async {
    try {
      final response = await _notificationRemoteDatasource
          .markNotificationAsRead(params);
      final notification = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: notification));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Notification>>> markNotificationAsUnread(
    MarkNotificationAsUnreadUsecaseParams params,
  ) async {
    try {
      final response = await _notificationRemoteDatasource
          .markNotificationAsUnread(params);
      final notification = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: notification));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> markAllNotificationsAsRead() async {
    try {
      final response = await _notificationRemoteDatasource
          .markAllNotificationsAsRead();
      return Right(ActionSuccess(message: response.message));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Notification>>> updateNotification(
    UpdateNotificationUsecaseParams params,
  ) async {
    try {
      final response = await _notificationRemoteDatasource.updateNotification(
        params,
      );
      final notification = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: notification));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      } else {
        return Left(ServerFailure(message: apiError.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> deleteNotification(
    DeleteNotificationUsecaseParams params,
  ) async {
    try {
      final response = await _notificationRemoteDatasource.deleteNotification(
        params,
      );
      return Right(ActionSuccess(message: response.message));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
