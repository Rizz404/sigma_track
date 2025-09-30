import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_record_repository.dart';

class GetMaintenanceRecordByIdUsecase
    implements
        Usecase<
          ItemSuccess<MaintenanceRecord>,
          GetMaintenanceRecordByIdUsecaseParams
        > {
  final MaintenanceRecordRepository _maintenanceRecordRepository;

  GetMaintenanceRecordByIdUsecase(this._maintenanceRecordRepository);

  @override
  Future<Either<Failure, ItemSuccess<MaintenanceRecord>>> call(
    GetMaintenanceRecordByIdUsecaseParams params,
  ) async {
    return await _maintenanceRecordRepository.getMaintenanceRecordById(params);
  }
}

class GetMaintenanceRecordByIdUsecaseParams extends Equatable {
  final String id;

  GetMaintenanceRecordByIdUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
