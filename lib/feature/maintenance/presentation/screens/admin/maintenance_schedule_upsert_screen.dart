import 'package:flutter/material.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class MaintenanceScheduleUpsertScreen extends StatelessWidget {
  final MaintenanceSchedule? maintenanceSchedule;
  final String? maintenanceId;

  const MaintenanceScheduleUpsertScreen({
    super.key,
    this.maintenanceSchedule,
    this.maintenanceId,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(
        child: Center(child: AppText('MaintenanceScheduleUpsertScreen')),
      ),
    );
  }
}
