import 'package:flutter/material.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart'
    as notification_entity;
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class NotificationDetailScreen extends StatelessWidget {
  final notification_entity.Notification notification;

  const NotificationDetailScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(
        child: Center(child: AppText('NotificationDetailScreen')),
      ),
    );
  }
}
