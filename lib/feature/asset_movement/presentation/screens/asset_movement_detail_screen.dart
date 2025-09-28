import 'package:flutter/material.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class AssetMovementDetailScreen extends StatelessWidget {
  final AssetMovement assetMovement;

  const AssetMovementDetailScreen({super.key, required this.assetMovement});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenWrapper(
        child: Center(child: AppText('AssetMovementDetailScreen')),
      ),
    );
  }
}
