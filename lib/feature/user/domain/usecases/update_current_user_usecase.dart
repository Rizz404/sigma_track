import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class UpdateCurrentUserUsecase
    implements Usecase<ItemSuccess<User>, UpdateCurrentUserUsecaseParams> {
  final UserRepository _userRepository;

  UpdateCurrentUserUsecase(this._userRepository);

  @override
  Future<Either<Failure, ItemSuccess<User>>> call(
    UpdateCurrentUserUsecaseParams params,
  ) async {
    return await _userRepository.updateCurrentUser(params);
  }
}

class UpdateCurrentUserUsecaseParams extends Equatable {
  final String? name;
  final String? email;
  final String? password;
  final String? fullName;
  final String? role;
  final String? employeeId;
  final String? preferredLang;
  final bool? isActive;
  final String? avatarUrl;
  final File? avatarFile;
  final String? fcmToken;

  UpdateCurrentUserUsecaseParams({
    this.name,
    this.email,
    this.password,
    this.fullName,
    this.role,
    this.employeeId,
    this.preferredLang,
    this.isActive,
    this.avatarUrl,
    this.avatarFile,
    this.fcmToken,
  });

  UpdateCurrentUserUsecaseParams copyWith({
    ValueGetter<String?>? name,
    ValueGetter<String?>? email,
    ValueGetter<String?>? password,
    ValueGetter<String?>? fullName,
    ValueGetter<String?>? role,
    ValueGetter<String?>? employeeId,
    ValueGetter<String?>? preferredLang,
    ValueGetter<bool?>? isActive,
    ValueGetter<String?>? avatarUrl,
    ValueGetter<File?>? avatarFile,
    ValueGetter<String?>? fcmToken,
  }) {
    return UpdateCurrentUserUsecaseParams(
      name: name != null ? name() : this.name,
      email: email != null ? email() : this.email,
      password: password != null ? password() : this.password,
      fullName: fullName != null ? fullName() : this.fullName,
      role: role != null ? role() : this.role,
      employeeId: employeeId != null ? employeeId() : this.employeeId,
      preferredLang: preferredLang != null
          ? preferredLang()
          : this.preferredLang,
      isActive: isActive != null ? isActive() : this.isActive,
      avatarUrl: avatarUrl != null ? avatarUrl() : this.avatarUrl,
      avatarFile: avatarFile != null ? avatarFile() : this.avatarFile,
      fcmToken: fcmToken != null ? fcmToken() : this.fcmToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (fullName != null) 'fullName': fullName,
      if (role != null) 'role': role,
      if (employeeId != null) 'employeeId': employeeId,
      if (preferredLang != null) 'preferredLang': preferredLang,
      if (isActive != null) 'isActive': isActive,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      if (avatarFile != null) 'avatarFile': avatarFile!.path,
      if (fcmToken != null) 'fcmToken': fcmToken,
    };
  }

  factory UpdateCurrentUserUsecaseParams.fromMap(Map<String, dynamic> map) {
    return UpdateCurrentUserUsecaseParams(
      name: map['name'],
      email: map['email'],
      password: map['password'],
      fullName: map['fullName'],
      role: map['role'],
      employeeId: map['employeeId'],
      preferredLang: map['preferredLang'],
      isActive: map['isActive'],
      avatarUrl: map['avatarUrl'],
      avatarFile: map['avatarFile'] != null ? File(map['avatarFile']) : null,
      fcmToken: map['fcmToken'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateCurrentUserUsecaseParams.fromJson(String source) =>
      UpdateCurrentUserUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpdateCurrentUserUsecaseParams(name: $name, email: $email, password: $password, fullName: $fullName, role: $role, employeeId: $employeeId, preferredLang: $preferredLang, isActive: $isActive, avatarUrl: $avatarUrl, avatarFile: $avatarFile, fcmToken: $fcmToken)';
  }

  @override
  List<Object?> get props {
    return [
      name,
      email,
      password,
      fullName,
      role,
      employeeId,
      preferredLang,
      isActive,
      avatarUrl,
      avatarFile,
      fcmToken,
    ];
  }
}
