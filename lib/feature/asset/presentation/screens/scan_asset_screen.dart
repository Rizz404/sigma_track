import 'package:flutter/material.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class ScanAssetScreen extends StatelessWidget {
  const ScanAssetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenWrapper(child: Center(child: AppText('ScanAssetScreen'))),
    );
  }
}
