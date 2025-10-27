# FCM Notification Format Guide

## Overview
Format data untuk Firebase Cloud Messaging (FCM) notification yang akan trigger navigation ke screen spesifik di aplikasi Sigma Track.

## Required Data Fields

Setiap notification FCM harus menyertakan `data` payload dengan field berikut:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `entityType` | string | Yes | Tipe entity yang terkait dengan notification |
| `entityId` | string | Yes | ID dari entity yang terkait |
| `priority` | string | No | Priority level: `LOW`, `NORMAL`, `HIGH`, `URGENT` |

## Supported Entity Types

### 1. Asset
```json
{
  "notification": {
    "title": "Asset Updated",
    "body": "Asset ABC-123 has been updated"
  },
  "data": {
    "entityType": "asset",
    "entityId": "01K8AET7TE6499RF7NZR7XXF43",
    "priority": "NORMAL"
  }
}
```
**Navigation**: `/asset/{entityId}` → `AssetDetailScreen`

---

### 2. Category
```json
{
  "notification": {
    "title": "New Category",
    "body": "Category Electronics has been created"
  },
  "data": {
    "entityType": "category",
    "entityId": "01K8B1234567890123456789AB",
    "priority": "LOW"
  }
}
```
**Navigation**: `/category/{entityId}` → `CategoryDetailScreen`

---

### 3. Location
```json
{
  "notification": {
    "title": "Location Changed",
    "body": "Asset moved to Warehouse A"
  },
  "data": {
    "entityType": "location",
    "entityId": "01K8C9876543210987654321CD",
    "priority": "NORMAL"
  }
}
```
**Navigation**: `/location/{entityId}` → `LocationDetailScreen`

---

### 4. Asset Movement
```json
{
  "notification": {
    "title": "Asset Movement",
    "body": "Asset ABC-123 has been moved"
  },
  "data": {
    "entityType": "asset_movement",
    "entityId": "01K8D1234567890123456789EF",
    "priority": "HIGH"
  }
}
```
**Navigation**: `/asset-movement/{entityId}` → `AssetMovementDetailScreen`

---

### 5. Maintenance Schedule
```json
{
  "notification": {
    "title": "Maintenance Due",
    "body": "Scheduled maintenance for Asset ABC-123"
  },
  "data": {
    "entityType": "maintenance_schedule",
    "entityId": "01K8E9876543210987654321GH",
    "priority": "HIGH"
  }
}
```
**Navigation**: `/maintenance-schedule/{entityId}` → `MaintenanceScheduleDetailScreen`

---

### 6. Maintenance Record
```json
{
  "notification": {
    "title": "Maintenance Complete",
    "body": "Maintenance for Asset ABC-123 completed"
  },
  "data": {
    "entityType": "maintenance_record",
    "entityId": "01K8F1234567890123456789IJ",
    "priority": "NORMAL"
  }
}
```
**Navigation**: `/maintenance-record/{entityId}` → `MaintenanceRecordDetailScreen`

---

### 7. Issue Report
```json
{
  "notification": {
    "title": "New Issue Reported",
    "body": "Issue reported for Asset ABC-123"
  },
  "data": {
    "entityType": "issue_report",
    "entityId": "01K8G9876543210987654321KL",
    "priority": "URGENT"
  }
}
```
**Navigation**: `/issue-report/{entityId}` → `IssueReportDetailScreen`

---

### 8. Scan Log
```json
{
  "notification": {
    "title": "Asset Scanned",
    "body": "Asset ABC-123 scanned by User XYZ"
  },
  "data": {
    "entityType": "scan_log",
    "entityId": "01K8H1234567890123456789MN",
    "priority": "LOW"
  }
}
```
**Navigation**: `/scan-log/{entityId}` → `ScanLogDetailScreen`

---

### 9. User
```json
{
  "notification": {
    "title": "User Profile Update",
    "body": "User profile has been updated"
  },
  "data": {
    "entityType": "user",
    "entityId": "01K8I9876543210987654321OP",
    "priority": "NORMAL"
  }
}
```
**Navigation**: `/user/{entityId}` → `UserDetailScreen`

---

## Priority Levels

| Priority | Description | Visual Effect |
|----------|-------------|---------------|
| `LOW` | Standard notification | Default notification sound & vibration |
| `NORMAL` | Default priority | Default notification sound & vibration |
| `HIGH` | Important notification | High priority channel, emphasized |
| `URGENT` | Critical notification | High priority channel, emphasized, heads-up |

## Important Notes

1. **Case Sensitivity**: `entityType` values are case-insensitive (`asset` = `Asset` = `ASSET`)
2. **ID Format**: Use ULID format for all entity IDs
3. **Missing Data**: If `entityType` or `entityId` is missing, notification will be shown but won't trigger navigation
4. **Unknown Entity**: If `entityType` is not recognized, notification will be logged but won't navigate

## Testing

### Using Firebase Console
1. Go to Firebase Console → Cloud Messaging
2. Send test notification
3. Add custom data as JSON:
```json
{
  "entityType": "asset",
  "entityId": "01K8AET7TE6499RF7NZR7XXF43",
  "priority": "HIGH"
}
```

### Using REST API
```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: Bearer YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "USER_FCM_TOKEN",
    "notification": {
      "title": "Test Notification",
      "body": "This is a test notification"
    },
    "data": {
      "entityType": "asset",
      "entityId": "01K8AET7TE6499RF7NZR7XXF43",
      "priority": "HIGH"
    }
  }'
```

## Behavior by App State

| App State | Behavior |
|-----------|----------|
| **Foreground** | Local notification shown → Tap to navigate |
| **Background** | System notification shown → Tap to navigate |
| **Terminated** | System notification shown → Tap to open app & navigate |

---

**Last Updated**: October 24, 2025
**Version**: 1.0.0
