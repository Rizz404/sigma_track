import 'package:flutter/material.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class AssetDetailScreen extends StatelessWidget {
  final Asset asset;

  const AssetDetailScreen({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(child: Center(child: AppText('AssetDetailScreen'))),
    );
  }
}
