import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_schedule_repository.dart';

class GetMaintenanceScheduleByIdUsecase
    implements
        Usecase<
          ItemSuccess<MaintenanceSchedule>,
          GetMaintenanceScheduleByIdUsecaseParams
        > {
  final MaintenanceScheduleRepository _maintenanceScheduleRepository;

  GetMaintenanceScheduleByIdUsecase(this._maintenanceScheduleRepository);

  @override
  Future<Either<Failure, ItemSuccess<MaintenanceSchedule>>> call(
    GetMaintenanceScheduleByIdUsecaseParams params,
  ) async {
    return await _maintenanceScheduleRepository.getMaintenanceScheduleById(
      params,
    );
  }
}

class GetMaintenanceScheduleByIdUsecaseParams extends Equatable {
  final String id;

  GetMaintenanceScheduleByIdUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
