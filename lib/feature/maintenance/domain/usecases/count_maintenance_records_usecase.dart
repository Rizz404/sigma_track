import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_record_repository.dart';

class CountMaintenanceRecordsUsecase
    implements Usecase<ItemSuccess<int>, CountMaintenanceRecordsUsecaseParams> {
  final MaintenanceRecordRepository _maintenanceRecordRepository;

  CountMaintenanceRecordsUsecase(this._maintenanceRecordRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(
    CountMaintenanceRecordsUsecaseParams params,
  ) async {
    return await _maintenanceRecordRepository.countMaintenanceRecords(params);
  }
}

class CountMaintenanceRecordsUsecaseParams extends Equatable {
  final String? assetId;
  final String? performedByUser;

  const CountMaintenanceRecordsUsecaseParams({
    this.assetId,
    this.performedByUser,
  });

  CountMaintenanceRecordsUsecaseParams copyWith({
    String? assetId,
    String? performedByUser,
  }) {
    return CountMaintenanceRecordsUsecaseParams(
      assetId: assetId ?? this.assetId,
      performedByUser: performedByUser ?? this.performedByUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (assetId != null) 'assetId': assetId,
      if (performedByUser != null) 'performedByUser': performedByUser,
    };
  }

  factory CountMaintenanceRecordsUsecaseParams.fromMap(
    Map<String, dynamic> map,
  ) {
    return CountMaintenanceRecordsUsecaseParams(
      assetId: map['assetId'],
      performedByUser: map['performedByUser'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CountMaintenanceRecordsUsecaseParams.fromJson(String source) =>
      CountMaintenanceRecordsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'CountMaintenanceRecordsUsecaseParams(assetId: $assetId, performedByUser: $performedByUser)';

  @override
  List<Object?> get props => [assetId, performedByUser];
}
