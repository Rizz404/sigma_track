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
  final String? employeeID;
  final String preferredLang;
  final bool isActive;
  final String? avatarURL;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.fullName,
    required this.role,
    this.employeeID,
    required this.preferredLang,
    required this.isActive,
    required this.avatarURL,
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
      employeeID,
      preferredLang,
      isActive,
      avatarURL,
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
    ValueGetter<String?>? employeeID,
    String? preferredLang,
    bool? isActive,
    ValueGetter<String?>? avatarURL,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      employeeID: employeeID != null ? employeeID() : this.employeeID,
      preferredLang: preferredLang ?? this.preferredLang,
      isActive: isActive ?? this.isActive,
      avatarURL: avatarURL != null ? avatarURL() : this.avatarURL,
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
      'role': role.toMap(),
      'employeeID': employeeID,
      'preferredLang': preferredLang,
      'isActive': isActive,
      'avatarURL': avatarURL,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      role: UserRole.fromMap(map['role']),
      employeeID: map['employeeID'],
      preferredLang: map['preferredLang'] ?? '',
      isActive: map['isActive'] ?? false,
      avatarURL: map['avatarURL'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, fullName: $fullName, role: $role, employeeID: $employeeID, preferredLang: $preferredLang, isActive: $isActive, avatarURL: $avatarURL, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
