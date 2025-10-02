import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';

class CountNotificationsUsecase
    implements Usecase<ItemSuccess<int>, CountNotificationsUsecaseParams> {
  final NotificationRepository _notificationRepository;

  CountNotificationsUsecase(this._notificationRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(
    CountNotificationsUsecaseParams params,
  ) async {
    return await _notificationRepository.countNotifications(params);
  }
}

class CountNotificationsUsecaseParams extends Equatable {
  final String? userId;
  final bool? isRead;

  const CountNotificationsUsecaseParams({this.userId, this.isRead});

  CountNotificationsUsecaseParams copyWith({String? userId, bool? isRead}) {
    return CountNotificationsUsecaseParams(
      userId: userId ?? this.userId,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (userId != null) 'userId': userId,
      if (isRead != null) 'isRead': isRead,
    };
  }

  factory CountNotificationsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CountNotificationsUsecaseParams(
      userId: map['userId'],
      isRead: map['isRead'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CountNotificationsUsecaseParams.fromJson(String source) =>
      CountNotificationsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'CountNotificationsUsecaseParams(userId: $userId, isRead: $isRead)';

  @override
  List<Object?> get props => [userId, isRead];
}
