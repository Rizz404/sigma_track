# Quick Fix: Manual Conversion Guide

Karena ffmpeg belum terinstall, convert manual dengan 2 opsi:

## Opsi 1: Install ffmpeg (Recommended)

```powershell
# Via Chocolatey
choco install ffmpeg

# Or via Scoop
scoop install ffmpeg

# Or via winget
winget install ffmpeg
```

Setelah install, jalankan:
```powershell
.\convert_notification_sounds.ps1
```

## Opsi 2: Online Converter (No Install)

1. **Buka**: https://convertio.co/mp3-ogg/ atau https://cloudconvert.com/mp3-to-ogg
2. **Upload file**:
   - `android\app\src\main\res\raw\notification_sound.mp3`
   - `android\app\src\main\res\raw\high_priority_sound.mp3`
3. **Convert** ke OGG (Vorbis codec)
4. **Download** hasil convert
5. **Replace** file MP3 dengan OGG di folder `raw/`
6. **Delete** semua file `.mp3`

## Opsi 3: Pakai WAV (Alternatif)

Android juga support WAV format:
1. Convert MP3 ke WAV: https://audio.online-convert.com/convert-to-wav
2. Settings: 16-bit, 44100 Hz (CD quality)
3. Replace di folder `raw/`

## Verification Checklist

Setelah convert, pastikan:

- [ ] ✅ File di `android/app/src/main/res/raw/` dengan ekstensi `.ogg` atau `.wav`
- [ ] ✅ Nama lowercase dengan underscore (e.g., `notification_sound.ogg`)
- [ ] ✅ **Tidak ada file `.mp3` lagi**
- [ ] ✅ Kode di `local_notification_service.dart` tanpa ekstensi:
  ```dart
  RawResourceAndroidNotificationSound('notification_sound')
  ```

## Test Steps

```powershell
# 1. Uninstall app (clear notification channels)
adb uninstall com.example.sigma_track

# 2. Clean build
flutter clean
flutter pub get

# 3. Run app
flutter run

# 4. Trigger test notification
# Notification seharusnya pakai custom sound
```

## Expected Results

✅ **Success**: Notification plays custom OGG sound
❌ **Still default**:
   - Check file format (must be OGG/WAV, not MP3)
   - Check file exists in `raw/` folder
   - Uninstall app (channels cached)
   - Check device volume is up

## File Size Guide

Current files should be:
- **notification_sound.ogg**: ~30-100KB (2-4 seconds)
- **high_priority_sound.ogg**: ~30-100KB (2-4 seconds)

Terlalu besar? Reduce quality/duration.
