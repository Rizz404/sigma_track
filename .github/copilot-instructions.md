Pedoman Copilot (wajib diikuti & eksplisit)

1) Gunakan extensions yang sudah disediakan (langsung import ini)
- Theme/context:
	import 'package:sigma_track/core/extensions/theme_extension.dart';
	// Akses cepat:
	// context.theme, context.textTheme, context.colorScheme, context.isDarkMode,
	// context.appTheme, context.appCupertinoTheme, context.semantic (SemanticColors)
- Localization:
	import 'package:sigma_track/core/extensions/localization_extension.dart';
	// Akses cepat: context.l10n, context.locale, context.isEnglish|isIndonesian|isJapanese
- Theme-aware colors wrapper (jika perlu context.colors):
	import 'package:sigma_track/core/themes/app_colors.dart';
	// Akses cepat: context.colors.primary/surface/textPrimary/dll

Contoh singkat (wajib pakai style/theme, bukan warna statis):
Widget build(BuildContext context) {
	// ...
	return Container(
		color: context.colors.surface,
		child: Text(
			context.l10n.ok,
			style: context.textTheme.titleMedium?.copyWith(
				color: context.colorScheme.primary,
			),
		),
	);
}

2) Selalu gunakan style dari lib/core/themes (jangan warna statis)
- Gunakan: context.textTheme, context.colorScheme, context.colors, context.semantic.
- Dilarang: Color(0xFF...), Colors.red, dsb.

Pola umum:
- Text: style: context.textTheme.bodyMedium
- Warna utama: color: context.colorScheme.primary
- Latar permukaan: color: context.colors.surface
- Border: color: context.colors.border
- Status error/sukses/peringatan: context.semantic.error|success|warning

Contoh:
ElevatedButton(
	onPressed: onTap,
	style: ElevatedButton.styleFrom(
		backgroundColor: context.colorScheme.tertiary,
		foregroundColor: context.colorScheme.onTertiary,
	),
	child: Text(context.l10n.save, style: context.textTheme.labelLarge),
)

3) Logging: ganti semua print/debugPrint dengan logger project
- Import utama (cukup satu ini untuk kebutuhan umum):
	import 'package:sigma_track/core/utils/logging.dart';
	// Tersedia: appLogger (alias dari logger) & extension methods di Object

- Cara pakai (disarankan pakai extensions agar ada context class name):
	class ExampleService {
		void run() {
			this.logService('Mulai proses');
			try {
				// ...
				this.logDomain('Validasi bisnis OK');
			} catch (e, s) {
				this.logError('Gagal memproses', e, s); // atau this.logData(...)
			}
		}
	}

- Untuk integrasi Dio:
	import 'package:sigma_track/core/utils/logger.dart';
	final dioLogger = logger.dioLogger; // TalkerDioLogger interceptor

4) Komentar: gunakan format Better Comments (VS Code)
- // TODO: hal yang akan dilakukan
- // FIXME: ini bug yang harus diperbaiki
- // ! Peringatan penting / breaking change
- // ? Pertanyaan atau butuh klarifikasi
- // * catatan penting implementasi

5) Selalu pakai const jika memungkinkan
- Contoh: const SizedBox(height: 16), const Duration(milliseconds: 300)
- Widget statis tanpa variabel dinamis wajib diberi const

6) Respons Copilot Chat harus singkat & to the point
- Hanya sebutkan apa yang diubah/ditambah/dihapus.
- Jangan jelaskan detail panjang lebar kecuali diminta.

7) Ringkasan cepat (cheat sheet)
- Import extensions: theme_extension.dart, localization_extension.dart, (opsional) app_colors.dart
- Akses theme: context.theme | context.textTheme | context.colorScheme | context.colors | context.semantic
- Akses i18n: context.l10n
- Logger: import core/utils/logging.dart, pakai this.logInfo/logError/logData/logDomain/logPresentation/logService
- Hindari warna statis; pakai theme/colors yang tersedia

8) Dokumentasi & penjelasan kode
- Hindari membuat file .md terpisah kecuali diminta eksplisit
- Hindari penjelasan panjang tentang "mengapa" kecuali benar-benar critical
- Code should be self-explanatory; komentar hanya untuk context tambahan
