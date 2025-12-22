import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/repositories/scan_log_repository.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_response.dart';

class BulkDeleteScanLogsUsecase
    implements Usecase<ItemSuccess<BulkDeleteResponse>, BulkDeleteParams> {
  final ScanLogRepository _scanLogRepository;

  BulkDeleteScanLogsUsecase(this._scanLogRepository);

  @override
  Future<Either<Failure, ItemSuccess<BulkDeleteResponse>>> call(
    BulkDeleteParams params,
  ) async {
    return await _scanLogRepository.deleteManyScanLogs(params);
  }
}
