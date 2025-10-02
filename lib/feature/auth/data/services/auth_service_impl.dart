import 'package:sigma_track/core/services/auth_service.dart';
import 'package:sigma_track/feature/auth/data/datasources/auth_local_datasource.dart';

class AuthServiceImpl implements AuthService {
  final AuthLocalDatasource _authLocalDatasource;

  AuthServiceImpl(this._authLocalDatasource);

  @override
  Future<String?> getAccessToken() => _authLocalDatasource.getAccessToken();

  @override
  Future<void> saveAccessToken(String token) =>
      _authLocalDatasource.saveAccessToken(token);

  @override
  Future<void> deleteAccessToken() => _authLocalDatasource.deleteAccessToken();

  @override
  Future<String?> getRefreshToken() => _authLocalDatasource.getRefreshToken();

  @override
  Future<void> saveRefreshToken(String token) =>
      _authLocalDatasource.saveRefreshToken(token);

  @override
  Future<void> deleteRefreshToken() =>
      _authLocalDatasource.deleteRefreshToken();

  @override
  Future<void> clearAuthData() async {
    await _authLocalDatasource.deleteAccessToken();
    await _authLocalDatasource.deleteRefreshToken();
    await _authLocalDatasource.deleteUser();
  }
}
