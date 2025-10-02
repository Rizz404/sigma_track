import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
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
  final String? search;
  final String? userId;
  final String? relatedAssetId;
  final NotificationType? type;
  final bool? isRead;
  final NotificationSortBy? sortBy;
  final SortOrder? sortOrder;
  final int? limit;
  final int? offset;

  const GetNotificationsUsecaseParams({
    this.search,
    this.userId,
    this.relatedAssetId,
    this.type,
    this.isRead,
    this.sortBy,
    this.sortOrder,
    this.limit,
    this.offset,
  });

  GetNotificationsUsecaseParams copyWith({
    String? search,
    String? userId,
    String? relatedAssetId,
    NotificationType? type,
    bool? isRead,
    NotificationSortBy? sortBy,
    SortOrder? sortOrder,
    int? limit,
    int? offset,
  }) {
    return GetNotificationsUsecaseParams(
      search: search ?? this.search,
      userId: userId ?? this.userId,
      relatedAssetId: relatedAssetId ?? this.relatedAssetId,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (userId != null) 'userId': userId,
      if (relatedAssetId != null) 'relatedAssetId': relatedAssetId,
      if (type != null) 'type': type!.value,
      if (isRead != null) 'isRead': isRead,
      if (sortBy != null) 'sortBy': sortBy!.value,
      if (sortOrder != null) 'sortOrder': sortOrder!.value,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
    };
  }

  factory GetNotificationsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetNotificationsUsecaseParams(
      search: map['search'],
      userId: map['userId'],
      relatedAssetId: map['relatedAssetId'],
      type: map['type'] != null
          ? NotificationType.fromString(map['type'])
          : null,
      isRead: map['isRead'],
      sortBy: map['sortBy'] != null
          ? NotificationSortBy.fromString(map['sortBy'])
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.fromString(map['sortOrder'])
          : null,
      limit: map['limit']?.toInt(),
      offset: map['offset']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetNotificationsUsecaseParams.fromJson(String source) =>
      GetNotificationsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetNotificationsUsecaseParams(search: $search, userId: $userId, relatedAssetId: $relatedAssetId, type: $type, isRead: $isRead, sortBy: $sortBy, sortOrder: $sortOrder, limit: $limit, offset: $offset)';

  @override
  List<Object?> get props => [
    search,
    userId,
    relatedAssetId,
    type,
    isRead,
    sortBy,
    sortOrder,
    limit,
    offset,
  ];
}
