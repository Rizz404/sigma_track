// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get assetDeleteAsset => '資産を削除';

  @override
  String assetDeleteConfirmation(String assetName) {
    return '\"$assetName\"を削除してもよろしいですか？';
  }

  @override
  String get assetCancel => 'キャンセル';

  @override
  String get assetDelete => '削除';

  @override
  String get assetDetail => '資産詳細';

  @override
  String get assetInformation => '資産情報';

  @override
  String get assetTag => '資産タグ';

  @override
  String get assetName => '資産名';

  @override
  String get assetCategory => 'カテゴリ';

  @override
  String get assetBrand => 'ブランド';

  @override
  String get assetBrandLabel => 'ブランド';

  @override
  String get assetModel => 'モデル';

  @override
  String get assetModelLabel => 'モデル';

  @override
  String get assetSerialNumber => 'シリアル番号';

  @override
  String get assetStatus => 'ステータス';

  @override
  String get assetCondition => '状態';

  @override
  String get assetLocation => '場所';

  @override
  String get assetAssignedTo => '割り当て先';

  @override
  String get assetPurchaseInformation => '購入情報';

  @override
  String get assetPurchaseDate => '購入日';

  @override
  String get assetPurchasePrice => '購入価格';

  @override
  String get assetVendorName => 'ベンダー名';

  @override
  String get assetWarrantyEnd => '保証終了';

  @override
  String get assetMetadata => 'メタデータ';

  @override
  String get assetCreatedAt => '作成日時';

  @override
  String get assetUpdatedAt => '更新日時';

  @override
  String get assetDataMatrixImage => 'データマトリックス画像';

  @override
  String get assetOnlyAdminCanEdit => '資産を編集できるのは管理者のみです';

  @override
  String get assetOnlyAdminCanDelete => '資産を削除できるのは管理者のみです';

  @override
  String get assetFailedToLoad => '資産の読み込みに失敗しました';

  @override
  String get assetLocationPermissionRequired => '位置情報許可が必要です';

  @override
  String get assetLocationPermissionMessage =>
      'スキャンログを追跡するには位置情報アクセスが必要です。設定で有効にしてください。';

  @override
  String get assetOpenSettings => '設定を開く';

  @override
  String get assetLocationPermissionNeeded => 'スキャンログには位置情報許可が必要です';

  @override
  String get assetInvalidBarcode => '無効なバーコードデータ';

  @override
  String assetFound(String assetName) {
    return '資産が見つかりました: $assetName';
  }

  @override
  String get assetNotFound => '資産が見つかりません';

  @override
  String get assetFailedToProcessBarcode => 'バーコードの処理に失敗しました';

  @override
  String get assetCameraError => 'カメラエラー';

  @override
  String get assetAlignDataMatrix => 'データマトリックスをフレーム内に揃えてください';

  @override
  String get assetProcessing => '処理中...';

  @override
  String get assetFlash => 'フラッシュ';

  @override
  String get assetFlip => '反転';

  @override
  String get assetEditAsset => '資産を編集';

  @override
  String get assetCreateAsset => '資産を作成';

  @override
  String get assetFillRequiredFields => '必須フィールドをすべて入力してください';

  @override
  String get assetSelectCategory => 'カテゴリを選択してください';

  @override
  String get assetSavedSuccessfully => '資産が正常に保存されました';

  @override
  String get assetOperationFailed => '操作に失敗しました';

  @override
  String get assetDeletedSuccess => '資産が削除されました';

  @override
  String get assetDeletedFailed => '削除に失敗しました';

  @override
  String get assetFailedToGenerateDataMatrix => 'データマトリックスの生成に失敗しました';

  @override
  String get assetSelectCategoryFirst => 'まずカテゴリを選択してください';

  @override
  String assetTagGenerated(String tag) {
    return '資産タグが生成されました: $tag';
  }

  @override
  String get assetFailedToGenerateTag => '資産タグの生成に失敗しました';

  @override
  String get assetEnterAssetTagFirst => 'まず資産タグを入力してください';

  @override
  String get assetBasicInformation => '基本情報';

  @override
  String get assetEnterAssetTag => '資産タグを入力 (例: AST-001)';

  @override
  String get assetAutoGenerateTag => '資産タグを自動生成';

  @override
  String get assetEnterAssetName => '資産名を入力';

  @override
  String get assetBrandOptional => 'ブランド (オプション)';

  @override
  String get assetEnterBrand => 'ブランド名を入力';

  @override
  String get assetModelOptional => 'モデル (オプション)';

  @override
  String get assetEnterModel => 'モデルを入力';

  @override
  String get assetSerialNumberOptional => 'シリアル番号 (オプション)';

  @override
  String get assetEnterSerialNumber => 'シリアル番号を入力';

  @override
  String get assetDataMatrixPreview => 'データマトリックスプレビュー';

  @override
  String get assetRegenerateDataMatrix => 'データマトリックスを再生成';

  @override
  String get assetCategoryAndLocation => 'カテゴリと場所';

  @override
  String get assetSearchCategory => 'カテゴリを検索...';

  @override
  String get assetNotSet => '未設定';

  @override
  String get assetChangeLocationInstruction => '場所を変更するには、資産移動画面を使用してください';

  @override
  String get assetLocationOptional => '場所 (オプション)';

  @override
  String get assetSearchLocation => '場所を検索...';

  @override
  String get assetNotAssigned => '未割り当て';

  @override
  String get assetChangeAssignmentInstruction => '割り当てを変更するには、資産移動画面を使用してください';

  @override
  String get assetAssignedToOptional => '割り当て先 (オプション)';

  @override
  String get assetSearchUser => 'ユーザーを検索...';

  @override
  String get assetPurchaseDateOptional => '購入日 (オプション)';

  @override
  String get assetEnterPurchasePrice => '購入価格を入力';

  @override
  String get assetVendorNameOptional => 'ベンダー名 (オプション)';

  @override
  String get assetEnterVendorName => 'ベンダー名を入力';

  @override
  String get assetWarrantyEndDateOptional => '保証終了日 (オプション)';

  @override
  String get assetStatusAndCondition => 'ステータスと状態';

  @override
  String get assetSelectStatus => 'ステータスを選択';

  @override
  String get assetSelectCondition => '状態を選択';

  @override
  String get assetUpdate => '更新';

  @override
  String get assetCreate => '作成';

  @override
  String get assetCreateAssetTitle => '資産を作成';

  @override
  String get assetCreateAssetSubtitle => '新しい資産を追加';

  @override
  String get assetSelectManyTitle => '複数選択';

  @override
  String get assetSelectManySubtitle => '削除する複数の資産を選択';

  @override
  String get assetFilterAndSortTitle => 'フィルターと並べ替え';

  @override
  String get assetFilterAndSortSubtitle => '資産表示をカスタマイズ';

  @override
  String get assetFilterByCategory => 'カテゴリでフィルター';

  @override
  String get assetFilterByLocation => '場所でフィルター';

  @override
  String get assetFilterByAssignedTo => '割り当て先でフィルター';

  @override
  String get assetEnterBrandFilter => 'ブランドを入力...';

  @override
  String get assetEnterModelFilter => 'モデルを入力...';

  @override
  String get assetSortBy => '並べ替え';

  @override
  String get assetSortOrder => '並べ替え順序';

  @override
  String get assetReset => 'リセット';

  @override
  String get assetApply => '適用';

  @override
  String get assetFilterReset => 'フィルターをリセットしました';

  @override
  String get assetFilterApplied => 'フィルターを適用しました';

  @override
  String get assetManagement => '資産管理';

  @override
  String get assetSelectAssetsToDelete => '削除する資産を選択';

  @override
  String get assetDeleteAssets => '資産を削除';

  @override
  String assetDeleteMultipleConfirmation(int count) {
    return '$count個の資産を削除してもよろしいですか？';
  }

  @override
  String get assetNoAssetsSelected => '資産が選択されていません';

  @override
  String get assetNotImplementedYet => 'まだ実装されていません';

  @override
  String assetSelectedCount(int count) {
    return '$count個選択済み';
  }

  @override
  String get assetSearchAssets => '資産を検索...';

  @override
  String get assetNoAssetsFound => '資産が見つかりません';

  @override
  String get assetCreateFirstAsset => '最初の資産を作成して開始しましょう';

  @override
  String get assetLongPressToSelect => '長押ししてさらに資産を選択';

  @override
  String get assetFiltersAndSorting => 'フィルターと並べ替え';

  @override
  String get assetApplyFilters => 'フィルターを適用';

  @override
  String get assetMyAssets => '私の資産';

  @override
  String get assetSearchMyAssets => '私の資産を検索...';

  @override
  String get assetFiltersApplied => 'フィルター適用済み';

  @override
  String get assetNoAssignedAssets => '割り当てられた資産がありません';

  @override
  String get assetExportAssets => '資産をエクスポート';

  @override
  String get assetExportFormat => 'エクスポート形式';

  @override
  String get assetIncludeDataMatrixImages => 'データマトリックス画像を含める';

  @override
  String get assetExportReady => 'エクスポート準備完了';

  @override
  String assetExportSize(String size) {
    return 'サイズ: $size KB';
  }

  @override
  String assetExportFormatDisplay(String format) {
    return '形式: $format';
  }

  @override
  String get assetExportShareInstruction =>
      'ファイルが共有メニューを開きます。開くアプリを選択するか、直接保存してください。';

  @override
  String get assetShareAndSave => '共有と保存';

  @override
  String get assetExportSubject => '資産エクスポート';

  @override
  String get assetSaveToDownloads => 'ダウンロードに保存しますか？';

  @override
  String get assetSaveToDownloadsMessage =>
      'ファイルが共有されました。ダウンロードフォルダにコピーを保存しますか？';

  @override
  String get assetNo => 'いいえ';

  @override
  String get assetSave => '保存';

  @override
  String get assetFileSharedSuccessfully => 'ファイルが正常に共有されました';

  @override
  String get assetShareCancelled => '共有がキャンセルされました';

  @override
  String assetFailedToShareFile(String error) {
    return 'ファイルの共有に失敗しました: $error';
  }

  @override
  String get assetFileSavedSuccessfully => 'ファイルがダウンロードに正常に保存されました';

  @override
  String assetFailedToSaveFile(String error) {
    return 'ファイルの保存に失敗しました: $error';
  }

  @override
  String get assetValidationTagRequired => '資産タグは必須です';

  @override
  String get assetValidationTagMinLength => '資産タグは3文字以上である必要があります';

  @override
  String get assetValidationTagMaxLength => '資産タグは50文字を超えることはできません';

  @override
  String get assetValidationTagAlphanumeric => '資産タグには英数字とダッシュのみ使用できます';

  @override
  String get assetValidationNameRequired => '資産名は必須です';

  @override
  String get assetValidationNameMinLength => '資産名は3文字以上である必要があります';

  @override
  String get assetValidationNameMaxLength => '資産名は100文字を超えることはできません';

  @override
  String get assetValidationCategoryRequired => 'カテゴリは必須です';

  @override
  String get assetValidationBrandMaxLength => 'ブランドは50文字を超えることはできません';

  @override
  String get assetValidationModelMaxLength => 'モデルは50文字を超えることはできません';

  @override
  String get assetValidationSerialMaxLength => 'シリアル番号は50文字を超えることはできません';

  @override
  String get assetValidationPriceInvalid => '購入価格は有効な数値である必要があります';

  @override
  String get assetValidationPriceNegative => '購入価格は負の値にできません';

  @override
  String get assetValidationVendorMaxLength => 'ベンダー名は100文字を超えることはできません';

  @override
  String get assetExport => 'エクスポート';

  @override
  String get assetMovementDeleteAssetMovement => '資産移動を削除';

  @override
  String get assetMovementDeleteConfirmation => 'この資産移動記録を削除してもよろしいですか？';

  @override
  String get assetMovementCancel => 'キャンセル';

  @override
  String get assetMovementDelete => '削除';

  @override
  String get assetMovementDetail => '資産移動詳細';

  @override
  String get assetMovementInformation => '移動情報';

  @override
  String get assetMovementId => '移動ID';

  @override
  String get assetMovementAsset => '資産';

  @override
  String get assetMovementMovementType => '移動タイプ';

  @override
  String get assetMovementFromLocation => '移動元の場所';

  @override
  String get assetMovementToLocation => '移動先の場所';

  @override
  String get assetMovementFromUser => '移動元のユーザー';

  @override
  String get assetMovementToUser => '移動先のユーザー';

  @override
  String get assetMovementMovedBy => '移動者';

  @override
  String get assetMovementMovementDate => '移動日';

  @override
  String get assetMovementNotes => 'メモ';

  @override
  String get assetMovementStatus => 'ステータス';

  @override
  String get assetMovementMetadata => 'メタデータ';

  @override
  String get assetMovementCreatedAt => '作成日時';

  @override
  String get assetMovementUpdatedAt => '更新日時';

  @override
  String get assetMovementOnlyAdminCanEdit => '資産移動を編集できるのは管理者のみです';

  @override
  String get assetMovementOnlyAdminCanDelete => '資産移動を削除できるのは管理者のみです';

  @override
  String get assetMovementFailedToLoad => '資産移動の読み込みに失敗しました';

  @override
  String get assetMovementEditAssetMovement => '資産移動を編集';

  @override
  String get assetMovementCreateAssetMovement => '資産移動を作成';

  @override
  String get assetMovementFillRequiredFields => '必須フィールドをすべて入力してください';

  @override
  String get assetMovementSelectAsset => '資産を選択してください';

  @override
  String get assetMovementSavedSuccessfully => '資産移動が正常に保存されました';

  @override
  String get assetMovementOperationFailed => '操作に失敗しました';

  @override
  String get assetMovementBasicInformation => '基本情報';

  @override
  String get assetMovementSelectAssetPlaceholder => '資産を選択';

  @override
  String get assetMovementSearchAsset => '資産を検索...';

  @override
  String get assetMovementSelectMovementType => '移動タイプを選択';

  @override
  String get assetMovementLocationDetails => '場所の詳細';

  @override
  String get assetMovementFromLocationLabel => '移動元の場所';

  @override
  String get assetMovementSearchFromLocation => '移動元の場所を検索...';

  @override
  String get assetMovementToLocationLabel => '移動先の場所';

  @override
  String get assetMovementSearchToLocation => '移動先の場所を検索...';

  @override
  String get assetMovementUserDetails => 'ユーザーの詳細';

  @override
  String get assetMovementFromUserLabel => '移動元のユーザー';

  @override
  String get assetMovementSearchFromUser => '移動元のユーザーを検索...';

  @override
  String get assetMovementToUserLabel => '移動先のユーザー';

  @override
  String get assetMovementSearchToUser => '移動先のユーザーを検索...';

  @override
  String get assetMovementMovementDateLabel => '移動日';

  @override
  String get assetMovementNotesLabel => 'メモ (オプション)';

  @override
  String get assetMovementEnterNotes => 'メモを入力...';

  @override
  String get assetMovementUpdate => '更新';

  @override
  String get assetMovementCreate => '作成';

  @override
  String get assetMovementManagement => '資産移動管理';

  @override
  String get assetMovementSearchAssetMovements => '資産移動を検索...';

  @override
  String get assetMovementNoMovementsFound => '資産移動が見つかりません';

  @override
  String get assetMovementCreateFirstMovement => '最初の資産移動を作成して開始しましょう';

  @override
  String get assetMovementFilterAndSortTitle => 'フィルターと並べ替え';

  @override
  String get assetMovementFilterAndSortSubtitle => '資産移動表示をカスタマイズ';

  @override
  String get assetMovementFilterByAsset => '資産でフィルター';

  @override
  String get assetMovementFilterByMovementType => '移動タイプでフィルター';

  @override
  String get assetMovementFilterByLocation => '場所でフィルター';

  @override
  String get assetMovementFilterByUser => 'ユーザーでフィルター';

  @override
  String get assetMovementSortBy => '並べ替え';

  @override
  String get assetMovementSortOrder => '並べ替え順序';

  @override
  String get assetMovementReset => 'リセット';

  @override
  String get assetMovementApply => '適用';

  @override
  String get assetMovementFilterReset => 'フィルターをリセットしました';

  @override
  String get assetMovementFilterApplied => 'フィルターを適用しました';

  @override
  String get assetMovementStatistics => '移動統計';

  @override
  String get assetMovementTotalMovements => '総移動数';

  @override
  String get assetMovementByType => 'タイプ別移動';

  @override
  String get assetMovementByStatus => 'ステータス別移動';

  @override
  String get assetMovementRecentActivity => '最近のアクティビティ';

  @override
  String get assetMovementValidationAssetRequired => '資産は必須です';

  @override
  String get assetMovementValidationMovementTypeRequired => '移動タイプは必須です';

  @override
  String get assetMovementValidationLocationRequired => 'この移動タイプには場所が必要です';

  @override
  String get assetMovementValidationUserRequired => 'この移動タイプにはユーザーが必要です';

  @override
  String get assetMovementValidationMovementDateRequired => '移動日は必須です';

  @override
  String get assetMovementValidationNotesMaxLength => 'メモは500文字を超えることはできません';

  @override
  String get assetMovementNotSet => '未設定';

  @override
  String get assetMovementLocationMovement => '場所移動';

  @override
  String get assetMovementUserMovement => 'ユーザー移動';

  @override
  String get assetMovementCreateAssetMovementTitle => '資産移動を作成';

  @override
  String get assetMovementCreateAssetMovementSubtitle => '新しい資産移動を記録';

  @override
  String get assetMovementForLocation => '場所の資産移動';

  @override
  String get assetMovementForUser => 'ユーザーの資産移動';

  @override
  String get assetMovementCurrentLocation => '現在の場所';

  @override
  String get assetMovementNewLocation => '新しい場所';

  @override
  String get assetMovementCurrentUser => '現在のユーザー';

  @override
  String get assetMovementNewUser => '新しいユーザー';

  @override
  String get assetMovementMovementHistory => '移動履歴';

  @override
  String get assetMovementNoHistory => '移動履歴がありません';

  @override
  String get assetMovementViewAll => 'すべて表示';

  @override
  String get assetMovementMovedTo => 'に移動';

  @override
  String get assetMovementAssignedTo => 'に割り当て';

  @override
  String get adminShellBottomNavDashboard => 'ダッシュボード';

  @override
  String get adminShellBottomNavScanAsset => '資産をスキャン';

  @override
  String get adminShellBottomNavProfile => 'プロフィール';

  @override
  String get userShellBottomNavHome => 'ホーム';

  @override
  String get userShellBottomNavScanAsset => '資産をスキャン';

  @override
  String get userShellBottomNavProfile => 'プロフィール';

  @override
  String get appEndDrawerTitle => 'Sigma Track';

  @override
  String get appEndDrawerPleaseLoginFirst => 'まずログインしてください';

  @override
  String get appEndDrawerTheme => 'テーマ';

  @override
  String get appEndDrawerLanguage => '言語';

  @override
  String get appEndDrawerLogout => 'ログアウト';

  @override
  String get appEndDrawerManagementSection => '管理';

  @override
  String get appEndDrawerMaintenanceSection => 'メンテナンス';

  @override
  String get appEndDrawerEnglish => 'English';

  @override
  String get appEndDrawerIndonesian => 'Indonesia';

  @override
  String get appEndDrawerJapanese => '日本語';

  @override
  String get appEndDrawerMyAssets => '私の資産';

  @override
  String get appEndDrawerNotifications => '通知';

  @override
  String get appEndDrawerMyIssueReports => '私の問題報告';

  @override
  String get appEndDrawerAssets => '資産';

  @override
  String get appEndDrawerAssetMovements => '資産移動';

  @override
  String get appEndDrawerCategories => 'カテゴリ';

  @override
  String get appEndDrawerLocations => '場所';

  @override
  String get appEndDrawerUsers => 'ユーザー';

  @override
  String get appEndDrawerMaintenanceSchedules => 'メンテナンススケジュール';

  @override
  String get appEndDrawerMaintenanceRecords => 'メンテナンス記録';

  @override
  String get appEndDrawerReports => 'レポート';

  @override
  String get appEndDrawerIssueReports => '問題報告';

  @override
  String get appEndDrawerScanLogs => 'スキャンログ';

  @override
  String get appEndDrawerScanAsset => '資産をスキャン';

  @override
  String get appEndDrawerDashboard => 'ダッシュボード';

  @override
  String get appEndDrawerHome => 'ホーム';

  @override
  String get appEndDrawerProfile => 'プロフィール';

  @override
  String get customAppBarTitle => 'Sigma Track';

  @override
  String get customAppBarOpenMenu => 'メニューを開く';

  @override
  String get appDropdownSelectOption => 'オプションを選択';

  @override
  String get appSearchFieldHint => '検索...';

  @override
  String get appSearchFieldClear => 'クリア';

  @override
  String get appSearchFieldNoResultsFound => '結果が見つかりません';
}
