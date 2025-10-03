import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';

class ScanLog extends Equatable {
  final String id;
  final String? assetId;
  final String scannedValue;
  final ScanMethodType scanMethod;
  final String scannedById;
  final DateTime scanTimestamp;
  final double? scanLocationLat;
  final double? scanLocationLng;
  final ScanResultType scanResult;

  const ScanLog({
    required this.id,
    this.assetId,
    required this.scannedValue,
    required this.scanMethod,
    required this.scannedById,
    required this.scanTimestamp,
    this.scanLocationLat,
    this.scanLocationLng,
    required this.scanResult,
  });

  @override
  List<Object?> get props {
    return [
      id,
      assetId,
      scannedValue,
      scanMethod,
      scannedById,
      scanTimestamp,
      scanLocationLat,
      scanLocationLng,
      scanResult,
    ];
  }
}
