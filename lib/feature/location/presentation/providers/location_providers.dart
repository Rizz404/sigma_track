import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/location/presentation/providers/locations_notifier.dart';
import 'package:sigma_track/feature/location/presentation/providers/state/locations_state.dart';

final locationsProvider =
    AutoDisposeNotifierProvider<LocationsNotifier, LocationsState>(
      LocationsNotifier.new,
    );
