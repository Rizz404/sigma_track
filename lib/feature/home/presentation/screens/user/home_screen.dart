import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenWrapper(
        child: Center(child: AppText(context.l10n.homeScreen)),
      ),
    );
  }
}
