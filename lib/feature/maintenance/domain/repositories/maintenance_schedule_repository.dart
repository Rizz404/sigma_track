import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule_statistics.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/check_maintenance_schedule_exists_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/count_maintenance_schedules_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/create_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/delete_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedules_cursor_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedules_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedule_by_id_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/update_maintenance_schedule_usecase.dart';

abstract class MaintenanceScheduleRepository {
  Future<Either<Failure, ItemSuccess<MaintenanceSchedule>>>
  createMaintenanceSchedule(CreateMaintenanceScheduleUsecaseParams params);
  Future<Either<Failure, OffsetPaginatedSuccess<MaintenanceSchedule>>>
  getMaintenanceSchedules(GetMaintenanceSchedulesUsecaseParams params);
  Future<Either<Failure, ItemSuccess<MaintenanceScheduleStatistics>>>
  getMaintenanceSchedulesStatistics();
  Future<Either<Failure, CursorPaginatedSuccess<MaintenanceSchedule>>>
  getMaintenanceSchedulesCursor(
    GetMaintenanceSchedulesCursorUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<int>>> countMaintenanceSchedules(
    CountMaintenanceSchedulesUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<bool>>> checkMaintenanceScheduleExists(
    CheckMaintenanceScheduleExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<MaintenanceSchedule>>>
  getMaintenanceScheduleById(GetMaintenanceScheduleByIdUsecaseParams params);
  Future<Either<Failure, ItemSuccess<MaintenanceSchedule>>>
  updateMaintenanceSchedule(UpdateMaintenanceScheduleUsecaseParams params);
  Future<Either<Failure, ItemSuccess<dynamic>>> deleteMaintenanceSchedule(
    DeleteMaintenanceScheduleUsecaseParams params,
  );
}
