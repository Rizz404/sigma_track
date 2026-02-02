import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';

enum SortOrder {
  asc('asc'),
  desc('desc');

  const SortOrder(this.value);
  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case SortOrder.asc:
        return l10n.enumSortOrderAsc;
      case SortOrder.desc:
        return l10n.enumSortOrderDesc;
    }
  }

  IconData get icon {
    switch (this) {
      case SortOrder.asc:
        return Icons.arrow_upward;
      case SortOrder.desc:
        return Icons.arrow_downward;
    }
  }
}

enum CategorySortBy {
  categoryCode('categoryCode'),
  name('name'),
  categoryName('categoryName'),
  createdAt('createdAt'),
  updatedAt('updatedAt');

  const CategorySortBy(this.value);
  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case CategorySortBy.categoryCode:
        return l10n.enumCategorySortByCategoryCode;
      case CategorySortBy.name:
        return l10n.enumCategorySortByName;
      case CategorySortBy.categoryName:
        return l10n.enumCategorySortByCategoryName;
      case CategorySortBy.createdAt:
        return l10n.enumCategorySortByCreatedAt;
      case CategorySortBy.updatedAt:
        return l10n.enumCategorySortByUpdatedAt;
    }
  }

  IconData get icon {
    switch (this) {
      case CategorySortBy.categoryCode:
        return Icons.code;
      case CategorySortBy.name:
      case CategorySortBy.categoryName:
        return Icons.sort_by_alpha;
      case CategorySortBy.createdAt:
        return Icons.calendar_today;
      case CategorySortBy.updatedAt:
        return Icons.update;
    }
  }
}

enum LocationSortBy {
  locationCode('locationCode'),
  name('name'),
  locationName('locationName'),
  building('building'),
  floor('floor'),
  createdAt('createdAt'),
  updatedAt('updatedAt');

  const LocationSortBy(this.value);
  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case LocationSortBy.locationCode:
        return l10n.enumLocationSortByLocationCode;
      case LocationSortBy.name:
        return l10n.enumLocationSortByName;
      case LocationSortBy.locationName:
        return l10n.enumLocationSortByLocationName;
      case LocationSortBy.building:
        return l10n.enumLocationSortByBuilding;
      case LocationSortBy.floor:
        return l10n.enumLocationSortByFloor;
      case LocationSortBy.createdAt:
        return l10n.enumLocationSortByCreatedAt;
      case LocationSortBy.updatedAt:
        return l10n.enumLocationSortByUpdatedAt;
    }
  }

  IconData get icon {
    switch (this) {
      case LocationSortBy.locationCode:
        return Icons.code;
      case LocationSortBy.name:
      case LocationSortBy.locationName:
        return Icons.sort_by_alpha;
      case LocationSortBy.building:
        return Icons.business;
      case LocationSortBy.floor:
        return Icons.layers;
      case LocationSortBy.createdAt:
        return Icons.calendar_today;
      case LocationSortBy.updatedAt:
        return Icons.update;
    }
  }
}

enum NotificationSortBy {
  type('type'),
  isRead('isRead'),
  createdAt('createdAt'),
  title('title'),
  message('message');

  const NotificationSortBy(this.value);
  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case NotificationSortBy.type:
        return l10n.enumNotificationSortByType;
      case NotificationSortBy.isRead:
        return l10n.enumNotificationSortByIsRead;
      case NotificationSortBy.createdAt:
        return l10n.enumNotificationSortByCreatedAt;
      case NotificationSortBy.title:
        return l10n.enumNotificationSortByTitle;
      case NotificationSortBy.message:
        return l10n.enumNotificationSortByMessage;
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationSortBy.type:
        return Icons.category;
      case NotificationSortBy.isRead:
        return Icons.visibility;
      case NotificationSortBy.createdAt:
        return Icons.calendar_today;
      case NotificationSortBy.title:
        return Icons.title;
      case NotificationSortBy.message:
        return Icons.message;
    }
  }
}

