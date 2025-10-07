import 'package:equatable/equatable.dart';

import 'package:sigma_track/feature/user/domain/entities/user.dart';

/// Response entity dari API login
/// Semua field required karena API selalu mengembalikan data lengkap
/// Hanya digunakan sebagai return type dari login usecase
class LoginResponse extends Equatable {
  final User user;
  final String accessToken;
  final String refreshToken;

  const LoginResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponse.dummy() =>
      LoginResponse(user: User.dummy(), accessToken: '', refreshToken: '');

  @override
  List<Object> get props => [user, accessToken, refreshToken];
}
