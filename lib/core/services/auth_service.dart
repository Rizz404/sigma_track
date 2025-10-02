abstract class AuthService {
  Future<String?> getAccessToken();
  Future<void> saveAccessToken(String token);
  Future<void> deleteAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveRefreshToken(String token);
  Future<void> deleteRefreshToken();
  Future<void> clearAuthData();
}
