import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record_statistics.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_record_repository.dart';

class GetMaintenanceRecordsStatisticsUsecase
    implements Usecase<ItemSuccess<MaintenanceRecordStatistics>, NoParams> {
  final MaintenanceRecordRepository _maintenanceRecordRepository;

  GetMaintenanceRecordsStatisticsUsecase(this._maintenanceRecordRepository);

  @override
  Future<Either<Failure, ItemSuccess<MaintenanceRecordStatistics>>> call(
    NoParams params,
  ) async {
    return await _maintenanceRecordRepository.getMaintenanceRecordsStatistics();
  }
}
