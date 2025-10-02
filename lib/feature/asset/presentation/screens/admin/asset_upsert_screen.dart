import 'package:flutter/material.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class AssetUpsertScreen extends StatelessWidget {
  final Asset? asset;

  const AssetUpsertScreen({super.key, this.asset});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(child: Center(child: AppText('AssetUpsertScreen'))),
    );
  }
}
