import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/repositories/scan_log_repository.dart';

class CheckScanLogExistsUsecase
    implements Usecase<ItemSuccess<bool>, CheckScanLogExistsUsecaseParams> {
  final ScanLogRepository _scanLogRepository;

  CheckScanLogExistsUsecase(this._scanLogRepository);

  @override
  Future<Either<Failure, ItemSuccess<bool>>> call(
    CheckScanLogExistsUsecaseParams params,
  ) async {
    return await _scanLogRepository.checkScanLogExists(params);
  }
}

class CheckScanLogExistsUsecaseParams extends Equatable {
  final String id;

  CheckScanLogExistsUsecaseParams({required this.id});

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory CheckScanLogExistsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CheckScanLogExistsUsecaseParams(id: map['id'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory CheckScanLogExistsUsecaseParams.fromJson(String source) =>
      CheckScanLogExistsUsecaseParams.fromMap(json.decode(source));

  CheckScanLogExistsUsecaseParams copyWith({String? id}) {
    return CheckScanLogExistsUsecaseParams(id: id ?? this.id);
  }

  @override
  List<Object> get props => [id];
}
