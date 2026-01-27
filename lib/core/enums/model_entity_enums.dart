import 'package:flutter/material.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';

enum UserRole {
  admin('Admin'),
  staff('Staff'),
  employee('Employee');

  const UserRole(this.value);

  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case UserRole.admin:
        return l10n.enumUserRoleAdmin;
      case UserRole.staff:
        return l10n.enumUserRoleStaff;
      case UserRole.employee:
        return l10n.enumUserRoleEmployee;
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

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case AssetStatus.active:
        return l10n.enumAssetStatusActive;
      case AssetStatus.maintenance:
        return l10n.enumAssetStatusMaintenance;
      case AssetStatus.disposed:
        return l10n.enumAssetStatusDisposed;
      case AssetStatus.lost:
        return l10n.enumAssetStatusLost;
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

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case AssetCondition.good:
        return l10n.enumAssetConditionGood;
      case AssetCondition.fair:
        return l10n.enumAssetConditionFair;
      case AssetCondition.poor:
        return l10n.enumAssetConditionPoor;
      case AssetCondition.damaged:
        return l10n.enumAssetConditionDamaged;
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
  issue('ISSUE'),
  movement('MOVEMENT'),
  statusChange('STATUS_CHANGE'),
  locationChange('LOCATION_CHANGE'),
  categoryChange('CATEGORY_CHANGE');

  const NotificationType(this.value);

  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case NotificationType.maintenance:
        return l10n.enumNotificationTypeMaintenance;
      case NotificationType.warranty:
        return l10n.enumNotificationTypeWarranty;
      case NotificationType.issue:
        return l10n.enumNotificationTypeIssue;
      case NotificationType.movement:
        return l10n.enumNotificationTypeMovement;
      case NotificationType.statusChange:
        return l10n.enumNotificationTypeStatusChange;
      case NotificationType.locationChange:
        return l10n.enumNotificationTypeLocationChange;
      case NotificationType.categoryChange:
        return l10n.enumNotificationTypeCategoryChange;
    }
  }

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
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case NotificationPriority.low:
        return l10n.enumNotificationPriorityLow;
      case NotificationPriority.normal:
        return l10n.enumNotificationPriorityNormal;
      case NotificationPriority.high:
        return l10n.enumNotificationPriorityHigh;
      case NotificationPriority.urgent:
        return l10n.enumNotificationPriorityUrgent;
    }
  }
}

enum ScanMethodType {
  dataMatrix('DATA_MATRIX'),
  manualInput('MANUAL_INPUT');

  const ScanMethodType(this.value);

  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case ScanMethodType.dataMatrix:
        return l10n.enumScanMethodTypeDataMatrix;
      case ScanMethodType.manualInput:
        return l10n.enumScanMethodTypeManualInput;
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

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case ScanResultType.success:
        return l10n.enumScanResultTypeSuccess;
      case ScanResultType.invalidID:
        return l10n.enumScanResultTypeInvalidID;
      case ScanResultType.assetNotFound:
        return l10n.enumScanResultTypeAssetNotFound;
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
  corrective('Corrective'),
  inspection('Inspection'),
  calibration('Calibration');

  const MaintenanceScheduleType(this.value);

  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case MaintenanceScheduleType.preventive:
        return l10n.enumMaintenanceScheduleTypePreventive;
      case MaintenanceScheduleType.corrective:
        return l10n.enumMaintenanceScheduleTypeCorrective;
      case MaintenanceScheduleType.inspection:
        return l10n.enumMaintenanceScheduleTypeInspection;
      case MaintenanceScheduleType.calibration:
        return l10n.enumMaintenanceScheduleTypeCalibration;
    }
  }

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
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case ScheduleState.active:
        return l10n.enumScheduleStateActive;
      case ScheduleState.paused:
        return l10n.enumScheduleStatePaused;
      case ScheduleState.stopped:
        return l10n.enumScheduleStateStopped;
      case ScheduleState.completed:
        return l10n.enumScheduleStateCompleted;
    }
  }

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
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case IntervalUnit.days:
        return l10n.enumIntervalUnitDays;
      case IntervalUnit.weeks:
        return l10n.enumIntervalUnitWeeks;
      case IntervalUnit.months:
        return l10n.enumIntervalUnitMonths;
      case IntervalUnit.years:
        return l10n.enumIntervalUnitYears;
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
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case IssuePriority.low:
        return l10n.enumIssuePriorityLow;
      case IssuePriority.medium:
        return l10n.enumIssuePriorityMedium;
      case IssuePriority.high:
        return l10n.enumIssuePriorityHigh;
      case IssuePriority.critical:
        return l10n.enumIssuePriorityCritical;
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

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case IssueStatus.open:
        return l10n.enumIssueStatusOpen;
      case IssueStatus.inProgress:
        return l10n.enumIssueStatusInProgress;
      case IssueStatus.resolved:
        return l10n.enumIssueStatusResolved;
      case IssueStatus.closed:
        return l10n.enumIssueStatusClosed;
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

enum MaintenanceResult {
  success('Success'),
  partial('Partial'),
  failed('Failed'),
  rescheduled('Rescheduled');

  const MaintenanceResult(this.value);

  final String value;

  // * Dropdown helper
  String get label {
    final l10n = LocalizationExtension.current;
    switch (this) {
      case MaintenanceResult.success:
        return l10n.enumMaintenanceResultSuccess;
      case MaintenanceResult.partial:
        return l10n.enumMaintenanceResultPartial;
      case MaintenanceResult.failed:
        return l10n.enumMaintenanceResultFailed;
      case MaintenanceResult.rescheduled:
        return l10n.enumMaintenanceResultRescheduled;
    }
  }

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
