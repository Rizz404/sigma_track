import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/mappers/cursor_mapper.dart';
import 'package:sigma_track/core/mappers/pagination_mapper.dart';
import 'package:sigma_track/core/network/models/api_error_response.dart';
import 'package:sigma_track/feature/scan_log/data/datasources/scan_log_remote_datasource.dart';
import 'package:sigma_track/feature/scan_log/data/mapper/scan_log_mappers.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log_statistics.dart';
import 'package:sigma_track/feature/scan_log/domain/repositories/scan_log_repository.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/check_scan_log_exists_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/count_scan_logs_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/create_scan_log_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/delete_scan_log_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_cursor_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_log_by_id_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_by_user_id_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_by_asset_id_usecase.dart';

class ScanLogRepositoryImpl implements ScanLogRepository {
  final ScanLogRemoteDatasource _scanLogRemoteDatasource;

  ScanLogRepositoryImpl(this._scanLogRemoteDatasource);

  @override
  Future<Either<Failure, ItemSuccess<ScanLog>>> createScanLog(
    CreateScanLogUsecaseParams params,
  ) async {
    try {
      final response = await _scanLogRemoteDatasource.createScanLog(params);
      final scanLog = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: scanLog));
    } on ApiErrorResponse catch (apiError) {
      if (apiError.errors != null && apiError.errors!.isNotEmpty) {
        return Left(
          ValidationFailure(
            message: apiError.message,
            errors: apiError.errors!
                .map(
                  (e) => ValidationError(
                    field: e.field,
                    tag: e.tag,
                    value: e.value,
                    message: e.message,
                  ),
                )
                .toList(),
          ),
        );
      }
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<ScanLog>>> getScanLogs(
    GetScanLogsUsecaseParams params,
  ) async {
    try {
      final response = await _scanLogRemoteDatasource.getScanLogs(params);
      final scanLogs = response.data.map((e) => e.toEntity()).toList();
      return Right(
        OffsetPaginatedSuccess(
          message: response.message,
          data: scanLogs,
          pagination: response.pagination.toEntity(),
        ),
      );
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<ScanLogStatistics>>>
  getScanLogsStatistics() async {
    try {
      final response = await _scanLogRemoteDatasource.getScanLogsStatistics();
      final statistics = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: statistics));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CursorPaginatedSuccess<ScanLog>>> getScanLogsCursor(
    GetScanLogsCursorUsecaseParams params,
  ) async {
    try {
      final response = await _scanLogRemoteDatasource.getScanLogsCursor(params);
      final scanLogs = response.data.map((e) => e.toEntity()).toList();
      return Right(
        CursorPaginatedSuccess(
          message: response.message,
          data: scanLogs,
          cursor: response.cursor.toEntity(),
        ),
      );
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<int>>> countScanLogs(
    CountScanLogsUsecaseParams params,
  ) async {
    try {
      final response = await _scanLogRemoteDatasource.countScanLogs(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<ScanLog>>> getScanLogsByUserId(
    GetScanLogsByUserIdUsecaseParams params,
  ) async {
    try {
      final response = await _scanLogRemoteDatasource.getScanLogsByUserId(
        params,
      );
      final scanLogs = response.data.map((e) => e.toEntity()).toList();
      return Right(
        OffsetPaginatedSuccess(
          message: response.message,
          data: scanLogs,
          pagination: response.pagination.toEntity(),
        ),
      );
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<ScanLog>>> getScanLogsByAssetId(
    GetScanLogsByAssetIdUsecaseParams params,
  ) async {
    try {
      final response = await _scanLogRemoteDatasource.getScanLogsByAssetId(
        params,
      );
      final scanLogs = response.data.map((e) => e.toEntity()).toList();
      return Right(
        OffsetPaginatedSuccess(
          message: response.message,
          data: scanLogs,
          pagination: response.pagination.toEntity(),
        ),
      );
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<bool>>> checkScanLogExists(
    CheckScanLogExistsUsecaseParams params,
  ) async {
    try {
      final response = await _scanLogRemoteDatasource.checkScanLogExists(
        params,
      );
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<ScanLog>>> getScanLogById(
    GetScanLogByIdUsecaseParams params,
  ) async {
    try {
      final response = await _scanLogRemoteDatasource.getScanLogById(params);
      final scanLog = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: scanLog));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> deleteScanLog(
    DeleteScanLogUsecaseParams params,
  ) async {
    try {
      final response = await _scanLogRemoteDatasource.deleteScanLog(params);
      return Right(ActionSuccess(message: response.message));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
