import 'package:flutter/material.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class ListNotificationsScreen extends StatelessWidget {
  const ListNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(child: AppText('ListNotificationsScreen')),
    );
  }
}
