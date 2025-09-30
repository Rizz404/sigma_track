import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/mappers/cursor_mapper.dart';
import 'package:sigma_track/core/mappers/pagination_mapper.dart';
import 'package:sigma_track/core/network/models/api_error_response.dart';
import 'package:sigma_track/feature/maintenance/data/datasources/maintenance_schedule_remote_datasource.dart';
import 'package:sigma_track/feature/maintenance/data/mapper/maintenance_schedule_mappers.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule.dart';
import 'package:sigma_track/feature/maintenance/domain/entities/maintenance_schedule_statistics.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_schedule_repository.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/check_maintenance_schedule_exists_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/create_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/delete_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedules_cursor_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedules_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedule_by_id_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/update_maintenance_schedule_usecase.dart';

class MaintenanceScheduleRepositoryImpl
    implements MaintenanceScheduleRepository {
  final MaintenanceScheduleRemoteDatasource
  _maintenanceScheduleRemoteDatasource;

  MaintenanceScheduleRepositoryImpl(this._maintenanceScheduleRemoteDatasource);

  @override
  Future<Either<Failure, ItemSuccess<MaintenanceSchedule>>>
  createMaintenanceSchedule(
    CreateMaintenanceScheduleUsecaseParams params,
  ) async {
    try {
      final response = await _maintenanceScheduleRemoteDatasource
          .createMaintenanceSchedule(params);
      final maintenanceSchedule = response.data.toEntity();
      return Right(
        ItemSuccess(message: response.message, data: maintenanceSchedule),
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
  Future<Either<Failure, OffsetPaginatedSuccess<MaintenanceSchedule>>>
  getMaintenanceSchedules(GetMaintenanceSchedulesUsecaseParams params) async {
    try {
      final response = await _maintenanceScheduleRemoteDatasource
          .getMaintenanceSchedules(params);
      final maintenanceSchedules = response.data
          .map((model) => model.toEntity())
          .toList();
      return Right(
        OffsetPaginatedSuccess(
          message: response.message,
          data: maintenanceSchedules,
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
  Future<Either<Failure, ItemSuccess<MaintenanceScheduleStatistics>>>
  getMaintenanceSchedulesStatistics() async {
    try {
      final response = await _maintenanceScheduleRemoteDatasource
          .getMaintenanceSchedulesStatistics();
      final statistics = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: statistics));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CursorPaginatedSuccess<MaintenanceSchedule>>>
  getMaintenanceSchedulesCursor(
    GetMaintenanceSchedulesCursorUsecaseParams params,
  ) async {
    try {
      final response = await _maintenanceScheduleRemoteDatasource
          .getMaintenanceSchedulesCursor(params);
      final maintenanceSchedules = response.data
          .map((model) => model.toEntity())
          .toList();
      return Right(
        CursorPaginatedSuccess(
          message: response.message,
          data: maintenanceSchedules,
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
  Future<Either<Failure, ItemSuccess<int>>> countMaintenanceSchedules() async {
    try {
      final response = await _maintenanceScheduleRemoteDatasource
          .countMaintenanceSchedules();
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<bool>>> checkMaintenanceScheduleExists(
    CheckMaintenanceScheduleExistsUsecaseParams params,
  ) async {
    try {
      final response = await _maintenanceScheduleRemoteDatasource
          .checkMaintenanceScheduleExists(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<MaintenanceSchedule>>>
  getMaintenanceScheduleById(
    GetMaintenanceScheduleByIdUsecaseParams params,
  ) async {
    try {
      final response = await _maintenanceScheduleRemoteDatasource
          .getMaintenanceScheduleById(params);
      final maintenanceSchedule = response.data.toEntity();
      return Right(
        ItemSuccess(message: response.message, data: maintenanceSchedule),
      );
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<MaintenanceSchedule>>>
  updateMaintenanceSchedule(
    UpdateMaintenanceScheduleUsecaseParams params,
  ) async {
    try {
      final response = await _maintenanceScheduleRemoteDatasource
          .updateMaintenanceSchedule(params);
      final maintenanceSchedule = response.data.toEntity();
      return Right(
        ItemSuccess(message: response.message, data: maintenanceSchedule),
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
  Future<Either<Failure, ItemSuccess<dynamic>>> deleteMaintenanceSchedule(
    DeleteMaintenanceScheduleUsecaseParams params,
  ) async {
    try {
      final response = await _maintenanceScheduleRemoteDatasource
          .deleteMaintenanceSchedule(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(NetworkFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
