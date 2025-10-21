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
  final IssuePriority? priority;
  final IssueStatus? status;
  final String? resolvedBy;
  final List<UpdateIssueReportTranslation>? translations;

  UpdateIssueReportUsecaseParams({
    required this.id,
    this.priority,
    this.status,
    this.resolvedBy,
    this.translations,
  });

  /// * Factory method to create params with only changed fields
  factory UpdateIssueReportUsecaseParams.fromChanges({
    required String id,
    required IssueReport original,
    IssuePriority? priority,
    IssueStatus? status,
    String? resolvedBy,
    List<UpdateIssueReportTranslation>? translations,
  }) {
    return UpdateIssueReportUsecaseParams(
      id: id,
      priority: priority != original.priority ? priority : null,
      status: status != original.status ? status : null,
      resolvedBy: resolvedBy,
      translations: translations,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    if (priority != null) map['priority'] = priority!.value;
    if (status != null) map['status'] = status!.value;
    if (resolvedBy != null) map['resolvedBy'] = resolvedBy;
    if (translations != null) {
      map['translations'] = translations!.map((x) => x.toMap()).toList();
    }

    return map;
  }

  factory UpdateIssueReportUsecaseParams.fromMap(Map<String, dynamic> map) {
    return UpdateIssueReportUsecaseParams(
      id: map['id'] ?? '',
      priority: map['priority'] != null
          ? IssuePriority.values.firstWhere((e) => e.value == map['priority'])
          : null,
      status: map['status'] != null
          ? IssueStatus.values.firstWhere((e) => e.value == map['status'])
          : null,
      resolvedBy: map['resolvedBy'],
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
  List<Object?> get props => [id, priority, status, resolvedBy, translations];
}

class UpdateIssueReportTranslation extends Equatable {
  final String langCode;
  final String? title;
  final String? description;
  final String? resolutionNotes;

  const UpdateIssueReportTranslation({
    required this.langCode,
    this.title,
    this.description,
    this.resolutionNotes,
  });

  @override
  List<Object?> get props => [langCode, title, description, resolutionNotes];

  UpdateIssueReportTranslation copyWith({
    String? langCode,
    String? title,
    String? description,
    String? resolutionNotes,
  }) {
    return UpdateIssueReportTranslation(
      langCode: langCode ?? this.langCode,
      title: title ?? this.title,
      description: description ?? this.description,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'langCode': langCode};
    if (title != null) map['title'] = title;
    if (description != null) map['description'] = description;
    if (resolutionNotes != null) map['resolutionNotes'] = resolutionNotes;
    return map;
  }

  factory UpdateIssueReportTranslation.fromMap(Map<String, dynamic> map) {
    return UpdateIssueReportTranslation(
      langCode: map['langCode'] ?? '',
      title: map['title'],
      description: map['description'],
      resolutionNotes: map['resolutionNotes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateIssueReportTranslation.fromJson(String source) =>
      UpdateIssueReportTranslation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpdateIssueReportTranslation(langCode: $langCode, title: $title, description: $description, resolutionNotes: $resolutionNotes)';
  }
}
