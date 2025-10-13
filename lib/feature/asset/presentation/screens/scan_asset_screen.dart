import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sigma_track/core/constants/route_constant.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/create_scan_log_usecase.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/scan_log_providers.dart';
import 'package:sigma_track/feature/user/presentation/providers/user_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';
import 'package:visibility_detector/visibility_detector.dart';

// Todo: Benerin behaviornya soalnya masih gak bisa otomatis add geolocator dan juga masih manual input typenya
class ScanAssetScreen extends ConsumerStatefulWidget {
  const ScanAssetScreen({super.key});

  @override
  ConsumerState<ScanAssetScreen> createState() => _ScanAssetScreenState();
}

class _ScanAssetScreenState extends ConsumerState<ScanAssetScreen>
    with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController(
    formats: const [BarcodeFormat.dataMatrix],
    detectionSpeed: DetectionSpeed.normal,
    autoStart: false, // ! Disable auto-start untuk manual lifecycle control
  );
  bool _isProcessing = false;
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // * Request location permission then start camera
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocationPermissionAndStartCamera();
    });
  }

  Future<void> _requestLocationPermissionAndStartCamera() async {
    if (!mounted) return;

    try {
      // * Check location permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        // * Show dialog to open settings
        if (mounted) {
          _showLocationPermissionDialog();
        }
        return;
      }

      if (permission == LocationPermission.denied) {
        // * Permission denied, but can try again
        if (mounted) {
          AppToast.warning('Location permission needed for scan logs');
        }
      }

      // * Start camera regardless of permission (location is optional)
      if (mounted) {
        this.logInfo('ScanAssetScreen: Starting camera');
        _controller.start();
      }
    } catch (e, s) {
      this.logError('Failed to request location permission', e, s);
      // * Start camera anyway
      if (mounted) {
        _controller.start();
      }
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(
          'Location Permission Required',
          style: AppTextStyle.titleMedium,
        ),
        content: const AppText(
          'Location access is needed to track scan logs. Please enable it in settings.',
          style: AppTextStyle.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const AppText('Cancel'),
          ),
          AppButton(
            text: 'Open Settings',
            isFullWidth: false,
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    this.logInfo('ScanAssetScreen: dispose - Stopping camera');
    WidgetsBinding.instance.removeObserver(this);
    if (_controller.value.isRunning) {
      _controller.stop();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // ! Stop camera saat app tidak aktif (background/inactive)
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        // * Stop kamera saat app tidak aktif
        if (_controller.value.isRunning) {
          this.logInfo('ScanAssetScreen: App paused - Stopping camera');
          _controller.stop();
        }
        break;
      case AppLifecycleState.resumed:
        // * Restart kamera saat app kembali aktif
        if (!_controller.value.isRunning) {
          this.logInfo('ScanAssetScreen: App resumed - Starting camera');
          _controller.start();
        }
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    // ! Prevent duplicate scans
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    final assetTag = barcode.rawValue;

    if (assetTag == null || assetTag.isEmpty) {
      AppToast.warning('Invalid barcode data');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      this.logInfo('Scanned asset tag: $assetTag');

      // * Fetch asset by tag
      final notifier = ref.read(getAssetByTagProvider(assetTag).notifier);
      await notifier.refresh();

      final state = ref.read(getAssetByTagProvider(assetTag));

      if (state.asset != null) {
        // * Create scan log
        await _createScanLog(
          assetId: state.asset!.id,
          scannedValue: assetTag,
          scanResult: ScanResultType.success,
        );

        AppToast.success('Asset found: ${state.asset!.assetName}');

        if (mounted) {
          // * Navigate to asset detail screen by assetTag (from QR scan)
          // ? This prevents duplicate log creation in asset_detail_screen
          await context.push('${RouteConstant.assetDetail}?assetTag=$assetTag');
          // * Reset processing state after navigation completes
          setState(() => _isProcessing = false);
        }
      } else if (state.failure != null) {
        // * Create scan log for failed scan
        await _createScanLog(
          scannedValue: assetTag,
          scanResult: ScanResultType.assetNotFound,
        );

        this.logError('Failed to fetch asset', state.failure);
        AppToast.error(state.failure?.message ?? 'Asset not found');
        setState(() => _isProcessing = false);
      }
    } catch (e, s) {
      // * Create scan log for error
      await _createScanLog(
        scannedValue: assetTag,
        scanResult: ScanResultType.invalidID,
      );

      this.logError('Error processing barcode', e, s);
      AppToast.error('Failed to process barcode');
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _createScanLog({
    String? assetId,
    required String scannedValue,
    required ScanResultType scanResult,
  }) async {
    try {
      // * Get current user
      final currentUserState = ref.read(currentUserNotifierProvider);
      if (currentUserState.user == null) {
        this.logError('Cannot create scan log: user not found');
        return;
      }

      // * Get current location
      Position? position;
      try {
        position = await _getCurrentLocation();
      } catch (e) {
        this.logInfo('Location unavailable: $e');
      }

      // * Create scan log
      final scanLogNotifier = ref.read(scanLogsProvider.notifier);
      await scanLogNotifier.createScanLog(
        CreateScanLogUsecaseParams(
          assetId: assetId,
          scannedValue: scannedValue,
          scanMethod: ScanMethodType.dataMatrix,
          scannedById: currentUserState.user!.id,
          scanTimestamp: DateTime.now(),
          scanLocationLat: position?.latitude,
          scanLocationLng: position?.longitude,
          scanResult: scanResult,
        ),
      );

      this.logInfo('Scan log created successfully');
    } catch (e, s) {
      this.logError('Failed to create scan log', e, s);
      // ! Don't show error to user, log creation is not critical
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // * Check if location services enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services disabled');
    }

    // * Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions permanently denied');
    }

    // * Get position
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('scan-asset-screen'),
      onVisibilityChanged: (info) {
        final visiblePercentage = info.visibleFraction;
        this.logInfo('ScanAssetScreen visibility: $visiblePercentage');

        // * Threshold 0.1 = screen hampir tidak visible (tab berubah)
        if (visiblePercentage < 0.1 && _controller.value.isRunning) {
          // * Screen tidak visible - stop kamera & reset state
          this.logInfo('ScanAssetScreen: Not visible - Stopping camera');
          _controller.stop();
          if (mounted) {
            setState(() => _isTorchOn = false);
          }
        } else if (visiblePercentage > 0.9 && !_controller.value.isRunning) {
          // * Screen kembali visible - restart kamera
          this.logInfo('ScanAssetScreen: Visible again - Starting camera');
          _controller.start();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
              errorBuilder: (context, error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: context.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      const AppText(
                        'Camera Error',
                        style: AppTextStyle.titleMedium,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 8),
                      AppText(
                        error.errorCode.toString(),
                        style: AppTextStyle.bodyMedium,
                        color: context.colors.textSecondary,
                      ),
                    ],
                  ),
                );
              },
            ),
            _buildScannerOverlay(),
            if (_isProcessing) _buildLoadingOverlay(),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Container(
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
      child: Stack(
        children: [
          // * Dark overlay with transparent center
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          // * Instructions
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const AppText(
                  'Align data matrix within frame',
                  style: AppTextStyle.bodyMedium,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // * Corner markers
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                children: [
                  _buildCornerMarker(Alignment.topLeft),
                  _buildCornerMarker(Alignment.topRight),
                  _buildCornerMarker(Alignment.bottomLeft),
                  _buildCornerMarker(Alignment.bottomRight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCornerMarker(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border(
            top:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.topRight
                ? BorderSide(color: context.colorScheme.primary, width: 4)
                : BorderSide.none,
            left:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.bottomLeft
                ? BorderSide(color: context.colorScheme.primary, width: 4)
                : BorderSide.none,
            right:
                alignment == Alignment.topRight ||
                    alignment == Alignment.bottomRight
                ? BorderSide(color: context.colorScheme.primary, width: 4)
                : BorderSide.none,
            bottom:
                alignment == Alignment.bottomLeft ||
                    alignment == Alignment.bottomRight
                ? BorderSide(color: context.colorScheme.primary, width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  context.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              const AppText(
                'Processing...',
                style: AppTextStyle.bodyMedium,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 32,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlButton(
                  icon: _isTorchOn ? Icons.flash_on : Icons.flash_off,
                  label: 'Flash',
                  onPressed: () async {
                    await _controller.toggleTorch();
                    setState(() => _isTorchOn = !_isTorchOn);
                  },
                ),
                const SizedBox(width: 32),
                _buildControlButton(
                  icon: Icons.flip_camera_ios,
                  label: 'Flip',
                  onPressed: () => _controller.switchCamera(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white),
            onPressed: onPressed,
            iconSize: 28,
          ),
        ),
        const SizedBox(height: 4),
        AppText(label, style: AppTextStyle.bodySmall, color: Colors.white),
      ],
    );
  }
}
