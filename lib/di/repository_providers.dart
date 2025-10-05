import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/di/datasource_providers.dart';

// Auth Repository
import 'package:sigma_track/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:sigma_track/feature/auth/domain/repositories/auth_repository.dart';

// Asset Repository
import 'package:sigma_track/feature/asset/data/repositories/asset_repository_impl.dart';
import 'package:sigma_track/feature/asset/domain/repositories/asset_repository.dart';

// Asset Movement Repository
import 'package:sigma_track/feature/asset_movement/data/repositories/asset_movement_repository_impl.dart';
import 'package:sigma_track/feature/asset_movement/domain/repositories/asset_movement_repository.dart';

// Category Repository
import 'package:sigma_track/feature/category/data/repositories/category_repository_impl.dart';
import 'package:sigma_track/feature/category/domain/repositories/category_repository.dart';

// Issue Report Repository
import 'package:sigma_track/feature/issue_report/data/repositories/issue_report_repository_impl.dart';
import 'package:sigma_track/feature/issue_report/domain/repositories/issue_report_repository.dart';

// Location Repository
import 'package:sigma_track/feature/location/data/repositories/location_repository_impl.dart';
import 'package:sigma_track/feature/location/domain/repositories/location_repository.dart';

// User Repository
import 'package:sigma_track/feature/user/data/repositories/user_repository_impl.dart';
import 'package:sigma_track/feature/user/domain/repositories/user_repository.dart';

// Maintenance Repositories
import 'package:sigma_track/feature/maintenance/data/repositories/maintenance_record_repository_impl.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_record_repository.dart';
import 'package:sigma_track/feature/maintenance/data/repositories/maintenance_schedule_repository_impl.dart';
import 'package:sigma_track/feature/maintenance/domain/repositories/maintenance_schedule_repository.dart';

// Notification Repository
import 'package:sigma_track/feature/notification/data/repositories/notification_repository_impl.dart';
import 'package:sigma_track/feature/notification/domain/repositories/notification_repository.dart';

// Scan Log Repository
import 'package:sigma_track/feature/scan_log/data/repositories/scan_log_repository_impl.dart';
import 'package:sigma_track/feature/scan_log/domain/repositories/scan_log_repository.dart';

// ===== AUTH REPOSITORY =====
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final _authRemoteDatasource = ref.watch(authRemoteDatasourceProvider);
  final _authLocalDatasource = ref.watch(authLocalDatasourceProvider);
  return AuthRepositoryImpl(_authRemoteDatasource, _authLocalDatasource);
});

// ===== ASSET REPOSITORY =====
final assetRepositoryProvider = Provider<AssetRepository>((ref) {
  final _assetRemoteDatasource = ref.watch(assetRemoteDatasourceProvider);
  return AssetRepositoryImpl(_assetRemoteDatasource);
});

// ===== ASSET MOVEMENT REPOSITORY =====
final assetMovementRepositoryProvider = Provider<AssetMovementRepository>((
  ref,
) {
  final _assetMovementRemoteDatasource = ref.watch(
    assetMovementRemoteDatasourceProvider,
  );
  return AssetMovementRepositoryImpl(_assetMovementRemoteDatasource);
});

// ===== CATEGORY REPOSITORY =====
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final _categoryRemoteDatasource = ref.watch(categoryRemoteDatasourceProvider);
  return CategoryRepositoryImpl(_categoryRemoteDatasource);
});

// ===== ISSUE REPORT REPOSITORY =====
final issueReportRepositoryProvider = Provider<IssueReportRepository>((ref) {
  final _issueReportRemoteDatasource = ref.watch(
    issueReportRemoteDatasourceProvider,
  );
  return IssueReportRepositoryImpl(_issueReportRemoteDatasource);
});

// ===== LOCATION REPOSITORY =====
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final _locationRemoteDatasource = ref.watch(locationRemoteDatasourceProvider);
  return LocationRepositoryImpl(_locationRemoteDatasource);
});

// ===== LOCATION REPOSITORY =====
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final _userRemoteDatasource = ref.watch(userRemoteDatasourceProvider);
  return UserRepositoryImpl(_userRemoteDatasource);
});

// ===== MAINTENANCE REPOSITORIES =====
final maintenanceRecordRepositoryProvider =
    Provider<MaintenanceRecordRepository>((ref) {
      final _maintenanceRecordRemoteDatasource = ref.watch(
        maintenanceRecordRemoteDatasourceProvider,
      );
      return MaintenanceRecordRepositoryImpl(
        _maintenanceRecordRemoteDatasource,
      );
    });

final maintenanceScheduleRepositoryProvider =
    Provider<MaintenanceScheduleRepository>((ref) {
      final _maintenanceScheduleRemoteDatasource = ref.watch(
        maintenanceScheduleRemoteDatasourceProvider,
      );
      return MaintenanceScheduleRepositoryImpl(
        _maintenanceScheduleRemoteDatasource,
      );
    });

// ===== NOTIFICATION REPOSITORY =====
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final _notificationRemoteDatasource = ref.watch(
    notificationRemoteDatasourceProvider,
  );
  return NotificationRepositoryImpl(_notificationRemoteDatasource);
});

// ===== SCAN LOG REPOSITORY =====
final scanLogRepositoryProvider = Provider<ScanLogRepository>((ref) {
  final _scanLogRemoteDatasource = ref.watch(scanLogRemoteDatasourceProvider);
  return ScanLogRepositoryImpl(_scanLogRemoteDatasource);
});