enum ScanLogSortBy {
  scanTimestamp('scanTimestamp'),
  scannedValue('scannedValue'),
  scanMethod('scanMethod'),
  scanResult('scanResult');

  const ScanLogSortBy(this.value);
  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case ScanLogSortBy.scanTimestamp:
        return l10n.enumScanLogSortByScanTimestamp;
      case ScanLogSortBy.scannedValue:
        return l10n.enumScanLogSortByScannedValue;
      case ScanLogSortBy.scanMethod:
        return l10n.enumScanLogSortByScanMethod;
      case ScanLogSortBy.scanResult:
        return l10n.enumScanLogSortByScanResult;
    }
  }

  IconData get icon {
    switch (this) {
      case ScanLogSortBy.scanTimestamp:
        return Icons.access_time;
      case ScanLogSortBy.scannedValue:
        return Icons.qr_code;
      case ScanLogSortBy.scanMethod:
        return Icons.input;
      case ScanLogSortBy.scanResult:
        return Icons.check_circle;
    }
  }
}

enum AssetSortBy {
  assetTag('assetTag'),
  assetName('assetName'),
  brand('brand'),
  model('model'),
  serialNumber('serialNumber'),
  purchaseDate('purchaseDate'),
  purchasePrice('purchasePrice'),
  vendorName('vendorName'),
  warrantyEnd('warrantyEnd'),
  status('status'),
  conditionStatus('conditionStatus'),
  createdAt('createdAt'),
  updatedAt('updatedAt');

  const AssetSortBy(this.value);
  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case AssetSortBy.assetTag:
        return l10n.enumAssetSortByAssetTag;
      case AssetSortBy.assetName:
        return l10n.enumAssetSortByAssetName;
      case AssetSortBy.brand:
        return l10n.enumAssetSortByBrand;
      case AssetSortBy.model:
        return l10n.enumAssetSortByModel;
      case AssetSortBy.serialNumber:
        return l10n.enumAssetSortBySerialNumber;
      case AssetSortBy.purchaseDate:
        return l10n.enumAssetSortByPurchaseDate;
      case AssetSortBy.purchasePrice:
        return l10n.enumAssetSortByPurchasePrice;
      case AssetSortBy.vendorName:
        return l10n.enumAssetSortByVendorName;
      case AssetSortBy.warrantyEnd:
        return l10n.enumAssetSortByWarrantyEnd;
      case AssetSortBy.status:
        return l10n.enumAssetSortByStatus;
      case AssetSortBy.conditionStatus:
        return l10n.enumAssetSortByConditionStatus;
      case AssetSortBy.createdAt:
        return l10n.enumAssetSortByCreatedAt;
      case AssetSortBy.updatedAt:
        return l10n.enumAssetSortByUpdatedAt;
    }
  }

  IconData get icon {
    switch (this) {
      case AssetSortBy.assetTag:
        return Icons.tag;
      case AssetSortBy.assetName:
        return Icons.inventory;
      case AssetSortBy.brand:
        return Icons.branding_watermark;
      case AssetSortBy.model:
        return Icons.devices;
      case AssetSortBy.serialNumber:
        return Icons.confirmation_number;
      case AssetSortBy.purchaseDate:
        return Icons.calendar_today;
      case AssetSortBy.purchasePrice:
        return Icons.attach_money;
      case AssetSortBy.vendorName:
        return Icons.business;
      case AssetSortBy.warrantyEnd:
        return Icons.shield;
      case AssetSortBy.status:
        return Icons.info;
      case AssetSortBy.conditionStatus:
        return Icons.build;
      case AssetSortBy.createdAt:
        return Icons.calendar_today;
      case AssetSortBy.updatedAt:
        return Icons.update;
    }
  }
}

enum AssetMovementSortBy {
  movementDate('movementDate'),
  movementdate('movementdate'),
  createdAt('createdAt'),
  createdat('createdat'),
  updatedAt('updatedAt'),
  updatedat('updatedat');

