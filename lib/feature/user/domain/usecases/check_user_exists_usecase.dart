import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class CheckUserExistsUsecase
    implements Usecase<ItemSuccess<bool>, CheckUserExistsUsecaseParams> {
  final UserRepository _userRepository;

  CheckUserExistsUsecase(this._userRepository);

  @override
  Future<Either<Failure, ItemSuccess<bool>>> call(
    CheckUserExistsUsecaseParams params,
  ) async {
    return await _userRepository.checkUserExists(params);
  }
}

class CheckUserExistsUsecaseParams extends Equatable {
  final String id;

  CheckUserExistsUsecaseParams({required this.id});

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory CheckUserExistsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CheckUserExistsUsecaseParams(id: map['id'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory CheckUserExistsUsecaseParams.fromJson(String source) =>
      CheckUserExistsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() => 'CheckUserExistsUsecaseParams(id: $id)';

  @override
  List<Object> get props => [id];
}
