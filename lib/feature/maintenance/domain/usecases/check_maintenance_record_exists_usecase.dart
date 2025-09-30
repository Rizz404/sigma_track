import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_record_repository.dart';

class CheckMaintenanceRecordExistsUsecase
    implements
        Usecase<ItemSuccess<bool>, CheckMaintenanceRecordExistsUsecaseParams> {
  final MaintenanceRecordRepository _maintenanceRecordRepository;

  CheckMaintenanceRecordExistsUsecase(this._maintenanceRecordRepository);

  @override
  Future<Either<Failure, ItemSuccess<bool>>> call(
    CheckMaintenanceRecordExistsUsecaseParams params,
  ) async {
    return await _maintenanceRecordRepository.checkMaintenanceRecordExists(
      params,
    );
  }
}

class CheckMaintenanceRecordExistsUsecaseParams extends Equatable {
  final String id;

  CheckMaintenanceRecordExistsUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
