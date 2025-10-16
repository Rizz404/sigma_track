import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';

import 'package:sigma_track/core/extensions/model_parsing_extension.dart';
import 'package:sigma_track/core/extensions/date_time_extension.dart';

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
      'scanMethod': scanMethod.value,
      'scannedById': scannedById,
      'scanTimestamp': scanTimestamp.iso8601String,
      'scanLocationLat': scanLocationLat,
      'scanLocationLng': scanLocationLng,
      'scanResult': scanResult.value,
    };
  }

  factory ScanLogModel.fromMap(Map<String, dynamic> map) {
    return ScanLogModel(
      id: map.getField<String>('id'),
      assetId: map.getFieldOrNull<String>('assetId'),
      scannedValue: map.getField<String>('scannedValue'),
      scanMethod: ScanMethodType.values.firstWhere(
        (e) => e.value == map.getField<String>('scanMethod'),
      ),
      scannedById: map.getField<String>('scannedById'),
      scanTimestamp: map.getDateTime('scanTimestamp'),
      scanLocationLat: map.getDoubleOrNull('scanLocationLat'),
      scanLocationLng: map.getDoubleOrNull('scanLocationLng'),
      scanResult: ScanResultType.values.firstWhere(
        (e) => e.value == map.getField<String>('scanResult'),
      ),
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
