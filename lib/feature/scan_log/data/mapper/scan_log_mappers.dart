import 'package:sigma_track/feature/scan_log/domain/entities/scan_log.dart';
import 'package:sigma_track/feature/scan_log/data/models/scan_log_model.dart';
import 'package:sigma_track/feature/scan_log/domain/entities/scan_log_statistics.dart';
import 'package:sigma_track/feature/scan_log/data/models/scan_log_statistics_model.dart';

extension ScanLogModelMapper on ScanLogModel {
  ScanLog toEntity() {
    return ScanLog(
      id: id,
      assetID: assetID,
      scannedValue: scannedValue,
      scanMethod: scanMethod,
      scannedByID: scannedByID,
      scanTimestamp: scanTimestamp,
      scanLocationLat: scanLocationLat,
      scanLocationLng: scanLocationLng,
      scanResult: scanResult,
    );
  }
}

extension ScanLogEntityMapper on ScanLog {
  ScanLogModel toModel() {
    return ScanLogModel(
      id: id,
      assetID: assetID,
      scannedValue: scannedValue,
      scanMethod: scanMethod,
      scannedByID: scannedByID,
      scanTimestamp: scanTimestamp,
      scanLocationLat: scanLocationLat,
      scanLocationLng: scanLocationLng,
      scanResult: scanResult,
    );
  }
}

extension ScanLogStatisticsModelMapper on ScanLogStatisticsModel {
  ScanLogStatistics toEntity() {
    return ScanLogStatistics(
      total: total.toEntity(),
      byMethod: byMethod.map((model) => model.toEntity()).toList(),
      byResult: byResult.map((model) => model.toEntity()).toList(),
      geographic: geographic.toEntity(),
      scanTrends: scanTrends.map((model) => model.toEntity()).toList(),
      topScanners: topScanners.map((model) => model.toEntity()).toList(),
      summary: summary.toEntity(),
    );
  }
}

extension ScanLogStatisticsEntityMapper on ScanLogStatistics {
  ScanLogStatisticsModel toModel() {
    return ScanLogStatisticsModel(
      total: total.toModel(),
      byMethod: byMethod.map((entity) => entity.toModel()).toList(),
      byResult: byResult.map((entity) => entity.toModel()).toList(),
      geographic: geographic.toModel(),
      scanTrends: scanTrends.map((entity) => entity.toModel()).toList(),
      topScanners: topScanners.map((entity) => entity.toModel()).toList(),
      summary: summary.toModel(),
    );
  }
}

extension ScanLogCountStatisticsModelMapper on ScanLogCountStatisticsModel {
  ScanLogCountStatistics toEntity() => ScanLogCountStatistics(count: count);
}

extension ScanLogCountStatisticsEntityMapper on ScanLogCountStatistics {
  ScanLogCountStatisticsModel toModel() =>
      ScanLogCountStatisticsModel(count: count);
}

extension ScanMethodStatisticsModelMapper on ScanMethodStatisticsModel {
  ScanMethodStatistics toEntity() =>
      ScanMethodStatistics(method: method, count: count);
}

extension ScanMethodStatisticsEntityMapper on ScanMethodStatistics {
  ScanMethodStatisticsModel toModel() =>
      ScanMethodStatisticsModel(method: method, count: count);
}

extension ScanResultStatisticsModelMapper on ScanResultStatisticsModel {
  ScanResultStatistics toEntity() =>
      ScanResultStatistics(result: result, count: count);
}

extension ScanResultStatisticsEntityMapper on ScanResultStatistics {
  ScanResultStatisticsModel toModel() =>
      ScanResultStatisticsModel(result: result, count: count);
}

extension ScanGeographicStatisticsModelMapper on ScanGeographicStatisticsModel {
  ScanGeographicStatistics toEntity() => ScanGeographicStatistics(
    withCoordinates: withCoordinates,
    withoutCoordinates: withoutCoordinates,
  );
}

extension ScanGeographicStatisticsEntityMapper on ScanGeographicStatistics {
  ScanGeographicStatisticsModel toModel() => ScanGeographicStatisticsModel(
    withCoordinates: withCoordinates,
    withoutCoordinates: withoutCoordinates,
  );
}

extension ScanTrendModelMapper on ScanTrendModel {
  ScanTrend toEntity() => ScanTrend(date: date, count: count);
}

extension ScanTrendEntityMapper on ScanTrend {
  ScanTrendModel toModel() => ScanTrendModel(date: date, count: count);
}

extension ScannerStatisticsModelMapper on ScannerStatisticsModel {
  ScannerStatistics toEntity() =>
      ScannerStatistics(userID: userID, count: count);
}

extension ScannerStatisticsEntityMapper on ScannerStatistics {
  ScannerStatisticsModel toModel() =>
      ScannerStatisticsModel(userID: userID, count: count);
}

extension ScanLogSummaryStatisticsModelMapper on ScanLogSummaryStatisticsModel {
  ScanLogSummaryStatistics toEntity() => ScanLogSummaryStatistics(
    totalScans: totalScans,
    successRate: successRate,
    scansWithCoordinates: scansWithCoordinates,
    coordinatesPercentage: coordinatesPercentage,
    averageScansPerDay: averageScansPerDay,
    latestScanDate: latestScanDate,
    earliestScanDate: earliestScanDate,
  );
}

extension ScanLogSummaryStatisticsEntityMapper on ScanLogSummaryStatistics {
  ScanLogSummaryStatisticsModel toModel() => ScanLogSummaryStatisticsModel(
    totalScans: totalScans,
    successRate: successRate,
    scansWithCoordinates: scansWithCoordinates,
    coordinatesPercentage: coordinatesPercentage,
    averageScansPerDay: averageScansPerDay,
    latestScanDate: latestScanDate,
    earliestScanDate: earliestScanDate,
  );
}
