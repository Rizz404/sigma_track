import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class GetUserByNameUsecase
    implements Usecase<ItemSuccess<User>, GetUserByNameUsecaseParams> {
  final UserRepository _userRepository;

  GetUserByNameUsecase(this._userRepository);

  @override
  Future<Either<Failure, ItemSuccess<User>>> call(
    GetUserByNameUsecaseParams params,
  ) async {
    return await _userRepository.getUserByName(params);
  }
}

class GetUserByNameUsecaseParams extends Equatable {
  final String name;

  GetUserByNameUsecaseParams({required this.name});

  Map<String, dynamic> toMap() {
    return {'name': name};
  }

  factory GetUserByNameUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetUserByNameUsecaseParams(name: map['name'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory GetUserByNameUsecaseParams.fromJson(String source) =>
      GetUserByNameUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() => 'GetUserByNameUsecaseParams(name: $name)';

  @override
  List<Object> get props => [name];
}
