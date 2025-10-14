import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sigma_track/core/extensions/logger_extension.dart';
import 'package:timezone/timezone.dart' as tz;

/// Service untuk handle native local notifications
class LocalNotificationService with LoggerMixin {
  LocalNotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  // * Notification channel config for Android
  static const AndroidNotificationChannel _defaultChannel =
      AndroidNotificationChannel(
    'sigma_track_default', // id
    'Default Notifications', // name
    description: 'General notifications from Sigma Track',
    importance: Importance.max,
    enableVibration: true,
    playSound: true,
    showBadge: true,
  );

  static const AndroidNotificationChannel _highPriorityChannel =
      AndroidNotificationChannel(
    'sigma_track_high_priority', // id
    'High Priority Notifications', // name
    description: 'Important notifications that require immediate attention',
    importance: Importance.max,
    enableVibration: true,
    playSound: true,
    showBadge: true,
  );

  // * Initialize plugin
  Future<void> initialize({
    void Function(NotificationResponse)? onNotificationTap,
  }) async {
    try {
      // Android settings
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS/macOS settings
      const darwinSettings = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      );

      await _plugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
      );

      // Create Android notification channels
      await _createNotificationChannels();

      // Request permissions
      await _requestPermissions();

      this.logService('Local notification service initialized');
    } catch (e, s) {
      this.logError('Failed to initialize local notification service', e, s);
    }
  }

  // * Create notification channels (Android 8+)
  Future<void> _createNotificationChannels() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(_defaultChannel);
      await androidPlugin.createNotificationChannel(_highPriorityChannel);
      this.logInfo('Notification channels created');
    }
  }

  // * Request notification permissions
  Future<void> _requestPermissions() async {
    // Android 13+ permission
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      this.logInfo('Android notification permission: $granted');
    }

    // iOS permission
    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      this.logInfo('iOS notification permission: $granted');
    }
  }

  // * Show notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool highPriority = false,
  }) async {
    try {
      final channel = highPriority ? _highPriorityChannel : _defaultChannel;

      final androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: channel.importance,
        priority: Priority.high,
        enableVibration: channel.enableVibration,
        playSound: channel.playSound,
        showWhen: true,
        ticker: body,
        styleInformation: BigTextStyleInformation(body),
      );

      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.active,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      );

      await _plugin.show(id, title, body, details, payload: payload);

      this.logInfo('Notification shown - ID: $id, Title: $title');
    } catch (e, s) {
      this.logError('Failed to show notification', e, s);
    }
  }

  // * Show notification with custom data
  Future<void> showNotificationWithData({
    required int id,
    required String title,
    required String body,
    required Map<String, String> data,
    bool highPriority = false,
  }) async {
    // Encode data as JSON string for payload
    final payload = data.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');

    await showNotification(
      id: id,
      title: title,
      body: body,
      payload: payload,
      highPriority: highPriority,
    );
  }

  // * Schedule notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    String? payload,
    bool highPriority = false,
  }) async {
    try {
      final channel = highPriority ? _highPriorityChannel : _defaultChannel;

      final androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: channel.importance,
        priority: Priority.high,
      );

      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      );

      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );

      this.logInfo('Notification scheduled - ID: $id at $scheduledDate');
    } catch (e, s) {
      this.logError('Failed to schedule notification', e, s);
    }
  }

  // * Cancel specific notification
  Future<void> cancelNotification(int id) async {
    try {
      await _plugin.cancel(id);
      this.logInfo('Notification cancelled - ID: $id');
    } catch (e, s) {
      this.logError('Failed to cancel notification', e, s);
    }
  }

  // * Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _plugin.cancelAll();
      this.logInfo('All notifications cancelled');
    } catch (e, s) {
      this.logError('Failed to cancel all notifications', e, s);
    }
  }

  // * Get pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _plugin.pendingNotificationRequests();
    } catch (e, s) {
      this.logError('Failed to get pending notifications', e, s);
      return [];
    }
  }

  // * Get active notifications (Android only)
  Future<List<ActiveNotification>> getActiveNotifications() async {
    try {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        return await androidPlugin.getActiveNotifications();
      }
      return [];
    } catch (e, s) {
      this.logError('Failed to get active notifications', e, s);
      return [];
    }
  }
}
