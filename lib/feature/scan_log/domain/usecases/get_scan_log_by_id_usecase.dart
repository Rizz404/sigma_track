import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';
import 'package:sigma_track/feature/scan_log/domain/repositories/scan_log_repository.dart';

class GetScanLogByIdUsecase
    implements Usecase<ItemSuccess<ScanLog>, GetScanLogByIdUsecaseParams> {
  final ScanLogRepository _scanLogRepository;

  GetScanLogByIdUsecase(this._scanLogRepository);

  @override
  Future<Either<Failure, ItemSuccess<ScanLog>>> call(
    GetScanLogByIdUsecaseParams params,
  ) async {
    return await _scanLogRepository.getScanLogById(params);
  }
}

class GetScanLogByIdUsecaseParams extends Equatable {
  final String id;

  GetScanLogByIdUsecaseParams({required this.id});

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory GetScanLogByIdUsecaseParams.fromMap(Map<String, dynamic> map) {
    return GetScanLogByIdUsecaseParams(id: map['id'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory GetScanLogByIdUsecaseParams.fromJson(String source) =>
      GetScanLogByIdUsecaseParams.fromMap(json.decode(source));

  GetScanLogByIdUsecaseParams copyWith({String? id}) {
    return GetScanLogByIdUsecaseParams(id: id ?? this.id);
  }

  @override
  List<Object> get props => [id];
}
