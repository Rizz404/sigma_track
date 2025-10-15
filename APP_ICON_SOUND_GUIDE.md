# 🎨 App Icon & Custom Notification Sound Guide

## ✅ App Icon - SUDAH SELESAI

Icon sudah di-generate untuk semua platform:
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ MacOS

Icon source: `assets/images/app-icon.jpg`

**Untuk ganti icon:**
1. Replace file `assets/images/app-icon.jpg` dengan icon baru
2. Run: `dart run flutter_launcher_icons`
3. Rebuild app

---

## 🔊 Custom Notification Sound

### 📱 **ANDROID**

#### Step 1: Siapkan File Sound
Format yang didukung: `.mp3`, `.wav`, `.ogg`, `.m4a`

**Rekomendasi:**
- Durasi: 1-3 detik
- Format: MP3 atau OGG
- Size: < 500KB
- Sample rate: 44.1kHz atau 48kHz

#### Step 2: Tambahkan ke Folder `raw`
```
android/app/src/main/res/raw/
├── notification_sound.mp3      # Default notification
└── high_priority_sound.mp3     # Important notification
```

**PENTING:**
- ✅ Nama file lowercase, gunakan underscore
- ✅ Tanpa spasi: `notification_sound.mp3`
- ❌ JANGAN: `Notification Sound.mp3`

#### Step 3: Rebuild App
```powershell
flutter clean
flutter pub get
flutter run
```

Sound akan otomatis terpakai!

---

### 🍎 **iOS**

#### Step 1: Convert Sound ke Format CAF (Apple)
```bash
# Install ffmpeg jika belum ada
# Windows: choco install ffmpeg
# Mac: brew install ffmpeg

# Convert MP3 to CAF
afconvert -f caff -d LEI16 notification_sound.mp3 notification_sound.caf
afconvert -f caff -d LEI16 high_priority_sound.mp3 high_priority_sound.caf
```

Atau gunakan online converter: https://convertio.co/mp3-caf/

#### Step 2: Tambahkan ke Xcode
1. Buka: `open ios/Runner.xcworkspace`
2. Drag & drop file `.caf` ke folder `Runner` di sidebar
3. Centang:
   - ✅ "Copy items if needed"
   - ✅ Target: "Runner"
4. Klik "Finish"

#### Step 3: Rebuild App
```powershell
flutter clean
flutter pub get
flutter run
```

---

## 🎵 Dimana Cari Sound Notification?

### Free Resources:
1. **Zapsplat** - https://www.zapsplat.com/sound-effect-categories/notification-sounds/
2. **Freesound** - https://freesound.org/search/?q=notification
3. **NotificationSounds** - https://notificationsounds.com/
4. **Mixkit** - https://mixkit.co/free-sound-effects/notification/

### Tips Memilih Sound:
- ✅ Pendek (1-3 detik)
- ✅ Jelas & tidak mengganggu
- ✅ Volume sedang
- ✅ Cocok dengan brand app
- ❌ JANGAN terlalu loud
- ❌ JANGAN terlalu panjang

---

## 🧪 Testing

### Test Default Sound (bawaan)
Untuk sementara, sebelum tambah custom sound, app akan pakai system default sound.

### Test Custom Sound
1. Tambahkan file sound sesuai guide di atas
2. Rebuild app
3. Kirim notifikasi dari backend
4. Verify sound yang keluar adalah custom sound

### Troubleshooting

**Sound tidak keluar:**
- ✅ Cek device tidak dalam silent mode
- ✅ Cek volume notification device
- ✅ Cek permission notification sudah granted
- ✅ Cek nama file sesuai (lowercase, underscore)

**Sound masih default:**
- ✅ Pastikan file ada di folder `raw` (Android)
- ✅ Pastikan file `.caf` sudah ditambahkan ke Xcode (iOS)
- ✅ Sudah rebuild app (`flutter clean && flutter run`)
- ✅ Clear app data & reinstall

**Android: Channel already exists**
```powershell
# Uninstall app untuk reset notification channel
flutter clean
# Uninstall dari device
# Reinstall
flutter run
```

---

## 📋 Checklist

### Android:
- [ ] Download file sound `.mp3` atau `.ogg`
- [ ] Rename file jadi `notification_sound.mp3` & `high_priority_sound.mp3`
- [ ] Copy ke `android/app/src/main/res/raw/`
- [ ] Run `flutter clean`
- [ ] Run `flutter run`
- [ ] Test notifikasi

### iOS:
- [ ] Convert sound ke `.caf` format
- [ ] Buka Xcode: `open ios/Runner.xcworkspace`
- [ ] Drag file `.caf` ke folder Runner
- [ ] Centang "Copy items" & target "Runner"
- [ ] Run `flutter clean`
- [ ] Run `flutter run`
- [ ] Test notifikasi

---

## 💡 Tips

**Ganti Sound Kapan Saja:**
1. Replace file di folder `raw` (Android) atau Runner (iOS)
2. Nama file tetap sama
3. Rebuild app
4. Done!

**Pakai Sound Berbeda per Notification Type:**
Code sudah support 2 jenis sound:
- `notification_sound` - Notifikasi biasa
- `high_priority_sound` - Notifikasi penting

Tinggal adjust parameter `highPriority: true` saat kirim notifikasi.

**Default Sound (Sementara):**
Jika belum ada custom sound, app akan pakai system default sound. Ini normal!
