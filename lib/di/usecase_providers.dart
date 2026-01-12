import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_track/di/repository_providers.dart';
import 'package:sigma_track/feature/asset/domain/usecases/generate_asset_tag_suggestion_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/create_asset_movement_for_location_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/create_asset_movement_for_user_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/update_asset_movement_for_location_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/update_asset_movement_for_user_usecase.dart';

// ===== AUTH USECASES =====
import 'package:sigma_track/feature/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/get_current_auth_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/login_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/logout_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/register_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/reset_password_usecase.dart';
import 'package:sigma_track/feature/auth/domain/usecases/verify_reset_code_usecase.dart';

// ===== ASSET USECASES =====
import 'package:sigma_track/feature/asset/domain/usecases/bulk_create_assets_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/bulk_delete_assets_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_exists_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_serial_exists_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/check_asset_tag_exists_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/count_assets_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/create_asset_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/delete_asset_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_asset_by_id_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_asset_by_tag_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_cursor_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_statistics_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/get_assets_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/export_asset_list_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/export_asset_data_matrix_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/generate_bulk_asset_tags_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/upload_bulk_data_matrix_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/delete_bulk_data_matrix_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/upload_bulk_asset_image_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/delete_bulk_asset_image_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/upload_template_images_usecase.dart';
import 'package:sigma_track/feature/asset/domain/usecases/update_asset_usecase.dart';

// ===== ASSET MOVEMENT USECASES =====
import 'package:sigma_track/feature/asset_movement/domain/usecases/bulk_create_asset_movements_for_location_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/bulk_create_asset_movements_for_user_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/bulk_delete_asset_movements_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/check_asset_movement_exists_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/count_asset_movements_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/delete_asset_movement_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movement_by_id_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_by_asset_id_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_cursor_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_statistics_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/get_asset_movements_usecase.dart';
import 'package:sigma_track/feature/asset_movement/domain/usecases/export_asset_movement_list_usecase.dart';

// ===== CATEGORY USECASES =====
import 'package:sigma_track/feature/category/domain/usecases/bulk_create_categories_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/bulk_delete_categories_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/check_category_code_exists_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/check_category_exists_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/count_categories_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/create_category_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/delete_category_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_categories_cursor_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_categories_statistics_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_categories_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_category_by_code_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/get_category_by_id_usecase.dart';
import 'package:sigma_track/feature/category/domain/usecases/update_category_usecase.dart';

// ===== ISSUE REPORT USECASES =====
import 'package:sigma_track/feature/issue_report/domain/usecases/bulk_create_issue_reports_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/bulk_delete_issue_reports_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/check_issue_report_exists_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/count_issue_reports_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/create_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/delete_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/get_issue_report_by_id_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/get_issue_reports_cursor_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/get_issue_reports_statistics_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/get_issue_reports_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/reopen_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/update_issue_report_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/export_issue_report_list_usecase.dart';
import 'package:sigma_track/feature/issue_report/domain/usecases/resolve_issue_report_usecase.dart';

// ===== LOCATION USECASES =====
import 'package:sigma_track/feature/location/domain/usecases/bulk_create_locations_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/bulk_delete_locations_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/check_location_code_exists_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/check_location_exists_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/count_locations_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/create_location_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/delete_location_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_location_by_code_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_location_by_id_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_locations_cursor_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_locations_statistics_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/get_locations_usecase.dart';
import 'package:sigma_track/feature/location/domain/usecases/update_location_usecase.dart';

// ===== MAINTENANCE RECORD USECASES =====
import 'package:sigma_track/feature/maintenance/domain/usecases/bulk_create_maintenance_records_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/bulk_delete_maintenance_records_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/check_maintenance_record_exists_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/count_maintenance_records_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/create_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/delete_maintenance_record_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/export_maintenance_record_list_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/export_maintenance_schedule_list_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_record_by_id_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_records_cursor_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_records_statistics_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_records_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/update_maintenance_record_usecase.dart';

// ===== MAINTENANCE SCHEDULE USECASES =====
import 'package:sigma_track/feature/maintenance/domain/usecases/bulk_create_maintenance_schedules_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/bulk_delete_maintenance_schedules_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/check_maintenance_schedule_exists_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/count_maintenance_schedules_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/create_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/delete_maintenance_schedule_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedule_by_id_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedules_cursor_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedules_statistics_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/get_maintenance_schedules_usecase.dart';
import 'package:sigma_track/feature/maintenance/domain/usecases/update_maintenance_schedule_usecase.dart';

// ===== NOTIFICATION USECASES =====
import 'package:sigma_track/feature/notification/domain/usecases/bulk_create_notifications_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/bulk_delete_notifications_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/check_notification_exists_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/count_notifications_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/create_notification_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/get_notification_by_id_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/get_notifications_cursor_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/get_notifications_statistics_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/mark_notifications_as_read_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/mark_notifications_as_unread_usecase.dart';
import 'package:sigma_track/feature/notification/domain/usecases/update_notification_usecase.dart';

// ===== SCAN LOG USECASES =====
import 'package:sigma_track/feature/scan_log/domain/usecases/bulk_create_scan_logs_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/bulk_delete_scan_logs_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/check_scan_log_exists_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/count_scan_logs_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/create_scan_log_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/delete_scan_log_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_log_by_id_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_by_asset_id_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_by_user_id_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_cursor_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_statistics_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/get_scan_logs_usecase.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/export_scan_log_list_usecase.dart';

