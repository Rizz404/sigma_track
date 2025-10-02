import 'package:flutter/material.dart';
import 'package:sigma_track/feature/asset_movement/domain/entities/asset_movement.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class AssetMovementUpsertScreen extends StatelessWidget {
  final AssetMovement? assetMovement;

  const AssetMovementUpsertScreen({super.key, this.assetMovement});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(
        child: Center(child: AppText('AssetMovementUpsertScreen')),
      ),
    );
  }
}
