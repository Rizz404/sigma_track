import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/check_maintenance_record_exists_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/count_maintenance_records_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/get_maintenance_record_by_id_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/get_maintenance_records_statistics_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_records_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_records_search_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_record_boolean_state.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_record_count_state.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_record_detail_state.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_record_statistics_state.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_records_state.dart';

final maintenanceRecordsProvider =
    AutoDisposeNotifierProvider<
      MaintenanceRecordsNotifier,
      MaintenanceRecordsState
    >(MaintenanceRecordsNotifier.new);

// * Provider khusus untuk dropdown search (data terpisah dari list utama)
final maintenanceRecordsSearchProvider =
    AutoDisposeNotifierProvider<
      MaintenanceRecordsSearchNotifier,
      MaintenanceRecordsState
    >(MaintenanceRecordsSearchNotifier.new);

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

final getMaintenanceRecordsStatisticsProvider =
    AutoDisposeNotifierProvider<
      GetMaintenanceRecordsStatisticsNotifier,
      MaintenanceRecordStatisticsState
    >(GetMaintenanceRecordsStatisticsNotifier.new);
