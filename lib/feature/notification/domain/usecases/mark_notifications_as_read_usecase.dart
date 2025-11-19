import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';

class MarkNotificationsAsReadUsecase
    implements Usecase<ActionSuccess, MarkNotificationsAsReadUsecaseParams> {
  final NotificationRepository _notificationRepository;

  MarkNotificationsAsReadUsecase(this._notificationRepository);

  @override
  Future<Either<Failure, ActionSuccess>> call(
    MarkNotificationsAsReadUsecaseParams params,
  ) async {
    return await _notificationRepository.markNotificationsAsRead(params);
  }
}

class MarkNotificationsAsReadUsecaseParams extends Equatable {
  final List<String> notificationIds;

  const MarkNotificationsAsReadUsecaseParams({required this.notificationIds});

  Map<String, dynamic> toMap() {
    return {'notificationIds': notificationIds};
  }

  factory MarkNotificationsAsReadUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return MarkNotificationsAsReadUsecaseParams(
      notificationIds: List<String>.from(map['notificationIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MarkNotificationsAsReadUsecaseParams.fromJson(String source) =>
      MarkNotificationsAsReadUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object> get props => [notificationIds];
}
