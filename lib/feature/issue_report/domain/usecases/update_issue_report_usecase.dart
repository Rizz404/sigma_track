import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';

class UpdateIssueReportUsecase
    implements
        Usecase<ItemSuccess<IssueReport>, UpdateIssueReportUsecaseParams> {
  final IssueReportRepository _issueReportRepository;

  UpdateIssueReportUsecase(this._issueReportRepository);

  @override
  Future<Either<Failure, ItemSuccess<IssueReport>>> call(
    UpdateIssueReportUsecaseParams params,
  ) async {
    return await _issueReportRepository.updateIssueReport(params);
  }
}

class UpdateIssueReportUsecaseParams extends Equatable {
  final String id;
  final String? assetId;
  final String? issueType;
  final IssuePriority? priority;
  final IssueStatus? status;
  final String? resolutionNotes;
  final List<UpdateIssueReportTranslation>? translations;

  UpdateIssueReportUsecaseParams({
    required this.id,
    this.assetId,
    this.issueType,
    this.priority,
    this.status,
    this.resolutionNotes,
    this.translations,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (assetId != null) map['assetId'] = assetId;
    if (issueType != null) map['issueType'] = issueType;
    if (priority != null) map['priority'] = priority!.toJson();
    if (status != null) map['status'] = status!.toJson();
    if (resolutionNotes != null) map['resolutionNotes'] = resolutionNotes;
    if (translations != null) {
      map['translations'] = translations!.map((x) => x.toMap()).toList();
    }

    return map;
  }

  factory UpdateIssueReportUsecaseParams.fromMap(Map<String, dynamic> map) {
    return UpdateIssueReportUsecaseParams(
      id: map['id'] ?? '',
      assetId: map['assetId'],
      issueType: map['issueType'],
      priority: map['priority'] != null
          ? IssuePriority.fromJson(map['priority'])
          : null,
      status: map['status'] != null
          ? IssueStatus.fromJson(map['status'])
          : null,
      resolutionNotes: map['resolutionNotes'],
      translations: map['translations'] != null
          ? List<UpdateIssueReportTranslation>.from(
              map['translations']?.map(
                (x) => UpdateIssueReportTranslation.fromMap(x),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateIssueReportUsecaseParams.fromJson(String source) =>
      UpdateIssueReportUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object?> get props => [
    id,
    assetId,
    issueType,
    priority,
    status,
    resolutionNotes,
    translations,
  ];
}

class UpdateIssueReportTranslation extends Equatable {
  final String langCode;
  final String title;
  final String? description;

  const UpdateIssueReportTranslation({
    required this.langCode,
    required this.title,
    this.description,
  });

  @override
  List<Object?> get props => [langCode, title, description];

  UpdateIssueReportTranslation copyWith({
    String? langCode,
    String? title,
    String? description,
  }) {
    return UpdateIssueReportTranslation(
      langCode: langCode ?? this.langCode,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'langCode': langCode, 'title': title};
    if (description != null) map['description'] = description;
    return map;
  }

  factory UpdateIssueReportTranslation.fromMap(Map<String, dynamic> map) {
    return UpdateIssueReportTranslation(
      langCode: map['langCode'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateIssueReportTranslation.fromJson(String source) =>
      UpdateIssueReportTranslation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpdateIssueReportTranslation(langCode: $langCode, title: $title, description: $description)';
  }
}
