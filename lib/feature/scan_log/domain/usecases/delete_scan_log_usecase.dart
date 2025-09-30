import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/repositories/scan_log_repository.dart';

class DeleteScanLogUsecase
    implements Usecase<ActionSuccess, DeleteScanLogUsecaseParams> {
  final ScanLogRepository _scanLogRepository;

  DeleteScanLogUsecase(this._scanLogRepository);

  @override
  Future<Either<Failure, ActionSuccess>> call(
    DeleteScanLogUsecaseParams params,
  ) async {
    return await _scanLogRepository.deleteScanLog(params);
  }
}

class DeleteScanLogUsecaseParams extends Equatable {
  final String id;

  DeleteScanLogUsecaseParams({required this.id});

  Map<String, dynamic> toMap() {
    return {'id': id};
  }

  factory DeleteScanLogUsecaseParams.fromMap(Map<String, dynamic> map) {
    return DeleteScanLogUsecaseParams(id: map['id'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory DeleteScanLogUsecaseParams.fromJson(String source) =>
      DeleteScanLogUsecaseParams.fromMap(json.decode(source));

  DeleteScanLogUsecaseParams copyWith({String? id}) {
    return DeleteScanLogUsecaseParams(id: id ?? this.id);
  }

  @override
  List<Object> get props => [id];
}
