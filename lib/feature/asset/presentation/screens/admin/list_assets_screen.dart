import 'package:flutter/material.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class ListAssetsScreen extends StatelessWidget {
  const ListAssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(child: Center(child: AppText('ListAssetsScreen'))),
    );
  }
}
