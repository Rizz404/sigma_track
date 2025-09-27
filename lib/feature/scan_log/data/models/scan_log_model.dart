import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';

class ScanLogModel extends Equatable {
  final String id;
  final String? assetID;
  final String scannedValue;
  final ScanMethodType scanMethod;
  final String scannedByID;
  final DateTime scanTimestamp;
  final double? scanLocationLat;
  final double? scanLocationLng;
  final ScanResultType scanResult;

  const ScanLogModel({
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

  ScanLogModel copyWith({
    String? id,
    String? assetID,
    String? scannedValue,
    ScanMethodType? scanMethod,
    String? scannedByID,
    DateTime? scanTimestamp,
    double? scanLocationLat,
    double? scanLocationLng,
    ScanResultType? scanResult,
  }) {
    return ScanLogModel(
      id: id ?? this.id,
      assetID: assetID ?? this.assetID,
      scannedValue: scannedValue ?? this.scannedValue,
      scanMethod: scanMethod ?? this.scanMethod,
      scannedByID: scannedByID ?? this.scannedByID,
      scanTimestamp: scanTimestamp ?? this.scanTimestamp,
      scanLocationLat: scanLocationLat ?? this.scanLocationLat,
      scanLocationLng: scanLocationLng ?? this.scanLocationLng,
      scanResult: scanResult ?? this.scanResult,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assetId': assetID,
      'scannedValue': scannedValue,
      'scanMethod': scanMethod.toJson(),
      'scannedById': scannedByID,
      'scanTimestamp': scanTimestamp.millisecondsSinceEpoch,
      'scanLocationLat': scanLocationLat,
      'scanLocationLng': scanLocationLng,
      'scanResult': scanResult.toJson(),
    };
  }

  factory ScanLogModel.fromMap(Map<String, dynamic> map) {
    return ScanLogModel(
      id: map['id'] ?? '',
      assetID: map['assetId'],
      scannedValue: map['scannedValue'] ?? '',
      scanMethod: ScanMethodType.fromJson(map['scanMethod']),
      scannedByID: map['scannedById'] ?? '',
      scanTimestamp: DateTime.fromMillisecondsSinceEpoch(map['scanTimestamp']),
      scanLocationLat: map['scanLocationLat']?.toDouble(),
      scanLocationLng: map['scanLocationLng']?.toDouble(),
      scanResult: ScanResultType.fromJson(map['scanResult']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScanLogModel.fromJson(String source) =>
      ScanLogModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ScanLogModel(id: $id, assetID: $assetID, scannedValue: $scannedValue, scanMethod: $scanMethod, scannedByID: $scannedByID, scanTimestamp: $scanTimestamp, scanLocationLat: $scanLocationLat, scanLocationLng: $scanLocationLng, scanResult: $scanResult)';
  }
}
