import 'package:sigma_track/feature/auth/data/models/auth_model.dart';
import 'package:sigma_track/feature/auth/domain/entities/auth.dart';

extension AuthModelMapper on AuthModel {
  Auth toEntity() {
    return Auth(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

extension AuthEntityMapper on Auth {
  AuthModel toModel() {
    return AuthModel(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
