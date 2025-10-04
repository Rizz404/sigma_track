import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/di/auth_providers.dart';

/// * ChangeNotifier untuk GoRouter refreshListenable
/// * Trigger router refresh saat auth state berubah tanpa recreate router
class AuthNotifierListenable extends ChangeNotifier {
  final Ref _ref;

  AuthNotifierListenable(this._ref) {
    // * Listen to auth state changes
    _ref.listen(authNotifierProvider, (_, __) {
      // * Notify GoRouter untuk refresh redirect logic
      notifyListeners();
    });
  }
}
