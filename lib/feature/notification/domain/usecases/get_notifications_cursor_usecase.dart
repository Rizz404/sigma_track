import 'dart:convert';

import 'package:flutter/foundation.dart';
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
    ValueGetter<String?>? search,
    ValueGetter<String?>? userId,
    ValueGetter<String?>? relatedAssetId,
    ValueGetter<NotificationType?>? type,
    ValueGetter<bool?>? isRead,
    ValueGetter<NotificationSortBy?>? sortBy,
    ValueGetter<SortOrder?>? sortOrder,
    ValueGetter<String?>? cursor,
    ValueGetter<int?>? limit,
  }) {
    return GetNotificationsCursorUsecaseParams(
      search: search != null ? search() : this.search,
      userId: userId != null ? userId() : this.userId,
      relatedAssetId: relatedAssetId != null
          ? relatedAssetId()
          : this.relatedAssetId,
      type: type != null ? type() : this.type,
      isRead: isRead != null ? isRead() : this.isRead,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortOrder: sortOrder != null ? sortOrder() : this.sortOrder,
      cursor: cursor != null ? cursor() : this.cursor,
      limit: limit != null ? limit() : this.limit,
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
