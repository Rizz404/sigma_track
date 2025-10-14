import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/utils/logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Talker configuration for the application
class TalkerConfig {
  static late final Talker talker;

  /// Initialize Talker with app-specific configuration
  static void initialize() {
    talker = TalkerFlutter.init(
      settings: TalkerSettings(
        enabled: true,
        useConsoleLogs: kDebugMode,
        maxHistoryItems: kDebugMode ? 1000 : 100,
        useHistory: true,
      ),
      logger: TalkerLogger(
        settings: TalkerLoggerSettings(enableColors: kDebugMode),
      ),
    );

    _logAppStart();
  }

  /// Get Riverpod logger observer
  static ProviderObserver get riverpodObserver =>
      _CustomRiverpodObserver(talker: AppLogger.instance.talker);

  /// Log application startup
  static void _logAppStart() {
    logger.info('🚀 Sigma Track App Started');
    logger.debug('Environment: ${kDebugMode ? 'DEBUG' : 'RELEASE'}');
    logger.debug('Platform: ${defaultTargetPlatform.name}');
  }

  /// Configure Talker for different environments
  static void configureForEnvironment(String environment) {
    switch (environment.toLowerCase()) {
      case 'development':
      case 'debug':
        _configureForDebug();
        break;
      case 'staging':
        _configureForStaging();
        break;
      case 'production':
      case 'release':
        _configureForProduction();
        break;
    }
  }

  static void _configureForDebug() {
    talker.configure(
      settings: talker.settings.copyWith(
        useConsoleLogs: true,
        maxHistoryItems: 1000,
        enabled: true,
      ),
    );
    logger.debug('Talker configured for DEBUG environment');
  }

  static void _configureForStaging() {
    talker.configure(
      settings: talker.settings.copyWith(
        useConsoleLogs: true,
        maxHistoryItems: 500,
        enabled: true,
      ),
    );
    logger.debug('Talker configured for STAGING environment');
  }

  static void _configureForProduction() {
    talker.configure(
      settings: talker.settings.copyWith(
        useConsoleLogs: false,
        maxHistoryItems: 100,
        enabled: true,
      ),
    );
    logger.info('Talker configured for PRODUCTION environment');
  }

  /// Get logs as formatted string for sharing/debugging
  static String getFormattedLogs() {
    return logger.exportLogs();
  }

  /// Clear all logs
  static void clearAllLogs() {
    logger.clearLogs();
    logger.info('All logs cleared');
  }
}

/// Custom Riverpod Observer using Talker
class _CustomRiverpodObserver extends ProviderObserver {
  final Talker talker;

  _CustomRiverpodObserver({required this.talker});

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    talker.info('Provider added: ${provider.name ?? provider.runtimeType}');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    talker.info('Provider disposed: ${provider.name ?? provider.runtimeType}');
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    talker.info('Provider updated: ${provider.name ?? provider.runtimeType}');
  }
}
