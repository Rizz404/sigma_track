import 'package:dio/dio.dart';
import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/utils/logging.dart';

class ApiFailoverInterceptor extends Interceptor {
  final Dio _dio;

  ApiFailoverInterceptor(this._dio);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldRetry(err)) {
      try {
        final uri = err.requestOptions.uri.toString();
        // Check if the request was made to the primary URL
        if (uri.startsWith(ApiConstant.baseUrlPrimary)) {
          final backupUri = uri.replaceFirst(
            ApiConstant.baseUrlPrimary,
            ApiConstant.baseUrlBackup,
          );

          logInfo('Primary API failed, switching to backup: $backupUri');

          // Create new options with the backup URI
          // setting path to full URI allows Dio to ignore the baseUrl
          err.requestOptions.path = backupUri;

          // Retry the request
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        logError('Failover retry failed', e);
        // If failover fails, propagate the new error
        return handler.next(e is DioException ? e : err);
      }
    }
    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.type == DioExceptionType.unknown && _isNetworkError(err.error));
  }

  bool _isNetworkError(dynamic error) {
    // Add logic to check for socket exceptions if needed
    // For now, assume unknown errors might be network related
    return true;
  }
}