// ===== USER USECASES =====
import 'package:sigma_track/feature/user/domain/usecases/bulk_create_users_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/bulk_delete_users_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/change_current_user_password_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/change_user_password_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/check_user_email_exists_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/check_user_exists_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/check_user_name_exists_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/count_users_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/create_user_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/delete_user_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/export_user_list_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_current_user_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_user_by_email_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_user_by_name_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_users_cursor_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_users_statistics_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/get_users_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/update_current_user_usecase.dart';
import 'package:sigma_track/feature/user/domain/usecases/update_user_usecase.dart';

// =============================================
// AUTH USECASE PROVIDERS
// =============================================
final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LoginUsecase(authRepository);
});

final getCurrentAuthUsecaseProvider = Provider<GetCurrentAuthUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GetCurrentAuthUsecase(authRepository);
});

final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository);
});

final forgotPasswordUsecaseProvider = Provider<ForgotPasswordUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return ForgotPasswordUsecase(authRepository);
});

final verifyResetCodeUsecaseProvider = Provider<VerifyResetCodeUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return VerifyResetCodeUsecase(authRepository);
});

final resetPasswordUsecaseProvider = Provider<ResetPasswordUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return ResetPasswordUsecase(authRepository);
});

final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LogoutUsecase(authRepository);
});

// =============================================
// ASSET USECASE PROVIDERS
// =============================================
final checkAssetExistsUsecaseProvider = Provider<CheckAssetExistsUsecase>((
  ref,
) {
  final assetRepository = ref.read(assetRepositoryProvider);
  return CheckAssetExistsUsecase(assetRepository);
});

final checkAssetSerialExistsUsecaseProvider =
    Provider<CheckAssetSerialExistsUsecase>((ref) {
      final assetRepository = ref.read(assetRepositoryProvider);
      return CheckAssetSerialExistsUsecase(assetRepository);
    });

final checkAssetTagExistsUsecaseProvider = Provider<CheckAssetTagExistsUsecase>(
  (ref) {
    final assetRepository = ref.read(assetRepositoryProvider);
    return CheckAssetTagExistsUsecase(assetRepository);
  },
);

final countAssetsUsecaseProvider = Provider<CountAssetsUsecase>((ref) {
  final assetRepository = ref.read(assetRepositoryProvider);
  return CountAssetsUsecase(assetRepository);
});

final createAssetUsecaseProvider = Provider<CreateAssetUsecase>((ref) {
  final assetRepository = ref.read(assetRepositoryProvider);
  return CreateAssetUsecase(assetRepository);
});

final deleteAssetUsecaseProvider = Provider<DeleteAssetUsecase>((ref) {
  final assetRepository = ref.read(assetRepositoryProvider);
  return DeleteAssetUsecase(assetRepository);
});

final bulkCreateAssetsUsecaseProvider = Provider<BulkCreateAssetsUsecase>((
  ref,
) {
  final assetRepository = ref.read(assetRepositoryProvider);
  return BulkCreateAssetsUsecase(assetRepository);
});

final bulkDeleteAssetsUsecaseProvider = Provider<BulkDeleteAssetsUsecase>((
  ref,
) {
  final assetRepository = ref.read(assetRepositoryProvider);
  return BulkDeleteAssetsUsecase(assetRepository);
});

final getAssetByIdUsecaseProvider = Provider<GetAssetByIdUsecase>((ref) {
  final assetRepository = ref.read(assetRepositoryProvider);
  return GetAssetByIdUsecase(assetRepository);
});

final getAssetByTagUsecaseProvider = Provider<GetAssetByTagUsecase>((ref) {
  final assetRepository = ref.read(assetRepositoryProvider);
  return GetAssetByTagUsecase(assetRepository);
});

final getAssetsCursorUsecaseProvider = Provider<GetAssetsCursorUsecase>((ref) {
  final assetRepository = ref.read(assetRepositoryProvider);
  return GetAssetsCursorUsecase(assetRepository);
});

final getAssetsStatisticsUsecaseProvider = Provider<GetAssetsStatisticsUsecase>(
  (ref) {
    final assetRepository = ref.read(assetRepositoryProvider);
    return GetAssetsStatisticsUsecase(assetRepository);
  },
);

final getAssetsUsecaseProvider = Provider<GetAssetsUsecase>((ref) {
  final assetRepository = ref.read(assetRepositoryProvider);
  return GetAssetsUsecase(assetRepository);
});

final updateAssetUsecaseProvider = Provider<UpdateAssetUsecase>((ref) {
  final assetRepository = ref.read(assetRepositoryProvider);
  return UpdateAssetUsecase(assetRepository);
});

final exportAssetListUsecaseProvider = Provider<ExportAssetListUsecase>((ref) {
  final assetRepository = ref.read(assetRepositoryProvider);
  return ExportAssetListUsecase(assetRepository);
});

final exportAssetDataMatrixUsecaseProvider =
    Provider<ExportAssetDataMatrixUsecase>((ref) {
      final assetRepository = ref.read(assetRepositoryProvider);
      return ExportAssetDataMatrixUsecase(assetRepository);
    });

final getGenerateAssetTagSuggestionProvider =
    Provider<GenerateAssetTagSuggestionUsecase>((ref) {
      final assetRepository = ref.read(assetRepositoryProvider);
      return GenerateAssetTagSuggestionUsecase(assetRepository);
    });

final generateBulkAssetTagsUsecaseProvider =
    Provider<GenerateBulkAssetTagsUsecase>((ref) {
      final assetRepository = ref.read(assetRepositoryProvider);
      return GenerateBulkAssetTagsUsecase(assetRepository);
    });

final uploadBulkDataMatrixUsecaseProvider =
    Provider<UploadBulkDataMatrixUsecase>((ref) {
      final assetRepository = ref.read(assetRepositoryProvider);
      return UploadBulkDataMatrixUsecase(assetRepository);
    });

