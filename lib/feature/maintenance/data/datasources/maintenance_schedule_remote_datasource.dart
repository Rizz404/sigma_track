import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/network/models/api_cursor_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_offset_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/feature/maintenance/data/models/maintenance_schedule_model.dart';
import 'package:sigma_track/feature/maintenance/data/models/maintenance_schedule_statistics_model.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/check_maintenance_schedule_exists_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/count_maintenance_schedules_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/create_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/delete_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedules_cursor_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedules_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedule_by_id_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/update_maintenance_schedule_usecase.dart';

abstract class MaintenanceScheduleRemoteDatasource {
  Future<ApiResponse<MaintenanceScheduleModel>> createMaintenanceSchedule(
    CreateMaintenanceScheduleUsecaseParams params,
  );
  Future<ApiOffsetPaginationResponse<MaintenanceScheduleModel>>
  getMaintenanceSchedules(GetMaintenanceSchedulesUsecaseParams params);
  Future<ApiResponse<MaintenanceScheduleStatisticsModel>>
  getMaintenanceSchedulesStatistics();
  Future<ApiCursorPaginationResponse<MaintenanceScheduleModel>>
  getMaintenanceSchedulesCursor(
    GetMaintenanceSchedulesCursorUsecaseParams params,
  );
  Future<ApiResponse<int>> countMaintenanceSchedules(
    CountMaintenanceSchedulesUsecaseParams params,
  );
  Future<ApiResponse<bool>> checkMaintenanceScheduleExists(
    CheckMaintenanceScheduleExistsUsecaseParams params,
  );
  Future<ApiResponse<MaintenanceScheduleModel>> getMaintenanceScheduleById(
    GetMaintenanceScheduleByIdUsecaseParams params,
  );
  Future<ApiResponse<MaintenanceScheduleModel>> updateMaintenanceSchedule(
    UpdateMaintenanceScheduleUsecaseParams params,
  );
  Future<ApiResponse<dynamic>> deleteMaintenanceSchedule(
    DeleteMaintenanceScheduleUsecaseParams params,
  );
}

class MaintenanceScheduleRemoteDatasourceImpl
    implements MaintenanceScheduleRemoteDatasource {
  final DioClient _dioClient;

  MaintenanceScheduleRemoteDatasourceImpl(this._dioClient);

  @override
  Future<ApiResponse<MaintenanceScheduleModel>> createMaintenanceSchedule(
    CreateMaintenanceScheduleUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.createMaintenanceSchedule,
        data: params.toMap(),
        fromJson: (json) => MaintenanceScheduleModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiOffsetPaginationResponse<MaintenanceScheduleModel>>
  getMaintenanceSchedules(GetMaintenanceSchedulesUsecaseParams params) async {
    try {
      final response = await _dioClient.getWithOffset(
        ApiConstant.getMaintenanceSchedules,
        queryParameters: params.toMap(),
        fromJson: (json) => MaintenanceScheduleModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<MaintenanceScheduleStatisticsModel>>
  getMaintenanceSchedulesStatistics() async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getMaintenanceSchedulesStatistics,
        fromJson: (json) => MaintenanceScheduleStatisticsModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiCursorPaginationResponse<MaintenanceScheduleModel>>
  getMaintenanceSchedulesCursor(
    GetMaintenanceSchedulesCursorUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithCursor(
        ApiConstant.getMaintenanceSchedulesCursor,
        queryParameters: params.toMap(),
        fromJson: (json) => MaintenanceScheduleModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<int>> countMaintenanceSchedules(
    CountMaintenanceSchedulesUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.countMaintenanceSchedules,
        fromJson: (json) => json as int,
        queryParameters: params.toMap(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkMaintenanceScheduleExists(
    CheckMaintenanceScheduleExistsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.checkMaintenanceScheduleExists(params.id),
        fromJson: (json) => json as bool,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<MaintenanceScheduleModel>> getMaintenanceScheduleById(
    GetMaintenanceScheduleByIdUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getMaintenanceScheduleById(params.id),
        fromJson: (json) => MaintenanceScheduleModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<MaintenanceScheduleModel>> updateMaintenanceSchedule(
    UpdateMaintenanceScheduleUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.put(
        ApiConstant.updateMaintenanceSchedule(params.id),
        data: params.toMap(),
        fromJson: (json) => MaintenanceScheduleModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<dynamic>> deleteMaintenanceSchedule(
    DeleteMaintenanceScheduleUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.delete(
        ApiConstant.deleteMaintenanceSchedule(params.id),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
