import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';

class MarkNotificationsAsUnreadUsecase
    implements Usecase<ActionSuccess, MarkNotificationsAsUnreadUsecaseParams> {
  final NotificationRepository _notificationRepository;

  MarkNotificationsAsUnreadUsecase(this._notificationRepository);

  @override
  Future<Either<Failure, ActionSuccess>> call(
    MarkNotificationsAsUnreadUsecaseParams params,
  ) async {
    return await _notificationRepository.markNotificationsAsUnread(params);
  }
}

class MarkNotificationsAsUnreadUsecaseParams extends Equatable {
  final List<String> notificationIds;

  const MarkNotificationsAsUnreadUsecaseParams({required this.notificationIds});

  Map<String, dynamic> toMap() {
    return {'notificationIds': notificationIds};
  }

  factory MarkNotificationsAsUnreadUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return MarkNotificationsAsUnreadUsecaseParams(
      notificationIds: List<String>.from(map['notificationIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MarkNotificationsAsUnreadUsecaseParams.fromJson(String source) =>
      MarkNotificationsAsUnreadUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object> get props => [notificationIds];
}
