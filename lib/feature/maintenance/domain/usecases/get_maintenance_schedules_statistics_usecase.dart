import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule_statistics.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_schedule_repository.dart';

class GetMaintenanceSchedulesStatisticsUsecase
    implements Usecase<ItemSuccess<MaintenanceScheduleStatistics>, NoParams> {
  final MaintenanceScheduleRepository _maintenanceScheduleRepository;

  GetMaintenanceSchedulesStatisticsUsecase(this._maintenanceScheduleRepository);

  @override
  Future<Either<Failure, ItemSuccess<MaintenanceScheduleStatistics>>> call(
    NoParams params,
  ) async {
    return await _maintenanceScheduleRepository
        .getMaintenanceSchedulesStatistics();
  }
}
