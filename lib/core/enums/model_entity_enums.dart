import 'package:flutter/material.dart';

enum UserRole {
  admin('Admin'),
  staff('Staff'),
  employee('Employee');

  const UserRole(this.value);

  final String value;

  // * Dropdown helper
  String get label => value;

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

  // * Dropdown helper
  String get label => value;

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

  // * Dropdown helper
  String get label => value;

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

  // * Dropdown helper
  String get label => value;

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

  // * Dropdown helper
  String get label => value;

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

  // * Dropdown helper
  String get label => value;

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

  // * Dropdown helper
  String get label => value;

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

  // * Dropdown helper
  String get label => value;

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

  // * Dropdown helper
  String get label => value;

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

  // * Dropdown helper
  String get label => value;

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
