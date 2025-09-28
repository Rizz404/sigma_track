import 'package:flutter/material.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';

class ListLocationsScreen extends StatelessWidget {
  const ListLocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ScreenWrapper(child: AppText('ListLocationsScreen')));
  }
}
