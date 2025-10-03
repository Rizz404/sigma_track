import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:sigma_track/feature/user/data/models/user_model.dart';

/// Model untuk authentication state aplikasi
/// Semua field nullable untuk support logout state
class AuthModel extends Equatable {
  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;

  const AuthModel({this.user, this.accessToken, this.refreshToken});

  /// Empty auth untuk unauthenticated state
  const AuthModel.empty()
    : user = null,
      accessToken = null,
      refreshToken = null;

  AuthModel copyWith({
    ValueGetter<UserModel?>? user,
    ValueGetter<String?>? accessToken,
    ValueGetter<String?>? refreshToken,
  }) {
    return AuthModel(
      user: user != null ? user() : this.user,
      accessToken: accessToken != null ? accessToken() : this.accessToken,
      refreshToken: refreshToken != null ? refreshToken() : this.refreshToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user': user?.toMap(),
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      user: map['user'] != null ? UserModel.fromMap(map['user']) : null,
      accessToken: map['accessToken'],
      refreshToken: map['refreshToken'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthModel.fromJson(String source) =>
      AuthModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AuthModel(user: $user, accessToken: $accessToken, refreshToken: $refreshToken)';

  @override
  List<Object?> get props => [user, accessToken, refreshToken];
}
