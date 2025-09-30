import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/auth/domain/entities/auth.dart';
import 'package:sigma_track/feature/auth/domain/repositories/auth_repository.dart';

class LoginUsecase implements Usecase<ItemSuccess<Auth>, LoginUsecaseParams> {
  final AuthRepository _authRepository;

  LoginUsecase(this._authRepository);

  @override
  Future<Either<Failure, ItemSuccess<Auth>>> call(
    LoginUsecaseParams params,
  ) async {
    return await _authRepository.login(params);
  }
}

class LoginUsecaseParams extends Equatable {
  final String email;
  final String password;

  LoginUsecaseParams({required this.email, required this.password});

  LoginUsecaseParams copyWith({String? email, String? password}) {
    return LoginUsecaseParams(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'password': password};
  }

  factory LoginUsecaseParams.fromMap(Map<String, dynamic> map) {
    return LoginUsecaseParams(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginUsecaseParams.fromJson(String source) =>
      LoginUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() => 'LoginUsecaseParams(email: $email, password: $password)';

  @override
  List<Object> get props => [email, password];
}
