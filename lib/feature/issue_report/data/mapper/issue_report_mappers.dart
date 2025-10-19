import 'package:sigma_track/feature/asset/data/mapper/asset_mappers.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report.dart';
import 'package:sigma_track/feature/issue_report/domain/entities/issue_report_statistics.dart';
import 'package:sigma_track/feature/issue_report/data/models/issue_report_model.dart';
import 'package:sigma_track/feature/issue_report/data/models/issue_report_statistics_model.dart';
import 'package:sigma_track/feature/user/data/mapper/user_mappers.dart';

extension IssueReportModelMapper on IssueReportModel {
  IssueReport toEntity() {
    return IssueReport(
      id: id,
      assetId: assetId,
      reportedById: reportedById,
      reportedDate: reportedDate,
      issueType: issueType,
      priority: priority,
      status: status,
      resolvedDate: resolvedDate,
      resolvedById: resolvedById,
      title: title,
      description: description,
      resolutionNotes: resolutionNotes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      translations: translations?.map((x) => x.toEntity()).toList() ?? [],
      asset: asset?.toEntity(),
      reportedBy: reportedBy?.toEntity(),
      resolvedBy: resolvedBy?.toEntity(),
    );
  }
}

extension IssueReportEntityMapper on IssueReport {
  IssueReportModel toModel() {
    return IssueReportModel(
      id: id,
      assetId: assetId,
      reportedById: reportedById,
      reportedDate: reportedDate,
      issueType: issueType,
      priority: priority,
      status: status,
      resolvedDate: resolvedDate,
      resolvedById: resolvedById,
      title: title,
      description: description,
      resolutionNotes: resolutionNotes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      translations: translations?.map((x) => x.toModel()).toList() ?? [],
      asset: asset?.toModel(),
      reportedBy: reportedBy?.toModel(),
      resolvedBy: resolvedBy?.toModel(),
    );
  }
}

extension IssueReportTranslationModelMapper on IssueReportTranslationModel {
  IssueReportTranslation toEntity() {
    return IssueReportTranslation(
      langCode: langCode,
      title: title,
      description: description,
      resolutionNotes: resolutionNotes,
    );
  }
}

extension IssueReportTranslationEntityMapper on IssueReportTranslation {
  IssueReportTranslationModel toModel() {
    return IssueReportTranslationModel(
      langCode: langCode,
      title: title,
      description: description,
      resolutionNotes: resolutionNotes,
    );
  }
}

extension IssueReportStatisticsModelMapper on IssueReportStatisticsModel {
  IssueReportStatistics toEntity() {
    return IssueReportStatistics(
      total: total.toEntity(),
      byPriority: byPriority.toEntity(),
      byStatus: byStatus.toEntity(),
      byType: byType.toEntity(),
      creationTrends: creationTrends.map((x) => x.toEntity()).toList(),
      summary: summary.toEntity(),
    );
  }
}

extension IssueReportStatisticsEntityMapper on IssueReportStatistics {
  IssueReportStatisticsModel toModel() {
    return IssueReportStatisticsModel(
      total: total.toModel(),
      byPriority: byPriority.toModel(),
      byStatus: byStatus.toModel(),
      byType: byType.toModel(),
      creationTrends: creationTrends.map((x) => x.toModel()).toList(),
      summary: summary.toModel(),
    );
  }
}

extension IssueReportCountStatisticsModelMapper
    on IssueReportCountStatisticsModel {
  IssueReportCountStatistics toEntity() {
    return IssueReportCountStatistics(count: count);
  }
}

extension IssueReportCountStatisticsEntityMapper on IssueReportCountStatistics {
  IssueReportCountStatisticsModel toModel() {
    return IssueReportCountStatisticsModel(count: count);
  }
}

extension IssueReportPriorityStatisticsModelMapper
    on IssueReportPriorityStatisticsModel {
  IssueReportPriorityStatistics toEntity() {
    return IssueReportPriorityStatistics(
      low: low,
      medium: medium,
      high: high,
      critical: critical,
    );
  }
}

extension IssueReportPriorityStatisticsEntityMapper
    on IssueReportPriorityStatistics {
  IssueReportPriorityStatisticsModel toModel() {
    return IssueReportPriorityStatisticsModel(
      low: low,
      medium: medium,
      high: high,
      critical: critical,
    );
  }
}

extension IssueReportStatusStatisticsModelMapper
    on IssueReportStatusStatisticsModel {
  IssueReportStatusStatistics toEntity() {
    return IssueReportStatusStatistics(
      open: open,
      inProgress: inProgress,
      resolved: resolved,
      closed: closed,
    );
  }
}

extension IssueReportStatusStatisticsEntityMapper
    on IssueReportStatusStatistics {
  IssueReportStatusStatisticsModel toModel() {
    return IssueReportStatusStatisticsModel(
      open: open,
      inProgress: inProgress,
      resolved: resolved,
      closed: closed,
    );
  }
}

extension IssueReportTypeStatisticsModelMapper
    on IssueReportTypeStatisticsModel {
  IssueReportTypeStatistics toEntity() {
    return IssueReportTypeStatistics(types: types);
  }
}

extension IssueReportTypeStatisticsEntityMapper on IssueReportTypeStatistics {
  IssueReportTypeStatisticsModel toModel() {
    return IssueReportTypeStatisticsModel(types: types);
  }
}

extension IssueReportCreationTrendModelMapper on IssueReportCreationTrendModel {
  IssueReportCreationTrend toEntity() {
    return IssueReportCreationTrend(date: date, count: count);
  }
}

extension IssueReportCreationTrendEntityMapper on IssueReportCreationTrend {
  IssueReportCreationTrendModel toModel() {
    return IssueReportCreationTrendModel(date: date, count: count);
  }
}

extension IssueReportSummaryStatisticsModelMapper
    on IssueReportSummaryStatisticsModel {
  IssueReportSummaryStatistics toEntity() {
    return IssueReportSummaryStatistics(
      totalReports: totalReports,
      openPercentage: openPercentage,
      resolvedPercentage: resolvedPercentage,
      averageResolutionTime: averageResolutionTime,
      mostCommonPriority: mostCommonPriority,
      mostCommonType: mostCommonType,
      criticalUnresolvedCount: criticalUnresolvedCount,
      averageReportsPerDay: averageReportsPerDay,
      latestCreationDate: latestCreationDate,
      earliestCreationDate: earliestCreationDate,
    );
  }
}

extension IssueReportSummaryStatisticsEntityMapper
    on IssueReportSummaryStatistics {
  IssueReportSummaryStatisticsModel toModel() {
    return IssueReportSummaryStatisticsModel(
      totalReports: totalReports,
      openPercentage: openPercentage,
      resolvedPercentage: resolvedPercentage,
      averageResolutionTime: averageResolutionTime,
      mostCommonPriority: mostCommonPriority,
      mostCommonType: mostCommonType,
      criticalUnresolvedCount: criticalUnresolvedCount,
      averageReportsPerDay: averageReportsPerDay,
      latestCreationDate: latestCreationDate,
      earliestCreationDate: earliestCreationDate,
    );
  }
}
