import 'package:flutter/material.dart';

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

  // * Dropdown helper
  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.staff:
        return 'Staff';
      case UserRole.employee:
        return 'Employee';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.staff:
        return Icons.people;
      case UserRole.employee:
        return Icons.person;
    }
  }
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

  // * Dropdown helper
  String get label {
    switch (this) {
      case AssetStatus.active:
        return 'Active';
      case AssetStatus.maintenance:
        return 'Maintenance';
      case AssetStatus.disposed:
        return 'Disposed';
      case AssetStatus.lost:
        return 'Lost';
    }
  }

  IconData get icon {
    switch (this) {
      case AssetStatus.active:
        return Icons.check_circle;
      case AssetStatus.maintenance:
        return Icons.build;
      case AssetStatus.disposed:
        return Icons.delete;
      case AssetStatus.lost:
        return Icons.error;
    }
  }
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

  // * Dropdown helper
  String get label {
    switch (this) {
      case AssetCondition.good:
        return 'Good';
      case AssetCondition.fair:
        return 'Fair';
      case AssetCondition.poor:
        return 'Poor';
      case AssetCondition.damaged:
        return 'Damaged';
    }
  }

  IconData get icon {
    switch (this) {
      case AssetCondition.good:
        return Icons.thumb_up;
      case AssetCondition.fair:
        return Icons.thumbs_up_down;
      case AssetCondition.poor:
        return Icons.thumb_down;
      case AssetCondition.damaged:
        return Icons.warning;
    }
  }
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

  // * Dropdown helper
  String get label {
    switch (this) {
      case NotificationType.maintenance:
        return 'Maintenance';
      case NotificationType.warranty:
        return 'Warranty';
      case NotificationType.statusChange:
        return 'Status Change';
      case NotificationType.movement:
        return 'Movement';
      case NotificationType.issueReport:
        return 'Issue Report';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.maintenance:
        return Icons.build;
      case NotificationType.warranty:
        return Icons.shield;
      case NotificationType.statusChange:
        return Icons.swap_horiz;
      case NotificationType.movement:
        return Icons.move_down;
      case NotificationType.issueReport:
        return Icons.report;
    }
  }
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

  // * Dropdown helper
  String get label {
    switch (this) {
      case ScanMethodType.dataMatrix:
        return 'Data Matrix';
      case ScanMethodType.manualInput:
        return 'Manual Input';
    }
  }

  IconData get icon {
    switch (this) {
      case ScanMethodType.dataMatrix:
        return Icons.qr_code;
      case ScanMethodType.manualInput:
        return Icons.keyboard;
    }
  }
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

  // * Dropdown helper
  String get label {
    switch (this) {
      case ScanResultType.success:
        return 'Success';
      case ScanResultType.invalidID:
        return 'Invalid ID';
      case ScanResultType.assetNotFound:
        return 'Asset Not Found';
    }
  }

  IconData get icon {
    switch (this) {
      case ScanResultType.success:
        return Icons.check_circle;
      case ScanResultType.invalidID:
        return Icons.error;
      case ScanResultType.assetNotFound:
        return Icons.search_off;
    }
  }
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

  // * Dropdown helper
  String get label {
    switch (this) {
      case MaintenanceScheduleType.preventive:
        return 'Preventive';
      case MaintenanceScheduleType.corrective:
        return 'Corrective';
    }
  }

  IconData get icon {
    switch (this) {
      case MaintenanceScheduleType.preventive:
        return Icons.shield;
      case MaintenanceScheduleType.corrective:
        return Icons.build;
    }
  }
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

  // * Dropdown helper
  String get label {
    switch (this) {
      case ScheduleStatus.scheduled:
        return 'Scheduled';
      case ScheduleStatus.completed:
        return 'Completed';
      case ScheduleStatus.cancelled:
        return 'Cancelled';
    }
  }

  IconData get icon {
    switch (this) {
      case ScheduleStatus.scheduled:
        return Icons.schedule;
      case ScheduleStatus.completed:
        return Icons.check_circle;
      case ScheduleStatus.cancelled:
        return Icons.cancel;
    }
  }
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

  // * Dropdown helper
  String get label {
    switch (this) {
      case IssuePriority.low:
        return 'Low';
      case IssuePriority.medium:
        return 'Medium';
      case IssuePriority.high:
        return 'High';
      case IssuePriority.critical:
        return 'Critical';
    }
  }

  IconData get icon {
    switch (this) {
      case IssuePriority.low:
        return Icons.arrow_downward;
      case IssuePriority.medium:
        return Icons.remove;
      case IssuePriority.high:
        return Icons.arrow_upward;
      case IssuePriority.critical:
        return Icons.priority_high;
    }
  }
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

  // * Dropdown helper
  String get label {
    switch (this) {
      case IssueStatus.open:
        return 'Open';
      case IssueStatus.inProgress:
        return 'In Progress';
      case IssueStatus.resolved:
        return 'Resolved';
      case IssueStatus.closed:
        return 'Closed';
    }
  }

  IconData get icon {
    switch (this) {
      case IssueStatus.open:
        return Icons.folder_open;
      case IssueStatus.inProgress:
        return Icons.hourglass_empty;
      case IssueStatus.resolved:
        return Icons.check_circle;
      case IssueStatus.closed:
        return Icons.lock;
    }
  }
}
