import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/count_scan_logs_usecase.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/check_scan_log_exists_notifier.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/count_scan_logs_notifier.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/get_scan_log_by_id_notifier.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/scan_log_statistics_notifier.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/scan_logs_notifier.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/scan_logs_search_notifier.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/state/scan_log_boolean_state.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/state/scan_log_count_state.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/state/scan_log_detail_state.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/state/scan_log_statistics_state.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/state/scan_logs_state.dart';

final scanLogsProvider =
    AutoDisposeNotifierProvider<ScanLogsNotifier, ScanLogsState>(
      ScanLogsNotifier.new,
    );

// * Provider khusus untuk dropdown search (data terpisah dari list utama)
final scanLogsSearchProvider =
    AutoDisposeNotifierProvider<ScanLogsSearchNotifier, ScanLogsState>(
      ScanLogsSearchNotifier.new,
    );

// * Provider untuk check apakah scan log exists
final checkScanLogExistsProvider =
    AutoDisposeNotifierProviderFamily<
      CheckScanLogExistsNotifier,
      ScanLogBooleanState,
      String
    >(CheckScanLogExistsNotifier.new);

// * Provider untuk count scan logs
final countScanLogsProvider =
    AutoDisposeNotifierProviderFamily<
      CountScanLogsNotifier,
      ScanLogCountState,
      CountScanLogsUsecaseParams
    >(CountScanLogsNotifier.new);

// * Provider untuk scan log statistics
final scanLogStatisticsProvider =
    AutoDisposeNotifierProvider<
      ScanLogStatisticsNotifier,
      ScanLogStatisticsState
    >(ScanLogStatisticsNotifier.new);

// * Provider untuk get scan log by ID
final getScanLogByIdProvider =
    AutoDisposeNotifierProviderFamily<
      GetScanLogByIdNotifier,
      ScanLogDetailState,
      String
    >(GetScanLogByIdNotifier.new);
