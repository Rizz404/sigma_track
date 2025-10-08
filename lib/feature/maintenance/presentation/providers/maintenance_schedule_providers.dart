import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/check_maintenance_schedule_exists_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/count_maintenance_schedules_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/get_maintenance_schedule_by_id_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/get_maintenance_schedules_statistics_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_schedules_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_schedules_search_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_schedule_boolean_state.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_schedule_count_state.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_schedule_detail_state.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_schedule_statistics_state.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_schedules_state.dart';

final maintenanceSchedulesProvider =
    AutoDisposeNotifierProvider<
      MaintenanceSchedulesNotifier,
      MaintenanceSchedulesState
    >(MaintenanceSchedulesNotifier.new);

// * Provider khusus untuk dropdown search (data terpisah dari list utama)
final maintenanceSchedulesSearchProvider =
    AutoDisposeNotifierProvider<
      MaintenanceSchedulesSearchNotifier,
      MaintenanceSchedulesState
    >(MaintenanceSchedulesSearchNotifier.new);

final getMaintenanceScheduleByIdProvider =
    AutoDisposeNotifierProviderFamily<
      GetMaintenanceScheduleByIdNotifier,
      MaintenanceScheduleDetailState,
      String
    >(GetMaintenanceScheduleByIdNotifier.new);

final checkMaintenanceScheduleExistsProvider =
    AutoDisposeNotifierProvider<
      CheckMaintenanceScheduleExistsNotifier,
      MaintenanceScheduleBooleanState
    >(CheckMaintenanceScheduleExistsNotifier.new);

final countMaintenanceSchedulesProvider =
    AutoDisposeNotifierProvider<
      CountMaintenanceSchedulesNotifier,
      MaintenanceScheduleCountState
    >(CountMaintenanceSchedulesNotifier.new);

final getMaintenanceSchedulesStatisticsProvider =
    AutoDisposeNotifierProvider<
      GetMaintenanceSchedulesStatisticsNotifier,
      MaintenanceScheduleStatisticsState
    >(GetMaintenanceSchedulesStatisticsNotifier.new);
