import 'package:flutter/material.dart';
import 'package:sigma_track/feature/category/domain/entities/category.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class CategoryDetailScreen extends StatelessWidget {
  final Category category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenWrapper(
        child: Center(child: AppText('CategoryDetailScreen')),
      ),
    );
  }
}
