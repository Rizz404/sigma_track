import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report_statistics.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/bulk_create_issue_reports_usecase.dart';
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
import 'package:sigma_track/shared/domain/entities/bulk_delete_params.dart';
import 'package:sigma_track/shared/domain/entities/bulk_delete_response.dart';

abstract class IssueReportRepository {
  Future<Either<Failure, ItemSuccess<IssueReport>>> createIssueReport(
    CreateIssueReportUsecaseParams params,
  );
  Future<Either<Failure, OffsetPaginatedSuccess<IssueReport>>> getIssueReports(
    GetIssueReportsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<IssueReportStatistics>>>
  getIssueReportsStatistics();
  Future<Either<Failure, CursorPaginatedSuccess<IssueReport>>>
  getIssueReportsCursor(GetIssueReportsCursorUsecaseParams params);
  Future<Either<Failure, ItemSuccess<int>>> countIssueReports(
    CountIssueReportsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<bool>>> checkIssueReportExists(
    CheckIssueReportExistsUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<IssueReport>>> getIssueReportById(
    GetIssueReportByIdUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<IssueReport>>> updateIssueReport(
    UpdateIssueReportUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<IssueReport>>> resolveIssueReport(
    ResolveIssueReportUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<IssueReport>>> reopenIssueReport(
    ReopenIssueReportUsecaseParams params,
  );
  Future<Either<Failure, ActionSuccess>> deleteIssueReport(
    DeleteIssueReportUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<Uint8List>>> exportIssueReportList(
    ExportIssueReportListUsecaseParams params,
  );
  Future<Either<Failure, ItemSuccess<BulkCreateIssueReportsResponse>>>
  createManyIssueReports(BulkCreateIssueReportsParams params);
  Future<Either<Failure, ItemSuccess<BulkDeleteResponse>>>
  deleteManyIssueReports(BulkDeleteParams params);
}
