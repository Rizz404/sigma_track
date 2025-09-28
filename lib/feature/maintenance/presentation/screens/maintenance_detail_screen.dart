import 'package:flutter/material.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class MaintenanceDetailScreen extends StatelessWidget {
  final MaintenanceRecord maintenanceRecord;

  const MaintenanceDetailScreen({super.key, required this.maintenanceRecord});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenWrapper(
        child: Center(child: AppText('MaintenanceDetailScreen')),
      ),
    );
  }
}
