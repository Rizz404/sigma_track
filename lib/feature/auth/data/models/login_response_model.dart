import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:sigma_track/core/extensions/model_parsing_extension.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';

/// Model untuk response API login
/// Semua field required karena API selalu mengembalikan data lengkap
class LoginResponseModel extends Equatable {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  const LoginResponseModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  LoginResponseModel copyWith({
    UserModel? user,
    String? accessToken,
    String? refreshToken,
  }) {
    return LoginResponseModel(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user.toMap(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  factory LoginResponseModel.fromMap(Map<String, dynamic> map) {
    return LoginResponseModel(
      user: UserModel.fromMap(map.getField<Map<String, dynamic>>('user')),
      accessToken: map.getField<String>('accessToken'),
      refreshToken: map.getField<String>('refreshToken'),
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponseModel.fromJson(String source) =>
      LoginResponseModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'LoginResponseModel(user: $user, accessToken: $accessToken, refreshToken: $refreshToken)';

  @override
  List<Object> get props => [user, accessToken, refreshToken];
}
