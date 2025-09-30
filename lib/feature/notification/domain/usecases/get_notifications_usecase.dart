import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';

class GetNotificationsUsecase
    implements
        Usecase<
          OffsetPaginatedSuccess<dynamic>,
          GetNotificationsUsecaseParams
        > {
  final NotificationRepository _notificationRepository;

  GetNotificationsUsecase(this._notificationRepository);

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<dynamic>>> call(
    GetNotificationsUsecaseParams params,
  ) async {
    return await _notificationRepository.getNotifications(params);
  }
}

class GetNotificationsUsecaseParams extends Equatable {
  final int? limit;
  final int? offset;
  final String? search;
  final String? sortBy;
  final String? sortOrder;
  final String? userId;
  final String? type;
  final bool? isRead;

  const GetNotificationsUsecaseParams({
    this.limit,
    this.offset,
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
    if (offset != null) map['offset'] = offset;
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
    offset,
    search,
    sortBy,
    sortOrder,
    userId,
    type,
    isRead,
  ];
}
