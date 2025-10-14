# 📱 Notification UI Implementation Guide

## 🎯 Overview

Implementasi lengkap notification system dengan UI yang responsif untuk menampilkan notifikasi dari Firebase Cloud Messaging (FCM) dan backend.

## 📁 File Structure

```
lib/
├── feature/notification/
│   ├── domain/entities/
│   │   └── notification.dart              # Entity notifikasi
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── notification_list_screen.dart  # Screen list notifikasi
│   │   ├── providers/
│   │   │   └── fcm_notification_notifier.dart # FCM handler
│   │   └── widgets/
│   │       └── notification_item.dart      # Item widget
├── shared/widgets/
│   └── notification_badge.dart             # Badge counter
└── core/
    ├── extensions/
    │   └── date_time_extension.dart        # Time ago formatter
    └── services/
        ├── fcm_token_manager.dart          # Token management
        └── firebase_messaging_service.dart  # FCM service
```

## 🔧 Components

### 1. **NotificationBadge** - Badge Counter Widget

```dart
NotificationBadge(
  count: 5,  // Unread count
  child: Icon(Icons.notifications),
)
```

**Features:**
- Auto show/hide berdasarkan count
- Max display "99+"
- Custom badge color
- Border untuk visibility

### 2. **NotificationItem** - List Item Widget

```dart
NotificationItem(
  notification: notification,
  onTap: () {
    // Mark as read & navigate
  },
  onDismiss: () {
    // Delete notification
  },
)
```

**Features:**
- Swipe to dismiss
- Visual indicator untuk unread
- Icon berbeda per notification type
- Time ago display
- Ellipsis untuk long text

### 3. **NotificationListScreen** - Main Screen

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => NotificationListScreen(),
  ),
);
```

**Features:**
- Empty state UI
- Mark all as read action
- Pull to refresh (TODO)
- Infinite scroll (TODO)

### 4. **FcmNotificationNotifier** - Message Handler

Automatically handles:
- ✅ Foreground messages
- ✅ Background tap
- ✅ Terminated state open
- ✅ Data processing
- 🔄 Navigation (TODO)

## 🎨 Notification Types & Icons

```dart
maintenance   → 🔧 Build icon (Primary color)
warranty      → ✓  Verified icon (Blue)
statusChange  → ⇄  Swap icon (Orange)
movement      → 🚚 Truck icon (Purple)
issueReport   → ⚠  Warning icon (Error color)
```

## 📊 Backend Integration

### Expected Notification Format

```json
{
  "notification": {
    "title": "Maintenance Due",
    "body": "Asset ABC-123 needs maintenance"
  },
  "data": {
    "id": "notif_123",
    "type": "maintenance",
    "relatedAssetId": "asset_456",
    "createdAt": "2024-10-14T10:30:00Z"
  }
}
```

### FCM Message Flow

```
Backend sends FCM
    ↓
Firebase Cloud Messaging
    ↓
Device receives notification
    ↓
App State Check
    ↓
┌─────────────┬──────────────┬─────────────┐
│  Foreground │  Background  │ Terminated  │
│             │              │             │
│ Show banner │ System notif │ System notif│
│ Update badge│ In tray      │ In tray     │
└─────────────┴──────────────┴─────────────┘
    ↓               ↓                ↓
User taps notification
    ↓
Open app & navigate to detail
```

## 🚀 Usage Examples

### 1. Add Notification Badge to AppBar

```dart
AppBar(
  actions: [
    IconButton(
      icon: NotificationBadge(
        count: unreadCount,
        child: Icon(Icons.notifications_outlined),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationListScreen(),
          ),
        );
      },
    ),
  ],
)
```

### 2. Handle Foreground Notification

```dart
// Otomatis di-handle oleh FcmNotificationNotifier
ref.listen(fcmNotificationProvider, (previous, next) {
  if (next != null) {
    // Show in-app banner atau snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(next.notification?.title ?? 'New notification'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Navigate to notification screen
          },
        ),
      ),
    );
  }
});
```

### 3. Navigation from Notification

```dart
void _handleNotificationData(Map<String, dynamic> data) {
  final type = data['type'];
  final id = data['id'];

  // Navigate berdasarkan type
  switch (type) {
    case 'maintenance':
      router.go('/assets/$id/maintenance');
      break;
    case 'issueReport':
      router.go('/issues/$id');
      break;
    default:
      router.go('/notifications');  // Default ke list
  }
}
```

## 📝 TODO: Backend API Integration

### Endpoints Needed

```dart
// 1. Get Notifications List
GET /api/notifications?page=1&limit=20&unreadOnly=false

