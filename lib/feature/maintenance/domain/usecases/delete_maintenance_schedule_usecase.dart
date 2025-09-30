import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_schedule_repository.dart';

class DeleteMaintenanceScheduleUsecase
    implements
        Usecase<ItemSuccess<dynamic>, DeleteMaintenanceScheduleUsecaseParams> {
  final MaintenanceScheduleRepository _maintenanceScheduleRepository;

  DeleteMaintenanceScheduleUsecase(this._maintenanceScheduleRepository);

  @override
  Future<Either<Failure, ItemSuccess<dynamic>>> call(
    DeleteMaintenanceScheduleUsecaseParams params,
  ) async {
    return await _maintenanceScheduleRepository.deleteMaintenanceSchedule(
      params,
    );
  }
}

class DeleteMaintenanceScheduleUsecaseParams extends Equatable {
  final String id;

  DeleteMaintenanceScheduleUsecaseParams({required this.id});

  @override
  List<Object> get props => [id];
}
