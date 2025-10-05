import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/repositories/scan_log_repository.dart';

class CountScanLogsUsecase
    implements Usecase<ItemSuccess<int>, CountScanLogsUsecaseParams> {
  final ScanLogRepository _scanLogRepository;

  CountScanLogsUsecase(this._scanLogRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(
    CountScanLogsUsecaseParams params,
  ) async {
    return await _scanLogRepository.countScanLogs(params);
  }
}

class CountScanLogsUsecaseParams extends Equatable {
  final ScanMethodType? scanMethod;
  final ScanResultType? scanResult;

  const CountScanLogsUsecaseParams({this.scanMethod, this.scanResult});

  CountScanLogsUsecaseParams copyWith({
    ScanMethodType? scanMethod,
    ScanResultType? scanResult,
  }) {
    return CountScanLogsUsecaseParams(
      scanMethod: scanMethod ?? this.scanMethod,
      scanResult: scanResult ?? this.scanResult,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (scanMethod != null) 'scanMethod': scanMethod!.toString(),
      if (scanResult != null) 'scanResult': scanResult!.toString(),
    };
  }

  factory CountScanLogsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CountScanLogsUsecaseParams(
      scanMethod: map['scanMethod'] != null
          ? ScanMethodType.fromString(map['scanMethod'])
          : null,
      scanResult: map['scanResult'] != null
          ? ScanResultType.fromString(map['scanResult'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CountScanLogsUsecaseParams.fromJson(String source) =>
      CountScanLogsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'CountScanLogsUsecaseParams(scanMethod: $scanMethod, scanResult: $scanResult)';

  @override
  List<Object?> get props => [scanMethod, scanResult];
}
