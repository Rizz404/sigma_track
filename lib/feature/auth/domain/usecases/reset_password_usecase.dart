import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUsecase
    implements Usecase<ActionSuccess, ResetPasswordUsecaseParams> {
  final AuthRepository _authRepository;

  ResetPasswordUsecase(this._authRepository);

  @override
  Future<Either<Failure, ActionSuccess>> call(
    ResetPasswordUsecaseParams params,
  ) async {
    return await _authRepository.resetPassword(params);
  }
}

class ResetPasswordUsecaseParams extends Equatable {
  final String email;
  final String code;
  final String newPassword;

  const ResetPasswordUsecaseParams({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  ResetPasswordUsecaseParams copyWith({
    String? email,
    String? code,
    String? newPassword,
  }) {
    return ResetPasswordUsecaseParams(
      email: email ?? this.email,
      code: code ?? this.code,
      newPassword: newPassword ?? this.newPassword,
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'code': code, 'newPassword': newPassword};
  }

  factory ResetPasswordUsecaseParams.fromMap(Map<String, dynamic> map) {
    return ResetPasswordUsecaseParams(
      email: map['email'] ?? '',
      code: map['code'] ?? '',
      newPassword: map['newPassword'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ResetPasswordUsecaseParams.fromJson(String source) =>
      ResetPasswordUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'ResetPasswordUsecaseParams(email: $email, code: $code, newPassword: ****)';

  @override
  List<Object> get props => [email, code, newPassword];
}
