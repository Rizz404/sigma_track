import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';

/// Utility class untuk menampilkan toast notifications menggunakan BotToast
///
/// Cara pakai:
/// ```dart
/// AppToast.success('Data berhasil disimpan');
/// AppToast.error('Terjadi kesalahan');
/// AppToast.warning('Peringatan penting');
/// AppToast.info('Informasi tambahan');
/// ```
class AppToast {
  AppToast._();

  /// Duration default untuk toast
  static const Duration _defaultDuration = Duration(seconds: 3);

  /// Menampilkan toast dengan tipe success (hijau)
  static void success(
    String message, {
    Duration? duration,
    VoidCallback? onTap,
  }) {
    BotToast.showCustomText(
      duration: duration ?? _defaultDuration,
      onlyOne: true,
      toastBuilder: (context) =>
          _ToastCard(message: message, type: _ToastType.success, onTap: onTap),
    );
  }

  /// Menampilkan toast dengan tipe error (merah)
  static void error(String message, {Duration? duration, VoidCallback? onTap}) {
    BotToast.showCustomText(
      duration: duration ?? _defaultDuration,
      onlyOne: true,
      toastBuilder: (context) =>
          _ToastCard(message: message, type: _ToastType.error, onTap: onTap),
    );
  }

  /// Menampilkan toast dengan tipe warning (orange/kuning)
  static void warning(
    String message, {
    Duration? duration,
    VoidCallback? onTap,
  }) {
    BotToast.showCustomText(
      duration: duration ?? _defaultDuration,
      onlyOne: true,
      toastBuilder: (context) =>
          _ToastCard(message: message, type: _ToastType.warning, onTap: onTap),
    );
  }

  /// Menampilkan toast dengan tipe info (biru)
  static void info(String message, {Duration? duration, VoidCallback? onTap}) {
    BotToast.showCustomText(
      duration: duration ?? _defaultDuration,
      onlyOne: true,
      toastBuilder: (context) =>
          _ToastCard(message: message, type: _ToastType.info, onTap: onTap),
    );
  }
}

enum _ToastType { success, error, warning, info }

class _ToastCard extends StatelessWidget {
  const _ToastCard({required this.message, required this.type, this.onTap});

  final String message;
  final _ToastType type;
  final VoidCallback? onTap;

  Color _getBackgroundColor(BuildContext context) {
    final semantic = context.semantic;
    switch (type) {
      case _ToastType.success:
        return semantic.success;
      case _ToastType.error:
        return semantic.error;
      case _ToastType.warning:
        return semantic.warning;
      case _ToastType.info:
        return semantic.info;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case _ToastType.success:
        return Icons.check_circle;
      case _ToastType.error:
        return Icons.error;
      case _ToastType.warning:
        return Icons.warning;
      case _ToastType.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getIcon(), color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                message,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
