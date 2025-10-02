import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class GetUserByIdUsecase
    implements Usecase<ItemSuccess<User>, GetUserByIdUsecaseParams> {
  final UserRepository _userRepository;

  GetUserByIdUsecase(this._userRepository);

  @override
  Future<Either<Failure, ItemSuccess<User>>> call(
    GetUserByIdUsecaseParams params,
  ) async {
    return await _userRepository.getUserById(params);
  }
}

class GetUserByIdUsecaseParams extends Equatable {
  final String id;

  GetUserByIdUsecaseParams({required this.id});

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory GetUserByIdUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetUserByIdUsecaseParams(id: map['id'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory GetUserByIdUsecaseParams.fromJson(String source) =>
      GetUserByIdUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() => 'GetUserByIdUsecaseParams(id: $id)';

  @override
  List<Object> get props => [id];
}
