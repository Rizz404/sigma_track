import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/feature/location/domain/usecases/count_locations_usecase.dart';
import 'package:sigma_track/feature/location/presentation/providers/check_location_code_exists_notifier.dart';
import 'package:sigma_track/feature/location/presentation/providers/check_location_exists_notifier.dart';
import 'package:sigma_track/feature/location/presentation/providers/count_locations_notifier.dart';
import 'package:sigma_track/feature/location/presentation/providers/get_location_by_code_notifier.dart';
import 'package:sigma_track/feature/location/presentation/providers/get_location_by_id_notifier.dart';
import 'package:sigma_track/feature/location/presentation/providers/location_statistics_notifier.dart';
import 'package:sigma_track/feature/location/presentation/providers/locations_notifier.dart';
import 'package:sigma_track/feature/location/presentation/providers/locations_search_notifier.dart';
import 'package:sigma_track/feature/location/presentation/providers/locations_search_dropdown_notifier.dart';
import 'package:sigma_track/feature/location/presentation/providers/state/location_boolean_state.dart';
import 'package:sigma_track/feature/location/presentation/providers/state/location_count_state.dart';
import 'package:sigma_track/feature/location/presentation/providers/state/location_detail_state.dart';
import 'package:sigma_track/feature/location/presentation/providers/state/location_statistics_state.dart';
import 'package:sigma_track/feature/location/presentation/providers/state/locations_state.dart';

final locationsProvider =
    AutoDisposeNotifierProvider<LocationsNotifier, LocationsState>(
      LocationsNotifier.new,
    );

// * Provider khusus untuk dropdown search (data terpisah dari list utama)
final locationsSearchProvider =
    AutoDisposeNotifierProvider<LocationsSearchNotifier, LocationsState>(
      LocationsSearchNotifier.new,
    );

// * Provider khusus untuk dropdown search dengan load data saat pertama kali
final locationsSearchDropdownProvider =
    AutoDisposeNotifierProvider<
      LocationsSearchDropdownNotifier,
      LocationsState
    >(LocationsSearchDropdownNotifier.new);

// * Provider untuk check apakah location code exists
final checkLocationCodeExistsProvider =
    AutoDisposeNotifierProviderFamily<
      CheckLocationCodeExistsNotifier,
      LocationBooleanState,
      String
    >(CheckLocationCodeExistsNotifier.new);

// * Provider untuk check apakah location exists by ID
final checkLocationExistsProvider =
    AutoDisposeNotifierProviderFamily<
      CheckLocationExistsNotifier,
      LocationBooleanState,
      String
    >(CheckLocationExistsNotifier.new);

// * Provider untuk count locations
final countLocationsProvider =
    AutoDisposeNotifierProviderFamily<
      CountLocationsNotifier,
      LocationCountState,
      CountLocationsUsecaseParams
    >(CountLocationsNotifier.new);

// * Provider untuk location statistics
final locationStatisticsProvider =
    AutoDisposeNotifierProvider<
      LocationStatisticsNotifier,
      LocationStatisticsState
    >(LocationStatisticsNotifier.new);

// * Provider untuk get location by code
final getLocationByCodeProvider =
    AutoDisposeNotifierProviderFamily<
      GetLocationByCodeNotifier,
      LocationDetailState,
      String
    >(GetLocationByCodeNotifier.new);

// * Provider untuk get location by ID
final getLocationByIdProvider =
    AutoDisposeNotifierProviderFamily<
      GetLocationByIdNotifier,
      LocationDetailState,
      String
    >(GetLocationByIdNotifier.new);
