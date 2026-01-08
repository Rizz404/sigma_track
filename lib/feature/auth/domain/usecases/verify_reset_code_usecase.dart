import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/auth/domain/entities/verify_reset_code_response.dart';
import 'package:sigma_track/feature/auth/domain/repositories/auth_repository.dart';

class VerifyResetCodeUsecase
    implements
        Usecase<
          ItemSuccess<VerifyResetCodeResponse>,
          VerifyResetCodeUsecaseParams
        > {
  final AuthRepository _authRepository;

  VerifyResetCodeUsecase(this._authRepository);

  @override
  Future<Either<Failure, ItemSuccess<VerifyResetCodeResponse>>> call(
    VerifyResetCodeUsecaseParams params,
  ) async {
    return await _authRepository.verifyResetCode(params);
  }
}

class VerifyResetCodeUsecaseParams extends Equatable {
  final String email;
  final String code;

  const VerifyResetCodeUsecaseParams({required this.email, required this.code});

  VerifyResetCodeUsecaseParams copyWith({String? email, String? code}) {
    return VerifyResetCodeUsecaseParams(
      email: email ?? this.email,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'code': code};
  }

  factory VerifyResetCodeUsecaseParams.fromMap(Map<String, dynamic> map) {
    return VerifyResetCodeUsecaseParams(
      email: map['email'] ?? '',
      code: map['code'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VerifyResetCodeUsecaseParams.fromJson(String source) =>
      VerifyResetCodeUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'VerifyResetCodeUsecaseParams(email: $email, code: $code)';

  @override
  List<Object> get props => [email, code];
}
