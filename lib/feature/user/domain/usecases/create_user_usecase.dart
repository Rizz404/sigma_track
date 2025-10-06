import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class CreateUserUsecase
    implements Usecase<ItemSuccess<User>, CreateUserUsecaseParams> {
  final UserRepository _userRepository;

  CreateUserUsecase(this._userRepository);

  @override
  Future<Either<Failure, ItemSuccess<User>>> call(
    CreateUserUsecaseParams params,
  ) async {
    return await _userRepository.createUser(params);
  }
}

class CreateUserUsecaseParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String fullName;
  final String role;
  final String? employeeId; // * Biarkan kosong saja
  final String? preferredLang;

  CreateUserUsecaseParams({
    required this.name,
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
    this.employeeId,
    this.preferredLang,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'fullName': fullName,
      'role': role,
      'employeeId': employeeId,
      'preferredLang': preferredLang,
    };
  }

  factory CreateUserUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CreateUserUsecaseParams(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      fullName: map['fullName'] ?? '',
      role: map['role'] ?? '',
      employeeId: map['employeeId'],
      preferredLang: map['preferredLang'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateUserUsecaseParams.fromJson(String source) =>
      CreateUserUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CreateUserUsecaseParams(name: $name, email: $email, password: $password, fullName: $fullName, role: $role, employeeId: $employeeId, preferredLang: $preferredLang)';
  }

  @override
  List<Object?> get props {
    return [name, email, password, fullName, role, employeeId, preferredLang];
  }
}
