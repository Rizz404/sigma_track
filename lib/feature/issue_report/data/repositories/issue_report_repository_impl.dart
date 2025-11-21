import 'dart:typed_data';

import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/mappers/cursor_mapper.dart';
import 'package:sigma_track/core/mappers/pagination_mapper.dart';
import 'package:sigma_track/core/network/models/api_error_response.dart';
import 'package:sigma_track/feature/issue_report/data/datasources/issue_report_remote_datasource.dart';
import 'package:sigma_track/feature/issue_report/data/mapper/issue_report_mappers.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report_statistics.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';
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

class IssueReportRepositoryImpl implements IssueReportRepository {
  final IssueReportRemoteDatasource _issueReportRemoteDatasource;

  IssueReportRepositoryImpl(this._issueReportRemoteDatasource);

  @override
  Future<Either<Failure, ItemSuccess<IssueReport>>> createIssueReport(
    CreateIssueReportUsecaseParams params,
  ) async {
    try {
      final response = await _issueReportRemoteDatasource.createIssueReport(
        params,
      );
      final issueReport = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: issueReport));
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
      } else {
        return Left(ServerFailure(message: apiError.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OffsetPaginatedSuccess<IssueReport>>> getIssueReports(
    GetIssueReportsUsecaseParams params,
  ) async {
    try {
      final response = await _issueReportRemoteDatasource.getIssueReports(
        params,
      );
      final issueReports = response.data
          .map((model) => model.toEntity())
          .toList();
      final pagination = response.pagination.toEntity();
      return Right(
        OffsetPaginatedSuccess(
          message: response.message,
          data: issueReports,
          pagination: pagination,
        ),
      );
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<IssueReportStatistics>>>
  getIssueReportsStatistics() async {
    try {
      final response = await _issueReportRemoteDatasource
          .getIssueReportsStatistics();
      final statistics = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: statistics));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CursorPaginatedSuccess<IssueReport>>>
  getIssueReportsCursor(GetIssueReportsCursorUsecaseParams params) async {
    try {
      final response = await _issueReportRemoteDatasource.getIssueReportsCursor(
        params,
      );
      final issueReports = response.data
          .map((model) => model.toEntity())
          .toList();
      final cursor = response.cursor.toEntity();
      return Right(
        CursorPaginatedSuccess(
          message: response.message,
          data: issueReports,
          cursor: cursor,
        ),
      );
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<int>>> countIssueReports(
    CountIssueReportsUsecaseParams params,
  ) async {
    try {
      final response = await _issueReportRemoteDatasource.countIssueReports(
        params,
      );
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<bool>>> checkIssueReportExists(
    CheckIssueReportExistsUsecaseParams params,
  ) async {
    try {
      final response = await _issueReportRemoteDatasource
          .checkIssueReportExists(params);
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<IssueReport>>> getIssueReportById(
    GetIssueReportByIdUsecaseParams params,
  ) async {
    try {
      final response = await _issueReportRemoteDatasource.getIssueReportById(
        params,
      );
      final issueReport = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: issueReport));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<IssueReport>>> updateIssueReport(
    UpdateIssueReportUsecaseParams params,
  ) async {
    try {
      final response = await _issueReportRemoteDatasource.updateIssueReport(
        params,
      );
      final issueReport = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: issueReport));
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
      } else {
        return Left(ServerFailure(message: apiError.message));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<IssueReport>>> resolveIssueReport(
    ResolveIssueReportUsecaseParams params,
  ) async {
    try {
      final response = await _issueReportRemoteDatasource.resolveIssueReport(
        params,
      );
      final issueReport = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: issueReport));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<IssueReport>>> reopenIssueReport(
    ReopenIssueReportUsecaseParams params,
  ) async {
    try {
      final response = await _issueReportRemoteDatasource.reopenIssueReport(
        params,
      );
      final issueReport = response.data.toEntity();
      return Right(ItemSuccess(message: response.message, data: issueReport));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> deleteIssueReport(
    DeleteIssueReportUsecaseParams params,
  ) async {
    try {
      final response = await _issueReportRemoteDatasource.deleteIssueReport(
        params,
      );
      return Right(ActionSuccess(message: response.message));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemSuccess<Uint8List>>> exportIssueReportList(
    ExportIssueReportListUsecaseParams params,
  ) async {
    try {
      final response = await _issueReportRemoteDatasource.exportIssueReportList(
        params,
      );
      return Right(ItemSuccess(message: response.message, data: response.data));
    } on ApiErrorResponse catch (apiError) {
      return Left(ServerFailure(message: apiError.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
