import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';

class GetNotificationsCursorUsecase
    implements
        Usecase<
          CursorPaginatedSuccess<dynamic>,
          GetNotificationsCursorUsecaseParams
        > {
  final NotificationRepository _notificationRepository;

  GetNotificationsCursorUsecase(this._notificationRepository);

  @override
  Future<Either<Failure, CursorPaginatedSuccess<dynamic>>> call(
    GetNotificationsCursorUsecaseParams params,
  ) async {
    return await _notificationRepository.getNotificationsCursor(params);
  }
}

class GetNotificationsCursorUsecaseParams extends Equatable {
  final int? limit;
  final String? cursor;
  final String? search;
  final String? sortBy;
  final String? sortOrder;
  final String? userId;
  final String? type;
  final bool? isRead;

  const GetNotificationsCursorUsecaseParams({
    this.limit,
    this.cursor,
    this.search,
    this.sortBy,
    this.sortOrder,
    this.userId,
    this.type,
    this.isRead,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (limit != null) map['limit'] = limit;
    if (cursor != null) map['cursor'] = cursor;
    if (search != null) map['search'] = search;
    if (sortBy != null) map['sortBy'] = sortBy;
    if (sortOrder != null) map['sortOrder'] = sortOrder;
    if (userId != null) map['userId'] = userId;
    if (type != null) map['type'] = type;
    if (isRead != null) map['isRead'] = isRead;
    return map;
  }

  @override
  List<Object?> get props => [
    limit,
    cursor,
    search,
    sortBy,
    sortOrder,
    userId,
    type,
    isRead,
  ];
}
