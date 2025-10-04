import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';
import 'package:sigma_track/core/extensions/model_parsing_extension.dart';
import 'package:sigma_track/feature/asset/data/models/asset_model.dart';
import 'package:sigma_track/feature/user/data/models/user_model.dart';

class IssueReportModel extends Equatable {
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
  final List<IssueReportTranslationModel> translations;
  final AssetModel asset;
  final UserModel reportedBy;
  final UserModel? resolvedBy;

  const IssueReportModel({
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
    required this.translations,
    required this.asset,
    required this.reportedBy,
    this.resolvedBy,
  });

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

  IssueReportModel copyWith({
    String? id,
    String? assetId,
    String? reportedById,
    DateTime? reportedDate,
    String? issueType,
    IssuePriority? priority,
    IssueStatus? status,
    DateTime? resolvedDate,
    String? resolvedById,
    String? title,
    String? description,
    String? resolutionNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<IssueReportTranslationModel>? translations,
    AssetModel? asset,
    UserModel? reportedBy,
    UserModel? resolvedBy,
  }) {
    return IssueReportModel(
      id: id ?? this.id,
      assetId: assetId ?? this.assetId,
      reportedById: reportedById ?? this.reportedById,
      reportedDate: reportedDate ?? this.reportedDate,
      issueType: issueType ?? this.issueType,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      resolvedDate: resolvedDate ?? this.resolvedDate,
      resolvedById: resolvedById ?? this.resolvedById,
      title: title ?? this.title,
      description: description ?? this.description,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      translations: translations ?? this.translations,
      asset: asset ?? this.asset,
      reportedBy: reportedBy ?? this.reportedBy,
      resolvedBy: resolvedBy ?? this.resolvedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'assetId': assetId,
      'reportedById': reportedById,
      'reportedDate': reportedDate.millisecondsSinceEpoch,
      'issueType': issueType,
      'priority': priority.toJson(),
      'status': status.toJson(),
      'resolvedDate': resolvedDate?.millisecondsSinceEpoch,
      'resolvedById': resolvedById,
      'title': title,
      'description': description,
      'resolutionNotes': resolutionNotes,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'translations': translations.map((x) => x.toMap()).toList(),
      'asset': asset.toMap(),
      'reportedBy': reportedBy.toMap(),
      'resolvedBy': resolvedBy?.toMap(),
    };
  }

  factory IssueReportModel.fromMap(Map<String, dynamic> map) {
    return IssueReportModel(
      id: map.getField<String>('id'),
      assetId: map.getField<String>('assetId'),
      reportedById: map.getField<String>('reportedById'),
      reportedDate: map.getDateTime('reportedDate'),
      issueType: map.getField<String>('issueType'),
      priority: IssuePriority.fromJson(map.getField<String>('priority')),
      status: IssueStatus.fromJson(map.getField<String>('status')),
      resolvedDate: map.getFieldOrNull<int>('resolvedDate') != null
          ? map.getDateTime('resolvedDate')
          : null,
      resolvedById: map.getFieldOrNull<String>('resolvedById'),
      title: map.getField<String>('title'),
      description: map.getFieldOrNull<String>('description'),
      resolutionNotes: map.getFieldOrNull<String>('resolutionNotes'),
      createdAt: map.getDateTime('createdAt'),
      updatedAt: map.getDateTime('updatedAt'),
      translations: List<IssueReportTranslationModel>.from(
        map
                .getFieldOrNull<List<dynamic>>('translations')
                ?.map(
                  (x) => IssueReportTranslationModel.fromMap(
                    x as Map<String, dynamic>,
                  ),
                ) ??
            [],
      ),
      asset: AssetModel.fromMap(map.getField<Map<String, dynamic>>('asset')),
      reportedBy: UserModel.fromMap(
        map.getField<Map<String, dynamic>>('reportedBy'),
      ),
      resolvedBy: map.getFieldOrNull<Map<String, dynamic>>('resolvedBy') != null
          ? UserModel.fromMap(map.getField<Map<String, dynamic>>('resolvedBy'))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory IssueReportModel.fromJson(String source) =>
      IssueReportModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'IssueReportModel(id: $id, assetId: $assetId, reportedById: $reportedById, reportedDate: $reportedDate, issueType: $issueType, priority: $priority, status: $status, resolvedDate: $resolvedDate, resolvedById: $resolvedById, title: $title, description: $description, resolutionNotes: $resolutionNotes, createdAt: $createdAt, updatedAt: $updatedAt, translations: $translations, asset: $asset, reportedBy: $reportedBy, resolvedBy: $resolvedBy)';
  }
}

class IssueReportTranslationModel extends Equatable {
  final String langCode;
  final String title;
  final String? description;
  final String? resolutionNotes;

  const IssueReportTranslationModel({
    required this.langCode,
    required this.title,
    this.description,
    this.resolutionNotes,
  });

  @override
  List<Object?> get props => [langCode, title, description, resolutionNotes];

  IssueReportTranslationModel copyWith({
    String? langCode,
    String? title,
    String? description,
    String? resolutionNotes,
  }) {
    return IssueReportTranslationModel(
      langCode: langCode ?? this.langCode,
      title: title ?? this.title,
      description: description ?? this.description,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'langCode': langCode,
      'title': title,
      'description': description,
      'resolutionNotes': resolutionNotes,
    };
  }

  factory IssueReportTranslationModel.fromMap(Map<String, dynamic> map) {
    return IssueReportTranslationModel(
      langCode: map.getField<String>('langCode'),
      title: map.getField<String>('title'),
      description: map.getFieldOrNull<String>('description'),
      resolutionNotes: map.getFieldOrNull<String>('resolutionNotes'),
    );
  }

  String toJson() => json.encode(toMap());

  factory IssueReportTranslationModel.fromJson(String source) =>
      IssueReportTranslationModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'IssueReportTranslationModel(langCode: $langCode, title: $title, description: $description, resolutionNotes: $resolutionNotes)';
}
