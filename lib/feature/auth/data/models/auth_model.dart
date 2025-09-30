import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:sigma_track/feature/user/data/models/user_model.dart';

class AuthModel extends Equatable {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  AuthModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  AuthModel copyWith({
    UserModel? user,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthModel(
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

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      user: UserModel.fromMap(map['user']),
      accessToken: map['accessToken'] ?? '',
      refreshToken: map['refreshToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthModel.fromJson(String source) =>
      AuthModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AuthModel(user: $user, accessToken: $accessToken, refreshToken: $refreshToken)';

  @override
  List<Object> get props => [user, accessToken, refreshToken];
}
