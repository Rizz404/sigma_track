import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class DeleteUserUsecase
    implements Usecase<ActionSuccess, DeleteUserUsecaseParams> {
  final UserRepository _userRepository;

  DeleteUserUsecase(this._userRepository);

  @override
  Future<Either<Failure, ActionSuccess>> call(
    DeleteUserUsecaseParams params,
  ) async {
    return await _userRepository.deleteUser(params);
  }
}

class DeleteUserUsecaseParams extends Equatable {
  final String id;

  DeleteUserUsecaseParams({required this.id});

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory DeleteUserUsecaseParams.fromMap(Map<String, dynamic> map) {
    return DeleteUserUsecaseParams(id: map['id'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory DeleteUserUsecaseParams.fromJson(String source) =>
      DeleteUserUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() => 'DeleteUserUsecaseParams(id: $id)';

  @override
  List<Object> get props => [id];
}
