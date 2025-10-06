import 'package:flutter/material.dart';

enum SortOrder {
  asc('asc'),
  desc('desc');

  const SortOrder(this.value);
  final String value;

  Map<String, dynamic> toMap() => {'value': value};

  static SortOrder fromMap(Map<String, dynamic> map) =>
      fromString(map['value'] as String);

  static SortOrder fromString(String value) => SortOrder.values.firstWhere(
    (order) => order.value == value,
    orElse: () => throw ArgumentError('Invalid SortOrder value: $value'),
  );

  String toJson() => value;
  static SortOrder fromJson(String json) => fromString(json);

  @override
  String toString() => value;

  // * Dropdown helper
  String get label {
    switch (this) {
      case SortOrder.asc:
        return 'Ascending';
      case SortOrder.desc:
        return 'Descending';
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

  Map<String, dynamic> toMap() => {'value': value};

  static CategorySortBy fromMap(Map<String, dynamic> map) =>
      fromString(map['value'] as String);

  static CategorySortBy fromString(String value) =>
      CategorySortBy.values.firstWhere(
        (f) => f.value == value,
        orElse: () =>
            throw ArgumentError('Invalid CategorySortBy value: $value'),
      );

  String toJson() => value;
  static CategorySortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;

  // * Dropdown helper
  String get label {
    switch (this) {
      case CategorySortBy.categoryCode:
        return 'Category Code';
      case CategorySortBy.name:
      case CategorySortBy.categoryName:
        return 'Category Name';
      case CategorySortBy.createdAt:
        return 'Created Date';
      case CategorySortBy.updatedAt:
        return 'Updated Date';
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

  Map<String, dynamic> toMap() => {'value': value};

  static LocationSortBy fromMap(Map<String, dynamic> map) =>
      fromString(map['value'] as String);

  static LocationSortBy fromString(String value) =>
      LocationSortBy.values.firstWhere(
        (f) => f.value == value,
        orElse: () =>
            throw ArgumentError('Invalid LocationSortBy value: $value'),
      );

  String toJson() => value;
  static LocationSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;

  // * Dropdown helper
  String get label {
    switch (this) {
      case LocationSortBy.locationCode:
        return 'Location Code';
      case LocationSortBy.name:
      case LocationSortBy.locationName:
        return 'Location Name';
      case LocationSortBy.building:
        return 'Building';
      case LocationSortBy.floor:
        return 'Floor';
      case LocationSortBy.createdAt:
        return 'Created Date';
      case LocationSortBy.updatedAt:
        return 'Updated Date';
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

  Map<String, dynamic> toMap() => {'value': value};

  static NotificationSortBy fromMap(Map<String, dynamic> map) =>
      fromString(map['value'] as String);

  static NotificationSortBy fromString(String value) =>
      NotificationSortBy.values.firstWhere(
        (f) => f.value == value,
        orElse: () =>
            throw ArgumentError('Invalid NotificationSortBy value: $value'),
      );

  String toJson() => value;
  static NotificationSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;

  // * Dropdown helper
  String get label {
    switch (this) {
      case NotificationSortBy.type:
        return 'Type';
      case NotificationSortBy.isRead:
        return 'Read Status';
      case NotificationSortBy.createdAt:
        return 'Created Date';
      case NotificationSortBy.title:
        return 'Title';
      case NotificationSortBy.message:
        return 'Message';
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

  Map<String, dynamic> toMap() => {'value': value};

  static ScanLogSortBy fromMap(Map<String, dynamic> map) =>
      fromString(map['value'] as String);

  static ScanLogSortBy fromString(String value) =>
      ScanLogSortBy.values.firstWhere(
        (f) => f.value == value,
        orElse: () =>
            throw ArgumentError('Invalid ScanLogSortBy value: $value'),
      );

  String toJson() => value;
  static ScanLogSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;

  // * Dropdown helper
  String get label {
    switch (this) {
      case ScanLogSortBy.scanTimestamp:
        return 'Scan Timestamp';
      case ScanLogSortBy.scannedValue:
        return 'Scanned Value';
      case ScanLogSortBy.scanMethod:
        return 'Scan Method';
      case ScanLogSortBy.scanResult:
        return 'Scan Result';
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

  Map<String, dynamic> toMap() => {'value': value};

  static AssetSortBy fromMap(Map<String, dynamic> map) =>
      fromString(map['value'] as String);

  static AssetSortBy fromString(String value) => AssetSortBy.values.firstWhere(
    (f) => f.value == value,
    orElse: () => throw ArgumentError('Invalid AssetSortBy value: $value'),
  );

  String toJson() => value;
  static AssetSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;

  // * Dropdown helper
  String get label {
    switch (this) {
      case AssetSortBy.assetTag:
        return 'Asset Tag';
      case AssetSortBy.assetName:
        return 'Asset Name';
      case AssetSortBy.brand:
        return 'Brand';
      case AssetSortBy.model:
        return 'Model';
      case AssetSortBy.serialNumber:
        return 'Serial Number';
      case AssetSortBy.purchaseDate:
        return 'Purchase Date';
      case AssetSortBy.purchasePrice:
        return 'Purchase Price';
      case AssetSortBy.vendorName:
        return 'Vendor Name';
      case AssetSortBy.warrantyEnd:
        return 'Warranty End';
      case AssetSortBy.status:
        return 'Status';
      case AssetSortBy.conditionStatus:
        return 'Condition Status';
      case AssetSortBy.createdAt:
        return 'Created Date';
      case AssetSortBy.updatedAt:
        return 'Updated Date';
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

  Map<String, dynamic> toMap() => {'value': value};

  static AssetMovementSortBy fromMap(Map<String, dynamic> map) =>
      fromString(map['value'] as String);

  static AssetMovementSortBy fromString(String value) =>
      AssetMovementSortBy.values.firstWhere(
        (f) => f.value == value,
        orElse: () =>
            throw ArgumentError('Invalid AssetMovementSortBy value: $value'),
      );

  String toJson() => value;
  static AssetMovementSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;

  // * Dropdown helper
  String get label {
    switch (this) {
      case AssetMovementSortBy.movementDate:
      case AssetMovementSortBy.movementdate:
        return 'Movement Date';
      case AssetMovementSortBy.createdAt:
      case AssetMovementSortBy.createdat:
        return 'Created Date';
      case AssetMovementSortBy.updatedAt:
      case AssetMovementSortBy.updatedat:
        return 'Updated Date';
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

  Map<String, dynamic> toMap() => {'value': value};

  static IssueReportSortBy fromMap(Map<String, dynamic> map) =>
      fromString(map['value'] as String);

  static IssueReportSortBy fromString(String value) =>
      IssueReportSortBy.values.firstWhere(
        (f) => f.value == value,
        orElse: () =>
            throw ArgumentError('Invalid IssueReportSortBy value: $value'),
      );

  String toJson() => value;
  static IssueReportSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;

  // * Dropdown helper
  String get label {
    switch (this) {
      case IssueReportSortBy.reportedDate:
        return 'Reported Date';
      case IssueReportSortBy.resolvedDate:
        return 'Resolved Date';
      case IssueReportSortBy.issueType:
        return 'Issue Type';
      case IssueReportSortBy.priority:
        return 'Priority';
      case IssueReportSortBy.status:
        return 'Status';
      case IssueReportSortBy.title:
        return 'Title';
      case IssueReportSortBy.description:
        return 'Description';
      case IssueReportSortBy.createdAt:
        return 'Created Date';
      case IssueReportSortBy.updatedAt:
        return 'Updated Date';
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
  scheduledDate('scheduledDate'),
  title('title'),
  createdAt('createdAt'),
  updatedAt('updatedAt');

  const MaintenanceScheduleSortBy(this.value);
  final String value;

  Map<String, dynamic> toMap() => {'value': value};

  static MaintenanceScheduleSortBy fromMap(Map<String, dynamic> map) =>
      fromString(map['value'] as String);

  static MaintenanceScheduleSortBy fromString(String value) =>
      MaintenanceScheduleSortBy.values.firstWhere(
        (f) => f.value == value,
        orElse: () => throw ArgumentError(
          'Invalid MaintenanceScheduleSortBy value: $value',
        ),
      );

  String toJson() => value;
  static MaintenanceScheduleSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;

  // * Dropdown helper
  String get label {
    switch (this) {
      case MaintenanceScheduleSortBy.scheduledDate:
        return 'Scheduled Date';
      case MaintenanceScheduleSortBy.title:
        return 'Title';
      case MaintenanceScheduleSortBy.createdAt:
        return 'Created Date';
      case MaintenanceScheduleSortBy.updatedAt:
        return 'Updated Date';
    }
  }

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

  Map<String, dynamic> toMap() => {'value': value};

  static MaintenanceRecordSortBy fromMap(Map<String, dynamic> map) =>
      fromString(map['value'] as String);

  static MaintenanceRecordSortBy fromString(String value) =>
      MaintenanceRecordSortBy.values.firstWhere(
        (f) => f.value == value,
        orElse: () => throw ArgumentError(
          'Invalid MaintenanceRecordSortBy value: $value',
        ),
      );

  String toJson() => value;
  static MaintenanceRecordSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;

  // * Dropdown helper
  String get label {
    switch (this) {
      case MaintenanceRecordSortBy.maintenanceDate:
        return 'Maintenance Date';
      case MaintenanceRecordSortBy.title:
        return 'Title';
      case MaintenanceRecordSortBy.createdAt:
        return 'Created Date';
      case MaintenanceRecordSortBy.updatedAt:
        return 'Updated Date';
    }
  }

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

  Map<String, dynamic> toMap() => {'value': value};

  static UserSortBy fromMap(Map<String, dynamic> map) =>
      fromString(map['value'] as String);

  static UserSortBy fromString(String value) => UserSortBy.values.firstWhere(
    (f) => f.value == value,
    orElse: () => throw ArgumentError('Invalid UserSortBy value: $value'),
  );

  String toJson() => value;
  static UserSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;

  // * Dropdown helper
  String get label {
    switch (this) {
      case UserSortBy.name:
        return 'Name';
      case UserSortBy.fullName:
        return 'Full Name';
      case UserSortBy.email:
        return 'Email';
      case UserSortBy.role:
        return 'Role';
      case UserSortBy.employeeId:
        return 'Employee ID';
      case UserSortBy.isActive:
        return 'Active Status';
      case UserSortBy.createdAt:
        return 'Created Date';
      case UserSortBy.updatedAt:
        return 'Updated Date';
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
