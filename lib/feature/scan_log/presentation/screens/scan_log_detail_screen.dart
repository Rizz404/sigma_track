import 'package:flutter/material.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class ScanLogDetailScreen extends StatelessWidget {
  final ScanLog scanLog;

  const ScanLogDetailScreen({super.key, required this.scanLog});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(child: Center(child: AppText('ScanLogDetailScreen'))),
    );
  }
}
