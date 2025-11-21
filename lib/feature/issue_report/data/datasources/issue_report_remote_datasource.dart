import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:sigma_track/core/constants/api_constant.dart';
import 'package:sigma_track/core/network/dio_client.dart';
import 'package:sigma_track/core/network/models/api_cursor_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_offset_pagination_response.dart';
import 'package:sigma_track/core/network/models/api_response.dart';
import 'package:sigma_track/feature/issue_report/data/models/issue_report_model.dart';
import 'package:sigma_track/feature/issue_report/data/models/issue_report_statistics_model.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/check_issue_report_exists_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/count_issue_reports_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/create_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/delete_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/get_issue_reports_cursor_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/get_issue_reports_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/get_issue_report_by_id_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/reopen_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/resolve_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/update_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/export_issue_report_list_usecase.dart';

abstract class IssueReportRemoteDatasource {
  Future<ApiResponse<IssueReportModel>> createIssueReport(
    CreateIssueReportUsecaseParams params,
  );
  Future<ApiOffsetPaginationResponse<IssueReportModel>> getIssueReports(
    GetIssueReportsUsecaseParams params,
  );
  Future<ApiResponse<IssueReportStatisticsModel>> getIssueReportsStatistics();
  Future<ApiCursorPaginationResponse<IssueReportModel>> getIssueReportsCursor(
    GetIssueReportsCursorUsecaseParams params,
  );
  Future<ApiResponse<int>> countIssueReports(
    CountIssueReportsUsecaseParams params,
  );
  Future<ApiResponse<bool>> checkIssueReportExists(
    CheckIssueReportExistsUsecaseParams params,
  );
  Future<ApiResponse<IssueReportModel>> getIssueReportById(
    GetIssueReportByIdUsecaseParams params,
  );
  Future<ApiResponse<IssueReportModel>> updateIssueReport(
    UpdateIssueReportUsecaseParams params,
  );
  Future<ApiResponse<IssueReportModel>> resolveIssueReport(
    ResolveIssueReportUsecaseParams params,
  );
  Future<ApiResponse<IssueReportModel>> reopenIssueReport(
    ReopenIssueReportUsecaseParams params,
  );
  Future<ApiResponse<dynamic>> deleteIssueReport(
    DeleteIssueReportUsecaseParams params,
  );
  Future<ApiResponse<Uint8List>> exportIssueReportList(
    ExportIssueReportListUsecaseParams params,
  );
}

class IssueReportRemoteDatasourceImpl implements IssueReportRemoteDatasource {
  final DioClient _dioClient;

  IssueReportRemoteDatasourceImpl(this._dioClient);

  @override
  Future<ApiResponse<IssueReportModel>> createIssueReport(
    CreateIssueReportUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.post(
        ApiConstant.createIssueReport,
        data: params.toMap(),
        fromJson: (json) => IssueReportModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiOffsetPaginationResponse<IssueReportModel>> getIssueReports(
    GetIssueReportsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithOffset(
        ApiConstant.getIssueReports,
        queryParameters: params.toMap(),
        fromJson: (json) => IssueReportModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<IssueReportStatisticsModel>>
  getIssueReportsStatistics() async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getIssueReportsStatistics,
        fromJson: (json) => IssueReportStatisticsModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiCursorPaginationResponse<IssueReportModel>> getIssueReportsCursor(
    GetIssueReportsCursorUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.getWithCursor(
        ApiConstant.getIssueReportsCursor,
        queryParameters: params.toMap(),
        fromJson: (json) => IssueReportModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<int>> countIssueReports(
    CountIssueReportsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.countIssueReports,
        queryParameters: params.toMap(),
        fromJson: (json) => json as int,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<bool>> checkIssueReportExists(
    CheckIssueReportExistsUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.checkIssueReportExists(params.id),
        fromJson: (json) => json as bool,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<IssueReportModel>> getIssueReportById(
    GetIssueReportByIdUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.get(
        ApiConstant.getIssueReportById(params.id),
        fromJson: (json) => IssueReportModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<IssueReportModel>> updateIssueReport(
    UpdateIssueReportUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.patch(
        ApiConstant.updateIssueReport(params.id),
        data: params.toMap(),
        fromJson: (json) => IssueReportModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<IssueReportModel>> resolveIssueReport(
    ResolveIssueReportUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.patch(
        ApiConstant.resolveIssueReport(params.id),
        data: params.toMap(),
        fromJson: (json) => IssueReportModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<IssueReportModel>> reopenIssueReport(
    ReopenIssueReportUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.patch(
        ApiConstant.reopenIssueReport(params.id),
        fromJson: (json) => IssueReportModel.fromMap(json),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<dynamic>> deleteIssueReport(
    DeleteIssueReportUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.delete(
        ApiConstant.deleteIssueReport(params.id),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ApiResponse<Uint8List>> exportIssueReportList(
    ExportIssueReportListUsecaseParams params,
  ) async {
    try {
      final response = await _dioClient.postForBinary(
        ApiConstant.exportIssueReportList,
        data: params.toMap(),
        options: dio.Options(responseType: dio.ResponseType.bytes),
        fromData: (data) => data as Uint8List,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