// 2. Mark as Read
PATCH /api/notifications/{id}/read

// 3. Mark All as Read
POST /api/notifications/read-all

// 4. Delete Notification
DELETE /api/notifications/{id}

// 5. Get Unread Count
GET /api/notifications/unread-count
```

### Provider Implementation (TODO)

```dart
final notificationListProvider = StateNotifierProvider<
    NotificationListNotifier,
    AsyncValue<List<Notification>>
>((ref) {
  final repository = ref.watch(notificationRepositoryProvider);
  return NotificationListNotifier(repository);
});

final unreadCountProvider = StreamProvider<int>((ref) {
  // Listen to real-time unread count updates
  final repository = ref.watch(notificationRepositoryProvider);
  return repository.watchUnreadCount();
});
```

## 🎨 UI Customization

### Change Badge Color

```dart
NotificationBadge(
  count: 5,
  badgeColor: Colors.red,  // Custom color
  child: Icon(Icons.notifications),
)
```

### Change Time Format

Edit `date_time_extension.dart`:

```dart
String get timeAgo {
  // Custom format logic
  if (difference.inMinutes < 1) {
    return 'baru saja';  // Indonesian
  }
  // ...
}
```

### Change Notification Icon

Edit `notification_item.dart`:

```dart
(IconData, Color) _getIconAndColor(BuildContext context) {
  switch (notification.type) {
    case NotificationType.maintenance:
      return (Icons.construction, Colors.yellow);  // Custom
    // ...
  }
}
```

## 🧪 Testing Scenarios

### 1. Test Foreground Notification

```bash
# Send test FCM dari Firebase Console
# Atau gunakan curl:
curl -X POST https://fcm.googleapis.com/v1/projects/YOUR_PROJECT/messages:send \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "message": {
      "token": "DEVICE_FCM_TOKEN",
      "notification": {
        "title": "Test Notification",
        "body": "This is a test message"
      },
      "data": {
        "type": "maintenance",
        "id": "123"
      }
    }
  }'
```

### 2. Test Background/Terminated

1. Send FCM notification
2. Put app in background
3. Tap notification
4. Verify app opens & navigates correctly

### 3. Test Badge Counter

```dart
// Mock unread count
final mockUnreadCount = 15;
// Verify badge shows "15"
// Send more notifications
// Verify counter updates
```

## 🔐 Permissions

### Android (API 33+)

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

### iOS

```
Automatic - handled by firebase_messaging
User will be prompted on first notification request
```

## 📊 Analytics (Optional)

Track notification interactions:

```dart
void _handleNotificationTap(RemoteMessage message) {
  // Log analytics event
  FirebaseAnalytics.instance.logEvent(
    name: 'notification_opened',
    parameters: {
      'notification_type': message.data['type'],
      'notification_id': message.messageId,
    },
  );

  // Handle navigation
  _handleNotificationData(message.data);
}
```

## 🐛 Troubleshooting

### Notifications not showing

1. ✅ Check FCM token synced to backend
2. ✅ Verify firebase_options.dart exists
3. ✅ Check notification permissions granted
4. ✅ Verify backend sending correct format

### Badge not updating

1. ✅ Check provider listening to unread count
2. ✅ Verify API returns correct count
3. ✅ Check mark as read updates count

### Navigation not working

1. ✅ Verify `_handleNotificationData` logic
2. ✅ Check router configuration
3. ✅ Ensure data format matches expectations

## 🚀 Future Enhancements

- [ ] Push notification sound/vibration customization
- [ ] Notification categories & filtering
- [ ] Rich media notifications (images, actions)
- [ ] Notification scheduling
- [ ] In-app notification center with search
- [ ] Notification preferences/settings
- [ ] Grouped notifications
- [ ] Silent notifications for data sync
