// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get home => 'ホーム';

  @override
  String get dashboard => 'ダッシュボード';

  @override
  String get scanAsset => '資産をスキャン';

  @override
  String get profile => 'プロフィール';
}
