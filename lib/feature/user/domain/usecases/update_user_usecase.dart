import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:equatable/equatable.dart';
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
  final String? fullName;
  final String? role;
  final String? employeeId;
  final String? preferredLang;
  final bool? isActive;
  final String? avatarUrl;

  UpdateUserUsecaseParams({
    required this.id,
    this.name,
    this.email,
    this.fullName,
    this.role,
    this.employeeId,
    this.preferredLang,
    this.isActive,
    this.avatarUrl,
  });

  UpdateUserUsecaseParams copyWith({
    String? id,
    ValueGetter<String?>? name,
    ValueGetter<String?>? email,
    ValueGetter<String?>? fullName,
    ValueGetter<String?>? role,
    ValueGetter<String?>? employeeId,
    ValueGetter<String?>? preferredLang,
    ValueGetter<bool?>? isActive,
    ValueGetter<String?>? avatarUrl,
  }) {
    return UpdateUserUsecaseParams(
      id: id ?? this.id,
      name: name != null ? name() : this.name,
      email: email != null ? email() : this.email,
      fullName: fullName != null ? fullName() : this.fullName,
      role: role != null ? role() : this.role,
      employeeId: employeeId != null ? employeeId() : this.employeeId,
      preferredLang: preferredLang != null
          ? preferredLang()
          : this.preferredLang,
      isActive: isActive != null ? isActive() : this.isActive,
      avatarUrl: avatarUrl != null ? avatarUrl() : this.avatarUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (fullName != null) 'fullName': fullName,
      if (role != null) 'role': role,
      if (employeeId != null) 'employeeId': employeeId,
      if (preferredLang != null) 'preferredLang': preferredLang,
      if (isActive != null) 'isActive': isActive,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    };
  }

  factory UpdateUserUsecaseParams.fromMap(Map<String, dynamic> map) {
    return UpdateUserUsecaseParams(
      id: map['id'] ?? '',
      name: map['name'],
      email: map['email'],
      fullName: map['fullName'],
      role: map['role'],
      employeeId: map['employeeId'],
      preferredLang: map['preferredLang'],
      isActive: map['isActive'],
      avatarUrl: map['avatarUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateUserUsecaseParams.fromJson(String source) =>
      UpdateUserUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpdateUserUsecaseParams(id: $id, name: $name, email: $email, fullName: $fullName, role: $role, employeeId: $employeeId, preferredLang: $preferredLang, isActive: $isActive, avatarUrl: $avatarUrl)';
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      email,
      fullName,
      role,
      employeeId,
      preferredLang,
      isActive,
      avatarUrl,
    ];
  }
}