final deleteBulkDataMatrixUsecaseProvider =
    Provider<DeleteBulkDataMatrixUsecase>((ref) {
      final assetRepository = ref.read(assetRepositoryProvider);
      return DeleteBulkDataMatrixUsecase(assetRepository);
    });

final uploadBulkAssetImageUsecaseProvider =
    Provider<UploadBulkAssetImageUsecase>((ref) {
      final assetRepository = ref.read(assetRepositoryProvider);
      return UploadBulkAssetImageUsecase(assetRepository);
    });

final deleteBulkAssetImageUsecaseProvider =
    Provider<DeleteBulkAssetImageUsecase>((ref) {
      final assetRepository = ref.read(assetRepositoryProvider);
      return DeleteBulkAssetImageUsecase(assetRepository);
    });

final uploadTemplateImagesUsecaseProvider =
    Provider<UploadTemplateImagesUsecase>((ref) {
      final assetRepository = ref.read(assetRepositoryProvider);
      return UploadTemplateImagesUsecase(assetRepository);
    });

// =============================================
// ASSET MOVEMENT USECASE PROVIDERS
// =============================================
final checkAssetMovementExistsUsecaseProvider =
    Provider<CheckAssetMovementExistsUsecase>((ref) {
      final assetMovementRepository = ref.read(assetMovementRepositoryProvider);
      return CheckAssetMovementExistsUsecase(assetMovementRepository);
    });

final countAssetMovementsUsecaseProvider = Provider<CountAssetMovementsUsecase>(
  (ref) {
    final assetMovementRepository = ref.read(assetMovementRepositoryProvider);
    return CountAssetMovementsUsecase(assetMovementRepository);
  },
);

final createAssetMovementForLocationUsecaseProvider =
    Provider<CreateAssetMovementForLocationUsecase>((ref) {
      final assetMovementRepository = ref.read(assetMovementRepositoryProvider);
      return CreateAssetMovementForLocationUsecase(assetMovementRepository);
    });

final createAssetMovementForUserUsecaseProvider =
    Provider<CreateAssetMovementForUserUsecase>((ref) {
      final assetMovementRepository = ref.read(assetMovementRepositoryProvider);
      return CreateAssetMovementForUserUsecase(assetMovementRepository);
    });

final deleteAssetMovementUsecaseProvider = Provider<DeleteAssetMovementUsecase>(
  (ref) {
    final assetMovementRepository = ref.read(assetMovementRepositoryProvider);
    return DeleteAssetMovementUsecase(assetMovementRepository);
  },
);

final bulkCreateAssetMovementsForLocationUsecaseProvider =
    Provider<BulkCreateAssetMovementsForLocationUsecase>((ref) {
      final assetMovementRepository = ref.read(assetMovementRepositoryProvider);
      return BulkCreateAssetMovementsForLocationUsecase(
        assetMovementRepository,
      );
    });

final bulkCreateAssetMovementsForUserUsecaseProvider =
    Provider<BulkCreateAssetMovementsForUserUsecase>((ref) {
      final assetMovementRepository = ref.read(assetMovementRepositoryProvider);
      return BulkCreateAssetMovementsForUserUsecase(assetMovementRepository);
    });

final bulkDeleteAssetMovementsUsecaseProvider =
    Provider<BulkDeleteAssetMovementsUsecase>((ref) {
      final assetMovementRepository = ref.read(assetMovementRepositoryProvider);
      return BulkDeleteAssetMovementsUsecase(assetMovementRepository);
    });

final getAssetMovementByIdUsecaseProvider =
    Provider<GetAssetMovementByIdUsecase>((ref) {
      final assetMovementRepository = ref.read(assetMovementRepositoryProvider);
      return GetAssetMovementByIdUsecase(assetMovementRepository);
    });

final getAssetMovementsByAssetIdUsecaseProvider =
    Provider<GetAssetMovementsByAssetIdUsecase>((ref) {
      final assetMovementRepository = ref.read(assetMovementRepositoryProvider);
      return GetAssetMovementsByAssetIdUsecase(assetMovementRepository);
    });

final getAssetMovementsCursorUsecaseProvider =
    Provider<GetAssetMovementsCursorUsecase>((ref) {
      final assetMovementRepository = ref.read(assetMovementRepositoryProvider);
      return GetAssetMovementsCursorUsecase(assetMovementRepository);
    });

final getAssetMovementsStatisticsUsecaseProvider =
    Provider<GetAssetMovementsStatisticsUsecase>((ref) {
      final assetMovementRepository = ref.read(assetMovementRepositoryProvider);
      return GetAssetMovementsStatisticsUsecase(assetMovementRepository);
    });

final getAssetMovementsUsecaseProvider = Provider<GetAssetMovementsUsecase>((
  ref,
) {
  final assetMovementRepository = ref.read(assetMovementRepositoryProvider);
  return GetAssetMovementsUsecase(assetMovementRepository);
});

final updateAssetMovementForLocationUsecaseProvider =
    Provider<UpdateAssetMovementForLocationUsecase>((ref) {
      final assetMovementRepository = ref.read(assetMovementRepositoryProvider);
      return UpdateAssetMovementForLocationUsecase(assetMovementRepository);
    });

final updateAssetMovementForUserUsecaseProvider =
    Provider<UpdateAssetMovementForUserUsecase>((ref) {
      final assetMovementRepository = ref.read(assetMovementRepositoryProvider);
      return UpdateAssetMovementForUserUsecase(assetMovementRepository);
    });

final exportAssetMovementListUsecaseProvider =
    Provider<ExportAssetMovementListUsecase>((ref) {
      final assetMovementRepository = ref.read(assetMovementRepositoryProvider);
      return ExportAssetMovementListUsecase(assetMovementRepository);
    });
