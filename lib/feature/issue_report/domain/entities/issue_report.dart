import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/feature/asset/domain/entities/asset.dart';
import 'package:sigma_track/feature/user/domain/entities/user.dart';

class IssueReport extends Equatable {
  final String id;
  final String assetId;
  final String reportedById;
  final DateTime reportedDate;
  final String issueType;
  final IssuePriority priority;
  final IssueStatus status;
  final DateTime? resolvedDate;
  final String? resolvedById;
  final String title;
  final String? description;
  final String? resolutionNotes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<IssueReportTranslation>? translations;
  final Asset? asset;
  final User? reportedBy;
  final User? resolvedBy;

  const IssueReport({
    required this.id,
    required this.assetId,
    required this.reportedById,
    required this.reportedDate,
    required this.issueType,
    required this.priority,
    required this.status,
    this.resolvedDate,
    this.resolvedById,
    required this.title,
    this.description,
    this.resolutionNotes,
    required this.createdAt,
    required this.updatedAt,
    this.translations,
    this.asset,
    this.reportedBy,
    this.resolvedBy,
  });

  factory IssueReport.dummy() => IssueReport(
    id: '',
    assetId: '',
    reportedById: '',
    reportedDate: DateTime(0),
    issueType: '',
    priority: IssuePriority.low,
    status: IssueStatus.open,
    title: '',
    createdAt: DateTime(0),
    updatedAt: DateTime(0),
  );

  @override
  List<Object?> get props => [
    id,
    assetId,
    reportedById,
    reportedDate,
    issueType,
    priority,
    status,
    resolvedDate,
    resolvedById,
    title,
    description,
    resolutionNotes,
    createdAt,
    updatedAt,
    translations,
    asset,
    reportedBy,
    resolvedBy,
  ];
}

class IssueReportTranslation extends Equatable {
  final String langCode;
  final String title;
  final String? description;
  final String? resolutionNotes;

  const IssueReportTranslation({
    required this.langCode,
    required this.title,
    this.description,
    this.resolutionNotes,
  });

  @override
  List<Object?> get props => [langCode, title, description, resolutionNotes];
}
