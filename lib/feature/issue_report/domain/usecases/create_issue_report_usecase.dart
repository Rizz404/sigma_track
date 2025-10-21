import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:sigma_track/core/domain/failure.dart';
import 'package:sigma_track/core/domain/success.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/usecases/usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';

class CreateIssueReportUsecase
    implements
        Usecase<ItemSuccess<IssueReport>, CreateIssueReportUsecaseParams> {
  final IssueReportRepository _issueReportRepository;

  CreateIssueReportUsecase(this._issueReportRepository);

  @override
  Future<Either<Failure, ItemSuccess<IssueReport>>> call(
    CreateIssueReportUsecaseParams params,
  ) async {
    return await _issueReportRepository.createIssueReport(params);
  }
}

class CreateIssueReportUsecaseParams extends Equatable {
  final String assetId;
  final String issueType;
  final IssuePriority priority;
  final List<CreateIssueReportTranslation> translations;

  CreateIssueReportUsecaseParams({
    required this.assetId,
    required this.issueType,
    required this.priority,
    required this.translations,
  });

  Map<String, dynamic> toMap() {
    return {
      'assetId': assetId,
      'issueType': issueType,
      'priority': priority.value,
      'translations': translations.map((x) => x.toMap()).toList(),
    };
  }

  factory CreateIssueReportUsecaseParams.fromMap(Map<String, dynamic> map) {
    return CreateIssueReportUsecaseParams(
      assetId: map['assetId'] ?? '',
      issueType: map['issueType'] ?? '',
      priority: IssuePriority.values.firstWhere(
        (e) => e.value == map['priority'],
      ),
      translations: List<CreateIssueReportTranslation>.from(
        map['translations']?.map(
          (x) => CreateIssueReportTranslation.fromMap(x),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateIssueReportUsecaseParams.fromJson(String source) =>
      CreateIssueReportUsecaseParams.fromMap(json.decode(source));

  @override
  List<Object> get props => [assetId, issueType, priority, translations];
}

class CreateIssueReportTranslation extends Equatable {
  final String langCode;
  final String title;
  final String? description;

  const CreateIssueReportTranslation({
    required this.langCode,
    required this.title,
    this.description,
  });

  @override
  List<Object?> get props => [langCode, title, description];

  CreateIssueReportTranslation copyWith({
    String? langCode,
    String? title,
    String? description,
  }) {
    return CreateIssueReportTranslation(
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

  factory CreateIssueReportTranslation.fromMap(Map<String, dynamic> map) {
    return CreateIssueReportTranslation(
      langCode: map['langCode'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateIssueReportTranslation.fromJson(String source) =>
      CreateIssueReportTranslation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CreateIssueReportTranslation(langCode: $langCode, title: $title, description: $description)';
  }
}
