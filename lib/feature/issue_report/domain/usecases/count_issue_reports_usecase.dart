import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';
import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';

class CountIssueReportsUsecase
    implements Usecase<ItemSuccess<int>, CountIssueReportsUsecaseParams> {
  final IssueReportRepository _issueReportRepository;

  CountIssueReportsUsecase(this._issueReportRepository);

  @override
  Future<Either<Failure, ItemSuccess<int>>> call(
    CountIssueReportsUsecaseParams params,
  ) async {
    return await _issueReportRepository.countIssueReports(params);
  }
}

class CountIssueReportsUsecaseParams extends Equatable {
  final IssueStatus? status;
  final IssuePriority? priority;

  const CountIssueReportsUsecaseParams({this.status, this.priority});

  CountIssueReportsUsecaseParams copyWith({
    IssueStatus? status,
    IssuePriority? priority,
  }) {
    return CountIssueReportsUsecaseParams(
      status: status ?? this.status,
      priority: priority ?? this.priority,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (status != null) 'status': status!.value,
      if (priority != null) 'priority': priority!.value,
    };
  }

  factory CountIssueReportsUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CountIssueReportsUsecaseParams(
      status: map['status'] != null
          ? IssueStatus.values.firstWhere((e) => e.value == map['status'])
          : null,
      priority: map['priority'] != null
          ? IssuePriority.values.firstWhere((e) => e.value == map['priority'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CountIssueReportsUsecaseParams.fromJson(String source) =>
      CountIssueReportsUsecaseParams.fromMap(json.decode(source));

  @override
  String toString() =>
      'CountIssueReportsUsecaseParams(status: $status, priority: $priority)';

  @override
  List<Object?> get props => [status, priority];
}