// =============================================
// CATEGORY USECASE PROVIDERS
// =============================================
final checkCategoryCodeExistsUsecaseProvider =
    Provider<CheckCategoryCodeExistsUsecase>((ref) {
      final categoryRepository = ref.read(categoryRepositoryProvider);
      return CheckCategoryCodeExistsUsecase(categoryRepository);
    });

final checkCategoryExistsUsecaseProvider = Provider<CheckCategoryExistsUsecase>(
  (ref) {
    final categoryRepository = ref.read(categoryRepositoryProvider);
    return CheckCategoryExistsUsecase(categoryRepository);
  },
);

final countCategoriesUsecaseProvider = Provider<CountCategoriesUsecase>((ref) {
  final categoryRepository = ref.read(categoryRepositoryProvider);
  return CountCategoriesUsecase(categoryRepository);
});

final createCategoryUsecaseProvider = Provider<CreateCategoryUsecase>((ref) {
  final categoryRepository = ref.read(categoryRepositoryProvider);
  return CreateCategoryUsecase(categoryRepository);
});

final deleteCategoryUsecaseProvider = Provider<DeleteCategoryUsecase>((ref) {
  final categoryRepository = ref.read(categoryRepositoryProvider);
  return DeleteCategoryUsecase(categoryRepository);
});

final getCategoriesCursorUsecaseProvider = Provider<GetCategoriesCursorUsecase>(
  (ref) {
    final categoryRepository = ref.read(categoryRepositoryProvider);
    return GetCategoriesCursorUsecase(categoryRepository);
  },
);

final getCategoriesStatisticsUsecaseProvider =
    Provider<GetCategoriesStatisticsUsecase>((ref) {
      final categoryRepository = ref.read(categoryRepositoryProvider);
      return GetCategoriesStatisticsUsecase(categoryRepository);
    });

final getCategoriesUsecaseProvider = Provider<GetCategoriesUsecase>((ref) {
  final categoryRepository = ref.read(categoryRepositoryProvider);
  return GetCategoriesUsecase(categoryRepository);
});

final getCategoryByCodeUsecaseProvider = Provider<GetCategoryByCodeUsecase>((
  ref,
) {
  final categoryRepository = ref.read(categoryRepositoryProvider);
  return GetCategoryByCodeUsecase(categoryRepository);
});

final getCategoryByIdUsecaseProvider = Provider<GetCategoryByIdUsecase>((ref) {
  final categoryRepository = ref.read(categoryRepositoryProvider);
  return GetCategoryByIdUsecase(categoryRepository);
});

final updateCategoryUsecaseProvider = Provider<UpdateCategoryUsecase>((ref) {
  final categoryRepository = ref.read(categoryRepositoryProvider);
  return UpdateCategoryUsecase(categoryRepository);
});

final bulkCreateCategoriesUsecaseProvider =
    Provider<BulkCreateCategoriesUsecase>((ref) {
      final categoryRepository = ref.read(categoryRepositoryProvider);
      return BulkCreateCategoriesUsecase(categoryRepository);
    });

final bulkDeleteCategoriesUsecaseProvider =
    Provider<BulkDeleteCategoriesUsecase>((ref) {
      final categoryRepository = ref.read(categoryRepositoryProvider);
      return BulkDeleteCategoriesUsecase(categoryRepository);
    });

// =============================================
// ISSUE REPORT USECASE PROVIDERS
// =============================================
final checkIssueReportExistsUsecaseProvider =
    Provider<CheckIssueReportExistsUsecase>((ref) {
      final issueReportRepository = ref.read(issueReportRepositoryProvider);
      return CheckIssueReportExistsUsecase(issueReportRepository);
    });

final countIssueReportsUsecaseProvider = Provider<CountIssueReportsUsecase>((
  ref,
) {
  final issueReportRepository = ref.read(issueReportRepositoryProvider);
  return CountIssueReportsUsecase(issueReportRepository);
});

final createIssueReportUsecaseProvider = Provider<CreateIssueReportUsecase>((
  ref,
) {
  final issueReportRepository = ref.read(issueReportRepositoryProvider);
  return CreateIssueReportUsecase(issueReportRepository);
});

final deleteIssueReportUsecaseProvider = Provider<DeleteIssueReportUsecase>((
  ref,
) {
  final issueReportRepository = ref.read(issueReportRepositoryProvider);
  return DeleteIssueReportUsecase(issueReportRepository);
});

final bulkCreateIssueReportsUsecaseProvider =
    Provider<BulkCreateIssueReportsUsecase>((ref) {
      final issueReportRepository = ref.read(issueReportRepositoryProvider);
      return BulkCreateIssueReportsUsecase(issueReportRepository);
    });

final bulkDeleteIssueReportsUsecaseProvider =
    Provider<BulkDeleteIssueReportsUsecase>((ref) {
      final issueReportRepository = ref.read(issueReportRepositoryProvider);
      return BulkDeleteIssueReportsUsecase(issueReportRepository);
    });

final getIssueReportByIdUsecaseProvider = Provider<GetIssueReportByIdUsecase>((
  ref,
) {
  final issueReportRepository = ref.read(issueReportRepositoryProvider);
  return GetIssueReportByIdUsecase(issueReportRepository);
});

final getIssueReportsCursorUsecaseProvider =
    Provider<GetIssueReportsCursorUsecase>((ref) {
      final issueReportRepository = ref.read(issueReportRepositoryProvider);
      return GetIssueReportsCursorUsecase(issueReportRepository);
    });

final getIssueReportsStatisticsUsecaseProvider =
    Provider<GetIssueReportsStatisticsUsecase>((ref) {
      final issueReportRepository = ref.read(issueReportRepositoryProvider);
      return GetIssueReportsStatisticsUsecase(issueReportRepository);
    });

