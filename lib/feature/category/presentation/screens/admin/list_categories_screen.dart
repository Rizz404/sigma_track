import 'package:flutter/material.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class ListCategoriesScreen extends StatelessWidget {
  const ListCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(
        child: Center(child: AppText('ListCategoriesScreen')),
      ),
    );
  }
}
