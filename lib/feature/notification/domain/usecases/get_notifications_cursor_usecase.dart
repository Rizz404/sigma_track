import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
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
  final String? search;
  final String? userId;
  final String? relatedAssetId;
  final NotificationType? type;
  final bool? isRead;
  final NotificationSortBy? sortBy;
  final SortOrder? sortOrder;
  final String? cursor;
  final int? limit;

  const GetNotificationsCursorUsecaseParams({
    this.search,
    this.userId,
    this.relatedAssetId,
    this.type,
    this.isRead,
    this.sortBy,
    this.sortOrder,
    this.cursor,
    this.limit,
  });

  GetNotificationsCursorUsecaseParams copyWith({
    String? search,
    String? userId,
    String? relatedAssetId,
    NotificationType? type,
    bool? isRead,
    NotificationSortBy? sortBy,
    SortOrder? sortOrder,
    String? cursor,
    int? limit,
  }) {
    return GetNotificationsCursorUsecaseParams(
      search: search ?? this.search,
      userId: userId ?? this.userId,
      relatedAssetId: relatedAssetId ?? this.relatedAssetId,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      cursor: cursor ?? this.cursor,
      limit: limit ?? this.limit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (search != null) 'search': search,
      if (userId != null) 'userId': userId,
      if (relatedAssetId != null) 'relatedAssetId': relatedAssetId,
      if (type != null) 'type': type!.toString(),
      if (isRead != null) 'isRead': isRead,
      if (sortBy != null) 'sortBy': sortBy!.toString(),
      if (sortOrder != null) 'sortOrder': sortOrder!.toString(),
      if (cursor != null) 'cursor': cursor,
      if (limit != null) 'limit': limit,
    };
  }

  factory GetNotificationsCursorUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return GetNotificationsCursorUsecaseParams(
      search: map['search'],
      userId: map['userId'],
      relatedAssetId: map['relatedAssetId'],
      type: map['type'] != null
          ? NotificationType.values.firstWhere((e) => e.value == map['type'])
          : null,
      isRead: map['isRead'],
      sortBy: map['sortBy'] != null
          ? NotificationSortBy.values.firstWhere(
              (e) => e.value == map['sortBy'],
            )
          : null,
      sortOrder: map['sortOrder'] != null
          ? SortOrder.values.firstWhere((e) => e.value == map['sortOrder'])
          : null,
      cursor: map['cursor'],
      limit: map['limit']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory GetNotificationsCursorUsecaseParams.fromJson(String source) =>
      GetNotificationsCursorUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetNotificationsCursorUsecaseParams(search: $search, userId: $userId, relatedAssetId: $relatedAssetId, type: $type, isRead: $isRead, sortBy: $sortBy, sortOrder: $sortOrder, cursor: $cursor, limit: $limit)';

  @override
  List<Object?> get props => [
    search,
    userId,
    relatedAssetId,
    type,
    isRead,
    sortBy,
    sortOrder,
    cursor,
    limit,
  ];
}