final getIssueReportsUsecaseProvider = Provider<GetIssueReportsUsecase>((ref) {
  final issueReportRepository = ref.read(issueReportRepositoryProvider);
  return GetIssueReportsUsecase(issueReportRepository);
});

final reopenIssueReportUsecaseProvider = Provider<ReopenIssueReportUsecase>((
  ref,
) {
  final issueReportRepository = ref.read(issueReportRepositoryProvider);
  return ReopenIssueReportUsecase(issueReportRepository);
});

final resolveIssueReportUsecaseProvider = Provider<ResolveIssueReportUsecase>((
  ref,
) {
  final issueReportRepository = ref.read(issueReportRepositoryProvider);
  return ResolveIssueReportUsecase(issueReportRepository);
});

final updateIssueReportUsecaseProvider = Provider<UpdateIssueReportUsecase>((
  ref,
) {
  final issueReportRepository = ref.read(issueReportRepositoryProvider);
  return UpdateIssueReportUsecase(issueReportRepository);
});

final exportIssueReportListUsecaseProvider =
    Provider<ExportIssueReportListUsecase>((ref) {
      final issueReportRepository = ref.read(issueReportRepositoryProvider);
      return ExportIssueReportListUsecase(issueReportRepository);
    });

// =============================================
// LOCATION USECASE PROVIDERS
// =============================================
final checkLocationCodeExistsUsecaseProvider =
    Provider<CheckLocationCodeExistsUsecase>((ref) {
      final locationRepository = ref.read(locationRepositoryProvider);
      return CheckLocationCodeExistsUsecase(locationRepository);
    });

final checkLocationExistsUsecaseProvider = Provider<CheckLocationExistsUsecase>(
  (ref) {
    final locationRepository = ref.read(locationRepositoryProvider);
    return CheckLocationExistsUsecase(locationRepository);
  },
);

final countLocationsUsecaseProvider = Provider<CountLocationsUsecase>((ref) {
  final locationRepository = ref.read(locationRepositoryProvider);
  return CountLocationsUsecase(locationRepository);
});

final createLocationUsecaseProvider = Provider<CreateLocationUsecase>((ref) {
  final locationRepository = ref.read(locationRepositoryProvider);
  return CreateLocationUsecase(locationRepository);
});

final deleteLocationUsecaseProvider = Provider<DeleteLocationUsecase>((ref) {
  final locationRepository = ref.read(locationRepositoryProvider);
  return DeleteLocationUsecase(locationRepository);
});

final bulkCreateLocationsUsecaseProvider = Provider<BulkCreateLocationsUsecase>(
  (ref) {
    final locationRepository = ref.read(locationRepositoryProvider);
    return BulkCreateLocationsUsecase(locationRepository);
  },
);

final bulkDeleteLocationsUsecaseProvider = Provider<BulkDeleteLocationsUsecase>(
  (ref) {
    final locationRepository = ref.read(locationRepositoryProvider);
    return BulkDeleteLocationsUsecase(locationRepository);
  },
);

final getLocationByCodeUsecaseProvider = Provider<GetLocationByCodeUsecase>((
  ref,
) {
  final locationRepository = ref.read(locationRepositoryProvider);
  return GetLocationByCodeUsecase(locationRepository);
});

final getLocationByIdUsecaseProvider = Provider<GetLocationByIdUsecase>((ref) {
  final locationRepository = ref.read(locationRepositoryProvider);
  return GetLocationByIdUsecase(locationRepository);
});

final getLocationsCursorUsecaseProvider = Provider<GetLocationsCursorUsecase>((
  ref,
) {
  final locationRepository = ref.read(locationRepositoryProvider);
  return GetLocationsCursorUsecase(locationRepository);
});

final getLocationsStatisticsUsecaseProvider =
    Provider<GetLocationsStatisticsUsecase>((ref) {
      final locationRepository = ref.read(locationRepositoryProvider);
      return GetLocationsStatisticsUsecase(locationRepository);
    });

final getLocationsUsecaseProvider = Provider<GetLocationsUsecase>((ref) {
  final locationRepository = ref.read(locationRepositoryProvider);
  return GetLocationsUsecase(locationRepository);
});

final updateLocationUsecaseProvider = Provider<UpdateLocationUsecase>((ref) {
  final locationRepository = ref.read(locationRepositoryProvider);
  return UpdateLocationUsecase(locationRepository);
});

// =============================================
// MAINTENANCE RECORD USECASE PROVIDERS
// =============================================
final checkMaintenanceRecordExistsUsecaseProvider =
    Provider<CheckMaintenanceRecordExistsUsecase>((ref) {
      final maintenanceRecordRepository = ref.read(
        maintenanceRecordRepositoryProvider,
      );
      return CheckMaintenanceRecordExistsUsecase(maintenanceRecordRepository);
    });

final countMaintenanceRecordsUsecaseProvider =
    Provider<CountMaintenanceRecordsUsecase>((ref) {
      final maintenanceRecordRepository = ref.read(
        maintenanceRecordRepositoryProvider,
      );
      return CountMaintenanceRecordsUsecase(maintenanceRecordRepository);
    });

final createMaintenanceRecordUsecaseProvider =
    Provider<CreateMaintenanceRecordUsecase>((ref) {
      final maintenanceRecordRepository = ref.read(
        maintenanceRecordRepositoryProvider,
      );
      return CreateMaintenanceRecordUsecase(maintenanceRecordRepository);
    });

final deleteMaintenanceRecordUsecaseProvider =
    Provider<DeleteMaintenanceRecordUsecase>((ref) {
      final maintenanceRecordRepository = ref.read(
        maintenanceRecordRepositoryProvider,
      );
      return DeleteMaintenanceRecordUsecase(maintenanceRecordRepository);
    });

