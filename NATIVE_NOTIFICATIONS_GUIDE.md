# Native Notifications Implementation Guide

## Overview
Implementasi native system notifications menggunakan `flutter_local_notifications` yang terintegrasi dengan Firebase Cloud Messaging (FCM).

## Features
- ✅ Native Android/iOS notifications (system tray)
- ✅ Sound & vibration support
- ✅ Swipe-to-dismiss functionality
- ✅ Tap to open app with deep linking
- ✅ Background & foreground message handling
- ✅ Notification channels (Android 8+)
- ✅ Scheduled notifications support
- ✅ Permission handling (Android 13+)

## Architecture

### 1. LocalNotificationService
**File**: `lib/core/services/local_notification_service.dart`

Service wrapper untuk handle local notifications dengan features:
- Initialization & permission requests
- Notification channels (default & high priority)
- Show immediate notification
- Schedule future notification
- Cancel specific/all notifications
- Get pending/active notifications

**Key Methods**:
```dart
// Initialize service
await localNotificationService.initialize(
  onNotificationTap: _onNotificationTap,
);

// Show notification
await localNotificationService.showNotification(
  id: 1,
  title: 'New Message',
  body: 'You have a new message',
  payload: 'type=message&id=123',
  highPriority: true,
);

// Schedule notification
await localNotificationService.scheduleNotification(
  id: 2,
  title: 'Reminder',
  body: 'Don't forget your meeting',
  scheduledDate: scheduledDateTime,
);
```

### 2. FCM Integration
**File**: `lib/feature/notification/presentation/providers/fcm_notification_notifier.dart`

FCM notifier sekarang otomatis show native notification saat receive foreground message:

```dart
void _handleForegroundMessage(RemoteMessage message) {
  final notification = message.notification;

  if (notification != null) {
    _localNotificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: notification.title ?? 'Sigma Track',
      body: notification.body ?? '',
      payload: encodePayload(message.data),
      highPriority: message.data['priority'] == 'high',
    );
  }
}
```

### 3. Notification Tap Handling
**File**: `lib/main.dart`

Callback saat user tap notification:

```dart
void _onNotificationTap(NotificationResponse response) {
  if (response.payload != null) {
    final params = Uri.splitQueryString(response.payload!);

    // Navigate based on payload
    final type = params['type'];
    final id = params['id'];

    if (type == 'attendance' && id != null) {
      ref.read(routerProvider).go('/attendance/$id');
    }
  }
}
```

## Configuration

### Android Setup

#### 1. AndroidManifest.xml
Sudah ditambahkan:
- ✅ `POST_NOTIFICATIONS` permission (Android 13+)
- ✅ `RECEIVE_BOOT_COMPLETED` - Reschedule after reboot
- ✅ `SCHEDULE_EXACT_ALARM` - Exact scheduling
- ✅ `USE_FULL_SCREEN_INTENT` - Critical alerts
- ✅ Notification receivers (ScheduledNotification, Boot, Action)

#### 2. Notification Channels
Dua channels sudah dikonfigurasi:

**Default Channel**:
- ID: `sigma_track_default`
- Name: "Default Notifications"
- Importance: Max
- Sound: ✅ | Vibration: ✅ | Badge: ✅

**High Priority Channel**:
- ID: `sigma_track_high_priority`
- Name: "High Priority Notifications"
- Importance: Max
- Sound: ✅ | Vibration: ✅ | Badge: ✅

#### 3. Notification Icon
Icon default: `@mipmap/ic_launcher`

**Custom Icon** (opsional):
1. Tambahkan icon di `android/app/src/main/res/drawable/`
2. Format: PNG, ukuran 24x24dp, warna putih dengan alpha
3. Ganti di `LocalNotificationService`:
   ```dart
   AndroidInitializationSettings('@drawable/notification_icon')
   ```

### iOS Setup

#### Info.plist Permissions
Tambahkan di `ios/Runner/Info.plist`:
```xml
<key>UIBackgroundModes</key>
<array>
  <string>remote-notification</string>
</array>
```

## Usage Examples

