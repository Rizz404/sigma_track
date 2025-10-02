import 'package:flutter/material.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class MaintenanceUpsertScreen extends StatelessWidget {
  final MaintenanceRecord? maintenanceRecord;
  final String? maintenanceId;

  const MaintenanceUpsertScreen({
    super.key,
    this.maintenanceRecord,
    this.maintenanceId,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(
        child: Center(child: AppText('MaintenanceUpsertScreen')),
      ),
    );
  }
}
