import 'package:sigma_track/feature/auth/data/models/auth_model.dart';
import 'package:sigma_track/feature/auth/data/models/login_response_model.dart';
import 'package:sigma_track/feature/auth/domain/entities/auth.dart';
import 'package:sigma_track/feature/auth/domain/entities/login_response.dart';
import 'package:sigma_track/feature/user/data/mapper/user_mappers.dart';

// * Mapper untuk LoginResponse (API response - required fields)
extension LoginResponseModelMapper on LoginResponseModel {
  LoginResponse toEntity() {
    return LoginResponse(
      user: user.toEntity(),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

extension LoginResponseEntityMapper on LoginResponse {
  LoginResponseModel toModel() {
    return LoginResponseModel(
      user: user.toModel(),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  // * Converter dari LoginResponse ke Auth
  Auth toAuth() {
    return Auth(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

// * Mapper untuk Auth (App state - nullable fields)
extension AuthModelMapper on AuthModel {
  Auth toEntity() {
    return Auth(
      user: user?.toEntity(),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

extension AuthEntityMapper on Auth {
  AuthModel toModel() {
    return AuthModel(
      user: user?.toModel(),
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
