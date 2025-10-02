import 'package:flutter/material.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class LocationUpsertScreen extends StatelessWidget {
  final Location? location;
  final String? locationId;

  const LocationUpsertScreen({super.key, this.location, this.locationId});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(
        child: Center(child: AppText('LocationUpsertScreen')),
      ),
    );
  }
}