final bulkCreateMaintenanceRecordsUsecaseProvider =
    Provider<BulkCreateMaintenanceRecordsUsecase>((ref) {
      final maintenanceRecordRepository = ref.read(
        maintenanceRecordRepositoryProvider,
      );
      return BulkCreateMaintenanceRecordsUsecase(maintenanceRecordRepository);
    });

final bulkDeleteMaintenanceRecordsUsecaseProvider =
    Provider<BulkDeleteMaintenanceRecordsUsecase>((ref) {
      final maintenanceRecordRepository = ref.read(
        maintenanceRecordRepositoryProvider,
      );
      return BulkDeleteMaintenanceRecordsUsecase(maintenanceRecordRepository);
    });

final getMaintenanceRecordByIdUsecaseProvider =
    Provider<GetMaintenanceRecordByIdUsecase>((ref) {
      final maintenanceRecordRepository = ref.read(
        maintenanceRecordRepositoryProvider,
      );
      return GetMaintenanceRecordByIdUsecase(maintenanceRecordRepository);
    });

final getMaintenanceRecordsCursorUsecaseProvider =
    Provider<GetMaintenanceRecordsCursorUsecase>((ref) {
      final maintenanceRecordRepository = ref.read(
        maintenanceRecordRepositoryProvider,
      );
      return GetMaintenanceRecordsCursorUsecase(maintenanceRecordRepository);
    });

final getMaintenanceRecordsStatisticsUsecaseProvider =
    Provider<GetMaintenanceRecordsStatisticsUsecase>((ref) {
      final maintenanceRecordRepository = ref.read(
        maintenanceRecordRepositoryProvider,
      );
      return GetMaintenanceRecordsStatisticsUsecase(
        maintenanceRecordRepository,
      );
    });

final getMaintenanceRecordsUsecaseProvider =
    Provider<GetMaintenanceRecordsUsecase>((ref) {
      final maintenanceRecordRepository = ref.read(
        maintenanceRecordRepositoryProvider,
      );
      return GetMaintenanceRecordsUsecase(maintenanceRecordRepository);
    });

final updateMaintenanceRecordUsecaseProvider =
    Provider<UpdateMaintenanceRecordUsecase>((ref) {
      final maintenanceRecordRepository = ref.read(
        maintenanceRecordRepositoryProvider,
      );
      return UpdateMaintenanceRecordUsecase(maintenanceRecordRepository);
    });

final exportMaintenanceRecordListUsecaseProvider =
    Provider<ExportMaintenanceRecordListUsecase>((ref) {
      final maintenanceRecordRepository = ref.read(
        maintenanceRecordRepositoryProvider,
      );
      return ExportMaintenanceRecordListUsecase(maintenanceRecordRepository);
    });

// =============================================
// MAINTENANCE SCHEDULE USECASE PROVIDERS
// =============================================
final checkMaintenanceScheduleExistsUsecaseProvider =
    Provider<CheckMaintenanceScheduleExistsUsecase>((ref) {
      final maintenanceScheduleRepository = ref.read(
        maintenanceScheduleRepositoryProvider,
      );
      return CheckMaintenanceScheduleExistsUsecase(
        maintenanceScheduleRepository,
      );
    });

final countMaintenanceSchedulesUsecaseProvider =
    Provider<CountMaintenanceSchedulesUsecase>((ref) {
      final maintenanceScheduleRepository = ref.read(
        maintenanceScheduleRepositoryProvider,
      );
      return CountMaintenanceSchedulesUsecase(maintenanceScheduleRepository);
    });

final createMaintenanceScheduleUsecaseProvider =
    Provider<CreateMaintenanceScheduleUsecase>((ref) {
      final maintenanceScheduleRepository = ref.read(
        maintenanceScheduleRepositoryProvider,
      );
      return CreateMaintenanceScheduleUsecase(maintenanceScheduleRepository);
    });

final deleteMaintenanceScheduleUsecaseProvider =
    Provider<DeleteMaintenanceScheduleUsecase>((ref) {
      final maintenanceScheduleRepository = ref.read(
        maintenanceScheduleRepositoryProvider,
      );
      return DeleteMaintenanceScheduleUsecase(maintenanceScheduleRepository);
    });

final bulkCreateMaintenanceSchedulesUsecaseProvider =
    Provider<BulkCreateMaintenanceSchedulesUsecase>((ref) {
      final maintenanceScheduleRepository = ref.read(
        maintenanceScheduleRepositoryProvider,
      );
      return BulkCreateMaintenanceSchedulesUsecase(
        maintenanceScheduleRepository,
      );
    });

final bulkDeleteMaintenanceSchedulesUsecaseProvider =
    Provider<BulkDeleteMaintenanceSchedulesUsecase>((ref) {
      final maintenanceScheduleRepository = ref.read(
        maintenanceScheduleRepositoryProvider,
      );
      return BulkDeleteMaintenanceSchedulesUsecase(
        maintenanceScheduleRepository,
      );
    });

final getMaintenanceScheduleByIdUsecaseProvider =
    Provider<GetMaintenanceScheduleByIdUsecase>((ref) {
      final maintenanceScheduleRepository = ref.read(
        maintenanceScheduleRepositoryProvider,
      );
      return GetMaintenanceScheduleByIdUsecase(maintenanceScheduleRepository);
    });

final getMaintenanceSchedulesCursorUsecaseProvider =
    Provider<GetMaintenanceSchedulesCursorUsecase>((ref) {
      final maintenanceScheduleRepository = ref.read(
        maintenanceScheduleRepositoryProvider,
      );
      return GetMaintenanceSchedulesCursorUsecase(
        maintenanceScheduleRepository,
      );
    });

