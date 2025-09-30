import 'package:equatable/equatable.dart';

import 'package:sigma_track/feature/user/data/models/user_model.dart';

class Auth extends Equatable {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  Auth({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object> get props => [user, accessToken, refreshToken];
}
