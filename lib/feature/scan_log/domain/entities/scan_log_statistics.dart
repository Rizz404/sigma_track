import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';

class ScanLogStatistics extends Equatable {
  final ScanLogCountStatistics total;
  final List<ScanMethodStatistics> byMethod;
  final List<ScanResultStatistics> byResult;
  final ScanGeographicStatistics geographic;
  final List<ScanTrend> scanTrends;
  final List<ScannerStatistics> topScanners;
  final ScanLogSummaryStatistics summary;

  const ScanLogStatistics({
    required this.total,
    required this.byMethod,
    required this.byResult,
    required this.geographic,
    required this.scanTrends,
    required this.topScanners,
    required this.summary,
  });

  @override
  List<Object> get props => [
    total,
    byMethod,
    byResult,
    geographic,
    scanTrends,
    topScanners,
    summary,
  ];
}

class ScanLogCountStatistics extends Equatable {
  final int count;

  const ScanLogCountStatistics({required this.count});

  @override
  List<Object> get props => [count];
}

class ScanMethodStatistics extends Equatable {
  final ScanMethodType method;
  final int count;

  const ScanMethodStatistics({required this.method, required this.count});

  @override
  List<Object> get props => [method, count];
}

class ScanResultStatistics extends Equatable {
  final ScanResultType result;
  final int count;

  const ScanResultStatistics({required this.result, required this.count});

  @override
  List<Object> get props => [result, count];
}

class ScanGeographicStatistics extends Equatable {
  final int withCoordinates;
  final int withoutCoordinates;

  const ScanGeographicStatistics({
    required this.withCoordinates,
    required this.withoutCoordinates,
  });

  @override
  List<Object> get props => [withCoordinates, withoutCoordinates];
}

class ScanTrend extends Equatable {
  final DateTime date;
  final int count;

  const ScanTrend({required this.date, required this.count});

  @override
  List<Object> get props => [date, count];
}

class ScannerStatistics extends Equatable {
  final String userId;
  final int count;

  const ScannerStatistics({required this.userId, required this.count});

  @override
  List<Object> get props => [userId, count];
}

class ScanLogSummaryStatistics extends Equatable {
  final int totalScans;
  final double successRate;
  final int scansWithCoordinates;
  final double coordinatesPercentage;
  final double averageScansPerDay;
  final DateTime latestScanDate;
  final DateTime earliestScanDate;

  const ScanLogSummaryStatistics({
    required this.totalScans,
    required this.successRate,
    required this.scansWithCoordinates,
    required this.coordinatesPercentage,
    required this.averageScansPerDay,
    required this.latestScanDate,
    required this.earliestScanDate,
  });

  @override
  List<Object> get props => [
    totalScans,
    successRate,
    scansWithCoordinates,
    coordinatesPercentage,
    averageScansPerDay,
    latestScanDate,
    earliestScanDate,
  ];
}
