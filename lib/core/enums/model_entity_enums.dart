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
  issue('ISSUE'),
  movement('MOVEMENT'),
  statusChange('STATUS_CHANGE'),
  locationChange('LOCATION_CHANGE'),
  categoryChange('CATEGORY_CHANGE');

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
      case NotificationType.issue:
        return Icons.report;
      case NotificationType.movement:
        return Icons.move_down;
      case NotificationType.statusChange:
        return Icons.swap_horiz;
      case NotificationType.locationChange:
        return Icons.location_on;
      case NotificationType.categoryChange:
        return Icons.category;
    }
  }
}

enum NotificationPriority {
  low('LOW'),
  normal('NORMAL'),
  high('HIGH'),
  urgent('URGENT');

  const NotificationPriority(this.value);

  final String value;

  // * Dropdown helper
  String get label => value;
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
  corrective('Corrective'),
  inspection('Inspection'),
  calibration('Calibration');

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
      case MaintenanceScheduleType.inspection:
        return Icons.visibility;
      case MaintenanceScheduleType.calibration:
        return Icons.tune;
    }
  }
}

enum ScheduleState {
  active('Active'),
  paused('Paused'),
  stopped('Stopped'),
  completed('Completed');

  const ScheduleState(this.value);

  final String value;

  // * Dropdown helper
  String get label => value;

  IconData get icon {
    switch (this) {
      case ScheduleState.active:
        return Icons.play_arrow;
      case ScheduleState.paused:
        return Icons.pause;
      case ScheduleState.stopped:
        return Icons.stop;
      case ScheduleState.completed:
        return Icons.check_circle;
    }
  }
}

enum IntervalUnit {
  days('Days'),
  weeks('Weeks'),
  months('Months'),
  years('Years');

  const IntervalUnit(this.value);

  final String value;

  // * Dropdown helper
  String get label => value;
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

enum MaintenanceResult {
  success('Success'),
  partial('Partial'),
  failed('Failed'),
  rescheduled('Rescheduled');

  const MaintenanceResult(this.value);

  final String value;

  // * Dropdown helper
  String get label => value;

  IconData get icon {
    switch (this) {
      case MaintenanceResult.success:
        return Icons.check_circle;
      case MaintenanceResult.partial:
        return Icons.warning;
      case MaintenanceResult.failed:
        return Icons.error;
      case MaintenanceResult.rescheduled:
        return Icons.schedule;
    }
  }
}
