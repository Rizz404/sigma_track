enum UserRole {
  admin('Admin'),
  staff('Staff'),
  employee('Employee');

  const UserRole(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static UserRole fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => throw ArgumentError('Invalid UserRole value: $value'),
    );
  }

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => throw ArgumentError('Invalid UserRole value: $value'),
    );
  }

  String toJson() => value;

  static UserRole fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum AssetStatus {
  active('Active'),
  maintenance('Maintenance'),
  disposed('Disposed'),
  lost('Lost');

  const AssetStatus(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static AssetStatus fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return AssetStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw ArgumentError('Invalid AssetStatus value: $value'),
    );
  }

  static AssetStatus fromString(String value) {
    return AssetStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw ArgumentError('Invalid AssetStatus value: $value'),
    );
  }

  String toJson() => value;

  static AssetStatus fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum AssetCondition {
  good('Good'),
  fair('Fair'),
  poor('Poor'),
  damaged('Damaged');

  const AssetCondition(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static AssetCondition fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return AssetCondition.values.firstWhere(
      (condition) => condition.value == value,
      orElse: () => throw ArgumentError('Invalid AssetCondition value: $value'),
    );
  }

  static AssetCondition fromString(String value) {
    return AssetCondition.values.firstWhere(
      (condition) => condition.value == value,
      orElse: () => throw ArgumentError('Invalid AssetCondition value: $value'),
    );
  }

  String toJson() => value;

  static AssetCondition fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum NotificationType {
  maintenance('MAINTENANCE'),
  warranty('WARRANTY'),
  statusChange('STATUS_CHANGE'),
  movement('MOVEMENT'),
  issueReport('ISSUE_REPORT');

  const NotificationType(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static NotificationType fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () =>
          throw ArgumentError('Invalid NotificationType value: $value'),
    );
  }

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () =>
          throw ArgumentError('Invalid NotificationType value: $value'),
    );
  }

  String toJson() => value;

  static NotificationType fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum ScanMethodType {
  dataMatrix('DATA_MATRIX'),
  manualInput('MANUAL_INPUT');

  const ScanMethodType(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static ScanMethodType fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return ScanMethodType.values.firstWhere(
      (method) => method.value == value,
      orElse: () => throw ArgumentError('Invalid ScanMethodType value: $value'),
    );
  }

  static ScanMethodType fromString(String value) {
    return ScanMethodType.values.firstWhere(
      (method) => method.value == value,
      orElse: () => throw ArgumentError('Invalid ScanMethodType value: $value'),
    );
  }

  String toJson() => value;

  static ScanMethodType fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum ScanResultType {
  success('Success'),
  invalidID('Invalid Id'),
  assetNotFound('Asset Not Found');

  const ScanResultType(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static ScanResultType fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return ScanResultType.values.firstWhere(
      (result) => result.value == value,
      orElse: () => throw ArgumentError('Invalid ScanResultType value: $value'),
    );
  }

  static ScanResultType fromString(String value) {
    return ScanResultType.values.firstWhere(
      (result) => result.value == value,
      orElse: () => throw ArgumentError('Invalid ScanResultType value: $value'),
    );
  }

  String toJson() => value;

  static ScanResultType fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum MaintenanceScheduleType {
  preventive('Preventive'),
  corrective('Corrective');

  const MaintenanceScheduleType(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static MaintenanceScheduleType fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return MaintenanceScheduleType.values.firstWhere(
      (type) => type.value == value,
      orElse: () =>
          throw ArgumentError('Invalid MaintenanceScheduleType value: $value'),
    );
  }

  static MaintenanceScheduleType fromString(String value) {
    return MaintenanceScheduleType.values.firstWhere(
      (type) => type.value == value,
      orElse: () =>
          throw ArgumentError('Invalid MaintenanceScheduleType value: $value'),
    );
  }

  String toJson() => value;

  static MaintenanceScheduleType fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum ScheduleStatus {
  scheduled('Scheduled'),
  completed('Completed'),
  cancelled('Cancelled');

  const ScheduleStatus(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static ScheduleStatus fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return ScheduleStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw ArgumentError('Invalid ScheduleStatus value: $value'),
    );
  }

  static ScheduleStatus fromString(String value) {
    return ScheduleStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw ArgumentError('Invalid ScheduleStatus value: $value'),
    );
  }

  String toJson() => value;

  static ScheduleStatus fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum IssuePriority {
  low('Low'),
  medium('Medium'),
  high('High'),
  critical('Critical');

  const IssuePriority(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static IssuePriority fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return IssuePriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => throw ArgumentError('Invalid IssuePriority value: $value'),
    );
  }

  static IssuePriority fromString(String value) {
    return IssuePriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => throw ArgumentError('Invalid IssuePriority value: $value'),
    );
  }

  String toJson() => value;

  static IssuePriority fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}

enum IssueStatus {
  open('Open'),
  inProgress('In Progress'),
  resolved('Resolved'),
  closed('Closed');

  const IssueStatus(this.value);

  final String value;

  Map<String, dynamic> toMap() {
    return {'value': value};
  }

  static IssueStatus fromMap(Map<String, dynamic> map) {
    final value = map['value'] as String;
    return IssueStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw ArgumentError('Invalid IssueStatus value: $value'),
    );
  }

  static IssueStatus fromString(String value) {
    return IssueStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => throw ArgumentError('Invalid IssueStatus value: $value'),
    );
  }

  String toJson() => value;

  static IssueStatus fromJson(String json) => fromString(json);

  @override
  String toString() => value;
}