### Basic Notification
```dart
final localNotificationService = ref.read(localNotificationServiceProvider);

await localNotificationService.showNotification(
  id: 1,
  title: 'Task Completed',
  body: 'Your task has been completed successfully',
);
```

### Notification with Data
```dart
await localNotificationService.showNotificationWithData(
  id: 2,
  title: 'New Assignment',
  body: 'You have a new task assigned',
  data: {
    'type': 'task',
    'id': '123',
    'screen': '/tasks/123',
  },
  highPriority: true,
);
```

### Scheduled Notification
```dart
import 'package:timezone/timezone.dart' as tz;

final scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(hours: 1));

await localNotificationService.scheduleNotification(
  id: 3,
  title: 'Meeting Reminder',
  body: 'Your meeting starts in 15 minutes',
  scheduledDate: scheduledDate,
);
```

### Cancel Notification
```dart
// Cancel specific
await localNotificationService.cancelNotification(1);

// Cancel all
await localNotificationService.cancelAllNotifications();
```

### Get Notifications
```dart
// Pending (scheduled)
final pending = await localNotificationService.getPendingNotifications();

// Active (currently displayed - Android only)
final active = await localNotificationService.getActiveNotifications();
```

## FCM Payload Structure

Backend harus kirim payload dalam format:

```json
{
  "notification": {
    "title": "New Message",
    "body": "You have received a new message"
  },
  "data": {
    "type": "message",
    "id": "123",
    "screen": "/messages/123",
    "priority": "high"
  }
}
```

## Deep Linking Flow

1. **FCM message received** → `_handleForegroundMessage()`
2. **Local notification shown** with encoded payload
3. **User taps notification** → `_onNotificationTap()`
4. **Parse payload** → Extract type, id, screen
5. **Navigate** → `ref.read(routerProvider).go(screen)`

## Testing

### Test Foreground Notification
1. Run app di emulator/device
2. Send FCM test message dari Firebase Console
3. Notification muncul di system tray
4. Tap notification → app navigate

### Test Background Notification
1. Minimize app (background)
2. Send FCM test message
3. Tap notification → app open & navigate

### Test Terminated State
1. Force close app
2. Send FCM test message
3. Tap notification → app launch & navigate

## Notification Types dari Backend

Sesuai dengan `NotificationType` enum:

| Type | Icon | Navigate To |
|------|------|-------------|
| `maintenance` | build | `/maintenance/{id}` |
| `warranty` | verified | `/warranty/{id}` |
| `statusChange` | swap | `/assets/{id}` |
| `movement` | local_shipping | `/movement/{id}` |
| `issueReport` | warning | `/issues/{id}` |

## Troubleshooting

### Notification tidak muncul
- ✅ Check permissions granted (Android 13+)
- ✅ Check notification enabled di Settings → Apps → Sigma Track
- ✅ Verify FCM message format correct
- ✅ Check Talker logs untuk error

### Sound tidak berbunyi
- ✅ Check device volume
- ✅ Check Do Not Disturb disabled
- ✅ Verify notification channel importance = Max

### Tap tidak navigate
- ✅ Check payload format correct (key=value&key=value)
- ✅ Verify `_onNotificationTap()` callback registered
- ✅ Check router path valid

### Icon tidak muncul (Android)
- ✅ Icon harus di `res/drawable/` bukan `mipmap`
- ✅ Icon format: PNG, 24x24dp, putih dengan alpha
- ✅ Clean & rebuild: `flutter clean && flutter pub get`

## Next Steps

### TODO: Backend Integration
- [ ] Connect notification list API
- [ ] Implement mark as read
- [ ] Implement delete notification
- [ ] Implement unread count badge
- [ ] Add notification preferences (enable/disable types)

### TODO: Enhanced Features
- [ ] Grouped notifications (multiple messages)
- [ ] Action buttons (Reply, Mark Read, etc.)
- [ ] Big picture style (image in notification)
- [ ] Progress indicator (download/upload)
- [ ] Custom notification sounds per type

### TODO: Analytics
- [ ] Track notification open rate
- [ ] Track notification conversion
- [ ] A/B test notification content

## References
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Android Notification Channels](https://developer.android.com/develop/ui/views/notifications/channels)
