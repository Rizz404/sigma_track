import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class GetUserByEmailUsecase
    implements Usecase<ItemSuccess<User>, GetUserByEmailUsecaseParams> {
  final UserRepository _userRepository;

  GetUserByEmailUsecase(this._userRepository);

  @override
  Future<Either<Failure, ItemSuccess<User>>> call(
    GetUserByEmailUsecaseParams params,
  ) async {
    return await _userRepository.getUserByEmail(params);
  }
}

class GetUserByEmailUsecaseParams extends Equatable {
  final String email;

  GetUserByEmailUsecaseParams({required this.email});

  Map<String, dynamic> toMap() {
    return {'email': email};
  }

  factory GetUserByEmailUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetUserByEmailUsecaseParams(email: map['email'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory GetUserByEmailUsecaseParams.fromJson(String source) =>
      GetUserByEmailUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() => 'GetUserByEmailUsecaseParams(email: $email)';

  @override
  List<Object> get props => [email];
}
