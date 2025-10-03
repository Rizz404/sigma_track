import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';

import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/auth/domain/repositories/auth_repository.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';

class RegisterUsecase
    implements Usecase<ItemSuccess<User>, RegisterUsecaseParams> {
  final AuthRepository _authRepository;

  RegisterUsecase(this._authRepository);

  @override
  Future<Either<Failure, ItemSuccess<User>>> call(
    RegisterUsecaseParams params,
  ) async {
    return await _authRepository.register(params);
  }
}

class RegisterUsecaseParams extends Equatable {
  final String name;
  final String email;
  final String password;
  RegisterUsecaseParams({
    required this.name,
    required this.email,
    required this.password,
  });

  RegisterUsecaseParams copyWith({
    String? name,
    String? email,
    String? password,
  }) {
    return RegisterUsecaseParams(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'password': password};
  }

  factory RegisterUsecaseParams.fromMap(Map<String, dynamic> map) {
    return RegisterUsecaseParams(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterUsecaseParams.fromJson(String source) =>
      RegisterUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'RegisterUsecaseParams(name: $name, email: $email, password: $password)';

  @override
  List<Object> get props => [name, email, password];
}
