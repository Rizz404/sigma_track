# FCM Notification Debug Guide

## ✅ Yang Sudah Diimplementasi

### Client (Flutter)
1. **Foreground handler** - Notifikasi muncul saat app aktif
2. **Background handler** - Notifikasi muncul saat app di background
3. **Terminated handler** - App bisa dibuka dari notifikasi saat app mati
4. **Local notification service** - Sound & vibration enabled
5. **Permission handling** - Android 13+ & iOS

## 🔍 Checklist Troubleshooting

### 1. Backend FCM Payload Format
Backend **HARUS** mengirim dengan format:

```json
{
  "token": "user_fcm_token",
  "notification": {
    "title": "Asset Assigned",
    "body": "You have been assigned AST-000019"
  },
  "data": {
    "type": "asset_assignment",
    "asset_id": "01K7GX9MZWGZR9973NRV0TAWF0",
    "notification_id": "01K7JYWRF06595RAT6T7SXP5RH"
  },
  "android": {
    "priority": "high",
    "notification": {
      "channel_id": "sigma_track_high_priority",
      "sound": "default",
      "notification_priority": "PRIORITY_HIGH"
    }
  },
  "apns": {
    "payload": {
      "aps": {
        "sound": "default",
        "badge": 1
      }
    }
  }
}
```

**PENTING:**
- ❗ `notification` object **WAJIB ADA** agar muncul otomatis di background/terminated
- ❗ `data` object untuk custom payload & navigation
- ❗ `android.priority: "high"` agar langsung muncul
- ❗ `channel_id` harus match dengan yang di Flutter

### 2. Test Notifikasi

#### Foreground (app aktif):
```bash
# Kirim FCM dari backend
# Harusnya muncul local notification dengan sound
```

#### Background (app minimize):
```bash
# Kirim FCM dari backend
# Harusnya muncul notification bar dengan sound
```

#### Terminated (app close):
```bash
# Close app completely
# Kirim FCM dari backend
# Harusnya muncul notification bar
# Tap notification -> app terbuka
```

### 3. Log yang Harus Muncul di Client

**Foreground:**
```
Foreground FCM message: <message_id>
Notification shown - ID: <id>, Title: <title>
```

**Background/Terminated:**
```
Background FCM message: <message_id>
```

**Notification Opened:**
```
Notification opened app: <message_id>
App opened from notification with data: {...}
```

### 4. Android Manifest Check

File: `android/app/src/main/AndroidManifest.xml`

Pastikan ada:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.VIBRATE"/>
```

### 5. Common Issues

**Tidak muncul di foreground:**
- ✅ Sudah fixed dengan local notification service

**Tidak muncul di background:**
- ❌ Backend tidak kirim `notification` object
- ❌ Token FCM tidak valid/expired
- ❌ Android priority bukan "high"

**Tidak ada sound:**
- ❌ Backend tidak set `sound: "default"`
- ❌ Device silent mode
- ❌ Channel notification setting di-disable user

**App tidak terbuka dari notifikasi:**
- ❌ Backend tidak kirim `data` object
- ❌ Click action tidak properly configured

## 🧪 Test Manual

### 1. Test dengan Firebase Console
1. Go to Firebase Console → Cloud Messaging
2. Send test notification
3. Input FCM token dari log
4. Set notification title & body
5. Add custom data (optional)
6. Send

### 2. Test dengan Backend
```bash
# Check backend log setelah kirim
# Pastikan ada log: "Successfully sent FCM notification"
```

### 3. Monitor Client Log
```bash
flutter run
# Watch for FCM related logs
```

## 📱 Device Requirements

- **Android:** API 21+ (Android 5.0+)
- **Android 13+:** Notification permission harus granted
- **iOS:** Notification permission harus granted
- **Internet:** Device harus online untuk receive FCM

## 🎯 Next Steps

1. ✅ Backend kirim FCM dengan format yang benar
2. ✅ Test di foreground, background, terminated
3. ✅ Verify sound & vibration
4. ✅ Verify app bisa dibuka dari notification
5. ⏳ Implement navigation routing (nanti)
