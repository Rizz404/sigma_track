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
}
