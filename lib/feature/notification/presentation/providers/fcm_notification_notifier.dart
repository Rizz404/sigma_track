import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/extensions/logger_extension.dart';
import 'package:sigma_track/core/services/local_notification_service.dart';
import 'package:sigma_track/di/service_providers.dart';

/// Notifier untuk handle FCM messages & notifications
class FcmNotificationNotifier extends Notifier<RemoteMessage?> {
  late LocalNotificationService _localNotificationService;

  @override
  RemoteMessage? build() {
    _localNotificationService = ref.read(localNotificationServiceProvider);
    _setupMessageHandlers();
    return null;
  }

  // * Setup all message handlers
  void _setupMessageHandlers() {
    // * Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // * Background - app opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // * Check initial message (app opened from terminated state)
    _checkInitialMessage();
  }

  // * Handle message when app is in foreground
  void _handleForegroundMessage(RemoteMessage message) {
    this.logService('Foreground message received: ${message.messageId}');

    state = message;

    final notification = message.notification;
    final data = message.data;

    // * Show native notification
    if (notification != null) {
      this.logInfo('Title: ${notification.title}');
      this.logInfo('Body: ${notification.body}');

      // Encode data for payload
      final payload = data.entries.map((e) => '${e.key}=${e.value}').join('&');

      _localNotificationService.showNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title: notification.title ?? 'Sigma Track',
        body: notification.body ?? '',
        payload: payload,
        highPriority: data['priority'] == 'high',
      );
    }

    if (data.isNotEmpty) {
      this.logInfo('Data: $data');
      _handleNotificationData(data);
    }
  }

  // * Handle notification tap (app in background)
  void _handleNotificationTap(RemoteMessage message) {
    this.logService('Notification tapped: ${message.messageId}');

    state = message;

    // TODO: Navigate to specific screen based on message data
    final data = message.data;
    if (data.isNotEmpty) {
      _handleNotificationData(data);
    }
  }

  // * Check if app was opened from notification (terminated state)
  Future<void> _checkInitialMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      this.logService(
        'App opened from notification: ${initialMessage.messageId}',
      );
      state = initialMessage;

      // TODO: Navigate to specific screen
      final data = initialMessage.data;
      if (data.isNotEmpty) {
        _handleNotificationData(data);
      }
    }
  }

  // * Process notification data for navigation/action
  void _handleNotificationData(Map<String, dynamic> data) {
    this.logInfo('Processing notification data: $data');

    // TODO: Implement navigation logic based on data
    // Examples:
    // - data['type'] == 'attendance' -> Navigate to attendance detail
    // - data['type'] == 'leave' -> Navigate to leave detail
    // - data['screen'] -> Navigate to specific screen
    // - data['action'] -> Perform specific action

    final type = data['type'];
    final id = data['id'];
    final screen = data['screen'];

    if (type != null) {
      this.logInfo('Notification type: $type');
    }

    if (id != null) {
      this.logInfo('Notification ID: $id');
    }

    if (screen != null) {
      this.logInfo('Navigate to screen: $screen');
      // TODO: Use GoRouter to navigate
      // ref.read(routerProvider).go(screen);
    }
  }

  // * Clear current notification
  void clearNotification() {
    state = null;
  }
}

// * Provider for FCM notification management
final fcmNotificationProvider =
    NotifierProvider<FcmNotificationNotifier, RemoteMessage?>(
      FcmNotificationNotifier.new,
    );
