import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/di/service_providers.dart';

/// Debug screen untuk test custom notification sounds
class NotificationTestScreen extends ConsumerWidget {
  const NotificationTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localNotificationService = ref.read(localNotificationServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Sound Test')),
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
                      '🔊 Sound Test',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Test custom notification sounds. Make sure device volume is up!',
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
              label: const Text('Test Default Sound'),
              onPressed: () async {
                await localNotificationService.showNotification(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: 'Default Notification',
                  body: 'This should play notification_sound.ogg',
                  highPriority: false,
                );
              },
            ),

            const SizedBox(height: 16),

            // * High priority sound test
            ElevatedButton.icon(
              icon: const Icon(Icons.warning_amber_rounded),
              label: const Text('Test High Priority Sound'),
              onPressed: () async {
                await localNotificationService.showNotification(
                  id: DateTime.now().millisecondsSinceEpoch,
                  title: 'High Priority Notification',
                  body: 'This should play high_priority_sound.ogg',
                  highPriority: true,
                );
              },
            ),

            const SizedBox(height: 16),

            // * Multiple notifications
            ElevatedButton.icon(
              icon: const Icon(Icons.notifications_active),
              label: const Text('Test Multiple Notifications'),
              onPressed: () async {
                await localNotificationService.showNotification(
                  id: 1,
                  title: 'Notification 1',
                  body: 'Default sound',
                  highPriority: false,
                );

                await Future.delayed(const Duration(seconds: 2));

                await localNotificationService.showNotification(
                  id: 2,
                  title: 'Notification 2',
                  body: 'High priority sound',
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
                      '⚠️ Not Working?',
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.onErrorContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '1. Uninstall app completely\n'
                      '2. flutter clean && flutter pub get\n'
                      '3. flutter run\n'
                      '4. Check volume is up\n'
                      '5. Files must be .ogg format in raw/',
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
