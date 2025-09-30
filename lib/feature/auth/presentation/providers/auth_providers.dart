import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/auth/presentation/providers/auth_notifier.dart';
import 'package:sigma_track/feature/auth/presentation/providers/auth_state.dart';

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
