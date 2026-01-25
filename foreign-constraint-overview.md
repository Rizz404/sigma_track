## 📋 Foreign Key Constraints Overview

### **CASCADE** - Child terhapus otomatis saat parent dihapus
| Table | Column | References | Reasoning |
|-------|--------|------------|-----------|
| `category_translations` | category_id | categories(id) | Translation adalah bagian dari category |
| `location_translations` | location_id | locations(id) | Translation adalah bagian dari location |
| `asset_movements` | asset_id | assets(id) | Movement history tied to asset |
| `asset_movement_translations` | movement_id | asset_movements(id) | Translation adalah bagian dari movement |
| `maintenance_schedules` | asset_id | assets(id) | Schedule tied to specific asset |
| `maintenance_records` | asset_id | assets(id) | Record tied to specific asset |
| `maintenance_record_translations` | record_id | maintenance_records(id) | Translation adalah bagian dari record |
| `issue_reports` | asset_id | assets(id) | Issue tied to specific asset |
| `issue_report_translations` | report_id | issue_reports(id) | Translation adalah bagian dari report |
| `notifications` | user_id | users(id) | Notifikasi personal, tidak perlu dipertahankan |
| `asset_images` | asset_id | assets(id) | Images tied to asset |
| `asset_images` | image_id | images(id) | Junction record cleanup |

---

### **RESTRICT** - Mencegah penghapusan parent jika masih ada child
| Table | Column | References | Reasoning |
|-------|--------|------------|-----------|
| assets | category_id | categories(id) | Mencegah penghapusan kategori yang memiliki aset |
| `asset_movements` | moved_by | users(id) | Audit trail - siapa yang memindahkan |
| `maintenance_schedules` | created_by | users(id) | Audit trail - siapa yang membuat schedule |
| `issue_reports` | reported_by | users(id) | **✅ FIXED** - Audit trail penting |
| `scan_logs` | scanned_by | users(id) | **✅ FIXED** - Audit trail scan activity |

---

### **SET NULL** - Kolom di-null saat parent dihapus
| Table | Column | References | Reasoning |
|-------|--------|------------|-----------|
| `categories` | parent_id | categories(id) | Self-reference, category jadi root level |
| assets | location_id | locations(id) | Asset masih ada, location unknown |
| assets | assigned_to | users(id) | Asset masih ada, tidak di-assign ke siapa-siapa |
| `asset_movements` | from_location_id | locations(id) | History tetap ada, location info hilang |
| `asset_movements` | to_location_id | locations(id) | History tetap ada, location info hilang |
| `asset_movements` | from_user_id | users(id) | History tetap ada, user info hilang |
| `asset_movements` | to_user_id | users(id) | History tetap ada, user info hilang |
| `maintenance_records` | schedule_id | maintenance_schedules(id) | Record bisa standalone (manual maintenance) |
| `maintenance_records` | performed_by_user | users(id) | Record tetap ada, performer info hilang |
| `issue_reports` | resolved_by | users(id) | Issue tetap ada, resolver info hilang |
| `scan_logs` | asset_id | assets(id) | Scan log tetap ada untuk audit |
| `notifications` | related_asset_id | assets(id) | Notifikasi jadi generic |

---