final getMaintenanceSchedulesStatisticsUsecaseProvider =
    Provider<GetMaintenanceSchedulesStatisticsUsecase>((ref) {
      final maintenanceScheduleRepository = ref.read(
        maintenanceScheduleRepositoryProvider,
      );
      return GetMaintenanceSchedulesStatisticsUsecase(
        maintenanceScheduleRepository,
      );
    });

final getMaintenanceSchedulesUsecaseProvider =
    Provider<GetMaintenanceSchedulesUsecase>((ref) {
      final maintenanceScheduleRepository = ref.read(
        maintenanceScheduleRepositoryProvider,
      );
      return GetMaintenanceSchedulesUsecase(maintenanceScheduleRepository);
    });

final updateMaintenanceScheduleUsecaseProvider =
    Provider<UpdateMaintenanceScheduleUsecase>((ref) {
      final maintenanceScheduleRepository = ref.read(
        maintenanceScheduleRepositoryProvider,
      );
      return UpdateMaintenanceScheduleUsecase(maintenanceScheduleRepository);
    });

final exportMaintenanceScheduleListUsecaseProvider =
    Provider<ExportMaintenanceScheduleListUsecase>((ref) {
      final maintenanceScheduleRepository = ref.read(
        maintenanceScheduleRepositoryProvider,
      );
      return ExportMaintenanceScheduleListUsecase(
        maintenanceScheduleRepository,
      );
    });

// =============================================
// NOTIFICATION USECASE PROVIDERS
// =============================================
final checkNotificationExistsUsecaseProvider =
    Provider<CheckNotificationExistsUsecase>((ref) {
      final notificationRepository = ref.read(notificationRepositoryProvider);
      return CheckNotificationExistsUsecase(notificationRepository);
    });

final countNotificationsUsecaseProvider = Provider<CountNotificationsUsecase>((
  ref,
) {
  final notificationRepository = ref.read(notificationRepositoryProvider);
  return CountNotificationsUsecase(notificationRepository);
});

final createNotificationUsecaseProvider = Provider<CreateNotificationUsecase>((
  ref,
) {
  final notificationRepository = ref.read(notificationRepositoryProvider);
  return CreateNotificationUsecase(notificationRepository);
});

final deleteNotificationUsecaseProvider = Provider<DeleteNotificationUsecase>((
  ref,
) {
  final notificationRepository = ref.read(notificationRepositoryProvider);
  return DeleteNotificationUsecase(notificationRepository);
});

final bulkCreateNotificationsUsecaseProvider =
    Provider<BulkCreateNotificationsUsecase>((ref) {
      final notificationRepository = ref.read(notificationRepositoryProvider);
      return BulkCreateNotificationsUsecase(notificationRepository);
    });

final bulkDeleteNotificationsUsecaseProvider =
    Provider<BulkDeleteNotificationsUsecase>((ref) {
      final notificationRepository = ref.read(notificationRepositoryProvider);
      return BulkDeleteNotificationsUsecase(notificationRepository);
    });

final getNotificationByIdUsecaseProvider = Provider<GetNotificationByIdUsecase>(
  (ref) {
    final notificationRepository = ref.read(notificationRepositoryProvider);
    return GetNotificationByIdUsecase(notificationRepository);
  },
);

final getNotificationsCursorUsecaseProvider =
    Provider<GetNotificationsCursorUsecase>((ref) {
      final notificationRepository = ref.read(notificationRepositoryProvider);
      return GetNotificationsCursorUsecase(notificationRepository);
    });

final getNotificationsStatisticsUsecaseProvider =
    Provider<GetNotificationsStatisticsUsecase>((ref) {
      final notificationRepository = ref.read(notificationRepositoryProvider);
      return GetNotificationsStatisticsUsecase(notificationRepository);
    });

final getNotificationsUsecaseProvider = Provider<GetNotificationsUsecase>((
  ref,
) {
  final notificationRepository = ref.read(notificationRepositoryProvider);
  return GetNotificationsUsecase(notificationRepository);
});

final markNotificationsAsReadUsecaseProvider =
    Provider<MarkNotificationsAsReadUsecase>((ref) {
      final notificationRepository = ref.read(notificationRepositoryProvider);
      return MarkNotificationsAsReadUsecase(notificationRepository);
    });

final markNotificationsAsUnreadUsecaseProvider =
    Provider<MarkNotificationsAsUnreadUsecase>((ref) {
      final notificationRepository = ref.read(notificationRepositoryProvider);
      return MarkNotificationsAsUnreadUsecase(notificationRepository);
    });

final updateNotificationUsecaseProvider = Provider<UpdateNotificationUsecase>((
  ref,
) {
  final notificationRepository = ref.read(notificationRepositoryProvider);
  return UpdateNotificationUsecase(notificationRepository);
});

// =============================================
// SCAN LOG USECASE PROVIDERS
// =============================================
final checkScanLogExistsUsecaseProvider = Provider<CheckScanLogExistsUsecase>((
  ref,
) {
  final scanLogRepository = ref.read(scanLogRepositoryProvider);
  return CheckScanLogExistsUsecase(scanLogRepository);
});

final countScanLogsUsecaseProvider = Provider<CountScanLogsUsecase>((ref) {
  final scanLogRepository = ref.read(scanLogRepositoryProvider);
  return CountScanLogsUsecase(scanLogRepository);
});

final createScanLogUsecaseProvider = Provider<CreateScanLogUsecase>((ref) {
  final scanLogRepository = ref.read(scanLogRepositoryProvider);
  return CreateScanLogUsecase(scanLogRepository);
});

