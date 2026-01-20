import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/language_enums.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';
import 'package:sigma_track/feature/user/domain/usecases/create_user_usecase.dart';

class BulkCreateUsersUsecase
    implements
        Usecase<ItemSuccess<BulkCreateUsersResponse>, BulkCreateUsersParams> {
  final UserRepository _userRepository;

  BulkCreateUsersUsecase(this._userRepository);

  @override
  Future<Either<Failure, ItemSuccess<BulkCreateUsersResponse>>> call(
    BulkCreateUsersParams params,
  ) async {
    return await _userRepository.createManyUsers(params);
  }
}

class BulkCreateUsersParams extends Equatable {
  final List<CreateUserUsecaseParams> users;

  const BulkCreateUsersParams({required this.users});

  Map<String, dynamic> toMap() {
    return {'users': users.map((x) => x.toMap()).toList()};
  }

  factory BulkCreateUsersParams.fromMap(Map<String, dynamic> map) {
    return BulkCreateUsersParams(
      users: List<CreateUserUsecaseParams>.from(
        (map['users'] as List).map(
          (x) => CreateUserUsecaseParams.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateUsersParams.fromJson(String source) =>
      BulkCreateUsersParams.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [users];
}

class BulkCreateUsersResponse extends Equatable {
  final List<User> users;

  const BulkCreateUsersResponse({required this.users});

  Map<String, dynamic> toMap() {
    return {'users': users.map((x) => _userToMap(x)).toList()};
  }

  factory BulkCreateUsersResponse.fromMap(Map<String, dynamic> map) {
    return BulkCreateUsersResponse(
      users: List<User>.from(
        (map['users'] as List).map(
          (x) => _userFromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateUsersResponse.fromJson(String source) =>
      BulkCreateUsersResponse.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [users];

  static Map<String, dynamic> _userToMap(User user) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'fullName': user.fullName,
      'role': user.role.value,
      'employeeId': user.employeeId,
      'preferredLang': user.preferredLang.backendCode,
      'isActive': user.isActive,
      'avatarUrl': user.avatarUrl,
      'fcmToken': user.fcmToken,
      'createdAt': user.createdAt.toIso8601String(),
      'updatedAt': user.updatedAt.toIso8601String(),
    };
  }

  static User _userFromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.value == map['role'],
        orElse: () => UserRole.employee,
      ),
      employeeId: map['employeeId'],
      preferredLang: Language.fromBackendCode(map['preferredLang'] ?? 'en-US'),
      isActive: map['isActive'] ?? true,
      avatarUrl: map['avatarUrl'],
      fcmToken: map['fcmToken'],
      createdAt: DateTime.parse(map['createdAt'].toString()),
      updatedAt: DateTime.parse(map['updatedAt'].toString()),
    );
  }
}
