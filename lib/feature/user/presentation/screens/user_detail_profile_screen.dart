import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/di/common_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class UserDetailProfileScreen extends ConsumerWidget {
  const UserDetailProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      body: ScreenWrapper(
        child: Center(
          child: userAsync.when(
            data: (user) => AppText(user?.name ?? 'No User'),
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => AppText('Error: $error'),
          ),
        ),
      ),
    );
  }
}
