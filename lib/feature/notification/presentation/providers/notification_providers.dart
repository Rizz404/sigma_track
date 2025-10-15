import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/notification/domain/usecases/count_notifications_usecase.dart';
import 'package:sigma_track/feature/notification/presentation/providers/check_notification_exists_notifier.dart';
import 'package:sigma_track/feature/notification/presentation/providers/count_notifications_notifier.dart';
import 'package:sigma_track/feature/notification/presentation/providers/get_notification_by_id_notifier.dart';
import 'package:sigma_track/feature/notification/presentation/providers/my_notifications_notifier.dart';
import 'package:sigma_track/feature/notification/presentation/providers/notification_statistics_notifier.dart';
import 'package:sigma_track/feature/notification/presentation/providers/notifications_notifier.dart';
import 'package:sigma_track/feature/notification/presentation/providers/notifications_search_notifier.dart';
import 'package:sigma_track/feature/notification/presentation/providers/state/notification_boolean_state.dart';
import 'package:sigma_track/feature/notification/presentation/providers/state/notification_count_state.dart';
import 'package:sigma_track/feature/notification/presentation/providers/state/notification_detail_state.dart';
import 'package:sigma_track/feature/notification/presentation/providers/state/notification_statistics_state.dart';
import 'package:sigma_track/feature/notification/presentation/providers/state/notifications_state.dart';

final notificationsProvider =
    AutoDisposeNotifierProvider<NotificationsNotifier, NotificationsState>(
      NotificationsNotifier.new,
    );

final myNotificationsProvider =
    AutoDisposeNotifierProvider<MyNotificationsNotifier, NotificationsState>(
      MyNotificationsNotifier.new,
    );

// * Provider khusus untuk dropdown search (data terpisah dari list utama)
final notificationsSearchProvider =
    AutoDisposeNotifierProvider<
      NotificationsSearchNotifier,
      NotificationsState
    >(NotificationsSearchNotifier.new);

// * Provider untuk check apakah notification exists
final checkNotificationExistsProvider =
    AutoDisposeNotifierProviderFamily<
      CheckNotificationExistsNotifier,
      NotificationBooleanState,
      String
    >(CheckNotificationExistsNotifier.new);

// * Provider untuk count notifications
final countNotificationsProvider =
    AutoDisposeNotifierProviderFamily<
      CountNotificationsNotifier,
      NotificationCountState,
      CountNotificationsUsecaseParams
    >(CountNotificationsNotifier.new);

// * Provider untuk notification statistics
final notificationStatisticsProvider =
    AutoDisposeNotifierProvider<
      NotificationStatisticsNotifier,
      NotificationStatisticsState
    >(NotificationStatisticsNotifier.new);

// * Provider untuk get notification by ID
final getNotificationByIdProvider =
    AutoDisposeNotifierProviderFamily<
      GetNotificationByIdNotifier,
      NotificationDetailState,
      String
    >(GetNotificationByIdNotifier.new);
