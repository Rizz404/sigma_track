import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sigma_track/core/enums/model_entity_enums.dart';

class ScanLogStatisticsModel extends Equatable {
  final ScanLogCountStatisticsModel total;
  final List<ScanMethodStatisticsModel> byMethod;
  final List<ScanResultStatisticsModel> byResult;
  final ScanGeographicStatisticsModel geographic;
  final List<ScanTrendModel> scanTrends;
  final List<ScannerStatisticsModel> topScanners;
  final ScanLogSummaryStatisticsModel summary;

  const ScanLogStatisticsModel({
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

  ScanLogStatisticsModel copyWith({
    ScanLogCountStatisticsModel? total,
    List<ScanMethodStatisticsModel>? byMethod,
    List<ScanResultStatisticsModel>? byResult,
    ScanGeographicStatisticsModel? geographic,
    List<ScanTrendModel>? scanTrends,
    List<ScannerStatisticsModel>? topScanners,
    ScanLogSummaryStatisticsModel? summary,
  }) {
    return ScanLogStatisticsModel(
      total: total ?? this.total,
      byMethod: byMethod ?? this.byMethod,
      byResult: byResult ?? this.byResult,
      geographic: geographic ?? this.geographic,
      scanTrends: scanTrends ?? this.scanTrends,
      topScanners: topScanners ?? this.topScanners,
      summary: summary ?? this.summary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total.toMap(),
      'byMethod': byMethod.map((x) => x.toMap()).toList(),
      'byResult': byResult.map((x) => x.toMap()).toList(),
      'geographic': geographic.toMap(),
      'scanTrends': scanTrends.map((x) => x.toMap()).toList(),
      'topScanners': topScanners.map((x) => x.toMap()).toList(),
      'summary': summary.toMap(),
    };
  }

  factory ScanLogStatisticsModel.fromMap(Map<String, dynamic> map) {
    return ScanLogStatisticsModel(
      total: ScanLogCountStatisticsModel.fromMap(map['total']),
      byMethod: List<ScanMethodStatisticsModel>.from(
        map['byMethod']?.map((x) => ScanMethodStatisticsModel.fromMap(x)),
      ),
      byResult: List<ScanResultStatisticsModel>.from(
        map['byResult']?.map((x) => ScanResultStatisticsModel.fromMap(x)),
      ),
      geographic: ScanGeographicStatisticsModel.fromMap(map['geographic']),
      scanTrends: List<ScanTrendModel>.from(
        map['scanTrends']?.map((x) => ScanTrendModel.fromMap(x)),
      ),
      topScanners: List<ScannerStatisticsModel>.from(
        map['topScanners']?.map((x) => ScannerStatisticsModel.fromMap(x)),
      ),
      summary: ScanLogSummaryStatisticsModel.fromMap(map['summary']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ScanLogStatisticsModel.fromJson(String source) =>
      ScanLogStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ScanLogStatisticsModel(total: $total, byMethod: $byMethod, byResult: $byResult, geographic: $geographic, scanTrends: $scanTrends, topScanners: $topScanners, summary: $summary)';
  }
}

class ScanLogCountStatisticsModel extends Equatable {
  final int count;

  const ScanLogCountStatisticsModel({required this.count});

  @override
  List<Object> get props => [count];

  ScanLogCountStatisticsModel copyWith({int? count}) {
    return ScanLogCountStatisticsModel(count: count ?? this.count);
  }

  Map<String, dynamic> toMap() {
    return {'count': count};
  }

  factory ScanLogCountStatisticsModel.fromMap(Map<String, dynamic> map) {
    return ScanLogCountStatisticsModel(count: map['count']?.toInt() ?? 0);
  }

  String toJson() => json.encode(toMap());

  factory ScanLogCountStatisticsModel.fromJson(String source) =>
      ScanLogCountStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() => 'ScanLogCountStatisticsModel(count: $count)';
}

class ScanMethodStatisticsModel extends Equatable {
  final ScanMethodType method;
  final int count;

  const ScanMethodStatisticsModel({required this.method, required this.count});

  @override
  List<Object> get props => [method, count];

  ScanMethodStatisticsModel copyWith({ScanMethodType? method, int? count}) {
    return ScanMethodStatisticsModel(
      method: method ?? this.method,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {'method': method.toJson(), 'count': count};
  }

  factory ScanMethodStatisticsModel.fromMap(Map<String, dynamic> map) {
    return ScanMethodStatisticsModel(
      method: ScanMethodType.fromJson(map['method']),
      count: map['count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScanMethodStatisticsModel.fromJson(String source) =>
      ScanMethodStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ScanMethodStatisticsModel(method: $method, count: $count)';
}

class ScanResultStatisticsModel extends Equatable {
  final ScanResultType result;
  final int count;

  const ScanResultStatisticsModel({required this.result, required this.count});

  @override
  List<Object> get props => [result, count];

  ScanResultStatisticsModel copyWith({ScanResultType? result, int? count}) {
    return ScanResultStatisticsModel(
      result: result ?? this.result,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {'result': result.toJson(), 'count': count};
  }

  factory ScanResultStatisticsModel.fromMap(Map<String, dynamic> map) {
    return ScanResultStatisticsModel(
      result: ScanResultType.fromJson(map['result']),
      count: map['count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScanResultStatisticsModel.fromJson(String source) =>
      ScanResultStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ScanResultStatisticsModel(result: $result, count: $count)';
}

class ScanGeographicStatisticsModel extends Equatable {
  final int withCoordinates;
  final int withoutCoordinates;

  const ScanGeographicStatisticsModel({
    required this.withCoordinates,
    required this.withoutCoordinates,
  });

  @override
  List<Object> get props => [withCoordinates, withoutCoordinates];

  ScanGeographicStatisticsModel copyWith({
    int? withCoordinates,
    int? withoutCoordinates,
  }) {
    return ScanGeographicStatisticsModel(
      withCoordinates: withCoordinates ?? this.withCoordinates,
      withoutCoordinates: withoutCoordinates ?? this.withoutCoordinates,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'withCoordinates': withCoordinates,
      'withoutCoordinates': withoutCoordinates,
    };
  }

  factory ScanGeographicStatisticsModel.fromMap(Map<String, dynamic> map) {
    return ScanGeographicStatisticsModel(
      withCoordinates: map['withCoordinates']?.toInt() ?? 0,
      withoutCoordinates: map['withoutCoordinates']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScanGeographicStatisticsModel.fromJson(String source) =>
      ScanGeographicStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ScanGeographicStatisticsModel(withCoordinates: $withCoordinates, withoutCoordinates: $withoutCoordinates)';
}

class ScanTrendModel extends Equatable {
  final String date;
  final int count;

  const ScanTrendModel({required this.date, required this.count});

  @override
  List<Object> get props => [date, count];

  ScanTrendModel copyWith({String? date, int? count}) {
    return ScanTrendModel(date: date ?? this.date, count: count ?? this.count);
  }

  Map<String, dynamic> toMap() {
    return {'date': date, 'count': count};
  }

  factory ScanTrendModel.fromMap(Map<String, dynamic> map) {
    return ScanTrendModel(
      date: map['date'] ?? '',
      count: map['count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScanTrendModel.fromJson(String source) =>
      ScanTrendModel.fromMap(json.decode(source));

  @override
  String toString() => 'ScanTrendModel(date: $date, count: $count)';
}

class ScannerStatisticsModel extends Equatable {
  final String userID;
  final int count;

  const ScannerStatisticsModel({required this.userID, required this.count});

  @override
  List<Object> get props => [userID, count];

  ScannerStatisticsModel copyWith({String? userID, int? count}) {
    return ScannerStatisticsModel(
      userID: userID ?? this.userID,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {'userId': userID, 'count': count};
  }

  factory ScannerStatisticsModel.fromMap(Map<String, dynamic> map) {
    return ScannerStatisticsModel(
      userID: map['userId'] ?? '',
      count: map['count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScannerStatisticsModel.fromJson(String source) =>
      ScannerStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() => 'ScannerStatisticsModel(userID: $userID, count: $count)';
}

class ScanLogSummaryStatisticsModel extends Equatable {
  final int totalScans;
  final double successRate;
  final int scansWithCoordinates;
  final double coordinatesPercentage;
  final double averageScansPerDay;
  final String latestScanDate;
  final String earliestScanDate;

  const ScanLogSummaryStatisticsModel({
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

  ScanLogSummaryStatisticsModel copyWith({
    int? totalScans,
    double? successRate,
    int? scansWithCoordinates,
    double? coordinatesPercentage,
    double? averageScansPerDay,
    String? latestScanDate,
    String? earliestScanDate,
  }) {
    return ScanLogSummaryStatisticsModel(
      totalScans: totalScans ?? this.totalScans,
      successRate: successRate ?? this.successRate,
      scansWithCoordinates: scansWithCoordinates ?? this.scansWithCoordinates,
      coordinatesPercentage:
          coordinatesPercentage ?? this.coordinatesPercentage,
      averageScansPerDay: averageScansPerDay ?? this.averageScansPerDay,
      latestScanDate: latestScanDate ?? this.latestScanDate,
      earliestScanDate: earliestScanDate ?? this.earliestScanDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalScans': totalScans,
      'successRate': successRate,
      'scansWithCoordinates': scansWithCoordinates,
      'coordinatesPercentage': coordinatesPercentage,
      'averageScansPerDay': averageScansPerDay,
      'latestScanDate': latestScanDate,
      'earliestScanDate': earliestScanDate,
    };
  }

  factory ScanLogSummaryStatisticsModel.fromMap(Map<String, dynamic> map) {
    return ScanLogSummaryStatisticsModel(
      totalScans: map['totalScans']?.toInt() ?? 0,
      successRate: map['successRate']?.toDouble() ?? 0.0,
      scansWithCoordinates: map['scansWithCoordinates']?.toInt() ?? 0,
      coordinatesPercentage: map['coordinatesPercentage']?.toDouble() ?? 0.0,
      averageScansPerDay: map['averageScansPerDay']?.toDouble() ?? 0.0,
      latestScanDate: map['latestScanDate'] ?? '',
      earliestScanDate: map['earliestScanDate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ScanLogSummaryStatisticsModel.fromJson(String source) =>
      ScanLogSummaryStatisticsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ScanLogSummaryStatisticsModel(totalScans: $totalScans, successRate: $successRate, scansWithCoordinates: $scansWithCoordinates, coordinatesPercentage: $coordinatesPercentage, averageScansPerDay: $averageScansPerDay, latestScanDate: $latestScanDate, earliestScanDate: $earliestScanDate)';
  }
}
