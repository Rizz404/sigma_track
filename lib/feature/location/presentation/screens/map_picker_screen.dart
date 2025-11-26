import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';

class MapPickerScreen extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const MapPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  // Default to Jakarta if no location provided
  static const CameraPosition _kDefaultLocation = CameraPosition(
    target: LatLng(-6.2088, 106.8456),
    zoom: 14.4746,
  );

  CameraPosition? _currentCameraPosition;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _currentCameraPosition = CameraPosition(
        target: LatLng(widget.initialLatitude!, widget.initialLongitude!),
        zoom: 16,
      );
    } else {
      _currentCameraPosition = _kDefaultLocation;
      _determinePosition();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _determinePosition() async {
    setState(() => _isLoading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final controller = await _controller.future;

      final cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 16,
      );

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {
        _currentCameraPosition = cameraPosition;
      });
    } catch (e) {
      // Ignore errors, just stay at default
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _searchLocation() async {
    final query =
        _formKey.currentState?.fields['search']?.value as String? ?? '';
    if (query.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final controller = await _controller.future;

        final cameraPosition = CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: 16,
        );

        controller.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition),
        );
        setState(() {
          _currentCameraPosition = cameraPosition;
        });
      } else {
        if (mounted) AppToast.warning(context.l10n.locationNotFound);
      }
    } catch (e) {
      if (mounted) AppToast.error(context.l10n.locationSearchFailed);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onCameraMove(CameraPosition position) {
    _currentCameraPosition = position;
  }

  void _confirmLocation() {
    if (_currentCameraPosition != null) {
      context.pop(_currentCameraPosition!.target);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _currentCameraPosition ?? _kDefaultLocation,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: _onCameraMove,
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // We'll use our own
            zoomControlsEnabled: false,
          ),

          // Center Pin
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 30), // Adjust for pin tip
              child: Icon(Icons.location_on, color: Colors.red, size: 40),
            ),
          ),

          // Top Search Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                key: _formKey,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.pop(),
                        ),
                        Expanded(
                          child: AppSearchField<String>(
                            name: 'search',
                            hintText: context.l10n.locationSearchLocation,
                            enableAutocomplete: false,
                            showClearButton: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: _searchLocation,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Actions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton.small(
                          onPressed: _determinePosition,
                          backgroundColor: context.colors.surface,
                          child: Icon(
                            Icons.my_location,
                            color: context.colors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      text: context.l10n.locationConfirmLocation,
                      onPressed: _confirmLocation,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
