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
