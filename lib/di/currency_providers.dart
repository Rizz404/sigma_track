import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/services/currency_service.dart';
import 'package:sigma_track/di/common_providers.dart';

final currencyServiceProvider = Provider<CurrencyService>((ref) {
  final dio = ref.watch(dioProvider);
  return CurrencyService(dio);
});
