import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/model_parsing_extension.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String fullName;
  final UserRole role;
  final String? employeeId;
  final String preferredLang;
  final bool isActive;
  final String? avatarUrl;
  final String? fcmToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.fullName,
    required this.role,
    this.employeeId,
    required this.preferredLang,
    required this.isActive,
    required this.avatarUrl,
    this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
  });

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
      fcmToken,
      createdAt,
      updatedAt,
    ];
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? fullName,
    UserRole? role,
    ValueGetter<String?>? employeeId,
    String? preferredLang,
    bool? isActive,
    ValueGetter<String?>? avatarUrl,
    ValueGetter<String?>? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      employeeId: employeeId != null ? employeeId() : this.employeeId,
      preferredLang: preferredLang ?? this.preferredLang,
      isActive: isActive ?? this.isActive,
      avatarUrl: avatarUrl != null ? avatarUrl() : this.avatarUrl,
      fcmToken: fcmToken != null ? fcmToken() : this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'fullName': fullName,
      'role': role.toString(),
      'employeeId': employeeId,
      'preferredLang': preferredLang,
      'isActive': isActive,
      'avatarUrl': avatarUrl,
      'FCMToken': fcmToken,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map.getField<String>('id'),
      name: map.getField<String>('name'),
      email: map.getField<String>('email'),
      fullName: map.getField<String>('fullName'),
      role: UserRole.values.firstWhere(
        (e) => e.value == map.getField<String>('role'),
      ),
      employeeId: map.getFieldOrNull<String>('employeeId'),
      preferredLang: map.getField<String>('preferredLang'),
      isActive: map.getField<bool>('isActive'),
      avatarUrl: map.getFieldOrNull<String>('avatarUrl'),
      fcmToken: map.getFieldOrNull<String>('FCMToken'),
      createdAt: map.getDateTime('createdAt'),
      updatedAt: map.getDateTime('updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, fullName: $fullName, role: $role, employeeId: $employeeId, preferredLang: $preferredLang, isActive: $isActive, avatarUrl: $avatarUrl, fcmToken: $fcmToken, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