  const AssetMovementSortBy(this.value);
  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case AssetMovementSortBy.movementDate:
      case AssetMovementSortBy.movementdate:
        return l10n.enumAssetMovementSortByMovementDate;
      case AssetMovementSortBy.createdAt:
      case AssetMovementSortBy.createdat:
        return l10n.enumAssetMovementSortByCreatedAt;
      case AssetMovementSortBy.updatedAt:
      case AssetMovementSortBy.updatedat:
        return l10n.enumAssetMovementSortByUpdatedAt;
    }
  }

  IconData get icon {
    switch (this) {
      case AssetMovementSortBy.movementDate:
      case AssetMovementSortBy.movementdate:
        return Icons.move_down;
      case AssetMovementSortBy.createdAt:
      case AssetMovementSortBy.createdat:
        return Icons.calendar_today;
      case AssetMovementSortBy.updatedAt:
      case AssetMovementSortBy.updatedat:
        return Icons.update;
    }
  }
}

enum IssueReportSortBy {
  reportedDate('reportedDate'),
  resolvedDate('resolvedDate'),
  issueType('issueType'),
  priority('priority'),
  status('status'),
  title('title'),
  description('description'),
  createdAt('createdAt'),
  updatedAt('updatedAt');

  const IssueReportSortBy(this.value);
  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case IssueReportSortBy.reportedDate:
        return l10n.enumIssueReportSortByReportedDate;
      case IssueReportSortBy.resolvedDate:
        return l10n.enumIssueReportSortByResolvedDate;
      case IssueReportSortBy.issueType:
        return l10n.enumIssueReportSortByIssueType;
      case IssueReportSortBy.priority:
        return l10n.enumIssueReportSortByPriority;
      case IssueReportSortBy.status:
        return l10n.enumIssueReportSortByStatus;
      case IssueReportSortBy.title:
        return l10n.enumIssueReportSortByTitle;
      case IssueReportSortBy.description:
        return l10n.enumIssueReportSortByDescription;
      case IssueReportSortBy.createdAt:
        return l10n.enumIssueReportSortByCreatedAt;
      case IssueReportSortBy.updatedAt:
        return l10n.enumIssueReportSortByUpdatedAt;
    }
  }

  IconData get icon {
    switch (this) {
      case IssueReportSortBy.reportedDate:
        return Icons.report;
      case IssueReportSortBy.resolvedDate:
        return Icons.check_circle;
      case IssueReportSortBy.issueType:
        return Icons.category;
      case IssueReportSortBy.priority:
        return Icons.priority_high;
      case IssueReportSortBy.status:
        return Icons.info;
      case IssueReportSortBy.title:
        return Icons.title;
      case IssueReportSortBy.description:
        return Icons.description;
      case IssueReportSortBy.createdAt:
        return Icons.calendar_today;
      case IssueReportSortBy.updatedAt:
        return Icons.update;
    }
  }
}

enum MaintenanceScheduleSortBy {
  nextScheduledDate('nextScheduledDate'),
  maintenanceType('maintenanceType'),
  state('state'),
  createdAt('createdAt'),
  updatedAt('updatedAt');

  const MaintenanceScheduleSortBy(this.value);
  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case MaintenanceScheduleSortBy.nextScheduledDate:
        return l10n.enumMaintenanceScheduleSortByNextScheduledDate;
      case MaintenanceScheduleSortBy.maintenanceType:
        return l10n.enumMaintenanceScheduleSortByMaintenanceType;
      case MaintenanceScheduleSortBy.state:
        return l10n.enumMaintenanceScheduleSortByState;
      case MaintenanceScheduleSortBy.createdAt:
        return l10n.enumMaintenanceScheduleSortByCreatedAt;
      case MaintenanceScheduleSortBy.updatedAt:
        return l10n.enumMaintenanceScheduleSortByUpdatedAt;
    }
  }

  IconData get icon {
    switch (this) {
      case MaintenanceScheduleSortBy.nextScheduledDate:
        return Icons.schedule;
      case MaintenanceScheduleSortBy.maintenanceType:
        return Icons.build;
      case MaintenanceScheduleSortBy.state:
        return Icons.info;
      case MaintenanceScheduleSortBy.createdAt:
        return Icons.calendar_today;
      case MaintenanceScheduleSortBy.updatedAt:
        return Icons.update;
    }
  }
}

