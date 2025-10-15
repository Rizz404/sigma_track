# Custom Notification Sound Guide

## Format Requirements

### Android
- **Format**: `.ogg` (Vorbis) or `.wav` (recommended: `.ogg` for smaller size)
- **Location**: `android/app/src/main/res/raw/`
- **Naming**: Lowercase with underscores, NO extension in code
- **Reference**: `RawResourceAndroidNotificationSound('sound_name')` without `.ogg`

### iOS
- **Format**: `.caf` (Core Audio Format)
- **Location**: `ios/Runner/Resources/` (need to add to Xcode project)
- **Reference**: `'sound_name.caf'` with extension

## Current Sound Files

1. **notification_sound** - Default notification
2. **high_priority_sound** - Urgent/important notifications

## Convert Audio Files

### MP3 to OGG (Android)
```bash
# Using ffmpeg (install: choco install ffmpeg)
ffmpeg -i input.mp3 -c:a libvorbis -q:a 4 output.ogg

# Batch convert all MP3 in raw folder
cd android\app\src\main\res\raw
fd -e mp3 -x ffmpeg -i {} -c:a libvorbis -q:a 4 {.}.ogg

# Remove old MP3
fd -e mp3 -x rm {}
```

### MP3/OGG to CAF (iOS)
```bash
# Using afconvert (macOS only)
afconvert -f caff -d LEI16 input.mp3 output.caf

# Or use online converter: https://audio.online-convert.com/convert-to-caf
```

## Testing

1. **Uninstall app** - Notification channels persist, clean install needed
2. **Check logs** - `this.logInfo('Notification channels created')`
3. **Verify sound plays** when notification shown
4. **Test both channels**:
   - Default: `highPriority: false`
   - High Priority: `highPriority: true`

## Common Issues

### Sound not playing?

1. ❌ **MP3 format** - Android native notifications don't support MP3 well
   - ✅ Use OGG or WAV

2. ❌ **Wrong path** - Files must be in `raw/` folder
   - ✅ `android/app/src/main/res/raw/sound_name.ogg`

3. ❌ **Extension in code** - Don't use `.ogg` in Dart
   - ✅ `RawResourceAndroidNotificationSound('sound_name')`

4. ❌ **Old channel cached** - Notification channels persist
   - ✅ Uninstall app and reinstall

5. ❌ **Phone on silent** - Respect system settings
   - ✅ Test with volume up

## Clean Install Steps

```powershell
# 1. Uninstall from device
adb uninstall com.example.sigma_track

# 2. Clean build
flutter clean
flutter pub get

# 3. Rebuild and install
flutter run

# 4. Test notification
# Trigger a test notification from your app
```

## Keep Files in Release Build

Create `android/app/src/main/res/xml/keep.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources xmlns:tools="http://schemas.android.com/tools"
    tools:keep="@raw/notification_sound, @raw/high_priority_sound"
/>
```

## File Size Recommendations

- **Duration**: 2-5 seconds max
- **Bitrate**:
  - OGG: Quality 4 (128kbps equivalent)
  - WAV: 16-bit, 44.1kHz
- **File size**: < 100KB per sound

## Code Reference

### Local Notification Service
```dart
// Channel definition (no extension)
sound: RawResourceAndroidNotificationSound('notification_sound')

// Show notification with custom sound
showNotification(
  id: 1,
  title: 'Test',
  body: 'Custom sound test',
  highPriority: true, // Uses high_priority_sound
)
```

### FCM Integration
```dart
// FCM foreground message -> local notification
localNotificationService.showNotificationWithData(
  id: message.messageId.hashCode,
  title: notification.title ?? 'New Notification',
  body: notification.body ?? '',
  data: data,
  highPriority: true, // Custom sound for important FCM
);
```
