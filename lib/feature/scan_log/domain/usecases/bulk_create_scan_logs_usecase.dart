import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';
import 'package:sigma_track/feature/scan_log/domain/repositories/scan_log_repository.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/create_scan_log_usecase.dart';

class BulkCreateScanLogsUsecase
    implements
        Usecase<
          ItemSuccess<BulkCreateScanLogsResponse>,
          BulkCreateScanLogsParams
        > {
  final ScanLogRepository _scanLogRepository;

  BulkCreateScanLogsUsecase(this._scanLogRepository);

  @override
  Future<Either<Failure, ItemSuccess<BulkCreateScanLogsResponse>>> call(
    BulkCreateScanLogsParams params,
  ) async {
    return await _scanLogRepository.createManyScanLogs(params);
  }
}

class BulkCreateScanLogsParams extends Equatable {
  final List<CreateScanLogUsecaseParams> scanLogs;

  const BulkCreateScanLogsParams({required this.scanLogs});

  Map<String, dynamic> toMap() {
    return {'scanLogs': scanLogs.map((x) => x.toMap()).toList()};
  }

  factory BulkCreateScanLogsParams.fromMap(Map<String, dynamic> map) {
    return BulkCreateScanLogsParams(
      scanLogs: List<CreateScanLogUsecaseParams>.from(
        (map['scanLogs'] as List).map(
          (x) => CreateScanLogUsecaseParams.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateScanLogsParams.fromJson(String source) =>
      BulkCreateScanLogsParams.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [scanLogs];
}

class BulkCreateScanLogsResponse extends Equatable {
  final List<ScanLog> scanLogs;

  const BulkCreateScanLogsResponse({required this.scanLogs});

  Map<String, dynamic> toMap() {
    return {'scanLogs': scanLogs.map((x) => _scanLogToMap(x)).toList()};
  }

  factory BulkCreateScanLogsResponse.fromMap(Map<String, dynamic> map) {
    return BulkCreateScanLogsResponse(
      scanLogs: List<ScanLog>.from(
        (map['scanLogs'] as List).map(
          (x) => _scanLogFromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BulkCreateScanLogsResponse.fromJson(String source) =>
      BulkCreateScanLogsResponse.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [scanLogs];

  static Map<String, dynamic> _scanLogToMap(ScanLog scanLog) {
    return {
      'id': scanLog.id,
      'assetId': scanLog.assetId,
      'scannedValue': scanLog.scannedValue,
      'scanMethod': scanLog.scanMethod.value,
      'scannedById': scanLog.scannedById,
      'scanTimestamp': scanLog.scanTimestamp.toIso8601String(),
      'scanLocationLat': scanLog.scanLocationLat,
      'scanLocationLng': scanLog.scanLocationLng,
      'scanResult': scanLog.scanResult.value,
    };
  }

  static ScanLog _scanLogFromMap(Map<String, dynamic> map) {
    return ScanLog(
      id: map['id'] ?? '',
      assetId: map['assetId'],
      scannedValue: map['scannedValue'] ?? '',
      scanMethod: ScanMethodType.values.firstWhere(
        (e) => e.value == map['scanMethod'],
        orElse: () => ScanMethodType.dataMatrix,
      ),
      scannedById: map['scannedById'] ?? '',
      scanTimestamp: DateTime.parse(map['scanTimestamp'].toString()),
      scanLocationLat: map['scanLocationLat']?.toDouble(),
      scanLocationLng: map['scanLocationLng']?.toDouble(),
      scanResult: ScanResultType.values.firstWhere(
        (e) => e.value == map['scanResult'],
        orElse: () => ScanResultType.success,
      ),
    );
  }
}
