import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/notification/presentation/providers/notifications_notifier.dart';
import 'package:sigma_track/feature/notification/presentation/providers/state/notifications_state.dart';

final notificationsProvider =
    AutoDisposeNotifierProvider<NotificationsNotifier, NotificationsState>(
      NotificationsNotifier.new,
    );

// * Provider khusus untuk dropdown search (data terpisah dari list utama)
final notificationsSearchProvider =
    AutoDisposeNotifierProvider<NotificationsNotifier, NotificationsState>(
      NotificationsNotifier.new,
    );
