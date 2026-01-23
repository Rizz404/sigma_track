import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/di/service_providers.dart';

/// Debug screen untuk test custom notification sounds
class NotificationTestScreen extends ConsumerWidget {
  const NotificationTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localNotificationService = ref.read(localNotificationServiceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.notificationSoundTestTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // * Info card
            Card(
              color: context.colors.surface,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.notificationSoundTestCardTitle,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.notificationSoundTestCardMessage,
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // * Default sound test
            ElevatedButton.icon(
              icon: const Icon(Icons.music_note),
              label: Text(context.l10n.notificationTestDefaultSound),
              onPressed: () async {
                await localNotificationService.showNotification(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: context.l10n.notificationTestDefaultTitle,
                  body: context.l10n.notificationTestBodyDefault,
                  highPriority: false,
                );
              },
            ),

            const SizedBox(height: 16),

            // * High priority sound test
            ElevatedButton.icon(
              icon: const Icon(Icons.warning_amber_rounded),
              label: Text(context.l10n.notificationTestHighPrioritySound),
              onPressed: () async {
                await localNotificationService.showNotification(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: context.l10n.notificationTestHighPriorityTitle,
                  body: context.l10n.notificationTestBodyHighPriority,
                  highPriority: true,
                );
              },
            ),

            const SizedBox(height: 16),

            // * Multiple notifications
            ElevatedButton.icon(
              icon: const Icon(Icons.notifications_active),
              label: Text(context.l10n.notificationTestMultipleNotifications),
              onPressed: () async {
                await localNotificationService.showNotification(
                  id: 1,
                  title: context.l10n.notificationTest1Title,
                  body: context.l10n.notificationTestBodyMultiple1,
                  highPriority: false,
                );

                await Future.delayed(const Duration(seconds: 2));

                await localNotificationService.showNotification(
                  id: 2,
                  title: context.l10n.notificationTest2Title,
                  body: context.l10n.notificationTestBodyMultiple2,
                  highPriority: true,
                );
              },
            ),

            const SizedBox(height: 24),

            const Divider(),

            const SizedBox(height: 16),

            // * Troubleshooting tips
            Card(
              color: context.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.notificationTestTroubleshootingTitle,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.onErrorContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.notificationTestTroubleshootingMessage,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.onErrorContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
