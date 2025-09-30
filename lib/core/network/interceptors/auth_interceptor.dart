import 'package:dio/dio.dart';
import 'package:sigma_track/feature/auth/data/datasources/auth_local_datasource.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDatasource _authLocalDatasource;

  AuthInterceptor(this._authLocalDatasource);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Get the access token from secure storage
      final token = await _authLocalDatasource.getAccessToken();

      if (token != null && token.isNotEmpty) {
        // Add the Bearer token to the Authorization header
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // If there's an error getting the token, continue without it
      // This prevents the request from failing due to storage issues
      print('Error getting access token: $e');
    }

    // Continue with the request
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized responses
    if (err.response?.statusCode == 401) {
      // Token might be expired or invalid
      // Clear the stored token and user data
      _clearAuthData();
    }

    // Continue with the error
    handler.next(err);
  }

  /// Clear authentication data when token is invalid
  Future<void> _clearAuthData() async {
    try {
      await _authLocalDatasource.deleteAccessToken();
      await _authLocalDatasource.deleteUser();
    } catch (e) {
      print('Error clearing auth data: $e');
    }
  }
}
