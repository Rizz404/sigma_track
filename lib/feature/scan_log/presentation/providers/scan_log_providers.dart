import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/scan_logs_notifier.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/state/scan_logs_state.dart';

final scanLogsProvider =
    AutoDisposeNotifierProvider<ScanLogsNotifier, ScanLogsState>(
      ScanLogsNotifier.new,
    );
