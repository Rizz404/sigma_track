import 'package:dio/dio.dart';
import 'package:sigma_track/core/services/auth_service.dart';
import 'package:sigma_track/core/utils/logging.dart';

class AuthInterceptor extends Interceptor {
  final AuthService _authService;
  final void Function()? onTokenInvalid;

  AuthInterceptor(this._authService, {this.onTokenInvalid});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await _authService.getAccessToken();

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e, s) {
      this.logError('Error getting access token', e, s);
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final responseData = err.response?.data;
      final isInvalidToken =
          responseData is Map &&
          responseData['message']?.toString().toLowerCase().contains(
                'invalid token',
              ) ==
              true;

      if (isInvalidToken) {
        this.logInfo('Invalid token detected, clearing auth data');
        await _handleInvalidToken();
      }
    }

    handler.next(err);
  }

  Future<void> _handleInvalidToken() async {
    try {
      await _authService.clearAuthData();

      // * Notify listener (will trigger auth state refresh)
      onTokenInvalid?.call();
    } catch (e, s) {
      this.logError('Error handling invalid token', e, s);
    }
  }
}
