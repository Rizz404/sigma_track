import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_schedule_repository.dart';

class CountMaintenanceSchedulesUsecase
    implements Usecase<ItemSuccess<int>, NoParams> {
  final MaintenanceScheduleRepository _maintenanceScheduleRepository;

  CountMaintenanceSchedulesUsecase(this._maintenanceScheduleRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(NoParams params) async {
    return await _maintenanceScheduleRepository.countMaintenanceSchedules();
  }
}
