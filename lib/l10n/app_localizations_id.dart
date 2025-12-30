// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class L10nId extends L10n {
  L10nId([String locale = 'id']) : super(locale);

  @override
  String get assetDeleteAsset => 'Hapus Aset';

  @override
  String assetDeleteConfirmation(String assetName) {
    return 'Apakah Anda yakin ingin menghapus \"$assetName\"?';
  }

  @override
  String get assetCancel => 'Batal';

  @override
  String get assetDelete => 'Hapus';

  @override
  String get assetDetail => 'Detail Aset';

  @override
  String get assetInformation => 'Informasi Aset';

  @override
  String get assetTag => 'Tag Aset';

  @override
  String get assetName => 'Nama Aset';

  @override
  String get assetCategory => 'Kategori';

  @override
  String get assetBrand => 'Merek';

  @override
  String get assetBrandLabel => 'Merek';

  @override
  String get assetModel => 'Model';

  @override
  String get assetModelLabel => 'Model';

  @override
  String get assetSerialNumber => 'Nomor Seri';

  @override
  String get assetStatus => 'Status';

  @override
  String get assetCondition => 'Kondisi';

  @override
  String get assetLocation => 'Lokasi';

  @override
  String get assetAssignedTo => 'Ditugaskan Kepada';

  @override
  String get assetPurchaseInformation => 'Informasi Pembelian';

  @override
  String get assetPurchaseDate => 'Tanggal Pembelian';

  @override
  String get assetPurchasePrice => 'Harga Pembelian';

  @override
  String get assetVendorName => 'Nama Vendor';

  @override
  String get assetWarrantyEnd => 'Berakhir Garansi';

  @override
  String get assetMetadata => 'Metadata';

  @override
  String get assetCreatedAt => 'Dibuat Pada';

  @override
  String get assetUpdatedAt => 'Diperbarui Pada';

  @override
  String get assetDataMatrixImage => 'Gambar Data Matrix';

  @override
  String get assetOnlyAdminCanEdit => 'Hanya admin yang dapat mengedit aset';

  @override
  String get assetOnlyAdminCanDelete => 'Hanya admin yang dapat menghapus aset';

  @override
  String get assetFailedToLoad => 'Gagal memuat aset';

  @override
  String get assetLocationPermissionRequired => 'Izin Lokasi Diperlukan';

  @override
  String get assetLocationPermissionMessage =>
      'Akses lokasi diperlukan untuk melacak log pemindaian. Silakan aktifkan di pengaturan.';

  @override
  String get assetOpenSettings => 'Buka Pengaturan';

  @override
  String get assetLocationPermissionNeeded =>
      'Izin lokasi diperlukan untuk log pemindaian';

  @override
  String get assetInvalidBarcode => 'Data barcode tidak valid';

  @override
  String assetFound(String assetName) {
    return 'Aset ditemukan: $assetName';
  }

  @override
  String get assetNotFound => 'Aset tidak ditemukan';

  @override
  String get assetFailedToProcessBarcode => 'Gagal memproses barcode';

  @override
  String get assetCameraError => 'Kesalahan Kamera';

  @override
  String get assetAlignDataMatrix => 'Sejajarkan data matrix dalam bingkai';

  @override
  String get assetProcessing => 'Memproses...';

  @override
  String get assetFlash => 'Flash';

  @override
  String get assetFlip => 'Balik';

  @override
  String get assetEditAsset => 'Edit Aset';

  @override
  String get assetCreateAsset => 'Buat Aset';

  @override
  String get assetFillRequiredFields => 'Harap isi semua field yang wajib';

  @override
  String get assetSelectCategory => 'Harap pilih kategori';

  @override
  String get assetSavedSuccessfully => 'Aset berhasil disimpan';

  @override
  String get assetOperationFailed => 'Operasi gagal';

  @override
  String get assetDeletedSuccess => 'Aset dihapus';

  @override
  String get assetDeletedFailed => 'Gagal menghapus';

  @override
  String get assetFailedToGenerateDataMatrix => 'Gagal membuat data matrix';

  @override
  String get assetSelectCategoryFirst => 'Harap pilih kategori terlebih dahulu';

  @override
  String assetTagGenerated(String tag) {
    return 'Tag aset dibuat: $tag';
  }

  @override
  String get assetFailedToGenerateTag => 'Gagal membuat tag aset';

  @override
  String get assetEnterAssetTagFirst =>
      'Harap masukkan tag aset terlebih dahulu';

  @override
  String get assetBasicInformation => 'Informasi Dasar';

  @override
  String get assetEnterAssetTag => 'Masukkan tag aset (contoh: AST-001)';

  @override
  String get assetAutoGenerateTag => 'Buat tag aset otomatis';

  @override
  String get assetEnterAssetName => 'Masukkan nama aset';

  @override
  String get assetBrandOptional => 'Merek (Opsional)';

  @override
  String get assetEnterBrand => 'Masukkan nama merek';

  @override
  String get assetModelOptional => 'Model (Opsional)';

  @override
  String get assetEnterModel => 'Masukkan model';

  @override
  String get assetSerialNumberOptional => 'Nomor Seri (Opsional)';

  @override
  String get assetEnterSerialNumber => 'Masukkan nomor seri';

  @override
  String get assetDataMatrixPreview => 'Pratinjau Data Matrix';

  @override
  String get assetRegenerateDataMatrix => 'Buat Ulang Data Matrix';

  @override
  String get assetCategoryAndLocation => 'Kategori & Lokasi';

  @override
  String get assetSearchCategory => 'Cari kategori...';

  @override
  String get assetNotSet => 'Tidak diatur';

  @override
  String get assetChangeLocationInstruction =>
      'Untuk mengubah lokasi, gunakan layar Perpindahan Aset';

  @override
  String get assetLocationOptional => 'Lokasi (Opsional)';

  @override
  String get assetSearchLocation => 'Cari lokasi...';

  @override
  String get assetNotAssigned => 'Tidak ditugaskan';

  @override
  String get assetChangeAssignmentInstruction =>
      'Untuk mengubah penugasan, gunakan layar Perpindahan Aset';

  @override
  String get assetAssignedToOptional => 'Ditugaskan Kepada (Opsional)';

  @override
  String get assetSearchUser => 'Cari pengguna...';

  @override
  String get assetPurchaseDateOptional => 'Tanggal Pembelian (Opsional)';

  @override
  String get assetEnterPurchasePrice => 'Masukkan harga pembelian';

  @override
  String get assetVendorNameOptional => 'Nama Vendor (Opsional)';

  @override
  String get assetEnterVendorName => 'Masukkan nama vendor';

  @override
  String get assetWarrantyEndDateOptional =>
      'Tanggal Berakhir Garansi (Opsional)';

  @override
  String get assetStatusAndCondition => 'Status & Kondisi';

  @override
  String get assetSelectStatus => 'Pilih status';

  @override
  String get assetSelectCondition => 'Pilih kondisi';

  @override
  String get assetUpdate => 'Perbarui';

  @override
  String get assetCreate => 'Buat';

  @override
  String get assetCreateAssetTitle => 'Buat Aset';

  @override
  String get assetCreateAssetSubtitle => 'Tambah aset baru';

  @override
  String get assetSelectManyTitle => 'Pilih Banyak';

  @override
  String get assetSelectManySubtitle => 'Pilih beberapa aset untuk dihapus';

  @override
  String get assetFilterAndSortTitle => 'Filter & Urutkan';

  @override
  String get assetFilterAndSortSubtitle => 'Sesuaikan tampilan aset';

  @override
  String get assetFilterByCategory => 'Filter berdasarkan Kategori';

  @override
  String get assetFilterByLocation => 'Filter berdasarkan Lokasi';

  @override
  String get assetFilterByAssignedTo => 'Filter berdasarkan Ditugaskan Kepada';

  @override
  String get assetEnterBrandFilter => 'Masukkan merek...';

  @override
  String get assetEnterModelFilter => 'Masukkan model...';

  @override
  String get assetSortBy => 'Urutkan Berdasarkan';

  @override
  String get assetSortOrder => 'Urutan';

  @override
  String get assetReset => 'Reset';

  @override
  String get assetApply => 'Terapkan';

  @override
  String get assetFilterReset => 'Filter direset';

  @override
  String get assetFilterApplied => 'Filter diterapkan';

  @override
  String get assetManagement => 'Manajemen Aset';

  @override
  String get assetSelectAssetsToDelete => 'Pilih aset untuk dihapus';

  @override
  String get assetDeleteAssets => 'Hapus Aset';

  @override
  String assetDeleteMultipleConfirmation(int count) {
    return 'Apakah Anda yakin ingin menghapus $count aset?';
  }

  @override
  String get assetNoAssetsSelected => 'Tidak ada aset yang dipilih';

  @override
  String get assetNotImplementedYet => 'Belum diimplementasikan';

  @override
  String assetSelectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String get assetSearchAssets => 'Cari aset...';

  @override
  String get assetNoAssetsFound => 'Tidak ada aset ditemukan';

  @override
  String get assetCreateFirstAsset => 'Buat aset pertama Anda untuk memulai';

  @override
  String get assetLongPressToSelect =>
      'Tekan lama untuk memilih lebih banyak aset';

  @override
  String get assetFiltersAndSorting => 'Filter & Pengurutan';

  @override
  String get assetApplyFilters => 'Terapkan Filter';

  @override
  String get assetMyAssets => 'Aset Saya';

  @override
  String get assetSearchMyAssets => 'Cari aset saya...';

  @override
  String get assetFiltersApplied => 'Filter Diterapkan';

  @override
  String get assetNoAssignedAssets =>
      'Anda tidak memiliki aset yang ditugaskan';

  @override
  String get assetExportAssets => 'Ekspor Aset';

  @override
  String get assetExportFormat => 'Format Ekspor';

  @override
  String get assetIncludeDataMatrixImages => 'Sertakan Gambar Data Matrix';

  @override
  String get assetExportReady => 'Ekspor Siap';

  @override
  String assetExportSize(String size) {
    return 'Ukuran: $size KB';
  }

  @override
  String assetExportFormatDisplay(String format) {
    return 'Format: $format';
  }

  @override
  String get assetExportShareInstruction =>
      'File akan membuka menu berbagi. Pilih aplikasi untuk membuka atau simpan langsung.';

  @override
  String get assetShareAndSave => 'Simpan';

  @override
  String get assetExportSubject => 'Ekspor Aset';

  @override
  String get assetSaveToDownloads => 'Simpan ke Downloads?';

  @override
  String get assetSaveToDownloadsMessage =>
      'File telah dibagikan. Apakah Anda ingin menyimpan salinan ke folder Downloads?';

  @override
  String get assetNo => 'Tidak';

  @override
  String get assetSave => 'Simpan';

  @override
  String get assetFileSharedSuccessfully => 'File berhasil dibagikan';

  @override
  String get assetShareCancelled => 'Berbagi dibatalkan';

  @override
  String assetFailedToShareFile(String error) {
    return 'Gagal berbagi file: $error';
  }

  @override
  String get assetFileSavedSuccessfully =>
      'File berhasil disimpan ke Downloads';

  @override
  String assetFailedToSaveFile(String error) {
    return 'Gagal menyimpan file: $error';
  }

  @override
  String get assetValidationTagRequired => 'Tag aset wajib diisi';

  @override
  String get assetValidationTagMinLength => 'Tag aset minimal 3 karakter';

  @override
  String get assetValidationTagMaxLength => 'Tag aset maksimal 50 karakter';

  @override
  String get assetValidationTagAlphanumeric =>
      'Tag aset hanya boleh mengandung huruf, angka, dan tanda hubung';

  @override
  String get assetValidationNameRequired => 'Nama aset wajib diisi';

  @override
  String get assetValidationNameMinLength => 'Nama aset minimal 3 karakter';

  @override
  String get assetValidationNameMaxLength => 'Nama aset maksimal 100 karakter';

  @override
  String get assetValidationCategoryRequired => 'Kategori wajib diisi';

  @override
  String get assetValidationBrandMaxLength => 'Merek maksimal 50 karakter';

  @override
  String get assetValidationModelMaxLength => 'Model maksimal 50 karakter';

  @override
  String get assetValidationSerialMaxLength =>
      'Nomor seri maksimal 50 karakter';

  @override
  String get assetValidationPriceInvalid =>
      'Harga pembelian harus berupa angka valid';

  @override
  String get assetValidationPriceNegative =>
      'Harga pembelian tidak boleh negatif';

  @override
  String get assetValidationVendorMaxLength =>
      'Nama vendor maksimal 100 karakter';

  @override
  String get assetExport => 'Ekspor';

  @override
  String get assetSelectExportType => 'Pilih jenis ekspor';

  @override
  String get assetExportList => 'Ekspor Daftar';

  @override
  String get assetExportListSubtitle => 'Ekspor aset sebagai daftar';

  @override
  String get assetExportDataMatrix => 'Ekspor Data Matrix';

  @override
  String get assetExportDataMatrixSubtitle =>
      'Ekspor kode data matrix untuk aset';

  @override
  String get assetDataMatrixPdfOnly =>
      'Ekspor data matrix hanya tersedia dalam format PDF';

  @override
  String get assetQuickActions => 'Aksi Cepat';

  @override
  String get assetReportIssue => 'Laporkan\nMasalah';

  @override
  String get assetMoveToUser => 'Pindah ke\nPengguna';

  @override
  String get assetMoveToLocation => 'Pindah ke\nLokasi';

  @override
  String get assetScheduleMaintenance => 'Jadwalkan\nPemel.';

  @override
  String get assetRecordMaintenance => 'Catat\nPemel.';

  @override
  String get assetExportTitle => 'Ekspor';

  @override
  String get assetExportSubtitle => 'Ekspor data ke file';

  @override
  String get assetMovementDeleteAssetMovement => 'Hapus Perpindahan Aset';

  @override
  String get assetMovementDeleteConfirmation =>
      'Apakah Anda yakin ingin menghapus catatan perpindahan aset ini?';

  @override
  String get assetMovementCancel => 'Batal';

  @override
  String get assetMovementDelete => 'Hapus';

  @override
  String get assetMovementDetail => 'Detail Perpindahan Aset';

  @override
  String get assetMovementInformation => 'Informasi Perpindahan';

  @override
  String get assetMovementId => 'ID Perpindahan';

  @override
  String get assetMovementAsset => 'Aset';

  @override
  String get assetMovementMovementType => 'Jenis Perpindahan';

  @override
  String get assetMovementFromLocation => 'Dari Lokasi';

  @override
  String get assetMovementToLocation => 'Ke Lokasi';

  @override
  String get assetMovementFromUser => 'Dari Pengguna';

  @override
  String get assetMovementToUser => 'Ke Pengguna';

  @override
  String get assetMovementMovedBy => 'Dipindahkan Oleh';

  @override
  String get assetMovementMovementDate => 'Tanggal Perpindahan';

  @override
  String get assetMovementNotes => 'Catatan';

  @override
  String get assetMovementStatus => 'Status';

  @override
  String get assetMovementMetadata => 'Metadata';

  @override
  String get assetMovementCreatedAt => 'Dibuat Pada';

  @override
  String get assetMovementUpdatedAt => 'Diperbarui Pada';

  @override
  String get assetMovementOnlyAdminCanEdit =>
      'Hanya admin yang dapat mengedit perpindahan aset';

  @override
  String get assetMovementOnlyAdminCanDelete =>
      'Hanya admin yang dapat menghapus perpindahan aset';

  @override
  String get assetMovementFailedToLoad => 'Gagal memuat perpindahan aset';

  @override
  String get assetMovementEditAssetMovement => 'Edit Perpindahan Aset';

  @override
  String get assetMovementCreateAssetMovement => 'Buat Perpindahan Aset';

  @override
  String get assetMovementFillRequiredFields =>
      'Harap isi semua field yang wajib';

  @override
  String get assetMovementSelectAsset => 'Harap pilih aset';

  @override
  String get assetMovementSavedSuccessfully =>
      'Perpindahan aset berhasil disimpan';

  @override
  String get assetMovementOperationFailed => 'Operasi gagal';

  @override
  String get assetMovementBasicInformation => 'Informasi Dasar';

  @override
  String get assetMovementSelectAssetPlaceholder => 'Pilih aset';

  @override
  String get assetMovementSearchAsset => 'Cari aset...';

  @override
  String get assetMovementSelectMovementType => 'Pilih jenis perpindahan';

  @override
  String get assetMovementLocationDetails => 'Detail Lokasi';

  @override
  String get assetMovementFromLocationLabel => 'Dari Lokasi';

  @override
  String get assetMovementSearchFromLocation => 'Cari dari lokasi...';

  @override
  String get assetMovementToLocationLabel => 'Ke Lokasi';

  @override
  String get assetMovementSearchToLocation => 'Cari ke lokasi...';

  @override
  String get assetMovementUserDetails => 'Detail Pengguna';

  @override
  String get assetMovementFromUserLabel => 'Dari Pengguna';

  @override
  String get assetMovementSearchFromUser => 'Cari dari pengguna...';

  @override
  String get assetMovementToUserLabel => 'Ke Pengguna';

  @override
  String get assetMovementSearchToUser => 'Cari ke pengguna...';

  @override
  String get assetMovementMovementDateLabel => 'Tanggal Perpindahan';

  @override
  String get assetMovementNotesLabel => 'Catatan (Opsional)';

  @override
  String get assetMovementEnterNotes => 'Masukkan catatan...';

  @override
  String get assetMovementUpdate => 'Perbarui';

  @override
  String get assetMovementCreate => 'Buat';

  @override
  String get assetMovementManagement => 'Manajemen Perpindahan Aset';

  @override
  String get assetMovementSearchAssetMovements => 'Cari perpindahan aset...';

  @override
  String get assetMovementNoMovementsFound =>
      'Tidak ada perpindahan aset ditemukan';

  @override
  String get assetMovementCreateFirstMovement =>
      'Buat perpindahan aset pertama Anda untuk memulai';

  @override
  String get assetMovementFilterAndSortTitle => 'Filter & Urutkan';

  @override
  String get assetMovementFilterAndSortSubtitle =>
      'Sesuaikan tampilan perpindahan aset';

  @override
  String get assetMovementFilterByAsset => 'Filter berdasarkan Aset';

  @override
  String get assetMovementFilterByMovementType =>
      'Filter berdasarkan Jenis Perpindahan';

  @override
  String get assetMovementFilterByLocation => 'Filter berdasarkan Lokasi';

  @override
  String get assetMovementFilterByUser => 'Filter berdasarkan Pengguna';

  @override
  String get assetMovementSortBy => 'Urutkan Berdasarkan';

  @override
  String get assetMovementSortOrder => 'Urutan';

  @override
  String get assetMovementReset => 'Reset';

  @override
  String get assetMovementApply => 'Terapkan';

  @override
  String get assetMovementFilterReset => 'Filter direset';

  @override
  String get assetMovementFilterApplied => 'Filter diterapkan';

  @override
  String get assetMovementStatistics => 'Statistik Perpindahan';

  @override
  String get assetMovementTotalMovements => 'Total Perpindahan';

  @override
  String get assetMovementByType => 'Perpindahan berdasarkan Jenis';

  @override
  String get assetMovementByStatus => 'Perpindahan berdasarkan Status';

  @override
  String get assetMovementRecentActivity => 'Aktivitas Terbaru';

  @override
  String get assetMovementValidationAssetRequired => 'Aset wajib diisi';

  @override
  String get assetMovementValidationMovementTypeRequired =>
      'Jenis perpindahan wajib diisi';

  @override
  String get assetMovementValidationLocationRequired =>
      'Lokasi wajib diisi untuk jenis perpindahan ini';

  @override
  String get assetMovementValidationUserRequired =>
      'Pengguna wajib diisi untuk jenis perpindahan ini';

  @override
  String get assetMovementValidationMovementDateRequired =>
      'Tanggal perpindahan wajib diisi';

  @override
  String get assetMovementValidationNotesMaxLength =>
      'Catatan maksimal 500 karakter';

  @override
  String get assetMovementValidationToLocationRequired =>
      'Lokasi tujuan wajib diisi';

  @override
  String get assetMovementValidationToUserRequired =>
      'Pengguna tujuan wajib diisi';

  @override
  String get assetMovementValidationMovedByRequired =>
      'Dipindahkan oleh wajib diisi';

  @override
  String get assetMovementValidationMovementDateFuture =>
      'Tanggal perpindahan tidak boleh di masa depan';

  @override
  String get assetMovementTranslations => 'Terjemahan';

  @override
  String get assetMovementUnknownAsset => 'Aset Tidak Diketahui';

  @override
  String get assetMovementUnknownTag => 'Tag Tidak Diketahui';

  @override
  String get assetMovementUnknown => 'Tidak Diketahui';

  @override
  String get assetMovementUnassigned => 'Tidak Ditugaskan';

  @override
  String get assetMovementNotSet => 'Tidak diatur';

  @override
  String get assetMovementLocationMovement => 'Perpindahan Lokasi';

  @override
  String get assetMovementUserMovement => 'Perpindahan Pengguna';

  @override
  String get assetMovementCreateAssetMovementTitle => 'Buat Perpindahan Aset';

  @override
  String get assetMovementCreateAssetMovementSubtitle =>
      'Catat perpindahan aset baru';

  @override
  String get assetMovementForLocation => 'Perpindahan Aset untuk Lokasi';

  @override
  String get assetMovementForUser => 'Perpindahan Aset untuk Pengguna';

  @override
  String get assetMovementCurrentLocation => 'Lokasi Saat Ini';

  @override
  String get assetMovementNewLocation => 'Lokasi Baru';

  @override
  String get assetMovementCurrentUser => 'Pengguna Saat Ini';

  @override
  String get assetMovementNewUser => 'Pengguna Baru';

  @override
  String get assetMovementMovementHistory => 'Riwayat Perpindahan';

  @override
  String get assetMovementNoHistory => 'Tidak ada riwayat perpindahan tersedia';

  @override
  String get assetMovementViewAll => 'Lihat Semua';

  @override
  String get assetMovementMovedTo => 'Dipindahkan ke';

  @override
  String get assetMovementAssignedTo => 'Ditugaskan ke';

  @override
  String get assetMovementSelectMany => 'Pilih Banyak';

  @override
  String get assetMovementSelectManySubtitle =>
      'Pilih beberapa perpindahan aset untuk dihapus';

  @override
  String get assetMovementSelectAssetMovementsToDelete =>
      'Pilih perpindahan aset untuk dihapus';

  @override
  String get assetMovementChooseMovementType => 'Pilih jenis perpindahan:';

  @override
  String get assetMovementFilterByFromLocation =>
      'Filter berdasarkan Dari Lokasi';

  @override
  String get assetMovementFilterByToLocation => 'Filter berdasarkan Ke Lokasi';

  @override
  String get assetMovementFilterByFromUser =>
      'Filter berdasarkan Dari Pengguna';

  @override
  String get assetMovementFilterByToUser => 'Filter berdasarkan Ke Pengguna';

  @override
  String get assetMovementFilterByMovedBy =>
      'Filter berdasarkan Dipindahkan Oleh';

  @override
  String get assetMovementDateFrom => 'Tanggal Dari';

  @override
  String get assetMovementDateTo => 'Tanggal Sampai';

  @override
  String get assetMovementSearchAssetPlaceholder => 'Cari aset...';

  @override
  String get assetMovementSearchFromLocationPlaceholder =>
      'Cari dari lokasi...';

  @override
  String get assetMovementSearchToLocationPlaceholder => 'Cari ke lokasi...';

  @override
  String get assetMovementSearchFromUserPlaceholder => 'Cari dari pengguna...';

  @override
  String get assetMovementSearchToUserPlaceholder => 'Cari ke pengguna...';

  @override
  String get assetMovementSearchMovedByPlaceholder =>
      'Cari pengguna yang memindahkan...';

  @override
  String get assetMovementDeleteAssetMovements => 'Hapus Perpindahan Aset';

  @override
  String assetMovementDeleteManyConfirmation(int count) {
    return 'Apakah Anda yakin ingin menghapus $count perpindahan aset?';
  }

  @override
  String get assetMovementNoAssetMovementsSelected =>
      'Tidak ada perpindahan aset yang dipilih';

  @override
  String get assetMovementNotImplementedYet => 'Belum diimplementasikan';

  @override
  String assetMovementSelectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String get assetMovementLongPressToSelectMore =>
      'Tekan lama untuk memilih lebih banyak perpindahan aset';

  @override
  String get assetMovementForLocationShort => 'Untuk Lokasi';

  @override
  String get assetMovementForUserShort => 'Untuk Pengguna';

  @override
  String get authWelcomeBack => 'Selamat Datang Kembali';

  @override
  String get authSignInToContinue => 'Masuk untuk melanjutkan';

  @override
  String get authEmail => 'Email';

  @override
  String get authEnterYourEmail => 'Masukkan email Anda';

  @override
  String get authPassword => 'Kata Sandi';

  @override
  String get authEnterYourPassword => 'Masukkan kata sandi Anda';

  @override
  String get authForgotPassword => 'Lupa Kata Sandi?';

  @override
  String get authLogin => 'Masuk';

  @override
  String get authDontHaveAccount => 'Belum punya akun? ';

  @override
  String get authRegister => 'Daftar';

  @override
  String get authLoginSuccessful => 'Login berhasil';

  @override
  String get authCreateAccount => 'Buat Akun';

  @override
  String get authSignUpToGetStarted => 'Daftar untuk memulai';

  @override
  String get authName => 'Nama';

  @override
  String get authEnterYourName => 'Masukkan nama Anda';

  @override
  String get authConfirmPassword => 'Konfirmasi Kata Sandi';

  @override
  String get authReEnterYourPassword => 'Masukkan ulang kata sandi Anda';

  @override
  String get authPasswordMustContain => 'Kata sandi harus berisi:';

  @override
  String get authPasswordRequirementPlaceholder => 'Buat kata sandi saja bro!';

  @override
  String get authRegistrationSuccessful => 'Pendaftaran berhasil';

  @override
  String get authAlreadyHaveAccount => 'Sudah punya akun? ';

  @override
  String get authForgotPasswordTitle => 'Lupa Kata Sandi';

  @override
  String get authEnterEmailToResetPassword =>
      'Masukkan email Anda untuk mereset kata sandi';

  @override
  String get authSendResetLink => 'Kirim Tautan Reset';

  @override
  String get authEmailSentSuccessfully => 'Email berhasil dikirim';

  @override
  String get authRememberPassword => 'Ingat kata sandi Anda? ';

  @override
  String get authValidationEmailRequired => 'Email wajib diisi';

  @override
  String get authValidationEmailInvalid =>
      'Silakan masukkan alamat email yang valid';

  @override
  String get authValidationPasswordRequired => 'Kata sandi wajib diisi';

  @override
  String get authValidationNameRequired => 'Nama wajib diisi';

  @override
  String get authValidationNameMinLength => 'Nama minimal 3 karakter';

  @override
  String get authValidationNameMaxLength => 'Nama maksimal 20 karakter';

  @override
  String get authValidationNameAlphanumeric =>
      'Nama hanya boleh berisi huruf, angka, dan garis bawah';

  @override
  String get authValidationConfirmPasswordRequired =>
      'Silakan konfirmasi kata sandi Anda';

  @override
  String get authValidationPasswordsDoNotMatch => 'Kata sandi tidak cocok';

  @override
  String get categoryDetail => 'Detail Kategori';

  @override
  String get categoryInformation => 'Informasi Kategori';

  @override
  String get categoryCategoryCode => 'Kode Kategori';

  @override
  String get categoryCategoryName => 'Nama Kategori';

  @override
  String get categoryDescription => 'Deskripsi';

  @override
  String get categoryParentCategory => 'Kategori Induk';

  @override
  String get categoryMetadata => 'Metadata';

  @override
  String get categoryCreatedAt => 'Dibuat Pada';

  @override
  String get categoryUpdatedAt => 'Diperbarui Pada';

  @override
  String get categoryOnlyAdminCanEdit =>
      'Hanya admin yang dapat mengedit kategori';

  @override
  String get categoryOnlyAdminCanDelete =>
      'Hanya admin yang dapat menghapus kategori';

  @override
  String get categoryDeleteCategory => 'Hapus Kategori';

  @override
  String categoryDeleteConfirmation(String categoryName) {
    return 'Apakah Anda yakin ingin menghapus \"$categoryName\"?';
  }

  @override
  String get categoryCancel => 'Batal';

  @override
  String get categoryDelete => 'Hapus';

  @override
  String get categoryCategoryDeleted => 'Kategori dihapus';

  @override
  String get categoryDeleteFailed => 'Gagal menghapus';

  @override
  String get categoryEditCategory => 'Edit Kategori';

  @override
  String get categoryCreateCategory => 'Buat Kategori';

  @override
  String get categorySearchCategory => 'Cari kategori...';

  @override
  String get categoryEnterCategoryCode =>
      'Masukkan kode kategori (contoh: CAT-001)';

  @override
  String get categoryTranslations => 'Terjemahan';

  @override
  String get categoryAddTranslations =>
      'Tambahkan terjemahan untuk bahasa yang berbeda';

  @override
  String get categoryEnglish => 'Inggris';

  @override
  String get categoryJapanese => 'Jepang';

  @override
  String get categoryIndonesian => 'Indonesia';

  @override
  String get categoryEnterCategoryName => 'Masukkan nama kategori';

  @override
  String get categoryEnterDescription => 'Masukkan deskripsi';

  @override
  String get categoryUpdate => 'Perbarui';

  @override
  String get categoryCreate => 'Buat';

  @override
  String get categoryFillRequiredFields => 'Harap isi semua field yang wajib';

  @override
  String get categorySavedSuccessfully => 'Kategori berhasil disimpan';

  @override
  String get categoryOperationFailed => 'Operasi gagal';

  @override
  String get categoryFailedToLoadTranslations => 'Gagal memuat terjemahan';

  @override
  String get categoryManagement => 'Manajemen Kategori';

  @override
  String get categorySearchCategories => 'Cari kategori...';

  @override
  String get categoryCreateCategoryTitle => 'Buat Kategori';

  @override
  String get categoryCreateCategorySubtitle => 'Tambah kategori baru';

  @override
  String get categorySelectManyTitle => 'Pilih Banyak';

  @override
  String get categorySelectManySubtitle =>
      'Pilih beberapa kategori untuk dihapus';

  @override
  String get categoryFilterAndSortTitle => 'Filter & Urutkan';

  @override
  String get categoryFilterAndSortSubtitle => 'Sesuaikan tampilan kategori';

  @override
  String get categorySelectCategoriesToDelete => 'Pilih kategori untuk dihapus';

  @override
  String get categorySortBy => 'Urutkan Berdasarkan';

  @override
  String get categorySortOrder => 'Urutan';

  @override
  String get categoryHasParent => 'Memiliki Induk';

  @override
  String get categoryFilterByParent => 'Filter berdasarkan Kategori Induk';

  @override
  String get categorySearchParentCategory => 'Cari kategori induk...';

  @override
  String get categoryReset => 'Reset';

  @override
  String get categoryApply => 'Terapkan';

  @override
  String get categoryFilterReset => 'Filter direset';

  @override
  String get categoryFilterApplied => 'Filter diterapkan';

  @override
  String get categoryDeleteCategories => 'Hapus Kategori';

  @override
  String categoryDeleteMultipleConfirmation(int count) {
    return 'Apakah Anda yakin ingin menghapus $count kategori?';
  }

  @override
  String get categoryNoCategoriesSelected => 'Tidak ada kategori yang dipilih';

  @override
  String get categoryNotImplementedYet => 'Belum diimplementasikan';

  @override
  String categorySelectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String get categoryNoCategoriesFound => 'Tidak ada kategori ditemukan';

  @override
  String get categoryCreateFirstCategory =>
      'Buat kategori pertama Anda untuk memulai';

  @override
  String get categoryLongPressToSelect =>
      'Tekan lama untuk memilih lebih banyak kategori';

  @override
  String get categoryValidationCodeRequired => 'Kode kategori wajib diisi';

  @override
  String get categoryValidationCodeMinLength =>
      'Kode kategori minimal 2 karakter';

  @override
  String get categoryValidationCodeMaxLength =>
      'Kode kategori maksimal 20 karakter';

  @override
  String get categoryValidationCodeAlphanumeric =>
      'Kode kategori hanya boleh mengandung huruf, angka, dan garis bawah';

  @override
  String get categoryValidationNameRequired => 'Nama kategori wajib diisi';

  @override
  String get categoryValidationNameMinLength =>
      'Nama kategori minimal 3 karakter';

  @override
  String get categoryValidationNameMaxLength =>
      'Nama kategori maksimal 100 karakter';

  @override
  String get categoryValidationDescriptionRequired => 'Deskripsi wajib diisi';

  @override
  String get categoryValidationDescriptionMinLength =>
      'Deskripsi minimal 10 karakter';

  @override
  String get categoryValidationDescriptionMaxLength =>
      'Deskripsi maksimal 500 karakter';

  @override
  String get dashboardTotalUsers => 'Total Pengguna';

  @override
  String get dashboardTotalAssets => 'Total Aset';

  @override
  String get dashboardAssetStatusOverview => 'Ikhtisar Status Aset';

  @override
  String get dashboardActive => 'Aktif';

  @override
  String get dashboardMaintenance => 'Pemeliharaan';

  @override
  String get dashboardDisposed => 'Dibuang';

  @override
  String get dashboardLost => 'Hilang';

  @override
  String get dashboardUserRoleDistribution => 'Distribusi Peran Pengguna';

  @override
  String get dashboardAdmin => 'Admin';

  @override
  String get dashboardStaff => 'Staf';

  @override
  String get dashboardEmployee => 'Karyawan';

  @override
  String get dashboardAssetStatusBreakdown => 'Rincian Status Aset';

  @override
  String get dashboardAssetConditionOverview => 'Ikhtisar Kondisi Aset';

  @override
  String get dashboardGood => 'Baik';

  @override
  String get dashboardFair => 'Cukup';

  @override
  String get dashboardPoor => 'Buruk';

  @override
  String get dashboardDamaged => 'Rusak';

  @override
  String get dashboardUserRegistrationTrends => 'Tren Registrasi Pengguna';

  @override
  String get dashboardAssetCreationTrends => 'Tren Pembuatan Aset';

  @override
  String get dashboardCategories => 'Kategori';

  @override
  String get dashboardLocations => 'Lokasi';

  @override
  String get dashboardActivityOverview => 'Ikhtisar Aktivitas';

  @override
  String get dashboardScanLogs => 'Log Pemindaian';

  @override
  String get dashboardNotifications => 'Notifikasi';

  @override
  String get dashboardAssetMovements => 'Perpindahan Aset';

  @override
  String get dashboardIssueReports => 'Laporan Masalah';

  @override
  String get dashboardMaintenanceSchedules => 'Jadwal Pemeliharaan';

  @override
  String get dashboardMaintenanceRecords => 'Catatan Pemeliharaan';

  @override
  String get homeScreen => 'Beranda';

  @override
  String get issueReportDeleteIssueReport => 'Hapus Laporan Masalah';

  @override
  String issueReportDeleteConfirmation(String title) {
    return 'Apakah Anda yakin ingin menghapus \"$title\"?';
  }

  @override
  String get issueReportCancel => 'Batal';

  @override
  String get issueReportDelete => 'Hapus';

  @override
  String get issueReportDetail => 'Detail Laporan Masalah';

  @override
  String get issueReportInformation => 'Informasi Laporan Masalah';

  @override
  String get issueReportTitle => 'Judul';

  @override
  String get issueReportDescription => 'Deskripsi';

  @override
  String get issueReportAsset => 'Aset';

  @override
  String get issueReportIssueType => 'Jenis Masalah';

  @override
  String get issueReportPriority => 'Prioritas';

  @override
  String get issueReportStatus => 'Status';

  @override
  String get issueReportReportedBy => 'Dilaporkan Oleh';

  @override
  String get issueReportReportedDate => 'Tanggal Dilaporkan';

  @override
  String get issueReportResolvedDate => 'Tanggal Diselesaikan';

  @override
  String get issueReportResolvedBy => 'Diselesaikan Oleh';

  @override
  String get issueReportResolutionNotes => 'Catatan Resolusi';

  @override
  String get issueReportMetadata => 'Metadata';

  @override
  String get issueReportCreatedAt => 'Dibuat Pada';

  @override
  String get issueReportUpdatedAt => 'Diperbarui Pada';

  @override
  String get issueReportOnlyAdminCanEdit =>
      'Hanya admin yang dapat mengedit laporan masalah';

  @override
  String get issueReportOnlyAdminCanDelete =>
      'Hanya admin yang dapat menghapus laporan masalah';

  @override
  String get issueReportFailedToLoad => 'Gagal memuat laporan masalah';

  @override
  String get issueReportDeletedSuccess => 'Laporan masalah dihapus';

  @override
  String get issueReportDeletedFailed => 'Gagal menghapus';

  @override
  String get issueReportUnknownAsset => 'Aset Tidak Diketahui';

  @override
  String get issueReportUnknownUser => 'Pengguna Tidak Diketahui';

  @override
  String get issueReportEditIssueReport => 'Edit Laporan Masalah';

  @override
  String get issueReportCreateIssueReport => 'Buat Laporan Masalah';

  @override
  String get issueReportFillRequiredFields =>
      'Harap isi semua field yang wajib';

  @override
  String get issueReportSavedSuccessfully =>
      'Laporan masalah berhasil disimpan';

  @override
  String get issueReportOperationFailed => 'Operasi gagal';

  @override
  String get issueReportFailedToLoadTranslations => 'Gagal memuat terjemahan';

  @override
  String get issueReportSearchAsset => 'Cari dan pilih aset';

  @override
  String get issueReportSearchReportedBy =>
      'Cari dan pilih pengguna yang melaporkan masalah';

  @override
  String get issueReportEnterIssueType =>
      'Masukkan jenis masalah (contoh: Hardware, Software)';

  @override
  String get issueReportSelectPriority => 'Pilih prioritas';

  @override
  String get issueReportSelectStatus => 'Pilih status';

  @override
  String get issueReportSearchResolvedBy =>
      'Cari dan pilih pengguna yang menyelesaikan masalah';

  @override
  String get issueReportTranslations => 'Terjemahan';

  @override
  String get issueReportEnglish => 'Inggris';

  @override
  String get issueReportJapanese => 'Jepang';

  @override
  String get issueReportIndonesian => 'Indonesia';

  @override
  String issueReportEnterTitleIn(String language) {
    return 'Masukkan judul dalam $language';
  }

  @override
  String issueReportEnterDescriptionIn(String language) {
    return 'Masukkan deskripsi dalam $language';
  }

  @override
  String issueReportEnterResolutionNotesIn(String language) {
    return 'Masukkan catatan resolusi dalam $language';
  }

  @override
  String get issueReportUpdate => 'Perbarui';

  @override
  String get issueReportCreate => 'Buat';

  @override
  String get issueReportManagement => 'Manajemen Laporan Masalah';

  @override
  String get issueReportCreateIssueReportTitle => 'Buat Laporan Masalah';

  @override
  String get issueReportCreateIssueReportSubtitle =>
      'Tambah laporan masalah baru';

  @override
  String get issueReportSelectManyTitle => 'Pilih Banyak';

  @override
  String get issueReportSelectManySubtitle =>
      'Pilih beberapa laporan masalah untuk dihapus';

  @override
  String get issueReportFilterAndSortTitle => 'Filter & Urutkan';

  @override
  String get issueReportFilterAndSortSubtitle =>
      'Sesuaikan tampilan laporan masalah';

  @override
  String get issueReportSelectIssueReportsToDelete =>
      'Pilih laporan masalah untuk dihapus';

  @override
  String get issueReportDeleteIssueReports => 'Hapus Laporan Masalah';

  @override
  String issueReportDeleteMultipleConfirmation(int count) {
    return 'Apakah Anda yakin ingin menghapus $count laporan masalah?';
  }

  @override
  String get issueReportNoIssueReportsSelected =>
      'Tidak ada laporan masalah yang dipilih';

  @override
  String get issueReportNotImplementedYet => 'Belum diimplementasikan';

  @override
  String issueReportSelectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String get issueReportSearchIssueReports => 'Cari laporan masalah...';

  @override
  String get issueReportNoIssueReportsFound =>
      'Tidak ada laporan masalah ditemukan';

  @override
  String get issueReportCreateFirstIssueReport =>
      'Buat laporan masalah pertama Anda untuk memulai';

  @override
  String get issueReportLongPressToSelect =>
      'Tekan lama untuk memilih lebih banyak laporan masalah';

  @override
  String get issueReportFilterByAsset => 'Filter berdasarkan Aset';

  @override
  String get issueReportFilterByReportedBy =>
      'Filter berdasarkan Dilaporkan Oleh';

  @override
  String get issueReportFilterByResolvedBy =>
      'Filter berdasarkan Diselesaikan Oleh';

  @override
  String get issueReportSearchAssetFilter => 'Cari aset...';

  @override
  String get issueReportSearchUserFilter => 'Cari pengguna...';

  @override
  String get issueReportEnterIssueTypeFilter => 'Masukkan jenis masalah...';

  @override
  String get issueReportSortBy => 'Urutkan Berdasarkan';

  @override
  String get issueReportSortOrder => 'Urutan';

  @override
  String get issueReportIsResolved => 'Sudah Diselesaikan';

  @override
  String get issueReportDateFrom => 'Tanggal Dari';

  @override
  String get issueReportDateTo => 'Tanggal Sampai';

  @override
  String get issueReportReset => 'Reset';

  @override
  String get issueReportApply => 'Terapkan';

  @override
  String get issueReportFilterReset => 'Filter direset';

  @override
  String get issueReportFilterApplied => 'Filter diterapkan';

  @override
  String get issueReportMyIssueReports => 'Laporan Masalah Saya';

  @override
  String get issueReportSearchMyIssueReports => 'Cari laporan masalah saya...';

  @override
  String get issueReportFiltersAndSorting => 'Filter & Pengurutan';

  @override
  String get issueReportApplyFilters => 'Terapkan Filter';

  @override
  String get issueReportFiltersApplied => 'Filter Diterapkan';

  @override
  String get issueReportFilterAndSort => 'Filter & Urutkan';

  @override
  String get issueReportNoIssueReportsFoundEmpty =>
      'Tidak ada laporan masalah ditemukan';

  @override
  String get issueReportYouHaveNoReportedIssues =>
      'Anda tidak memiliki laporan masalah';

  @override
  String get issueReportCreateIssueReportTooltip => 'Buat Laporan Masalah';

  @override
  String get issueReportValidationAssetRequired => 'Aset wajib diisi';

  @override
  String get issueReportValidationReportedByRequired =>
      'Dilaporkan oleh wajib diisi';

  @override
  String get issueReportValidationIssueTypeRequired =>
      'Jenis masalah wajib diisi';

  @override
  String get issueReportValidationIssueTypeMaxLength =>
      'Jenis masalah maksimal 100 karakter';

  @override
  String get issueReportValidationPriorityRequired => 'Prioritas wajib diisi';

  @override
  String get issueReportValidationStatusRequired => 'Status wajib diisi';

  @override
  String get issueReportValidationTitleRequired => 'Judul wajib diisi';

  @override
  String get issueReportValidationTitleMaxLength =>
      'Judul maksimal 200 karakter';

  @override
  String get issueReportValidationDescriptionMaxLength =>
      'Deskripsi maksimal 1000 karakter';

  @override
  String get issueReportValidationResolutionNotesMaxLength =>
      'Catatan resolusi maksimal 1000 karakter';

  @override
  String get locationDeleteLocation => 'Hapus Lokasi';

  @override
  String locationDeleteConfirmation(String locationName) {
    return 'Apakah Anda yakin ingin menghapus \"$locationName\"?';
  }

  @override
  String get locationCancel => 'Batal';

  @override
  String get locationDelete => 'Hapus';

  @override
  String get locationDetail => 'Detail Lokasi';

  @override
  String get locationInformation => 'Informasi Lokasi';

  @override
  String get locationCode => 'Kode Lokasi';

  @override
  String get locationName => 'Nama Lokasi';

  @override
  String get locationBuilding => 'Gedung';

  @override
  String get locationFloor => 'Lantai';

  @override
  String get locationLatitude => 'Lintang';

  @override
  String get locationLongitude => 'Bujur';

  @override
  String get locationMetadata => 'Metadata';

  @override
  String get locationCreatedAt => 'Dibuat Pada';

  @override
  String get locationUpdatedAt => 'Diperbarui Pada';

  @override
  String get locationOnlyAdminCanEdit =>
      'Hanya admin yang dapat mengedit lokasi';

  @override
  String get locationOnlyAdminCanDelete =>
      'Hanya admin yang dapat menghapus lokasi';

  @override
  String get locationFailedToLoad => 'Gagal memuat lokasi';

  @override
  String get locationDeleted => 'Lokasi dihapus';

  @override
  String get locationDeleteFailed => 'Gagal menghapus';

  @override
  String get locationEditLocation => 'Edit Lokasi';

  @override
  String get locationCreateLocation => 'Buat Lokasi';

  @override
  String get locationFillRequiredFields => 'Harap isi semua field yang wajib';

  @override
  String get locationSavedSuccessfully => 'Lokasi berhasil disimpan';

  @override
  String get locationOperationFailed => 'Operasi gagal';

  @override
  String get locationFailedToLoadTranslations => 'Gagal memuat terjemahan';

  @override
  String get locationEnterLocationCode =>
      'Masukkan kode lokasi (contoh: LOC-001)';

  @override
  String get locationBuildingOptional => 'Gedung (Opsional)';

  @override
  String get locationEnterBuilding => 'Masukkan nama gedung';

  @override
  String get locationFloorOptional => 'Lantai (Opsional)';

  @override
  String get locationEnterFloor => 'Masukkan nomor lantai';

  @override
  String get locationLatitudeOptional => 'Lintang (Opsional)';

  @override
  String get locationEnterLatitude => 'Masukkan lintang';

  @override
  String get locationLongitudeOptional => 'Bujur (Opsional)';

  @override
  String get locationEnterLongitude => 'Masukkan bujur';

  @override
  String get locationGettingLocation => 'Mendapatkan Lokasi...';

  @override
  String get locationUseCurrentLocation => 'Gunakan Lokasi Saat Ini';

  @override
  String get locationServicesDisabled => 'Layanan lokasi dinonaktifkan';

  @override
  String get locationServicesDialogTitle => 'Layanan Lokasi Dinonaktifkan';

  @override
  String get locationServicesDialogMessage =>
      'Layanan lokasi diperlukan untuk mendapatkan lokasi Anda saat ini. Apakah Anda ingin mengaktifkannya?';

  @override
  String get locationOpenSettings => 'Buka Pengaturan';

  @override
  String get locationPermissionDenied => 'Izin lokasi ditolak';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Izin lokasi ditolak secara permanen';

  @override
  String get locationPermissionRequired => 'Izin Diperlukan';

  @override
  String get locationPermissionDialogMessage =>
      'Izin lokasi ditolak secara permanen. Silakan aktifkan di pengaturan aplikasi.';

  @override
  String get locationRetrievedSuccessfully =>
      'Lokasi saat ini berhasil didapatkan';

  @override
  String get locationFailedToGetCurrent => 'Gagal mendapatkan lokasi saat ini';

  @override
  String get locationTranslations => 'Terjemahan';

  @override
  String get locationTranslationsSubtitle =>
      'Tambahkan terjemahan untuk bahasa yang berbeda';

  @override
  String get locationEnglish => 'Inggris';

  @override
  String get locationJapanese => 'Jepang';

  @override
  String get locationIndonesian => 'Indonesia';

  @override
  String get locationEnterLocationName => 'Masukkan nama lokasi';

  @override
  String get locationUpdate => 'Perbarui';

  @override
  String get locationCreate => 'Buat';

  @override
  String get locationManagement => 'Manajemen Lokasi';

  @override
  String get locationCreateLocationTitle => 'Buat Lokasi';

  @override
  String get locationCreateLocationSubtitle => 'Tambah lokasi baru';

  @override
  String get locationSelectManyTitle => 'Pilih Banyak';

  @override
  String get locationSelectManySubtitle =>
      'Pilih beberapa lokasi untuk dihapus';

  @override
  String get locationFilterAndSortTitle => 'Filter & Urutkan';

  @override
  String get locationFilterAndSortSubtitle => 'Sesuaikan tampilan lokasi';

  @override
  String get locationSelectLocationsToDelete => 'Pilih lokasi untuk dihapus';

  @override
  String get locationSortBy => 'Urutkan Berdasarkan';

  @override
  String get locationSortOrder => 'Urutan';

  @override
  String get locationReset => 'Reset';

  @override
  String get locationApply => 'Terapkan';

  @override
  String get locationFilterReset => 'Filter direset';

  @override
  String get locationFilterApplied => 'Filter diterapkan';

  @override
  String get locationDeleteLocations => 'Hapus Lokasi';

  @override
  String locationDeleteMultipleConfirmation(int count) {
    return 'Apakah Anda yakin ingin menghapus $count lokasi?';
  }

  @override
  String get locationNoLocationsSelected => 'Tidak ada lokasi yang dipilih';

  @override
  String get locationNotImplementedYet => 'Belum diimplementasikan';

  @override
  String locationSelectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String get locationSearchLocations => 'Cari lokasi...';

  @override
  String get locationNoLocationsFound => 'Tidak ada lokasi ditemukan';

  @override
  String get locationCreateFirstLocation =>
      'Buat lokasi pertama Anda untuk memulai';

  @override
  String get locationLongPressToSelect =>
      'Tekan lama untuk memilih lebih banyak lokasi';

  @override
  String locationFloorPrefix(String floor) {
    return 'Lantai $floor';
  }

  @override
  String get locationValidationCodeRequired => 'Kode lokasi wajib diisi';

  @override
  String get locationValidationCodeMinLength =>
      'Kode lokasi minimal 2 karakter';

  @override
  String get locationValidationCodeMaxLength =>
      'Kode lokasi maksimal 20 karakter';

  @override
  String get locationValidationCodeAlphanumeric =>
      'Kode lokasi hanya boleh mengandung huruf, angka, dan tanda hubung';

  @override
  String get locationValidationNameRequired => 'Nama lokasi wajib diisi';

  @override
  String get locationValidationNameMinLength =>
      'Nama lokasi minimal 3 karakter';

  @override
  String get locationValidationNameMaxLength =>
      'Nama lokasi maksimal 100 karakter';

  @override
  String get locationValidationBuildingMaxLength =>
      'Gedung maksimal 50 karakter';

  @override
  String get locationValidationFloorMaxLength => 'Lantai maksimal 20 karakter';

  @override
  String get locationValidationLatitudeInvalid =>
      'Lintang harus berupa angka valid';

  @override
  String get locationValidationLatitudeRange =>
      'Lintang harus antara -90 dan 90';

  @override
  String get locationValidationLongitudeInvalid =>
      'Bujur harus berupa angka valid';

  @override
  String get locationValidationLongitudeRange =>
      'Bujur harus antara -180 dan 180';

  @override
  String get locationNotFound => 'Lokasi tidak ditemukan';

  @override
  String get locationSearchFailed => 'Pencarian gagal';

  @override
  String get locationConfirmLocation => 'Konfirmasi Lokasi';

  @override
  String get locationSelectedFromMap => 'Lokasi dipilih dari peta';

  @override
  String get locationSearchLocation => 'Cari lokasi...';

  @override
  String get locationPickFromMap => 'Pilih dari peta';

  @override
  String get maintenanceScheduleDeleteSchedule => 'Hapus Jadwal Pemeliharaan';

  @override
  String maintenanceScheduleDeleteConfirmation(String title) {
    return 'Apakah Anda yakin ingin menghapus \"$title\"?';
  }

  @override
  String get maintenanceScheduleDeleted => 'Jadwal pemeliharaan dihapus';

  @override
  String get maintenanceScheduleDeleteFailed => 'Gagal menghapus';

  @override
  String get maintenanceScheduleDetail => 'Detail Jadwal Pemeliharaan';

  @override
  String get maintenanceScheduleInformation => 'Informasi Jadwal Pemeliharaan';

  @override
  String get maintenanceScheduleTitle => 'Judul';

  @override
  String get maintenanceScheduleDescription => 'Deskripsi';

  @override
  String get maintenanceScheduleAsset => 'Aset';

  @override
  String get maintenanceScheduleMaintenanceType => 'Jenis Pemeliharaan';

  @override
  String get maintenanceScheduleIsRecurring => 'Berulang';

  @override
  String get maintenanceScheduleInterval => 'Interval';

  @override
  String get maintenanceScheduleScheduledTime => 'Waktu Terjadwal';

  @override
  String get maintenanceScheduleNextScheduledDate =>
      'Tanggal Terjadwal Berikutnya';

  @override
  String get maintenanceScheduleLastExecutedDate => 'Tanggal Eksekusi Terakhir';

  @override
  String get maintenanceScheduleState => 'Status';

  @override
  String get maintenanceScheduleAutoComplete => 'Selesai Otomatis';

  @override
  String get maintenanceScheduleEstimatedCost => 'Estimasi Biaya';

  @override
  String get maintenanceScheduleCreatedBy => 'Dibuat Oleh';

  @override
  String get maintenanceScheduleYes => 'Ya';

  @override
  String get maintenanceScheduleNo => 'Tidak';

  @override
  String get maintenanceScheduleUnknownAsset => 'Aset Tidak Diketahui';

  @override
  String get maintenanceScheduleUnknownUser => 'Pengguna Tidak Diketahui';

  @override
  String get maintenanceScheduleOnlyAdminCanEdit =>
      'Hanya admin yang dapat mengedit jadwal pemeliharaan';

  @override
  String get maintenanceScheduleOnlyAdminCanDelete =>
      'Hanya admin yang dapat menghapus jadwal pemeliharaan';

  @override
  String get maintenanceScheduleFailedToLoad =>
      'Gagal memuat jadwal pemeliharaan';

  @override
  String get maintenanceScheduleEditSchedule => 'Edit Jadwal Pemeliharaan';

  @override
  String get maintenanceScheduleCreateSchedule => 'Buat Jadwal Pemeliharaan';

  @override
  String get maintenanceScheduleFillRequiredFields =>
      'Harap isi semua field yang wajib';

  @override
  String get maintenanceScheduleSavedSuccessfully =>
      'Jadwal pemeliharaan berhasil disimpan';

  @override
  String get maintenanceScheduleOperationFailed => 'Operasi gagal';

  @override
  String get maintenanceScheduleFailedToLoadTranslations =>
      'Gagal memuat terjemahan';

  @override
  String get maintenanceScheduleSearchAsset => 'Cari dan pilih aset';

  @override
  String get maintenanceScheduleSelectMaintenanceType =>
      'Pilih jenis pemeliharaan';

  @override
  String get maintenanceScheduleEnterIntervalValue =>
      'Masukkan nilai interval (contoh: 3)';

  @override
  String get maintenanceScheduleSelectIntervalUnit => 'Pilih unit interval';

  @override
  String get maintenanceScheduleEnterScheduledTime => 'contoh: 09:30';

  @override
  String get maintenanceScheduleSelectState => 'Pilih status';

  @override
  String get maintenanceScheduleEnterEstimatedCost =>
      'Masukkan estimasi biaya (opsional)';

  @override
  String get maintenanceScheduleSearchUser =>
      'Cari dan pilih pengguna yang membuat jadwal';

  @override
  String get maintenanceScheduleTranslations => 'Terjemahan';

  @override
  String get maintenanceScheduleEnglish => 'Inggris';

  @override
  String get maintenanceScheduleJapanese => 'Jepang';

  @override
  String maintenanceScheduleEnterTitle(String language) {
    return 'Masukkan judul dalam $language';
  }

  @override
  String maintenanceScheduleEnterDescription(String language) {
    return 'Masukkan deskripsi dalam $language';
  }

  @override
  String get maintenanceScheduleCancel => 'Batal';

  @override
  String get maintenanceScheduleUpdate => 'Perbarui';

  @override
  String get maintenanceScheduleCreate => 'Buat';

  @override
  String get maintenanceScheduleManagement => 'Manajemen Jadwal Pemeliharaan';

  @override
  String get maintenanceScheduleCreateTitle => 'Buat Jadwal Pemeliharaan';

  @override
  String get maintenanceScheduleCreateSubtitle =>
      'Tambah jadwal pemeliharaan baru';

  @override
  String get maintenanceScheduleSelectManyTitle => 'Pilih Banyak';

  @override
  String get maintenanceScheduleSelectManySubtitle =>
      'Pilih beberapa jadwal untuk dihapus';

  @override
  String get maintenanceScheduleFilterAndSortTitle => 'Filter & Urutkan';

  @override
  String get maintenanceScheduleFilterAndSortSubtitle =>
      'Sesuaikan tampilan jadwal';

  @override
  String get maintenanceScheduleSelectToDelete =>
      'Pilih jadwal pemeliharaan untuk dihapus';

  @override
  String get maintenanceScheduleSortBy => 'Urutkan Berdasarkan';

  @override
  String get maintenanceScheduleSortOrder => 'Urutan';

  @override
  String get maintenanceScheduleReset => 'Reset';

  @override
  String get maintenanceScheduleApply => 'Terapkan';

  @override
  String get maintenanceScheduleFilterReset => 'Filter direset';

  @override
  String get maintenanceScheduleFilterApplied => 'Filter diterapkan';

  @override
  String get maintenanceScheduleDeleteSchedules => 'Hapus Jadwal';

  @override
  String maintenanceScheduleDeleteMultipleConfirmation(int count) {
    return 'Apakah Anda yakin ingin menghapus $count jadwal?';
  }

  @override
  String get maintenanceScheduleNoSchedulesSelected =>
      'Tidak ada jadwal yang dipilih';

  @override
  String get maintenanceScheduleNotImplementedYet => 'Belum diimplementasikan';

  @override
  String maintenanceScheduleSelectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String get maintenanceScheduleDelete => 'Hapus';

  @override
  String get maintenanceScheduleSearch => 'Cari jadwal...';

  @override
  String get maintenanceScheduleNoSchedulesFound =>
      'Tidak ada jadwal ditemukan';

  @override
  String get maintenanceScheduleCreateFirstSchedule =>
      'Buat jadwal pertama Anda untuk memulai';

  @override
  String get maintenanceScheduleLongPressToSelect =>
      'Tekan lama untuk memilih lebih banyak jadwal';

  @override
  String get maintenanceScheduleMetadata => 'Metadata';

  @override
  String get maintenanceScheduleCreatedAt => 'Dibuat Pada';

  @override
  String get maintenanceScheduleUpdatedAt => 'Diperbarui Pada';

  @override
  String get maintenanceScheduleIntervalValueLabel => 'Nilai Interval';

  @override
  String get maintenanceScheduleIntervalUnitLabel => 'Unit Interval';

  @override
  String get maintenanceScheduleScheduledTimeLabel => 'Waktu Terjadwal (JJ:mm)';

  @override
  String get maintenanceRecordDeleteRecord => 'Hapus Catatan Pemeliharaan';

  @override
  String maintenanceRecordDeleteConfirmation(String title) {
    return 'Apakah Anda yakin ingin menghapus \"$title\"?';
  }

  @override
  String get maintenanceRecordDeleted => 'Catatan pemeliharaan dihapus';

  @override
  String get maintenanceRecordDeleteFailed => 'Gagal menghapus';

  @override
  String get maintenanceRecordDetail => 'Detail Catatan Pemeliharaan';

  @override
  String get maintenanceRecordInformation => 'Informasi Catatan Pemeliharaan';

  @override
  String get maintenanceRecordTitle => 'Judul';

  @override
  String get maintenanceRecordNotes => 'Catatan';

  @override
  String get maintenanceRecordAsset => 'Aset';

  @override
  String get maintenanceRecordMaintenanceDate => 'Tanggal Pemeliharaan';

  @override
  String get maintenanceRecordCompletionDate => 'Tanggal Selesai';

  @override
  String get maintenanceRecordDuration => 'Durasi';

  @override
  String maintenanceRecordDurationMinutes(int minutes) {
    return '$minutes menit';
  }

  @override
  String get maintenanceRecordPerformedByUser => 'Dilakukan Oleh Pengguna';

  @override
  String get maintenanceRecordPerformedByVendor => 'Dilakukan Oleh Vendor';

  @override
  String get maintenanceRecordResult => 'Hasil';

  @override
  String get maintenanceRecordActualCost => 'Biaya Aktual';

  @override
  String maintenanceRecordActualCostValue(String cost) {
    return '\$$cost';
  }

  @override
  String get maintenanceRecordUnknownAsset => 'Aset Tidak Diketahui';

  @override
  String get maintenanceRecordOnlyAdminCanEdit =>
      'Hanya admin yang dapat mengedit catatan pemeliharaan';

  @override
  String get maintenanceRecordOnlyAdminCanDelete =>
      'Hanya admin yang dapat menghapus catatan pemeliharaan';

  @override
  String get maintenanceRecordFailedToLoad =>
      'Gagal memuat catatan pemeliharaan';

  @override
  String get maintenanceRecordEditRecord => 'Edit Catatan Pemeliharaan';

  @override
  String get maintenanceRecordCreateRecord => 'Buat Catatan Pemeliharaan';

  @override
  String get maintenanceRecordFillRequiredFields =>
      'Harap isi semua field yang wajib';

  @override
  String get maintenanceRecordSavedSuccessfully =>
      'Catatan pemeliharaan berhasil disimpan';

  @override
  String get maintenanceRecordOperationFailed => 'Operasi gagal';

  @override
  String get maintenanceRecordFailedToLoadTranslations =>
      'Gagal memuat terjemahan';

  @override
  String get maintenanceRecordSearchSchedule =>
      'Cari dan pilih jadwal pemeliharaan';

  @override
  String get maintenanceRecordSearchAsset => 'Cari dan pilih aset';

  @override
  String get maintenanceRecordCompletionDateOptional =>
      'Tanggal Selesai (Opsional)';

  @override
  String get maintenanceRecordDurationMinutesLabel => 'Durasi (Menit)';

  @override
  String get maintenanceRecordEnterDuration =>
      'Masukkan durasi dalam menit (opsional)';

  @override
  String get maintenanceRecordSearchPerformedByUser =>
      'Cari dan pilih pengguna yang melakukan pemeliharaan';

  @override
  String get maintenanceRecordPerformedByVendorLabel => 'Dilakukan Oleh Vendor';

  @override
  String get maintenanceRecordEnterVendor => 'Masukkan nama vendor (opsional)';

  @override
  String get maintenanceRecordSelectResult => 'Pilih hasil pemeliharaan';

  @override
  String get maintenanceRecordActualCostLabel => 'Biaya Aktual';

  @override
  String get maintenanceRecordEnterActualCost =>
      'Masukkan biaya aktual (opsional)';

  @override
  String get maintenanceRecordTranslations => 'Terjemahan';

  @override
  String get maintenanceRecordEnglish => 'Inggris';

  @override
  String get maintenanceRecordJapanese => 'Jepang';

  @override
  String maintenanceRecordEnterTitle(String language) {
    return 'Masukkan judul dalam $language';
  }

  @override
  String maintenanceRecordEnterNotes(String language) {
    return 'Masukkan catatan dalam $language';
  }

  @override
  String get maintenanceRecordCancel => 'Batal';

  @override
  String get maintenanceRecordUpdate => 'Perbarui';

  @override
  String get maintenanceRecordCreate => 'Buat';

  @override
  String get maintenanceRecordManagement => 'Manajemen Catatan Pemeliharaan';

  @override
  String get maintenanceRecordCreateTitle => 'Buat Catatan Pemeliharaan';

  @override
  String get maintenanceRecordCreateSubtitle =>
      'Tambah catatan pemeliharaan baru';

  @override
  String get maintenanceRecordSelectManyTitle => 'Pilih Banyak';

  @override
  String get maintenanceRecordSelectManySubtitle =>
      'Pilih beberapa catatan untuk dihapus';

  @override
  String get maintenanceRecordFilterAndSortTitle => 'Filter & Urutkan';

  @override
  String get maintenanceRecordFilterAndSortSubtitle =>
      'Sesuaikan tampilan catatan';

  @override
  String get maintenanceRecordSelectToDelete =>
      'Pilih catatan pemeliharaan untuk dihapus';

  @override
  String get maintenanceRecordSortBy => 'Urutkan Berdasarkan';

  @override
  String get maintenanceRecordSortOrder => 'Urutan';

  @override
  String get maintenanceRecordReset => 'Reset';

  @override
  String get maintenanceRecordApply => 'Terapkan';

  @override
  String get maintenanceRecordFilterReset => 'Filter direset';

  @override
  String get maintenanceRecordFilterApplied => 'Filter diterapkan';

  @override
  String get maintenanceRecordDeleteRecords => 'Hapus Catatan';

  @override
  String maintenanceRecordDeleteMultipleConfirmation(int count) {
    return 'Apakah Anda yakin ingin menghapus $count catatan?';
  }

  @override
  String get maintenanceRecordNoRecordsSelected =>
      'Tidak ada catatan yang dipilih';

  @override
  String get maintenanceRecordNotImplementedYet => 'Belum diimplementasikan';

  @override
  String maintenanceRecordSelectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String get maintenanceRecordDelete => 'Hapus';

  @override
  String get maintenanceRecordSearch => 'Cari catatan...';

  @override
  String get maintenanceRecordNoRecordsFound => 'Tidak ada catatan ditemukan';

  @override
  String get maintenanceRecordCreateFirstRecord =>
      'Buat catatan pertama Anda untuk memulai';

  @override
  String get maintenanceRecordLongPressToSelect =>
      'Tekan lama untuk memilih lebih banyak catatan';

  @override
  String get maintenanceRecordMetadata => 'Metadata';

  @override
  String get maintenanceRecordCreatedAt => 'Dibuat Pada';

  @override
  String get maintenanceRecordUpdatedAt => 'Diperbarui Pada';

  @override
  String get maintenanceRecordSchedule => 'Jadwal Pemeliharaan';

  @override
  String get notificationManagement => 'Manajemen Notifikasi';

  @override
  String get notificationDetail => 'Detail Notifikasi';

  @override
  String get notificationMyNotifications => 'Notifikasi Saya';

  @override
  String get notificationDeleteNotification => 'Hapus Notifikasi';

  @override
  String get notificationDeleteConfirmation =>
      'Apakah Anda yakin ingin menghapus notifikasi ini?';

  @override
  String notificationDeleteMultipleConfirmation(int count) {
    return 'Apakah Anda yakin ingin menghapus $count notifikasi?';
  }

  @override
  String get notificationCancel => 'Batal';

  @override
  String get notificationDelete => 'Hapus';

  @override
  String get notificationOnlyAdminCanDelete =>
      'Hanya admin yang dapat menghapus notifikasi';

  @override
  String get notificationDeleted => 'Notifikasi dihapus';

  @override
  String get notificationDeleteFailed => 'Gagal menghapus';

  @override
  String get notificationFailedToLoad => 'Gagal memuat notifikasi';

  @override
  String get notificationInformation => 'Informasi Notifikasi';

  @override
  String get notificationTitle => 'Judul';

  @override
  String get notificationMessage => 'Pesan';

  @override
  String get notificationType => 'Jenis';

  @override
  String get notificationPriority => 'Prioritas';

  @override
  String get notificationIsRead => 'Sudah Dibaca';

  @override
  String get notificationReadStatus => 'Status Baca';

  @override
  String get notificationRead => 'Dibaca';

  @override
  String get notificationUnread => 'Belum Dibaca';

  @override
  String get notificationYes => 'Ya';

  @override
  String get notificationNo => 'Tidak';

  @override
  String get notificationCreatedAt => 'Dibuat Pada';

  @override
  String get notificationExpiresAt => 'Kadaluarsa Pada';

  @override
  String get notificationSearchNotifications => 'Cari notifikasi...';

  @override
  String get notificationSearchMyNotifications => 'Cari notifikasi saya...';

  @override
  String get notificationNoNotificationsFound =>
      'Tidak ada notifikasi ditemukan';

  @override
  String get notificationNoNotificationsYet => 'Anda tidak memiliki notifikasi';

  @override
  String get notificationCreateFirstNotification =>
      'Buat notifikasi pertama Anda untuk memulai';

  @override
  String get notificationCreateNotification => 'Buat Notifikasi';

  @override
  String get notificationCreateNotificationSubtitle => 'Tambah notifikasi baru';

  @override
  String get notificationSelectMany => 'Pilih Banyak';

  @override
  String get notificationSelectManySubtitle =>
      'Pilih beberapa notifikasi untuk dihapus';

  @override
  String get notificationFilterAndSort => 'Filter & Urutkan';

  @override
  String get notificationFilterAndSortSubtitle =>
      'Sesuaikan tampilan notifikasi';

  @override
  String get notificationFiltersAndSorting => 'Filter & Pengurutan';

  @override
  String get notificationSelectNotificationsToDelete =>
      'Pilih notifikasi untuk dihapus';

  @override
  String get notificationLongPressToSelect =>
      'Tekan lama untuk memilih lebih banyak notifikasi';

  @override
  String notificationSelectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String get notificationNoNotificationsSelected =>
      'Tidak ada notifikasi yang dipilih';

  @override
  String get notificationFilterByUser => 'Filter berdasarkan Pengguna';

  @override
  String get notificationFilterByRelatedAsset =>
      'Filter berdasarkan Aset Terkait';

  @override
  String get notificationSearchUser => 'Cari pengguna...';

  @override
  String get notificationSearchAsset => 'Cari aset...';

  @override
  String get notificationSortBy => 'Urutkan Berdasarkan';

  @override
  String get notificationSortOrder => 'Urutan';

  @override
  String get notificationReset => 'Reset';

  @override
  String get notificationApply => 'Terapkan';

  @override
  String get notificationApplyFilters => 'Terapkan Filter';

  @override
  String get notificationFilterReset => 'Filter direset';

  @override
  String get notificationFilterApplied => 'Filter diterapkan';

  @override
  String get notificationFiltersApplied => 'Filter Diterapkan';

  @override
  String get notificationNotImplementedYet => 'Belum diimplementasikan';

  @override
  String get notificationJustNow => 'Baru saja';

  @override
  String notificationMinutesAgo(int minutes) {
    return '${minutes}m yang lalu';
  }

  @override
  String notificationHoursAgo(int hours) {
    return '${hours}j yang lalu';
  }

  @override
  String notificationDaysAgo(int days) {
    return '${days}h yang lalu';
  }

  @override
  String get notificationMarkAsRead => 'Tandai Dibaca';

  @override
  String get notificationMarkAsUnread => 'Tandai Belum Dibaca';

  @override
  String notificationMarkedAsRead(int count) {
    return '$count ditandai dibaca';
  }

  @override
  String notificationMarkedAsUnread(int count) {
    return '$count ditandai belum dibaca';
  }

  @override
  String get scanLogManagement => 'Manajemen Log Pemindaian';

  @override
  String get scanLogDetail => 'Detail Log Pemindaian';

  @override
  String get scanLogDeleteScanLog => 'Hapus Log Pemindaian';

  @override
  String get scanLogDeleteConfirmation =>
      'Apakah Anda yakin ingin menghapus log pemindaian ini?';

  @override
  String scanLogDeleteMultipleConfirmation(int count) {
    return 'Apakah Anda yakin ingin menghapus $count log pemindaian?';
  }

  @override
  String get scanLogCancel => 'Batal';

  @override
  String get scanLogDelete => 'Hapus';

  @override
  String get scanLogOnlyAdminCanDelete =>
      'Hanya admin yang dapat menghapus log pemindaian';

  @override
  String get scanLogDeleted => 'Log pemindaian dihapus';

  @override
  String get scanLogDeleteFailed => 'Gagal menghapus';

  @override
  String get scanLogFailedToLoad => 'Gagal memuat log pemindaian';

  @override
  String get scanLogInformation => 'Informasi Pemindaian';

  @override
  String get scanLogScannedValue => 'Nilai yang Dipindai';

  @override
  String get scanLogScanMethod => 'Metode Pemindaian';

  @override
  String get scanLogScanResult => 'Hasil Pemindaian';

  @override
  String get scanLogScanTimestamp => 'Waktu Pemindaian';

  @override
  String get scanLogLocation => 'Lokasi';

  @override
  String get scanLogSearchScanLogs => 'Cari log pemindaian...';

  @override
  String get scanLogNoScanLogsFound => 'Tidak ada log pemindaian ditemukan';

  @override
  String get scanLogCreateFirstScanLog =>
      'Buat log pemindaian pertama Anda untuk memulai';

  @override
  String get scanLogCreateScanLog => 'Buat Log Pemindaian';

  @override
  String get scanLogCreateScanLogSubtitle => 'Tambah log pemindaian baru';

  @override
  String get scanLogSelectMany => 'Pilih Banyak';

  @override
  String get scanLogSelectManySubtitle =>
      'Pilih beberapa log pemindaian untuk dihapus';

  @override
  String get scanLogFilterAndSort => 'Filter & Urutkan';

  @override
  String get scanLogFilterAndSortSubtitle =>
      'Sesuaikan tampilan log pemindaian';

  @override
  String get scanLogFiltersAndSorting => 'Filter & Pengurutan';

  @override
  String get scanLogSelectScanLogsToDelete =>
      'Pilih log pemindaian untuk dihapus';

  @override
  String get scanLogLongPressToSelect =>
      'Tekan lama untuk memilih lebih banyak log pemindaian';

  @override
  String scanLogSelectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String get scanLogNoScanLogsSelected =>
      'Tidak ada log pemindaian yang dipilih';

  @override
  String get scanLogFilterByAsset => 'Filter berdasarkan Aset';

  @override
  String get scanLogFilterByScannedBy => 'Filter berdasarkan Dipindai Oleh';

  @override
  String get scanLogSearchAsset => 'Cari aset...';

  @override
  String get scanLogSearchUser => 'Cari pengguna...';

  @override
  String get scanLogSortBy => 'Urutkan Berdasarkan';

  @override
  String get scanLogSortOrder => 'Urutan';

  @override
  String get scanLogHasCoordinates => 'Memiliki Koordinat';

  @override
  String get scanLogDateFrom => 'Tanggal Dari';

  @override
  String get scanLogDateTo => 'Tanggal Sampai';

  @override
  String get scanLogReset => 'Reset';

  @override
  String get scanLogApply => 'Terapkan';

  @override
  String get scanLogFilterReset => 'Filter direset';

  @override
  String get scanLogFilterApplied => 'Filter diterapkan';

  @override
  String get scanLogNotImplementedYet => 'Belum diimplementasikan';

  @override
  String get userManagement => 'Manajemen Pengguna';

  @override
  String get userCreateUser => 'Buat Pengguna';

  @override
  String get userAddNewUser => 'Tambah pengguna baru';

  @override
  String get userSelectMany => 'Pilih Banyak';

  @override
  String get userSelectMultipleToDelete =>
      'Pilih beberapa pengguna untuk dihapus';

  @override
  String get userFilterAndSort => 'Filter & Urutkan';

  @override
  String get userCustomizeDisplay => 'Sesuaikan tampilan pengguna';

  @override
  String get userFilters => 'Filter';

  @override
  String get userRole => 'Peran';

  @override
  String get userEmployeeId => 'ID Karyawan';

  @override
  String get userEnterEmployeeId => 'Masukkan ID karyawan...';

  @override
  String get userActiveStatus => 'Status Aktif';

  @override
  String get userActive => 'Aktif';

  @override
  String get userInactive => 'Tidak Aktif';

  @override
  String get userSort => 'Urutkan';

  @override
  String get userSortBy => 'Urutkan Berdasarkan';

  @override
  String get userSortOrder => 'Urutan';

  @override
  String get userAscending => 'Naik';

  @override
  String get userDescending => 'Turun';

  @override
  String get userReset => 'Reset';

  @override
  String get userApply => 'Terapkan';

  @override
  String get userFilterReset => 'Filter direset';

  @override
  String get userFilterApplied => 'Filter diterapkan';

  @override
  String get userSelectUsersToDelete => 'Pilih pengguna untuk dihapus';

  @override
  String get userDeleteUsers => 'Hapus Pengguna';

  @override
  String userDeleteConfirmation(int count) {
    return 'Apakah Anda yakin ingin menghapus $count pengguna?';
  }

  @override
  String get userCancel => 'Batal';

  @override
  String get userDelete => 'Hapus';

  @override
  String get userNoUsersSelected => 'Tidak ada pengguna yang dipilih';

  @override
  String get userNotImplementedYet => 'Belum diimplementasikan';

  @override
  String userSelectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String get userSearchUsers => 'Cari pengguna...';

  @override
  String get userNoUsersFound => 'Tidak ada pengguna ditemukan';

  @override
  String get userCreateFirstUser => 'Buat pengguna pertama Anda untuk memulai';

  @override
  String get userLongPressToSelect =>
      'Tekan lama untuk memilih lebih banyak pengguna';

  @override
  String get userEditUser => 'Edit Pengguna';

  @override
  String get userPleaseFixErrors => 'Harap perbaiki semua kesalahan';

  @override
  String get userPleaseSelectRole => 'Harap pilih peran';

  @override
  String get userPleaseValidateFields => 'Harap isi semua field yang wajib';

  @override
  String get userSavedSuccessfully => 'Pengguna berhasil disimpan';

  @override
  String get userOperationFailed => 'Operasi gagal';

  @override
  String get userInformation => 'Informasi Pengguna';

  @override
  String get userUsername => 'Nama Pengguna';

  @override
  String get userEnterUsername => 'Masukkan nama pengguna';

  @override
  String get userEmail => 'Email';

  @override
  String get userEnterEmail => 'Masukkan email';

  @override
  String get userPassword => 'Kata Sandi';

  @override
  String get userEnterPassword => 'Masukkan kata sandi';

  @override
  String get userFullName => 'Nama Lengkap';

  @override
  String get userEnterFullName => 'Masukkan nama lengkap';

  @override
  String get userSelectRole => 'Pilih peran';

  @override
  String get userEmployeeIdOptional => 'ID Karyawan (Opsional)';

  @override
  String get userEnterEmployeeIdOptional => 'Masukkan ID karyawan';

  @override
  String get userPreferredLanguage => 'Bahasa Pilihan (Opsional)';

  @override
  String get userSelectLanguage => 'Pilih bahasa';

  @override
  String get userUpdate => 'Perbarui';

  @override
  String get userCreate => 'Buat';

  @override
  String get userDetail => 'Detail Pengguna';

  @override
  String get userOnlyAdminCanEdit => 'Hanya admin yang dapat mengedit pengguna';

  @override
  String get userDeleteUser => 'Hapus Pengguna';

  @override
  String userDeleteSingleConfirmation(String fullName) {
    return 'Apakah Anda yakin ingin menghapus \"$fullName\"?';
  }

  @override
  String get userOnlyAdminCanDelete =>
      'Hanya admin yang dapat menghapus pengguna';

  @override
  String get userDeleted => 'Pengguna dihapus';

  @override
  String get userDeleteFailed => 'Gagal menghapus';

  @override
  String get userName => 'Nama';

  @override
  String get userPreferredLang => 'Bahasa Pilihan';

  @override
  String get userYes => 'Ya';

  @override
  String get userNo => 'Tidak';

  @override
  String get userMetadata => 'Metadata';

  @override
  String get userCreatedAt => 'Dibuat Pada';

  @override
  String get userUpdatedAt => 'Diperbarui Pada';

  @override
  String get userFailedToLoad => 'Gagal memuat pengguna';

  @override
  String get userFailedToLoadProfile => 'Gagal memuat profil';

  @override
  String get userPersonalInformation => 'Informasi Pribadi';

  @override
  String get userAccountDetails => 'Detail Akun';

  @override
  String get userStatus => 'Status';

  @override
  String get userUpdateProfile => 'Perbarui Profil';

  @override
  String get userNoUserData => 'Tidak ada data pengguna tersedia';

  @override
  String get userProfileInformation => 'Informasi Profil';

  @override
  String get userProfilePicture => 'Foto Profil';

  @override
  String get userChooseImage => 'Pilih gambar';

  @override
  String get userProfileUpdatedSuccessfully => 'Profil berhasil diperbarui';

  @override
  String get userChangePassword => 'Ubah Kata Sandi';

  @override
  String get userChangePasswordTitle => 'Perbarui Kata Sandi Anda';

  @override
  String get userChangePasswordDescription =>
      'Masukkan kata sandi saat ini dan pilih kata sandi baru yang aman.';

  @override
  String get userCurrentPassword => 'Kata Sandi Saat Ini';

  @override
  String get userEnterCurrentPassword => 'Masukkan kata sandi saat ini';

  @override
  String get userNewPassword => 'Kata Sandi Baru';

  @override
  String get userEnterNewPassword => 'Masukkan kata sandi baru';

  @override
  String get userConfirmNewPassword => 'Konfirmasi Kata Sandi Baru';

  @override
  String get userEnterConfirmNewPassword => 'Masukkan ulang kata sandi baru';

  @override
  String get userPasswordRequirements => 'Persyaratan Kata Sandi';

  @override
  String get userPasswordRequirementsList =>
      '• Minimal 8 karakter\n• Minimal satu huruf besar\n• Minimal satu huruf kecil\n• Minimal satu angka';

  @override
  String get userChangePasswordButton => 'Ubah Kata Sandi';

  @override
  String get userPasswordChangedSuccessfully => 'Kata sandi berhasil diubah';

  @override
  String get adminShellBottomNavDashboard => 'Dasbor';

  @override
  String get adminShellBottomNavScanAsset => 'Pindai Aset';

  @override
  String get adminShellBottomNavProfile => 'Profil';

  @override
  String get userShellBottomNavHome => 'Beranda';

  @override
  String get userShellBottomNavScanAsset => 'Pindai Aset';

  @override
  String get userShellBottomNavProfile => 'Profil';

  @override
  String get appEndDrawerTitle => 'Sigma Track';

  @override
  String get appEndDrawerPleaseLoginFirst => 'Silakan login terlebih dahulu';

  @override
  String get appEndDrawerTheme => 'Tema';

  @override
  String get appEndDrawerLanguage => 'Bahasa';

  @override
  String get appEndDrawerLogout => 'Keluar';

  @override
  String get appEndDrawerManagementSection => 'Manajemen';

  @override
  String get appEndDrawerMaintenanceSection => 'Pemeliharaan';

  @override
  String get appEndDrawerEnglish => 'English';

  @override
  String get appEndDrawerIndonesian => 'Indonesia';

  @override
  String get appEndDrawerJapanese => '日本語';

  @override
  String get appEndDrawerMyAssets => 'Aset Saya';

  @override
  String get appEndDrawerNotifications => 'Notifikasi';

  @override
  String get appEndDrawerMyIssueReports => 'Laporan Masalah Saya';

  @override
  String get appEndDrawerAssets => 'Aset';

  @override
  String get appEndDrawerAssetMovements => 'Perpindahan Aset';

  @override
  String get appEndDrawerCategories => 'Kategori';

  @override
  String get appEndDrawerLocations => 'Lokasi';

  @override
  String get appEndDrawerUsers => 'Pengguna';

  @override
  String get appEndDrawerMaintenanceSchedules => 'Jadwal Pemeliharaan';

  @override
  String get appEndDrawerMaintenanceRecords => 'Catatan Pemeliharaan';

  @override
  String get appEndDrawerReports => 'Laporan';

  @override
  String get appEndDrawerIssueReports => 'Laporan Masalah';

  @override
  String get appEndDrawerScanLogs => 'Log Pemindaian';

  @override
  String get appEndDrawerScanAsset => 'Pindai Aset';

  @override
  String get appEndDrawerDashboard => 'Dasbor';

  @override
  String get appEndDrawerHome => 'Beranda';

  @override
  String get appEndDrawerProfile => 'Profil';

  @override
  String get customAppBarTitle => 'Sigma Track';

  @override
  String get customAppBarOpenMenu => 'Buka Menu';

  @override
  String get appDropdownSelectOption => 'Pilih opsi';

  @override
  String get appSearchFieldHint => 'Cari...';

  @override
  String get appSearchFieldClear => 'Hapus';

  @override
  String get appSearchFieldNoResultsFound => 'Tidak ada hasil ditemukan';

  @override
  String get staffShellBottomNavDashboard => 'Dasbor';

  @override
  String get staffShellBottomNavScanAsset => 'Pindai Aset';

  @override
  String get staffShellBottomNavProfile => 'Profil';
}
