enum SortOrder {
  asc('asc'),
  desc('desc');

  const SortOrder(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static SortOrder fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return SortOrder.values.firstWhere(
      (order) => order.value == value,
      orElse: () => throw ArgumentError('Invalid SortOrder value: $value'),
    );
  }

  static SortOrder fromString(String value) {
    return SortOrder.values.firstWhere(
      (order) => order.value == value,
      orElse: () => throw ArgumentError('Invalid SortOrder value: $value'),
    );
  }

  String toJson() => value;

  static SortOrder fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum CategorySortBy {
  categoryCode('category_code'),
  name('name'),
  categoryName('category_name'),
  createdAt('created_at'),
  updatedAt('updated_at');

  const CategorySortBy(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static CategorySortBy fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return CategorySortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () => throw ArgumentError('Invalid CategorySortBy value: $value'),
    );
  }

  static CategorySortBy fromString(String value) {
    return CategorySortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () => throw ArgumentError('Invalid CategorySortBy value: $value'),
    );
  }

  String toJson() => value;

  static CategorySortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum LocationSortBy {
  locationCode('location_code'),
  name('name'),
  locationName('location_name'),
  building('building'),
  floor('floor'),
  createdAt('created_at'),
  updatedAt('updated_at');

  const LocationSortBy(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static LocationSortBy fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return LocationSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () => throw ArgumentError('Invalid LocationSortBy value: $value'),
    );
  }

  static LocationSortBy fromString(String value) {
    return LocationSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () => throw ArgumentError('Invalid LocationSortBy value: $value'),
    );
  }

  String toJson() => value;

  static LocationSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum NotificationSortBy {
  type('type'),
  isRead('is_read'),
  createdAt('created_at'),
  title('title'),
  message('message');

  const NotificationSortBy(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static NotificationSortBy fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return NotificationSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () =>
          throw ArgumentError('Invalid NotificationSortBy value: $value'),
    );
  }

  static NotificationSortBy fromString(String value) {
    return NotificationSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () =>
          throw ArgumentError('Invalid NotificationSortBy value: $value'),
    );
  }

  String toJson() => value;

  static NotificationSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum ScanLogSortBy {
  scanTimestamp('scan_timestamp'),
  scannedValue('scanned_value'),
  scanMethod('scan_method'),
  scanResult('scan_result');

  const ScanLogSortBy(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static ScanLogSortBy fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return ScanLogSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () => throw ArgumentError('Invalid ScanLogSortBy value: $value'),
    );
  }

  static ScanLogSortBy fromString(String value) {
    return ScanLogSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () => throw ArgumentError('Invalid ScanLogSortBy value: $value'),
    );
  }

  String toJson() => value;

  static ScanLogSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum AssetSortBy {
  assetTag('asset_tag'),
  assetName('asset_name'),
  brand('brand'),
  model('model'),
  serialNumber('serial_number'),
  purchaseDate('purchase_date'),
  purchasePrice('purchase_price'),
  vendorName('vendor_name'),
  warrantyEnd('warranty_end'),
  status('status'),
  conditionStatus('condition_status'),
  createdAt('created_at'),
  updatedAt('updated_at');

  const AssetSortBy(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static AssetSortBy fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return AssetSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () => throw ArgumentError('Invalid AssetSortBy value: $value'),
    );
  }

  static AssetSortBy fromString(String value) {
    return AssetSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () => throw ArgumentError('Invalid AssetSortBy value: $value'),
    );
  }

  String toJson() => value;

  static AssetSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum AssetMovementSortBy {
  movementDate('movement_date'),
  movementdate('movementdate'),
  createdAt('created_at'),
  createdat('createdat'),
  updatedAt('updated_at'),
  updatedat('updatedat');

  const AssetMovementSortBy(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static AssetMovementSortBy fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return AssetMovementSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () =>
          throw ArgumentError('Invalid AssetMovementSortBy value: $value'),
    );
  }

  static AssetMovementSortBy fromString(String value) {
    return AssetMovementSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () =>
          throw ArgumentError('Invalid AssetMovementSortBy value: $value'),
    );
  }

  String toJson() => value;

  static AssetMovementSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum IssueReportSortBy {
  reportedDate('reported_date'),
  resolvedDate('resolved_date'),
  issueType('issue_type'),
  priority('priority'),
  status('status'),
  title('title'),
  description('description'),
  createdAt('created_at'),
  updatedAt('updated_at');

  const IssueReportSortBy(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static IssueReportSortBy fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return IssueReportSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () =>
          throw ArgumentError('Invalid IssueReportSortBy value: $value'),
    );
  }

  static IssueReportSortBy fromString(String value) {
    return IssueReportSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () =>
          throw ArgumentError('Invalid IssueReportSortBy value: $value'),
    );
  }

  String toJson() => value;

  static IssueReportSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum MaintenanceScheduleSortBy {
  scheduledDate('scheduled_date'),
  title('title'),
  createdAt('created_at'),
  updatedAt('updated_at');

  const MaintenanceScheduleSortBy(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static MaintenanceScheduleSortBy fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return MaintenanceScheduleSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () => throw ArgumentError(
        'Invalid MaintenanceScheduleSortBy value: $value',
      ),
    );
  }

  static MaintenanceScheduleSortBy fromString(String value) {
    return MaintenanceScheduleSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () => throw ArgumentError(
        'Invalid MaintenanceScheduleSortBy value: $value',
      ),
    );
  }

  String toJson() => value;

  static MaintenanceScheduleSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum MaintenanceRecordSortBy {
  maintenanceDate('maintenance_date'),
  title('title'),
  createdAt('created_at'),
  updatedAt('updated_at');

  const MaintenanceRecordSortBy(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static MaintenanceRecordSortBy fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return MaintenanceRecordSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () =>
          throw ArgumentError('Invalid MaintenanceRecordSortBy value: $value'),
    );
  }

  static MaintenanceRecordSortBy fromString(String value) {
    return MaintenanceRecordSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () =>
          throw ArgumentError('Invalid MaintenanceRecordSortBy value: $value'),
    );
  }

  String toJson() => value;

  static MaintenanceRecordSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum UserSortBy {
  name('name'),
  fullName('full_name'),
  email('email'),
  role('role'),
  employeeId('employee_id'),
  isActive('is_active'),
  createdAt('created_at'),
  updatedAt('updated_at');

  const UserSortBy(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static UserSortBy fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return UserSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () => throw ArgumentError('Invalid UserSortBy value: $value'),
    );
  }

  static UserSortBy fromString(String value) {
    return UserSortBy.values.firstWhere(
      (field) => field.value == value,
      orElse: () => throw ArgumentError('Invalid UserSortBy value: $value'),
    );
  }

  String toJson() => value;

  static UserSortBy fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}
