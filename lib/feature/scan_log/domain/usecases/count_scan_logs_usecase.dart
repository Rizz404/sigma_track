import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/repositories/scan_log_repository.dart';

class CountScanLogsUsecase implements Usecase<ItemSuccess<int>, NoParams> {
  final ScanLogRepository _scanLogRepository;

  CountScanLogsUsecase(this._scanLogRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(NoParams params) async {
    return await _scanLogRepository.countScanLogs();
  }
}
