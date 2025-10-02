import 'package:flutter/material.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class ListMaintenancesScreen extends StatelessWidget {
  const ListMaintenancesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(child: AppText('ListMaintenancesScreen')),
    );
  }
}
