import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/user/presentation/providers/users_notifier.dart';
import 'package:sigma_track/feature/user/presentation/providers/state/users_state.dart';

final usersProvider = AutoDisposeNotifierProvider<UsersNotifier, UsersState>(
  UsersNotifier.new,
);
