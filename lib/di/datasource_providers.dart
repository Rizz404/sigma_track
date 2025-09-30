import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/di/common_providers.dart';

// Auth Datasources
import 'package:sigma_track/feature/auth/data/datasources/auth_local_datasource.dart';
import 'package:sigma_track/feature/auth/data/datasources/auth_remote_datasource.dart';

// Asset Datasources
import 'package:sigma_track/feature/asset/data/datasources/asset_remote_datasource.dart';

// Asset Movement Datasources
import 'package:sigma_track/feature/asset_movement/data/datasources/asset_movement_remote_datasource.dart';

// Category Datasources
import 'package:sigma_track/feature/category/data/datasources/category_remote_datasource.dart';

// Issue Report Datasources
import 'package:sigma_track/feature/issue_report/data/datasources/issue_report_remote_datasource.dart';

// Location Datasources
import 'package:sigma_track/feature/location/data/datasources/location_remote_datasource.dart';

// Maintenance Datasources
import 'package:sigma_track/feature/maintenance/data/datasources/maintenance_record_remote_datasource.dart';
import 'package:sigma_track/feature/maintenance/data/datasources/maintenance_schedule_remote_datasource.dart';

// Notification Datasources
import 'package:sigma_track/feature/notification/data/datasources/notification_remote_datasource.dart';

// Scan Log Datasources
import 'package:sigma_track/feature/scan_log/data/datasources/scan_log_remote_datasource.dart';

// ===== AUTH DATASOURCES =====
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final _dioClient = ref.watch(dioClientProvider);
  return AuthRemoteDatasourceImpl(_dioClient);
});

final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final _sharedPreferencesWithCache = ref.watch(
    sharedPreferencesWithCacheProvider,
  );
  final _flutterSecureStorage = ref.watch(secureStorageProvider);
  return AuthLocalDatasourceImpl(
    _flutterSecureStorage,
    _sharedPreferencesWithCache,
  );
});

// ===== ASSET DATASOURCES =====
final assetRemoteDatasourceProvider = Provider<AssetRemoteDatasource>((ref) {
  final _dioClient = ref.watch(dioClientProvider);
  return AssetRemoteDatasourceImpl(_dioClient);
});

// ===== ASSET MOVEMENT DATASOURCES =====
final assetMovementRemoteDatasourceProvider =
    Provider<AssetMovementRemoteDatasource>((ref) {
      final _dioClient = ref.watch(dioClientProvider);
      return AssetMovementRemoteDatasourceImpl(_dioClient);
    });

// ===== CATEGORY DATASOURCES =====
final categoryRemoteDatasourceProvider = Provider<CategoryRemoteDatasource>((
  ref,
) {
  final _dioClient = ref.watch(dioClientProvider);
  return CategoryRemoteDatasourceImpl(_dioClient);
});

// ===== ISSUE REPORT DATASOURCES =====
final issueReportRemoteDatasourceProvider =
    Provider<IssueReportRemoteDatasource>((ref) {
      final _dioClient = ref.watch(dioClientProvider);
      return IssueReportRemoteDatasourceImpl(_dioClient);
    });

// ===== LOCATION DATASOURCES =====
final locationRemoteDatasourceProvider = Provider<LocationRemoteDatasource>((
  ref,
) {
  final _dioClient = ref.watch(dioClientProvider);
  return LocationRemoteDatasourceImpl(_dioClient);
});

// ===== MAINTENANCE DATASOURCES =====
final maintenanceRecordRemoteDatasourceProvider =
    Provider<MaintenanceRecordRemoteDatasource>((ref) {
      final _dioClient = ref.watch(dioClientProvider);
      return MaintenanceRecordRemoteDatasourceImpl(_dioClient);
    });

final maintenanceScheduleRemoteDatasourceProvider =
    Provider<MaintenanceScheduleRemoteDatasource>((ref) {
      final _dioClient = ref.watch(dioClientProvider);
      return MaintenanceScheduleRemoteDatasourceImpl(_dioClient);
    });

// ===== NOTIFICATION DATASOURCES =====
final notificationRemoteDatasourceProvider =
    Provider<NotificationRemoteDatasource>((ref) {
      final _dioClient = ref.watch(dioClientProvider);
      return NotificationRemoteDatasourceImpl(_dioClient);
    });

// ===== SCAN LOG DATASOURCES =====
final scanLogRemoteDatasourceProvider = Provider<ScanLogRemoteDatasource>((
  ref,
) {
  final _dioClient = ref.watch(dioClientProvider);
  return ScanLogRemoteDatasourceImpl(_dioClient);
});
