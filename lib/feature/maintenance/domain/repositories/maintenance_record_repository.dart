import 'dart:typed_data';

import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_record_statistics.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/bulk_create_maintenance_records_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/check_maintenance_record_exists_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/count_maintenance_records_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/create_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/delete_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_records_cursor_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_records_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_record_by_id_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/update_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/export_maintenance_record_list_usecase.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_response.dart';

abstract class MaintenanceRecordRepository {
  Future<Either<Failure, ItemSuccess<MaintenanceRecord>>>
  createMaintenanceRecord(CreateMaintenanceRecordUsecaseParams params);
  Future<Either<Failure, OffsetPaginatedSuccess<MaintenanceRecord>>>
  getMaintenanceRecords(GetMaintenanceRecordsUsecaseParams params);
  Future<Either<Failure, ItemSuccess<MaintenanceRecordStatistics>>>
  getMaintenanceRecordsStatistics();
  Future<Either<Failure, CursorPaginatedSuccess<MaintenanceRecord>>>
  getMaintenanceRecordsCursor(GetMaintenanceRecordsCursorUsecaseParams params);
  Future<Either<Failure, ItemSuccess<int>>> countMaintenanceRecords(
    CountMaintenanceRecordsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<bool>>> checkMaintenanceRecordExists(
    CheckMaintenanceRecordExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<MaintenanceRecord>>>
  getMaintenanceRecordById(GetMaintenanceRecordByIdUsecaseParams params);
  Future<Either<Failure, ItemSuccess<MaintenanceRecord>>>
  updateMaintenanceRecord(UpdateMaintenanceRecordUsecaseParams params);
  Future<Either<Failure, ItemSuccess<dynamic>>> deleteMaintenanceRecord(
    DeleteMaintenanceRecordUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<Uint8List>>> exportMaintenanceRecordList(
    ExportMaintenanceRecordListUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<BulkCreateMaintenanceRecordsResponse>>>
  createManyMaintenanceRecords(BulkCreateMaintenanceRecordsParams params);
  Future<Either<Failure, ItemSuccess<BulkDeleteResponse>>>
  deleteManyMaintenanceRecords(BulkDeleteParams params);
}
