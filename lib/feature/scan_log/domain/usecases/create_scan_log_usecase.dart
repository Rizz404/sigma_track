import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';
import 'package:sigma_track/feature/scan_log/domain/repositories/scan_log_repository.dart';

class CreateScanLogUsecase
    implements Usecase<ItemSuccess<ScanLog>, CreateScanLogUsecaseParams> {
  final ScanLogRepository _scanLogRepository;

  CreateScanLogUsecase(this._scanLogRepository);

  @override
  Future<Either<Failure, ItemSuccess<ScanLog>>> call(
    CreateScanLogUsecaseParams params,
  ) async {
    return await _scanLogRepository.createScanLog(params);
  }
}

class CreateScanLogUsecaseParams extends Equatable {
  final String? assetId;
  final String scannedValue;
  final ScanMethodType scanMethod;
  final String scannedById;
  final DateTime scanTimestamp;
  final double? scanLocationLat;
  final double? scanLocationLng;
  final ScanResultType scanResult;

  CreateScanLogUsecaseParams({
    this.assetId,
    required this.scannedValue,
    required this.scanMethod,
    required this.scannedById,
    required this.scanTimestamp,
    this.scanLocationLat,
    this.scanLocationLng,
    required this.scanResult,
  });

  Map<String, dynamic> toMap() {
    return {
      'assetId': assetId,
      'scannedValue': scannedValue,
      'scanMethod': scanMethod.value,
      'scannedById': scannedById,
      'scanTimestamp': scanTimestamp.toIso8601String(),
      'scanLocationLat': scanLocationLat,
      'scanLocationLng': scanLocationLng,
      'scanResult': scanResult.value,
    };
  }

  factory CreateScanLogUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CreateScanLogUsecaseParams(
      assetId: map['assetID'],
      scannedValue: map['scannedValue'] ?? '',
      scanMethod: ScanMethodType.values.firstWhere(
        (e) => e.value == map['scanMethod'],
        orElse: () => ScanMethodType.dataMatrix,
      ),
      scannedById: map['scannedByID'] ?? '',
      scanTimestamp: DateTime.parse(map['scanTimestamp']),
      scanLocationLat: map['scanLocationLat']?.toDouble(),
      scanLocationLng: map['scanLocationLng']?.toDouble(),
      scanResult: ScanResultType.values.firstWhere(
        (e) => e.value == map['scanResult'],
        orElse: () => ScanResultType.success,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateScanLogUsecaseParams.fromJson(String source) =>
      CreateScanLogUsecaseParams.fromMap(json.decode(source));

  CreateScanLogUsecaseParams copyWith({
    String? assetId,
    String? scannedValue,
    ScanMethodType? scanMethod,
    String? scannedById,
    DateTime? scanTimestamp,
    double? scanLocationLat,
    double? scanLocationLng,
    ScanResultType? scanResult,
  }) {
    return CreateScanLogUsecaseParams(
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

  @override
  List<Object?> get props {
    return [
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
