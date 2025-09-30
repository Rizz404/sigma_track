import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_record_repository.dart';

class CountMaintenanceRecordsUsecase
    implements Usecase<ItemSuccess<int>, NoParams> {
  final MaintenanceRecordRepository _maintenanceRecordRepository;

  CountMaintenanceRecordsUsecase(this._maintenanceRecordRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(NoParams params) async {
    return await _maintenanceRecordRepository.countMaintenanceRecords();
  }
}
