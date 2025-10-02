import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

class CheckUserEmailExistsUsecase
    implements Usecase<ItemSuccess<bool>, CheckUserEmailExistsUsecaseParams> {
  final UserRepository _userRepository;

  CheckUserEmailExistsUsecase(this._userRepository);

  @override
  Future<Either<Failure, ItemSuccess<bool>>> call(
    CheckUserEmailExistsUsecaseParams params,
  ) async {
    return await _userRepository.checkUserEmailExists(params);
  }
}

class CheckUserEmailExistsUsecaseParams extends Equatable {
  final String email;

  CheckUserEmailExistsUsecaseParams({required this.email});

  Map<String, dynamic> toMap() {
    return {'email': email};
  }

  factory CheckUserEmailExistsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CheckUserEmailExistsUsecaseParams(email: map['email'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory CheckUserEmailExistsUsecaseParams.fromJson(String source) =>
      CheckUserEmailExistsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() => 'CheckUserEmailExistsUsecaseParams(email: $email)';

  @override
  List<Object> get props => [email];
}
