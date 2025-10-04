import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/network/models/api_cursor_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_offset_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/feature/scan_log/data/models/scan_log_model.dart';
import 'package:sigma_track/feature/scan_log/data/models/scan_log_statistics_model.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/check_scan_log_exists_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/count_scan_logs_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/create_scan_log_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/delete_scan_log_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_cursor_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_log_by_id_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_by_user_id_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_by_asset_id_usecase.dart';

abstract class ScanLogRemoteDatasource {
  Future<ApiResponse<ScanLogModel>> createScanLog(
    CreateScanLogUsecaseParams params,
  );
  Future<ApiOffsetPaginationResponse<ScanLogModel>> getScanLogs(
    GetScanLogsUsecaseParams params,
  );
  Future<ApiResponse<ScanLogStatisticsModel>> getScanLogsStatistics();
  Future<ApiCursorPaginationResponse<ScanLogModel>> getScanLogsCursor(
    GetScanLogsCursorUsecaseParams params,
  );
  Future<ApiResponse<int>> countScanLogs(CountScanLogsUsecaseParams params);
  Future<ApiOffsetPaginationResponse<ScanLogModel>> getScanLogsByUserId(
    GetScanLogsByUserIdUsecaseParams params,
  );
  Future<ApiOffsetPaginationResponse<ScanLogModel>> getScanLogsByAssetId(
    GetScanLogsByAssetIdUsecaseParams params,
  );
  Future<ApiResponse<bool>> checkScanLogExists(
    CheckScanLogExistsUsecaseParams params,
  );
  Future<ApiResponse<ScanLogModel>> getScanLogById(
    GetScanLogByIdUsecaseParams params,
  );
  Future<ApiResponse<dynamic>> deleteScanLog(DeleteScanLogUsecaseParams params);
}

class ScanLogRemoteDatasourceImpl implements ScanLogRemoteDatasource {
  final DioClient _dioClient;

  ScanLogRemoteDatasourceImpl(this._dioClient);

  @override
  Future<ApiResponse<ScanLogModel>> createScanLog(
    CreateScanLogUsecaseParams params,
  ) async {
    this.logData('createScanLog called');
    try {
      final response = await _dioClient.post(
        ApiConstant.createScanLog,
        data: params.toMap(),
        fromJson: (json) => ScanLogModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiOffsetPaginationResponse<ScanLogModel>> getScanLogs(
    GetScanLogsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithOffset(
        ApiConstant.getScanLogs,
        queryParameters: params.toMap(),
        fromJson: (json) => ScanLogModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<ScanLogStatisticsModel>> getScanLogsStatistics() async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getScanLogsStatistics,
        fromJson: (json) => ScanLogStatisticsModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiCursorPaginationResponse<ScanLogModel>> getScanLogsCursor(
    GetScanLogsCursorUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithCursor(
        ApiConstant.getScanLogsCursor,
        queryParameters: params.toMap(),
        fromJson: (json) => ScanLogModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<int>> countScanLogs(
    CountScanLogsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.countScanLogs,
        queryParameters: params.toMap(),
        fromJson: (json) => json as int,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiOffsetPaginationResponse<ScanLogModel>> getScanLogsByUserId(
    GetScanLogsByUserIdUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithOffset(
        ApiConstant.getScanLogsByUserId(params.userId),
        queryParameters: params.toMap(),
        fromJson: (json) => ScanLogModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiOffsetPaginationResponse<ScanLogModel>> getScanLogsByAssetId(
    GetScanLogsByAssetIdUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithOffset(
        ApiConstant.getScanLogsByAssetId(params.assetId),
        queryParameters: params.toMap(),
        fromJson: (json) => ScanLogModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkScanLogExists(
    CheckScanLogExistsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.checkScanLogExists(params.id),
        fromJson: (json) => json as bool,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<ScanLogModel>> getScanLogById(
    GetScanLogByIdUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getScanLogById(params.id),
        fromJson: (json) => ScanLogModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<dynamic>> deleteScanLog(
    DeleteScanLogUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.delete(
        ApiConstant.deleteScanLog(params.id),
        fromJson: (json) => json,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
