import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class CheckUserNameExistsUsecase
    implements Usecase<ItemSuccess<bool>, CheckUserNameExistsUsecaseParams> {
  final UserRepository _userRepository;

  CheckUserNameExistsUsecase(this._userRepository);

  @override
  Future<Either<Failure, ItemSuccess<bool>>> call(
    CheckUserNameExistsUsecaseParams params,
  ) async {
    return await _userRepository.checkUserNameExists(params);
  }
}

class CheckUserNameExistsUsecaseParams extends Equatable {
  final String name;

  CheckUserNameExistsUsecaseParams({required this.name});

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  factory CheckUserNameExistsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CheckUserNameExistsUsecaseParams(name: map['name'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory CheckUserNameExistsUsecaseParams.fromJson(String source) =>
      CheckUserNameExistsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() => 'CheckUserNameExistsUsecaseParams(name: $name)';

  @override
  List<Object> get props => [name];
}
