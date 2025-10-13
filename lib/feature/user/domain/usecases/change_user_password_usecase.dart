import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class ChangeUserPasswordUsecase
    implements Usecase<ActionSuccess, ChangeUserPasswordUsecaseParams> {
  final UserRepository _userRepository;

  ChangeUserPasswordUsecase(this._userRepository);

  @override
  Future<Either<Failure, ActionSuccess>> call(
    ChangeUserPasswordUsecaseParams params,
  ) async {
    return await _userRepository.changeUserPassword(params);
  }
}

class ChangeUserPasswordUsecaseParams extends Equatable {
  final String id;
  final String oldPassword;
  final String newPassword;

  ChangeUserPasswordUsecaseParams({
    required this.id,
    required this.oldPassword,
    required this.newPassword,
  });

  ChangeUserPasswordUsecaseParams copyWith({
    String? id,
    String? oldPassword,
    String? newPassword,
  }) {
    return ChangeUserPasswordUsecaseParams(
      id: id ?? this.id,
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
    );
  }

  Map<String, dynamic> toMap() {
    return {'oldPassword': oldPassword, 'newPassword': newPassword};
  }

  factory ChangeUserPasswordUsecaseParams.fromMap(Map<String, dynamic> map) {
    return ChangeUserPasswordUsecaseParams(
      id: map['id'] ?? '',
      oldPassword: map['oldPassword'] ?? '',
      newPassword: map['newPassword'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChangeUserPasswordUsecaseParams.fromJson(String source) =>
      ChangeUserPasswordUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChangeUserPasswordUsecaseParams(id: $id, oldPassword: $oldPassword, newPassword: $newPassword)';
  }

  @override
  List<Object> get props => [id, oldPassword, newPassword];
}
