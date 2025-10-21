import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/check_maintenance_record_exists_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/check_maintenance_schedule_exists_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/count_maintenance_records_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/count_maintenance_schedules_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/get_maintenance_record_by_id_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_records_statistics_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/get_maintenance_schedule_by_id_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_schedules_statistics_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_records_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_records_search_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_schedules_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_schedules_search_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_record_boolean_state.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_record_count_state.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_record_detail_state.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_record_statistics_state.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_records_state.dart';
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

final maintenanceRecordsProvider =
    AutoDisposeNotifierProvider<
      MaintenanceRecordsNotifier,
      MaintenanceRecordsState
    >(MaintenanceRecordsNotifier.new);

// * Provider khusus untuk dropdown search (data terpisah dari list utama)
final maintenanceSchedulesSearchProvider =
    AutoDisposeNotifierProvider<
      MaintenanceSchedulesSearchNotifier,
      MaintenanceSchedulesState
    >(MaintenanceSchedulesSearchNotifier.new);

final maintenanceRecordsSearchProvider =
    AutoDisposeNotifierProvider<
      MaintenanceRecordsSearchNotifier,
      MaintenanceRecordsState
    >(MaintenanceRecordsSearchNotifier.new);

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

final maintenanceSchedulesStatisticsProvider =
    AutoDisposeNotifierProvider<
      MaintenanceSchedulesStatisticsNotifier,
      MaintenanceScheduleStatisticsState
    >(MaintenanceSchedulesStatisticsNotifier.new);

final getMaintenanceRecordByIdProvider =
    AutoDisposeNotifierProviderFamily<
      GetMaintenanceRecordByIdNotifier,
      MaintenanceRecordDetailState,
      String
    >(GetMaintenanceRecordByIdNotifier.new);

final checkMaintenanceRecordExistsProvider =
    AutoDisposeNotifierProvider<
      CheckMaintenanceRecordExistsNotifier,
      MaintenanceRecordBooleanState
    >(CheckMaintenanceRecordExistsNotifier.new);

final countMaintenanceRecordsProvider =
    AutoDisposeNotifierProvider<
      CountMaintenanceRecordsNotifier,
      MaintenanceRecordCountState
    >(CountMaintenanceRecordsNotifier.new);

final maintenanceRecordsStatisticsProvider =
    AutoDisposeNotifierProvider<
      MaintenanceRecordsStatisticsNotifier,
      MaintenanceRecordStatisticsState
    >(MaintenanceRecordsStatisticsNotifier.new);
