// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class L10nId extends L10n {
  L10nId([String locale = 'id']) : super(locale);

  @override
  String get home => 'Beranda';

  @override
  String get dashboard => 'Dasbor';

  @override
  String get scanAsset => 'Pindai Aset';

  @override
  String get profile => 'Profil';
}
