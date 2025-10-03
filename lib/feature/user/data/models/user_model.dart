import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/core/enums/model_entity_enums.dart';

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
      'role': role.value,
      'employeeId': employeeId,
      'preferredLang': preferredLang,
      'isActive': isActive,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      role: UserRole.fromString(map['role']),
      employeeId: map['employeeId'],
      preferredLang: map['preferredLang'] ?? '',
      isActive: map['isActive'] ?? false,
      avatarUrl: map['avatarUrl'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, fullName: $fullName, role: $role, employeeId: $employeeId, preferredLang: $preferredLang, isActive: $isActive, avatarUrl: $avatarUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
