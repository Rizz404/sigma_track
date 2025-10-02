# AppToast Usage Guide

Utility untuk menampilkan toast notifications menggunakan BotToast.

## Setup

BotToast sudah dikonfigurasi di `main.dart`:
```dart
builder: (context, child) => botToastBuilder(context, child),
```

## Cara Pakai

Import utility:
```dart
import 'package:sigma_track/core/utils/toast_utils.dart';
```

### 1. Success Toast (Hijau)
```dart
AppToast.success('Data berhasil disimpan');
AppToast.success('Login berhasil', duration: const Duration(seconds: 5));
```

### 2. Error Toast (Merah)
```dart
AppToast.error('Gagal menyimpan data');
AppToast.error('Terjadi kesalahan pada server');
```

### 3. Warning Toast (Orange)
```dart
AppToast.warning('Perhatian! Data akan dihapus');
AppToast.warning('Anda belum mengisi semua field');
```

### 4. Info Toast (Biru)
```dart
AppToast.info('Data sedang diproses');
AppToast.info('Silakan tunggu beberapa saat');
```

### 5. Custom Duration & OnTap
```dart
AppToast.success(
  'Data tersimpan',
  duration: const Duration(seconds: 5),
  onTap: () {
    print('Toast diklik');
  },
);
```

## Contoh Penggunaan dalam Widget/Screen

```dart
class ExampleScreen extends ConsumerWidget {
  const ExampleScreen({super.key});

  Future<void> _saveData(WidgetRef ref) async {
    try {
      // Proses async
      await Future.delayed(const Duration(seconds: 2));

      // Tampilkan success
      AppToast.success('Data berhasil disimpan');
    } catch (e) {
      AppToast.error('Gagal menyimpan: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _saveData(ref),
              child: const Text('Save'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => AppToast.warning('Hati-hati!'),
              child: const Text('Warning'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => AppToast.info('Informasi penting'),
              child: const Text('Info'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Contoh dengan UseCase

```dart
final result = await ref.read(loginUseCaseProvider).call(
  LoginParams(email: email, password: password),
);

result.fold(
  (failure) => AppToast.error(failure.message),
  (user) {
    AppToast.success('Selamat datang, ${user.name}');
    // Navigate to home...
  },
);
```

## Fitur

- ✅ onlyOne: true (hanya satu toast yang muncul)
- ✅ Auto dismiss setelah duration (default 3 detik)
- ✅ Custom duration
- ✅ OnTap callback
- ✅ Warna dari semantic colors (theme-aware)
- ✅ Text style dari theme system
- ✅ Icon sesuai tipe (success, error, warning, info)
- ✅ Shadow dan rounded corners
- ✅ Responsive text (Flexible widget)

## Catatan

- Toast akan otomatis hilang setelah 3 detik (default)
- Bisa custom duration dengan parameter `duration`
- `onlyOne: true` memastikan hanya ada satu toast yang tampil
- Warna sudah terintegrasi dengan theme system (SemanticColors)
- Text style menggunakan `context.textTheme.bodyMedium`
