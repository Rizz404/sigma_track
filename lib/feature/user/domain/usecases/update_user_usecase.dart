import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class UpdateUserUsecase
    implements Usecase<ItemSuccess<User>, UpdateUserUsecaseParams> {
  final UserRepository _userRepository;

  UpdateUserUsecase(this._userRepository);

  @override
  Future<Either<Failure, ItemSuccess<User>>> call(
    UpdateUserUsecaseParams params,
  ) async {
    return await _userRepository.updateUser(params);
  }
}

class UpdateUserUsecaseParams extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? password;
  final String? fullName;
  final String? role;
  final ValueGetter<String?>? employeeId;
  final String? preferredLang;
  final bool? isActive;
  final ValueGetter<String?>? avatarUrl;

  UpdateUserUsecaseParams({
    required this.id,
    this.name,
    this.email,
    this.password,
    this.fullName,
    this.role,
    this.employeeId,
    this.preferredLang,
    this.isActive,
    this.avatarUrl,
  });

  UpdateUserUsecaseParams copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? fullName,
    String? role,
    ValueGetter<String?>? employeeId,
    String? preferredLang,
    bool? isActive,
    ValueGetter<String?>? avatarUrl,
  }) {
    return UpdateUserUsecaseParams(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      employeeId: employeeId ?? this.employeeId,
      preferredLang: preferredLang ?? this.preferredLang,
      isActive: isActive ?? this.isActive,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'fullName': fullName,
      'role': role,
      'employeeId': employeeId?.call(),
      'preferredLang': preferredLang,
      'isActive': isActive,
      'avatarUrl': avatarUrl?.call(),
    };
  }

  factory UpdateUserUsecaseParams.fromMap(Map<String, dynamic> map) {
    return UpdateUserUsecaseParams(
      id: map['id'] ?? '',
      name: map['name'],
      email: map['email'],
      password: map['password'],
      fullName: map['fullName'],
      role: map['role'],
      employeeId: map['employeeId'] != null ? () => map['employeeId'] : null,
      preferredLang: map['preferredLang'],
      isActive: map['isActive'],
      avatarUrl: map['avatarUrl'] != null ? () => map['avatarUrl'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateUserUsecaseParams.fromJson(String source) =>
      UpdateUserUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpdateUserUsecaseParams(id: $id, name: $name, email: $email, password: $password, fullName: $fullName, role: $role, employeeId: ${employeeId?.call()}, preferredLang: $preferredLang, isActive: $isActive, avatarUrl: ${avatarUrl?.call()})';
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      email,
      password,
      fullName,
      role,
      employeeId,
      preferredLang,
      isActive,
      avatarUrl,
    ];
  }
}
