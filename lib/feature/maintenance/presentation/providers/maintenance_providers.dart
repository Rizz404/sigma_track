import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_records_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/maintenance_schedules_notifier.dart';
import 'package:sigma_track/feature/maintenance/presentation/providers/state/maintenance_records_state.dart';
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
