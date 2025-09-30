import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log_statistics.dart';
import 'package:sigma_track/feature/scan_log/domain/repositories/scan_log_repository.dart';

class GetScanLogsStatisticsUsecase
    implements Usecase<ItemSuccess<ScanLogStatistics>, NoParams> {
  final ScanLogRepository _scanLogRepository;

  GetScanLogsStatisticsUsecase(this._scanLogRepository);

  @override
  Future<Either<Failure, ItemSuccess<ScanLogStatistics>>> call(
    NoParams params,
  ) async {
    return await _scanLogRepository.getScanLogsStatistics();
  }
}
