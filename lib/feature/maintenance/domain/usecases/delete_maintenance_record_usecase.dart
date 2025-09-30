import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_record_repository.dart';

class DeleteMaintenanceRecordUsecase
    implements
        Usecase<ItemSuccess<dynamic>, DeleteMaintenanceRecordUsecaseParams> {
  final MaintenanceRecordRepository _maintenanceRecordRepository;

  DeleteMaintenanceRecordUsecase(this._maintenanceRecordRepository);

  @override
  Future<Either<Failure, ItemSuccess<dynamic>>> call(
    DeleteMaintenanceRecordUsecaseParams params,
  ) async {
    return await _maintenanceRecordRepository.deleteMaintenanceRecord(params);
  }
}

class DeleteMaintenanceRecordUsecaseParams extends Equatable {
  final String id;

  DeleteMaintenanceRecordUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
