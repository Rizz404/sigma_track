import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/di/auth_providers.dart';
import 'package:sigma_track/feature/auth/presentation/providers/auth_state.dart';

class RouterRefreshListenable extends ChangeNotifier {
  final Ref _ref;

  RouterRefreshListenable(this._ref) {
    // Todo: Nanti tambahin lebih banyak kalo ada
    // * Listen to auth state changes
    _ref.listen<AsyncValue<AuthState>>(authNotifierProvider, (_, __) {
      notifyListeners(); // * Trigger router refresh
    });
  }
}
