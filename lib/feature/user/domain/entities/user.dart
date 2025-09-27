import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';

class User extends Equatable {
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

  const User({
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
}
