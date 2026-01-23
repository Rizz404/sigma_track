# Dashboard ID
$p = "d:\kodingan\personal\sigma_track\lib\feature\dashboard\l10n\dashboard_id.arb"
$c = Get-Content $p -Raw -Encoding UTF8
$c = $c.Trim().TrimEnd('}')
$c += @'
,
  "dashboardAssetMovementTrends": "Tren Pergerakan Aset",
  "dashboardIssueReportStatusDistribution": "Distribusi Status Laporan Masalah",
  "dashboardIssueReportCreationTrends": "Tren Pembuatan Laporan Masalah",
  "dashboardMaintenanceScheduleByType": "Jadwal Pemeliharaan berdasarkan Tipe",
  "dashboardMaintenanceRecordCompletionTrends": "Tren Penyelesaian Rekaman Pemeliharaan",
  "dashboardIssueStatusOpen": "Terbuka",
  "dashboardIssueStatusInProgress": "Sedang Diproses",
  "dashboardIssueStatusResolved": "Terselesaikan",
  "dashboardIssueStatusClosed": "Ditutup",
  "dashboardMaintenanceTypePreventive": "Preventif",
  "dashboardMaintenanceTypeCorrective": "Korektif",
  "dashboardMaintenanceTypeInspection": "Inspeksi",
  "dashboardMaintenanceTypeCalibration": "Kalibrasi"
}
'@
Set-Content $p $c -Encoding UTF8

# Dashboard JA
$p = "d:\kodingan\personal\sigma_track\lib\feature\dashboard\l10n\dashboard_ja.arb"
$c = Get-Content $p -Raw -Encoding UTF8
$c = $c.Trim().TrimEnd('}')
$c += @'
,
  "dashboardAssetMovementTrends": "資産移動の傾向",
  "dashboardIssueReportStatusDistribution": "課題報告ステータスの分布",
  "dashboardIssueReportCreationTrends": "課題報告作成の傾向",
  "dashboardMaintenanceScheduleByType": "タイプ別メンテナンススケジュール",
  "dashboardMaintenanceRecordCompletionTrends": "メンテナンス記録完了の傾向",
  "dashboardIssueStatusOpen": "未解決",
  "dashboardIssueStatusInProgress": "進行中",
  "dashboardIssueStatusResolved": "解決済み",
  "dashboardIssueStatusClosed": "完了",
  "dashboardMaintenanceTypePreventive": "予防",
  "dashboardMaintenanceTypeCorrective": "修正",
  "dashboardMaintenanceTypeInspection": "点検",
  "dashboardMaintenanceTypeCalibration": "校正"
}
'@
Set-Content $p $c -Encoding UTF8

# Maintenance EN
$p = "d:\kodingan\personal\sigma_track\lib\feature\maintenance\l10n\maintenance_en.arb"
$c = Get-Content $p -Raw -Encoding UTF8
$c = $c.Trim().TrimEnd('}')
$c += @'
,
  "maintenanceFromDate": "From Date",
  "@maintenanceFromDate": { "description": "From date label" },
  "maintenanceToDate": "To Date",
  "@maintenanceToDate": { "description": "To date label" },
  "maintenanceVendorName": "Vendor Name",
  "@maintenanceVendorName": { "description": "Vendor name label" }
}
'@
Set-Content $p $c -Encoding UTF8

# Maintenance ID
$p = "d:\kodingan\personal\sigma_track\lib\feature\maintenance\l10n\maintenance_id.arb"
$c = Get-Content $p -Raw -Encoding UTF8
$c = $c.Trim().TrimEnd('}')
$c += @'
,
  "maintenanceFromDate": "Dari Tanggal",
  "maintenanceToDate": "Sampai Tanggal",
  "maintenanceVendorName": "Nama Vendor"
}
'@
Set-Content $p $c -Encoding UTF8

# Maintenance JA
$p = "d:\kodingan\personal\sigma_track\lib\feature\maintenance\l10n\maintenance_ja.arb"
$c = Get-Content $p -Raw -Encoding UTF8
$c = $c.Trim().TrimEnd('}')
$c += @'
,
  "maintenanceFromDate": "開始日",
  "maintenanceToDate": "終了日",
  "maintenanceVendorName": "ベンダー名"
}
'@
Set-Content $p $c -Encoding UTF8

# Notification EN
$p = "d:\kodingan\personal\sigma_track\lib\feature\notification\l10n\notification_en.arb"
$c = Get-Content $p -Raw -Encoding UTF8
$c = $c.Trim().TrimEnd('}')
$c += @'
,
  "notificationChannelGeneralDescription": "General notifications from Sigma Asset",
  "@notificationChannelGeneralDescription": { "description": "General channel description" },
  "notificationChannelImportantDescription": "Important notifications that require immediate attention",
  "@notificationChannelImportantDescription": { "description": "Important channel description" },
  "notificationTestDefaultTitle": "Default Notification",
  "@notificationTestDefaultTitle": { "description": "Test notification default title" },
  "notificationTestHighPriorityTitle": "High Priority Notification",
  "@notificationTestHighPriorityTitle": { "description": "Test notification high priority title" },
  "notificationTest1Title": "Notification 1",
  "@notificationTest1Title": { "description": "Test notification 1 title" },
  "notificationTest2Title": "Notification 2",
  "@notificationTest2Title": { "description": "Test notification 2 title" }
}
'@
Set-Content $p $c -Encoding UTF8

# Notification ID
$p = "d:\kodingan\personal\sigma_track\lib\feature\notification\l10n\notification_id.arb"
$c = Get-Content $p -Raw -Encoding UTF8
$c = $c.Trim().TrimEnd('}')
$c += @'
,
  "notificationChannelGeneralDescription": "Notifikasi umum dari Sigma Asset",
  "notificationChannelImportantDescription": "Notifikasi penting yang memerlukan perhatian segera",
  "notificationTestDefaultTitle": "Notifikasi Default",
  "notificationTestHighPriorityTitle": "Notifikasi Prioritas Tinggi",
  "notificationTest1Title": "Notifikasi 1",
  "notificationTest2Title": "Notifikasi 2"
}
'@
Set-Content $p $c -Encoding UTF8

# Notification JA
$p = "d:\kodingan\personal\sigma_track\lib\feature\notification\l10n\notification_ja.arb"
$c = Get-Content $p -Raw -Encoding UTF8
$c = $c.Trim().TrimEnd('}')
$c += @'
,
  "notificationChannelGeneralDescription": "Sigma Assetからの一般通知",
  "notificationChannelImportantDescription": "早急な対応が必要な重要な通知",
  "notificationTestDefaultTitle": "デフォルト通知",
  "notificationTestHighPriorityTitle": "高優先度通知",
  "notificationTest1Title": "通知1",
  "notificationTest2Title": "通知2"
}
'@
Set-Content $p $c -Encoding UTF8
