import 'package:flutter/material.dart';

enum SortOrder {
  asc('asc'),
  desc('desc');

  const SortOrder(this.value);
  final String value;

  // * Dropdown helper
  String get label => value;

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
  String get label => value;

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
  String get label => value;

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
  String get label => value;

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
  String get label => value;

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
  String get label => value;

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
  String get label => value;

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
  String get label => value;

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
  scheduledDate('scheduledDate'),
  title('title'),
  createdAt('createdAt'),
  updatedAt('updatedAt');

  const MaintenanceScheduleSortBy(this.value);
  final String value;

  // * Dropdown helper
  String get label => value;

  IconData get icon {
    switch (this) {
      case MaintenanceScheduleSortBy.scheduledDate:
        return Icons.schedule;
      case MaintenanceScheduleSortBy.title:
        return Icons.title;
      case MaintenanceScheduleSortBy.createdAt:
        return Icons.calendar_today;
      case MaintenanceScheduleSortBy.updatedAt:
        return Icons.update;
    }
  }
}

enum MaintenanceRecordSortBy {
  maintenanceDate('maintenanceDate'),
  title('title'),
  createdAt('createdAt'),
  updatedAt('updatedAt');

  const MaintenanceRecordSortBy(this.value);
  final String value;

  // * Dropdown helper
  String get label => value;

  IconData get icon {
    switch (this) {
      case MaintenanceRecordSortBy.maintenanceDate:
        return Icons.build;
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
  String get label => value;

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
  excel('excel');

  const ExportFormat(this.value);
  final String value;

  // * Dropdown helper
  String get label => value;

  IconData get icon {
    switch (this) {
      case ExportFormat.pdf:
        return Icons.picture_as_pdf;
      case ExportFormat.excel:
        return Icons.table_chart;
    }
  }
}
