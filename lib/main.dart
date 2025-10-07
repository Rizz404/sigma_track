import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:sigma_track/core/constants/storage_key_constant.dart';
import 'package:sigma_track/core/themes/app_theme.dart';
import 'package:sigma_track/core/utils/talker_config.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/di/common_providers.dart';
import 'package:sigma_track/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // * Initialize Talker logger
  TalkerConfig.initialize();

  try {
    // * Pre-cache main font selagi splash screen
    await GoogleFonts.pendingFonts();

    // * Storage
    const secureStorage = FlutterSecureStorage();
    final preferencesWithCache = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {StorageKeyConstant.userKey},
      ),
    );
    final preferences = await SharedPreferences.getInstance();

    // * Jangan remove splash dulu, tunggu auth state selesai loading
    // * Splash akan di-remove otomatis oleh MyApp setelah auth check

    runApp(
      ProviderScope(
        overrides: [
          secureStorageProvider.overrideWithValue(secureStorage),
          sharedPreferencesWithCacheProvider.overrideWithValue(
            preferencesWithCache,
          ),
          sharedPreferencesProvider.overrideWithValue(preferences),
        ],
        observers: [TalkerConfig.riverpodObserver],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    FlutterNativeSplash.remove();

    runApp(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            L10n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: L10n.supportedLocales,
          home: Scaffold(body: Center(child: Text('Error initializing app'))),
        ),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);
    final botToastBuilder = BotToastInit();

    // * Remove native splash setelah auth state selesai loading
    ref.listen(authNotifierProvider, (previous, next) {
      if (!next.isLoading && (previous?.isLoading ?? true)) {
        FlutterNativeSplash.remove();
      }
    });

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Sigma Track",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      builder: (context, child) => botToastBuilder(context, child),

      // * Router Configuration
      routerConfig: router,

      // * Localization Configuration
      localizationsDelegates: const [
        L10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L10n.supportedLocales,
      locale: currentLocale,

      // * Locale Resolution Strategy
      localeResolutionCallback: (locale, supportedLocales) {
        // * If device locale is supported, use it
        if (locale != null) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }

          // * If exact match not found, try language code only
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              return supportedLocale;
            }
          }
        }

        // * Fallback to first supported locale (should be 'en')
        return supportedLocales.first;
      },
    );
  }
}
