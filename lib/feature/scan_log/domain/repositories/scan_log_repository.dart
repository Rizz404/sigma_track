import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log_statistics.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/check_scan_log_exists_usecase.dart';

import 'package:sigma_track/feature/scan_log/domain/usecases/create_scan_log_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/delete_scan_log_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_cursor_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_log_by_id_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_by_user_id_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_by_asset_id_usecase.dart';

abstract class ScanLogRepository {
  Future<Either<Failure, ItemSuccess<ScanLog>>> createScanLog(
    CreateScanLogUsecaseParams params,
  );
  Future<Either<Failure, OffsetPaginatedSuccess<ScanLog>>> getScanLogs(
    GetScanLogsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<ScanLogStatistics>>>
  getScanLogsStatistics();
  Future<Either<Failure, CursorPaginatedSuccess<ScanLog>>> getScanLogsCursor(
    GetScanLogsCursorUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<int>>> countScanLogs();
  Future<Either<Failure, OffsetPaginatedSuccess<ScanLog>>> getScanLogsByUserId(
    GetScanLogsByUserIdUsecaseParams params,
  );
  Future<Either<Failure, OffsetPaginatedSuccess<ScanLog>>> getScanLogsByAssetId(
    GetScanLogsByAssetIdUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<bool>>> checkScanLogExists(
    CheckScanLogExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<ScanLog>>> getScanLogById(
    GetScanLogByIdUsecaseParams params,
  );
  Future<Either<Failure, ActionSuccess>> deleteScanLog(
    DeleteScanLogUsecaseParams params,
  );
}
