import 'package:flutter/material.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class MaintenanceRecordDetailScreen extends StatelessWidget {
  final MaintenanceRecord? maintenanceRecord;
  final String? id;

  const MaintenanceRecordDetailScreen({
    super.key,
    this.maintenanceRecord,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(
        child: Center(child: AppText('MaintenanceRecordDetailScreen')),
      ),
    );
  }
}
