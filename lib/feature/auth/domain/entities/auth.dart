import 'package:equatable/equatable.dart';

import 'package:sigma_track/feature/user/domain/entities/user.dart';

/// Entity untuk authentication state aplikasi
/// Semua field nullable untuk support logout state
/// Digunakan untuk state management dan presentation layer
class Auth extends Equatable {
  final User? user;
  final String? accessToken;
  final String? refreshToken;

  const Auth({this.user, this.accessToken, this.refreshToken});

  /// Helper untuk check apakah user sudah authenticated
  bool get isAuthenticated =>
      user != null && accessToken != null && refreshToken != null;

  /// Empty auth untuk unauthenticated state
  const Auth.empty() : user = null, accessToken = null, refreshToken = null;

  factory Auth.dummy() => const Auth.empty();

  @override
  List<Object?> get props => [user, accessToken, refreshToken];
}
