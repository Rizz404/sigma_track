import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/network/models/api_cursor_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_offset_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/feature/notification/data/models/notification_model.dart';
import 'package:sigma_track/feature/notification/data/models/notification_statistics_model.dart';
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

abstract class NotificationRemoteDatasource {
  Future<ApiResponse<NotificationModel>> createNotification(
    CreateNotificationUsecaseParams params,
  );
  Future<ApiOffsetPaginationResponse<NotificationModel>> getNotifications(
    GetNotificationsUsecaseParams params,
  );
  Future<ApiResponse<NotificationStatisticsModel>> getNotificationsStatistics();
  Future<ApiCursorPaginationResponse<NotificationModel>> getNotificationsCursor(
    GetNotificationsCursorUsecaseParams params,
  );
  Future<ApiResponse<int>> countNotifications(
    CountNotificationsUsecaseParams params,
  );
  Future<ApiResponse<bool>> checkNotificationExists(
    CheckNotificationExistsUsecaseParams params,
  );
  Future<ApiResponse<NotificationModel>> getNotificationById(
    GetNotificationByIdUsecaseParams params,
  );
  Future<ApiResponse<NotificationModel>> markNotificationAsRead(
    MarkNotificationAsReadUsecaseParams params,
  );
  Future<ApiResponse<NotificationModel>> markNotificationAsUnread(
    MarkNotificationAsUnreadUsecaseParams params,
  );
  Future<ApiResponse<dynamic>> markAllNotificationsAsRead();
  Future<ApiResponse<NotificationModel>> updateNotification(
    UpdateNotificationUsecaseParams params,
  );
  Future<ApiResponse<dynamic>> deleteNotification(
    DeleteNotificationUsecaseParams params,
  );
}

class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  final DioClient _dioClient;

  NotificationRemoteDatasourceImpl(this._dioClient);

  @override
  Future<ApiResponse<NotificationModel>> createNotification(
    CreateNotificationUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.createNotification,
        data: params.toMap(),
        fromJson: (json) => NotificationModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiOffsetPaginationResponse<NotificationModel>> getNotifications(
    GetNotificationsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithOffset(
        ApiConstant.getNotifications,
        queryParameters: params.toMap(),
        fromJson: (json) => NotificationModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<NotificationStatisticsModel>>
  getNotificationsStatistics() async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getNotificationsStatistics,
        fromJson: (json) => NotificationStatisticsModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiCursorPaginationResponse<NotificationModel>> getNotificationsCursor(
    GetNotificationsCursorUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithCursor(
        ApiConstant.getNotificationsCursor,
        queryParameters: params.toMap(),
        fromJson: (json) => NotificationModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<int>> countNotifications(
    CountNotificationsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.countNotifications,
        queryParameters: params.toMap(),
        fromJson: (json) => json as int,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkNotificationExists(
    CheckNotificationExistsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.checkNotificationExists(params.id),
        fromJson: (json) => json as bool,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<NotificationModel>> getNotificationById(
    GetNotificationByIdUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getNotificationById(params.id),
        fromJson: (json) => NotificationModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<NotificationModel>> markNotificationAsRead(
    MarkNotificationAsReadUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.put(
        ApiConstant.markNotificationAsRead(params.id),
        fromJson: (json) => NotificationModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<NotificationModel>> markNotificationAsUnread(
    MarkNotificationAsUnreadUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.put(
        ApiConstant.markNotificationAsUnread(params.id),
        fromJson: (json) => NotificationModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<dynamic>> markAllNotificationsAsRead() async {
    try {
      final response = await _dioClient.put(
        ApiConstant.markAllNotificationsAsRead,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<NotificationModel>> updateNotification(
    UpdateNotificationUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.put(
        ApiConstant.updateNotification(params.id),
        data: params.toMap(),
        fromJson: (json) => NotificationModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<dynamic>> deleteNotification(
    DeleteNotificationUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.delete(
        ApiConstant.deleteNotification(params.id),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
