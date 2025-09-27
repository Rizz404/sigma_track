import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';

class ScanLog extends Equatable {
  final String id;
  final String? assetID;
  final String scannedValue;
  final ScanMethodType scanMethod;
  final String scannedByID;
  final DateTime scanTimestamp;
  final double? scanLocationLat;
  final double? scanLocationLng;
  final ScanResultType scanResult;

  const ScanLog({
    required this.id,
    this.assetID,
    required this.scannedValue,
    required this.scanMethod,
    required this.scannedByID,
    required this.scanTimestamp,
    this.scanLocationLat,
    this.scanLocationLng,
    required this.scanResult,
  });

  @override
  List<Object?> get props {
    return [
      id,
      assetID,
      scannedValue,
      scanMethod,
      scannedByID,
      scanTimestamp,
      scanLocationLat,
      scanLocationLng,
      scanResult,
    ];
  }
}
