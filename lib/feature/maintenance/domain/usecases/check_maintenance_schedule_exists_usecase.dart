import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_schedule_repository.dart';

class CheckMaintenanceScheduleExistsUsecase
    implements
        Usecase<
          ItemSuccess<bool>,
          CheckMaintenanceScheduleExistsUsecaseParams
        > {
  final MaintenanceScheduleRepository _maintenanceScheduleRepository;

  CheckMaintenanceScheduleExistsUsecase(this._maintenanceScheduleRepository);

  @override
  Future<Either<Failure, ItemSuccess<bool>>> call(
    CheckMaintenanceScheduleExistsUsecaseParams params,
  ) async {
    return await _maintenanceScheduleRepository.checkMaintenanceScheduleExists(
      params,
    );
  }
}

class CheckMaintenanceScheduleExistsUsecaseParams extends Equatable {
  final String id;

  CheckMaintenanceScheduleExistsUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
