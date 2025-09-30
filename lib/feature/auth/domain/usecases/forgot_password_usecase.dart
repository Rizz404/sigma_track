import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUsecase
    implements Usecase<ItemSuccess<dynamic>, ForgotPasswordUsecaseParams> {
  final AuthRepository _authRepository;

  ForgotPasswordUsecase(this._authRepository);

  @override
  Future<Either<Failure, ItemSuccess<dynamic>>> call(
    ForgotPasswordUsecaseParams params,
  ) async {
    return await _authRepository.forgotPassword(params);
  }
}

class ForgotPasswordUsecaseParams extends Equatable {
  final String email;

  ForgotPasswordUsecaseParams({required this.email});

  ForgotPasswordUsecaseParams copyWith({String? email, String? password}) {
    return ForgotPasswordUsecaseParams(email: email ?? this.email);
  }

  Map<String, dynamic> toMap() {
    return {'email': email};
  }

  factory ForgotPasswordUsecaseParams.fromMap(Map<String, dynamic> map) {
    return ForgotPasswordUsecaseParams(email: map['email'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory ForgotPasswordUsecaseParams.fromJson(String source) =>
      ForgotPasswordUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() => 'ForgotPasswordUsecaseParams(email: $email)';

  @override
  List<Object> get props => [email];
}