enum MaintenanceRecordSortBy {
  maintenanceDate('maintenanceDate'),
  actualCost('actualCost'),
  title('title'),
  createdAt('createdAt'),
  updatedAt('updatedAt');

  const MaintenanceRecordSortBy(this.value);
  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case MaintenanceRecordSortBy.maintenanceDate:
        return l10n.enumMaintenanceRecordSortByMaintenanceDate;
      case MaintenanceRecordSortBy.actualCost:
        return l10n.enumMaintenanceRecordSortByActualCost;
      case MaintenanceRecordSortBy.title:
        return l10n.enumMaintenanceRecordSortByTitle;
      case MaintenanceRecordSortBy.createdAt:
        return l10n.enumMaintenanceRecordSortByCreatedAt;
      case MaintenanceRecordSortBy.updatedAt:
        return l10n.enumMaintenanceRecordSortByUpdatedAt;
    }
  }

  IconData get icon {
    switch (this) {
      case MaintenanceRecordSortBy.maintenanceDate:
        return Icons.build;
      case MaintenanceRecordSortBy.actualCost:
        return Icons.attach_money;
      case MaintenanceRecordSortBy.title:
        return Icons.title;
      case MaintenanceRecordSortBy.createdAt:
        return Icons.calendar_today;
      case MaintenanceRecordSortBy.updatedAt:
        return Icons.update;
    }
  }
}

enum UserSortBy {
  name('name'),
  fullName('fullName'),
  email('email'),
  role('role'),
  employeeId('employeeId'),
  isActive('isActive'),
  createdAt('createdAt'),
  updatedAt('updatedAt');

  const UserSortBy(this.value);
  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case UserSortBy.name:
        return l10n.enumUserSortByName;
      case UserSortBy.fullName:
        return l10n.enumUserSortByFullName;
      case UserSortBy.email:
        return l10n.enumUserSortByEmail;
      case UserSortBy.role:
        return l10n.enumUserSortByRole;
      case UserSortBy.employeeId:
        return l10n.enumUserSortByEmployeeId;
      case UserSortBy.isActive:
        return l10n.enumUserSortByIsActive;
      case UserSortBy.createdAt:
        return l10n.enumUserSortByCreatedAt;
      case UserSortBy.updatedAt:
        return l10n.enumUserSortByUpdatedAt;
    }
  }

  IconData get icon {
    switch (this) {
      case UserSortBy.name:
        return Icons.person;
      case UserSortBy.fullName:
        return Icons.person_outline;
      case UserSortBy.email:
        return Icons.email;
      case UserSortBy.role:
        return Icons.admin_panel_settings;
      case UserSortBy.employeeId:
        return Icons.badge;
      case UserSortBy.isActive:
        return Icons.check_circle;
      case UserSortBy.createdAt:
        return Icons.calendar_today;
      case UserSortBy.updatedAt:
        return Icons.update;
    }
  }
}

enum ExportFormat {
  pdf('pdf'),
  excel('xlsx');

  const ExportFormat(this.value);
  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case ExportFormat.pdf:
        return l10n.enumExportFormatPdf;
      case ExportFormat.excel:
        return l10n.enumExportFormatExcel;
    }
  }

  IconData get icon {
    switch (this) {
      case ExportFormat.pdf:
        return Icons.picture_as_pdf;
      case ExportFormat.excel:
        return Icons.table_chart;
    }
  }
}