final deleteScanLogUsecaseProvider = Provider<DeleteScanLogUsecase>((ref) {
  final scanLogRepository = ref.read(scanLogRepositoryProvider);
  return DeleteScanLogUsecase(scanLogRepository);
});

final bulkCreateScanLogsUsecaseProvider = Provider<BulkCreateScanLogsUsecase>((
  ref,
) {
  final scanLogRepository = ref.read(scanLogRepositoryProvider);
  return BulkCreateScanLogsUsecase(scanLogRepository);
});

final bulkDeleteScanLogsUsecaseProvider = Provider<BulkDeleteScanLogsUsecase>((
  ref,
) {
  final scanLogRepository = ref.read(scanLogRepositoryProvider);
  return BulkDeleteScanLogsUsecase(scanLogRepository);
});

final getScanLogByIdUsecaseProvider = Provider<GetScanLogByIdUsecase>((ref) {
  final scanLogRepository = ref.read(scanLogRepositoryProvider);
  return GetScanLogByIdUsecase(scanLogRepository);
});

final getScanLogsByAssetIdUsecaseProvider =
    Provider<GetScanLogsByAssetIdUsecase>((ref) {
      final scanLogRepository = ref.read(scanLogRepositoryProvider);
      return GetScanLogsByAssetIdUsecase(scanLogRepository);
    });

final getScanLogsByUserIdUsecaseProvider = Provider<GetScanLogsByUserIdUsecase>(
  (ref) {
    final scanLogRepository = ref.read(scanLogRepositoryProvider);
    return GetScanLogsByUserIdUsecase(scanLogRepository);
  },
);

final getScanLogsCursorUsecaseProvider = Provider<GetScanLogsCursorUsecase>((
  ref,
) {
  final scanLogRepository = ref.read(scanLogRepositoryProvider);
  return GetScanLogsCursorUsecase(scanLogRepository);
});

final getScanLogsStatisticsUsecaseProvider =
    Provider<GetScanLogsStatisticsUsecase>((ref) {
      final scanLogRepository = ref.read(scanLogRepositoryProvider);
      return GetScanLogsStatisticsUsecase(scanLogRepository);
    });

final getScanLogsUsecaseProvider = Provider<GetScanLogsUsecase>((ref) {
  final scanLogRepository = ref.read(scanLogRepositoryProvider);
  return GetScanLogsUsecase(scanLogRepository);
});

final exportScanLogListUsecaseProvider = Provider<ExportScanLogListUsecase>((
  ref,
) {
  final scanLogRepository = ref.read(scanLogRepositoryProvider);
  return ExportScanLogListUsecase(scanLogRepository);
});

// ===== USER USECASE PROVIDERS =====
final checkUserEmailExistsUsecaseProvider =
    Provider<CheckUserEmailExistsUsecase>((ref) {
      final userRepository = ref.read(userRepositoryProvider);
      return CheckUserEmailExistsUsecase(userRepository);
    });

final checkUserExistsUsecaseProvider = Provider<CheckUserExistsUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return CheckUserExistsUsecase(userRepository);
});

final checkUserNameExistsUsecaseProvider = Provider<CheckUserNameExistsUsecase>(
  (ref) {
    final userRepository = ref.read(userRepositoryProvider);
    return CheckUserNameExistsUsecase(userRepository);
  },
);

final countUsersUsecaseProvider = Provider<CountUsersUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return CountUsersUsecase(userRepository);
});

final createUserUsecaseProvider = Provider<CreateUserUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return CreateUserUsecase(userRepository);
});

final deleteUserUsecaseProvider = Provider<DeleteUserUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return DeleteUserUsecase(userRepository);
});

final bulkCreateUsersUsecaseProvider = Provider<BulkCreateUsersUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return BulkCreateUsersUsecase(userRepository);
});

final bulkDeleteUsersUsecaseProvider = Provider<BulkDeleteUsersUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return BulkDeleteUsersUsecase(userRepository);
});

final getCurrentUserUsecaseProvider = Provider<GetCurrentUserUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetCurrentUserUsecase(userRepository);
});

final updateCurrentUserUsecaseProvider = Provider<UpdateCurrentUserUsecase>((
  ref,
) {
  final userRepository = ref.read(userRepositoryProvider);
  return UpdateCurrentUserUsecase(userRepository);
});

final getUserByEmailUsecaseProvider = Provider<GetUserByEmailUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetUserByEmailUsecase(userRepository);
});

final getUserByIdUsecaseProvider = Provider<GetUserByIdUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetUserByIdUsecase(userRepository);
});

final getUserByNameUsecaseProvider = Provider<GetUserByNameUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetUserByNameUsecase(userRepository);
});

final getUsersCursorUsecaseProvider = Provider<GetUsersCursorUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetUsersCursorUsecase(userRepository);
});

final getUsersStatisticsUsecaseProvider = Provider<GetUsersStatisticsUsecase>((
  ref,
) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetUsersStatisticsUsecase(userRepository);
});

final getUsersUsecaseProvider = Provider<GetUsersUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetUsersUsecase(userRepository);
});

final updateUserUsecaseProvider = Provider<UpdateUserUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return UpdateUserUsecase(userRepository);
});

final changeUserPasswordUsecaseProvider = Provider<ChangeUserPasswordUsecase>((
  ref,
) {
  final userRepository = ref.read(userRepositoryProvider);
  return ChangeUserPasswordUsecase(userRepository);
});

final changeCurrentUserPasswordUsecaseProvider =
    Provider<ChangeCurrentUserPasswordUsecase>((ref) {
      final userRepository = ref.read(userRepositoryProvider);
      return ChangeCurrentUserPasswordUsecase(userRepository);
    });

final exportUserListUsecaseProvider = Provider<ExportUserListUsecase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return ExportUserListUsecase(userRepository);
});
