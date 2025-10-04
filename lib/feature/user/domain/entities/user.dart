import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';

class User extends Equatable {
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

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.fullName,
    required this.role,
    this.employeeId,
    required this.preferredLang,
    required this.isActive,
    required this.avatarUrl,
    required this.fcmToken,
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
}
