import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';

class ScanLogModel extends Equatable {
  final String id;
  final String? assetId;
  final String scannedValue;
  final ScanMethodType scanMethod;
  final String scannedById;
  final DateTime scanTimestamp;
  final double? scanLocationLat;
  final double? scanLocationLng;
  final ScanResultType scanResult;

  const ScanLogModel({
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

  ScanLogModel copyWith({
    String? id,
    String? assetId,
    String? scannedValue,
    ScanMethodType? scanMethod,
    String? scannedById,
    DateTime? scanTimestamp,
    double? scanLocationLat,
    double? scanLocationLng,
    ScanResultType? scanResult,
  }) {
    return ScanLogModel(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      scannedValue: scannedValue ?? this.scannedValue,
      scanMethod: scanMethod ?? this.scanMethod,
      scannedById: scannedById ?? this.scannedById,
      scanTimestamp: scanTimestamp ?? this.scanTimestamp,
      scanLocationLat: scanLocationLat ?? this.scanLocationLat,
      scanLocationLng: scanLocationLng ?? this.scanLocationLng,
      scanResult: scanResult ?? this.scanResult,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assetId': assetId,
      'scannedValue': scannedValue,
      'scanMethod': scanMethod.toJson(),
      'scannedById': scannedById,
      'scanTimestamp': scanTimestamp.millisecondsSinceEpoch,
      'scanLocationLat': scanLocationLat,
      'scanLocationLng': scanLocationLng,
      'scanResult': scanResult.toJson(),
    };
  }

  factory ScanLogModel.fromMap(Map<String, dynamic> map) {
    return ScanLogModel(
      id: map['id'] ?? '',
      assetId: map['assetId'],
      scannedValue: map['scannedValue'] ?? '',
      scanMethod: ScanMethodType.fromJson(map['scanMethod']),
      scannedById: map['scannedById'] ?? '',
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
    return 'ScanLogModel(id: $id, assetId: $assetId, scannedValue: $scannedValue, scanMethod: $scanMethod, scannedById: $scannedById, scanTimestamp: $scanTimestamp, scanLocationLat: $scanLocationLat, scanLocationLng: $scanLocationLng, scanResult: $scanResult)';
  }
}
