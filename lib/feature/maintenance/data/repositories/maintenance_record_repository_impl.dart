import 'dart:typed_data';

import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/mappers/cursor_mapper.dart';
import 'package:sigma_track/core/mappers/pagination_mapper.dart';
import 'package:sigma_track/core/network/models/api_error_response.dart';
import 'package:sigma_track/feature/maintenance/data/datasources/maintenance_record_remote_datasource.dart';
import 'package:sigma_track/feature/maintenance/data/mapper/maintenance_record_mappers.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record_statistics.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_record_repository.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/check_maintenance_record_exists_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/count_maintenance_records_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/create_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/delete_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_records_cursor_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_records_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_record_by_id_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/update_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/export_maintenance_record_list_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/bulk_create_maintenance_records_usecase.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_response.dart';

class MaintenanceRecordRepositoryImpl implements MaintenanceRecordRepository {
  final MaintenanceRecordRemoteDatasource _maintenanceRecordRemoteDatasource;

  MaintenanceRecordRepositoryImpl(this._maintenanceRecordRemoteDatasource);

  @override
  Future<Either<Failure, ItemSuccess<MaintenanceRecord>>>
  createMaintenanceRecord(CreateMaintenanceRecordUsecaseParams params) async {
    try {
      final response = await _maintenanceRecordRemoteDatasource
          .createMaintenanceRecord(params);
      final maintenanceRecord = response.data.toEntity();
      return Right(
        ItemSuccess(message: response.message, data: maintenanceRecord),
      );
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
  Future<Either<Failure, OffsetPaginatedSuccess<MaintenanceRecord>>>
  getMaintenanceRecords(GetMaintenanceRecordsUsecaseParams params) async {
    try {
      final response = await _maintenanceRecordRemoteDatasource
          .getMaintenanceRecords(params);
      final maintenanceRecords = response.data
          .map((model) => model.toEntity())
          .toList();
      return Right(
        OffsetPaginatedSuccess(
          message: response.message,
          data: maintenanceRecords,
          pagination: response.pagination.toEntity(),
        ),
      );
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
  Future<Either<Failure, ItemSuccess<MaintenanceRecordStatistics>>>
  getMaintenanceRecordsStatistics() async {
    try {
      final response = await _maintenanceRecordRemoteDatasource
          .getMaintenanceRecordsStatistics();
      final statistics = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: statistics));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CursorPaginatedSuccess<MaintenanceRecord>>>
  getMaintenanceRecordsCursor(
    GetMaintenanceRecordsCursorUsecaseParams params,
  ) async {
    try {
      final response = await _maintenanceRecordRemoteDatasource
          .getMaintenanceRecordsCursor(params);
      final maintenanceRecords = response.data
          .map((model) => model.toEntity())
          .toList();
      return Right(
        CursorPaginatedSuccess(
          message: response.message,
          data: maintenanceRecords,
          cursor: response.cursor.toEntity(),
        ),
      );
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
  Future<Either<Failure, ItemSuccess<int>>> countMaintenanceRecords(
    CountMaintenanceRecordsUsecaseParams params,
  ) async {
    try {
      final response = await _maintenanceRecordRemoteDatasource
          .countMaintenanceRecords(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<bool>>> checkMaintenanceRecordExists(
    CheckMaintenanceRecordExistsUsecaseParams params,
  ) async {
    try {
      final response = await _maintenanceRecordRemoteDatasource
          .checkMaintenanceRecordExists(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<MaintenanceRecord>>>
  getMaintenanceRecordById(GetMaintenanceRecordByIdUsecaseParams params) async {
    try {
      final response = await _maintenanceRecordRemoteDatasource
          .getMaintenanceRecordById(params);
      final maintenanceRecord = response.data.toEntity();
      return Right(
        ItemSuccess(message: response.message, data: maintenanceRecord),
      );
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<MaintenanceRecord>>>
  updateMaintenanceRecord(UpdateMaintenanceRecordUsecaseParams params) async {
    try {
      final response = await _maintenanceRecordRemoteDatasource
          .updateMaintenanceRecord(params);
      final maintenanceRecord = response.data.toEntity();
      return Right(
        ItemSuccess(message: response.message, data: maintenanceRecord),
      );
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
  Future<Either<Failure, ItemSuccess<dynamic>>> deleteMaintenanceRecord(
    DeleteMaintenanceRecordUsecaseParams params,
  ) async {
    try {
      final response = await _maintenanceRecordRemoteDatasource
          .deleteMaintenanceRecord(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Uint8List>>> exportMaintenanceRecordList(
    ExportMaintenanceRecordListUsecaseParams params,
  ) async {
    try {
      final response = await _maintenanceRecordRemoteDatasource
          .exportMaintenanceRecordList(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<BulkCreateMaintenanceRecordsResponse>>>
  createManyMaintenanceRecords(
    BulkCreateMaintenanceRecordsParams params,
  ) async {
    try {
      final response = await _maintenanceRecordRemoteDatasource
          .createManyMaintenanceRecords(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<BulkDeleteResponse>>>
  deleteManyMaintenanceRecords(BulkDeleteParams params) async {
    try {
      final response = await _maintenanceRecordRemoteDatasource
          .deleteManyMaintenanceRecords(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
