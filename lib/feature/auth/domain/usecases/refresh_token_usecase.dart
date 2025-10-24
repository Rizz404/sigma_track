import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/auth/domain/entities/login_response.dart';
import 'package:sigma_track/feature/auth/domain/repositories/auth_repository.dart';

class RefreshTokenUsecase
    implements Usecase<ItemSuccess<LoginResponse>, RefreshTokenUsecaseParams> {
  final AuthRepository _authRepository;

  RefreshTokenUsecase(this._authRepository);

  @override
  Future<Either<Failure, ItemSuccess<LoginResponse>>> call(
    RefreshTokenUsecaseParams params,
  ) async {
    return await _authRepository.refreshToken(params.refreshToken);
  }
}

class RefreshTokenUsecaseParams extends Equatable {
  final String refreshToken;

  RefreshTokenUsecaseParams({required this.refreshToken});

  RefreshTokenUsecaseParams copyWith({String? refreshToken}) {
    return RefreshTokenUsecaseParams(
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {'refreshToken': refreshToken};
  }

  factory RefreshTokenUsecaseParams.fromMap(Map<String, dynamic> map) {
    return RefreshTokenUsecaseParams(refreshToken: map['refreshToken'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory RefreshTokenUsecaseParams.fromJson(String source) =>
      RefreshTokenUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() => 'RefreshTokenUsecaseParams(refreshToken: $refreshToken)';

  @override
  List<Object> get props => [refreshToken];
}
