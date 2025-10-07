import 'package:flutter/material.dart';
import 'package:sigma_track/feature/notification/domain/entities/notification.dart'
    as notification_entity;
import 'package:sigma_track/shared/presentation/widgets/app_end_drawer.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class NotificationDetailScreen extends StatelessWidget {
  final notification_entity.Notification? notification;
  final String? id;

  const NotificationDetailScreen({super.key, this.notification, this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const AppEndDrawer(),
      body: const ScreenWrapper(
        child: Center(child: AppText('NotificationDetailScreen')),
      ),
    );
  }
}
