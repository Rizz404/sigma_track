import 'package:equatable/equatable.dart';

import 'package:sigma_track/feature/user/data/models/user_model.dart';

/// Response entity dari API login
/// Semua field required karena API selalu mengembalikan data lengkap
/// Hanya digunakan sebagai return type dari login usecase
class LoginResponse extends Equatable {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  const LoginResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object> get props => [user, accessToken, refreshToken];
}
