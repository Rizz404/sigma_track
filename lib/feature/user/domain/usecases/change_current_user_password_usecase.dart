import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class ChangeCurrentUserPasswordUsecase
    implements Usecase<ActionSuccess, ChangeCurrentUserPasswordUsecaseParams> {
  final UserRepository _userRepository;

  ChangeCurrentUserPasswordUsecase(this._userRepository);

  @override
  Future<Either<Failure, ActionSuccess>> call(
    ChangeCurrentUserPasswordUsecaseParams params,
  ) async {
    return await _userRepository.changeCurrentUserPassword(params);
  }
}

class ChangeCurrentUserPasswordUsecaseParams extends Equatable {
  final String oldPassword;
  final String newPassword;

  ChangeCurrentUserPasswordUsecaseParams({
    required this.oldPassword,
    required this.newPassword,
  });

  ChangeCurrentUserPasswordUsecaseParams copyWith({
    String? oldPassword,
    String? newPassword,
  }) {
    return ChangeCurrentUserPasswordUsecaseParams(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
    );
  }

  Map<String, dynamic> toMap() {
    return {'oldPassword': oldPassword, 'newPassword': newPassword};
  }

  factory ChangeCurrentUserPasswordUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return ChangeCurrentUserPasswordUsecaseParams(
      oldPassword: map['oldPassword'] ?? '',
      newPassword: map['newPassword'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChangeCurrentUserPasswordUsecaseParams.fromJson(String source) =>
      ChangeCurrentUserPasswordUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChangeCurrentUserPasswordUsecaseParams(oldPassword: $oldPassword, newPassword: $newPassword)';
  }

  @override
  List<Object> get props => [oldPassword, newPassword];
}
