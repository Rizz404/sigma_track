import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class CountUsersUsecase
    implements Usecase<ItemSuccess<int>, CountUsersUsecaseParams> {
  final UserRepository _userRepository;

  CountUsersUsecase(this._userRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(
    CountUsersUsecaseParams params,
  ) async {
    return await _userRepository.countUsers(params);
  }
}

class CountUsersUsecaseParams extends Equatable {
  final String? role;
  final bool? isActive;

  CountUsersUsecaseParams({this.role, this.isActive});

  CountUsersUsecaseParams copyWith({String? role, bool? isActive}) {
    return CountUsersUsecaseParams(
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {'role': role, 'isActive': isActive};
  }

  factory CountUsersUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CountUsersUsecaseParams(
      role: map['role'],
      isActive: map['isActive'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CountUsersUsecaseParams.fromJson(String source) =>
      CountUsersUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'CountUsersUsecaseParams(role: $role, isActive: $isActive)';

  @override
  List<Object?> get props => [role, isActive];
}
