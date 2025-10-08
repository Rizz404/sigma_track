import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/network/models/api_cursor_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_offset_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/feature/maintenance/data/models/maintenance_record_model.dart';
import 'package:sigma_track/feature/maintenance/data/models/maintenance_record_statistics_model.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/check_maintenance_record_exists_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/count_maintenance_records_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/create_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/delete_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_records_cursor_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_records_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_record_by_id_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/update_maintenance_record_usecase.dart';

abstract class MaintenanceRecordRemoteDatasource {
  Future<ApiResponse<MaintenanceRecordModel>> createMaintenanceRecord(
    CreateMaintenanceRecordUsecaseParams params,
  );
  Future<ApiOffsetPaginationResponse<MaintenanceRecordModel>>
  getMaintenanceRecords(GetMaintenanceRecordsUsecaseParams params);
  Future<ApiResponse<MaintenanceRecordStatisticsModel>>
  getMaintenanceRecordsStatistics();
  Future<ApiCursorPaginationResponse<MaintenanceRecordModel>>
  getMaintenanceRecordsCursor(GetMaintenanceRecordsCursorUsecaseParams params);
  Future<ApiResponse<int>> countMaintenanceRecords(
    CountMaintenanceRecordsUsecaseParams params,
  );
  Future<ApiResponse<bool>> checkMaintenanceRecordExists(
    CheckMaintenanceRecordExistsUsecaseParams params,
  );
  Future<ApiResponse<MaintenanceRecordModel>> getMaintenanceRecordById(
    GetMaintenanceRecordByIdUsecaseParams params,
  );
  Future<ApiResponse<MaintenanceRecordModel>> updateMaintenanceRecord(
    UpdateMaintenanceRecordUsecaseParams params,
  );
  Future<ApiResponse<dynamic>> deleteMaintenanceRecord(
    DeleteMaintenanceRecordUsecaseParams params,
  );
}

class MaintenanceRecordRemoteDatasourceImpl
    implements MaintenanceRecordRemoteDatasource {
  final DioClient _dioClient;

  MaintenanceRecordRemoteDatasourceImpl(this._dioClient);

  @override
  Future<ApiResponse<MaintenanceRecordModel>> createMaintenanceRecord(
    CreateMaintenanceRecordUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.createMaintenanceRecord,
        data: params.toMap(),
        fromJson: (json) => MaintenanceRecordModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiOffsetPaginationResponse<MaintenanceRecordModel>>
  getMaintenanceRecords(GetMaintenanceRecordsUsecaseParams params) async {
    try {
      final response = await _dioClient.getWithOffset(
        ApiConstant.getMaintenanceRecords,
        queryParameters: params.toMap(),
        fromJson: (json) => MaintenanceRecordModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<MaintenanceRecordStatisticsModel>>
  getMaintenanceRecordsStatistics() async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getMaintenanceRecordsStatistics,
        fromJson: (json) => MaintenanceRecordStatisticsModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiCursorPaginationResponse<MaintenanceRecordModel>>
  getMaintenanceRecordsCursor(
    GetMaintenanceRecordsCursorUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithCursor(
        ApiConstant.getMaintenanceRecordsCursor,
        queryParameters: params.toMap(),
        fromJson: (json) => MaintenanceRecordModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<int>> countMaintenanceRecords(
    CountMaintenanceRecordsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.countMaintenanceRecords,
        fromJson: (json) => json as int,
        queryParameters: params.toMap(),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkMaintenanceRecordExists(
    CheckMaintenanceRecordExistsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.checkMaintenanceRecordExists(params.id),
        fromJson: (json) => json as bool,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<MaintenanceRecordModel>> getMaintenanceRecordById(
    GetMaintenanceRecordByIdUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getMaintenanceRecordById(params.id),
        fromJson: (json) => MaintenanceRecordModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<MaintenanceRecordModel>> updateMaintenanceRecord(
    UpdateMaintenanceRecordUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.patch(
        ApiConstant.updateMaintenanceRecord(params.id),
        data: params.toMap(),
        fromJson: (json) => MaintenanceRecordModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<dynamic>> deleteMaintenanceRecord(
    DeleteMaintenanceRecordUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.delete(
        ApiConstant.deleteMaintenanceRecord(params.id),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
