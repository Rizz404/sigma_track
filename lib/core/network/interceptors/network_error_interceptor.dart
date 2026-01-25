import 'package:dio/dio.dart';
import 'package:sigma_track/core/extensions/logger_extension.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';

/// Interceptor untuk menampilkan toast otomatis untuk network dan server errors
///
/// Menangani:
/// - Connection errors (DNS failure, no internet)
/// - Timeout errors (connection/receive timeout)
/// - Server errors (5xx)
///
/// Error lainnya (4xx, validation) tetap ditangani oleh repository/UI
class NetworkErrorInterceptor extends Interceptor {
  NetworkErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final errorInfo = _categorizeError(err);

    if (errorInfo != null) {
      logError(errorInfo.logMessage, err.message);

      // * Tampilkan toast dengan pesan user-friendly
      AppToast.serverError(errorInfo.userMessage);
    }

    // * Tetap pass error ke handler berikutnya
    super.onError(err, handler);
  }

  /// Kategorisasi error dan return pesan yang sesuai
  _ErrorInfo? _categorizeError(DioException err) {
    // * 1. Connection errors (DNS, no internet, etc)
    if (err.type == DioExceptionType.connectionError) {
      if (err.message?.contains('Failed host lookup') == true) {
        return const _ErrorInfo(
          logMessage: 'DNS Failure',
          userMessage:
              'Tidak dapat terhubung ke server.\n'
              '• Periksa koneksi internet Anda\n'
              '• Matikan VPN/DNS jika aktif\n'
              '• Coba lagi dalam beberapa saat',
        );
      }
      // * Generic connection error (socket exception, etc)
      return const _ErrorInfo(
        logMessage: 'Connection Error',
        userMessage:
            'Koneksi terputus.\n'
            '• Periksa koneksi internet Anda\n'
            '• Pastikan WiFi/data aktif\n'
            '• Coba lagi dalam beberapa saat',
      );
    }

    // * 2. Timeout errors
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      return const _ErrorInfo(
        logMessage: 'Connection Timeout',
        userMessage:
            'Koneksi timeout.\n'
            '• Periksa kecepatan internet Anda\n'
            '• Coba lagi dalam beberapa saat\n'
            '• Hubungi admin jika masalah berlanjut',
      );
    }

    if (err.type == DioExceptionType.receiveTimeout) {
      return const _ErrorInfo(
        logMessage: 'Receive Timeout',
        userMessage:
            'Server terlalu lama merespons.\n'
            '• Koneksi internet Anda mungkin lambat\n'
            '• Coba lagi dalam beberapa saat\n'
            '• Hubungi admin jika masalah berlanjut',
      );
    }

    // * 3. Server errors (5xx)
    final statusCode = err.response?.statusCode;
    if (statusCode != null && statusCode >= 500 && statusCode < 600) {
      return _ErrorInfo(
        logMessage: 'Server Error ($statusCode)',
        userMessage: _getServerErrorMessage(statusCode),
      );
    }

    // * Return null untuk error lainnya (4xx, validation, etc)
    return null;
  }

  /// Generate pesan server error berdasarkan status code
  String _getServerErrorMessage(int statusCode) {
    switch (statusCode) {
      case 500:
        return 'Terjadi kesalahan pada server.\n'
            '• Coba lagi dalam beberapa saat\n'
            '• Hubungi admin jika masalah berlanjut';
      case 502:
        return 'Server sedang tidak dapat dijangkau.\n'
            '• Server mungkin sedang maintenance\n'
            '• Coba lagi dalam beberapa saat\n'
            '• Hubungi admin jika masalah berlanjut';
      case 503:
        return 'Layanan sedang dalam pemeliharaan.\n'
            '• Tunggu beberapa saat\n'
            '• Coba lagi nanti\n'
            '• Hubungi admin untuk info lebih lanjut';
      case 504:
        return 'Server terlalu lama merespons.\n'
            '• Server sedang sibuk\n'
            '• Coba lagi dalam beberapa saat\n'
            '• Hubungi admin jika masalah berlanjut';
      default:
        return 'Terjadi kesalahan pada server.\n'
            '• Coba lagi dalam beberapa saat\n'
            '• Hubungi admin jika masalah berlanjut';
    }
  }
}

/// Helper class untuk menyimpan info error
class _ErrorInfo {
  final String logMessage;
  final String userMessage;

  const _ErrorInfo({required this.logMessage, required this.userMessage});
}
