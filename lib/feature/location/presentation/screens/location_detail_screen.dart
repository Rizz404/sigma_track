import 'package:flutter/material.dart';
import 'package:sigma_track/feature/location/domain/entities/location.dart';
import 'package:sigma_track/shared/presentation/widgets/screen_wrapper.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class LocationDetailScreen extends StatelessWidget {
  final Location? location;
  final String? id;
  final String? locationCode;

  const LocationDetailScreen({
    super.key,
    this.location,
    this.id,
    this.locationCode,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenWrapper(
        child: Center(child: AppText('LocationDetailScreen')),
      ),
    );
  }
}
