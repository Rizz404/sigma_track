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
  String get assetWarrantyDuration => '保証期間 (自動計算)';

  @override
  String get assetWarrantyDurationHelper => '購入日から保証終了日を自動計算';

  @override
  String get assetEnterDuration => '期間を入力';

  @override
  String get assetMonth => 'ヶ月';

  @override
  String get assetMonths => 'ヶ月';

  @override
  String get assetYear => '年';

  @override
  String get assetYears => '年';

  @override
  String get assetSelectPeriod => '期間を選択';

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
  String get assetShareAndSave => '保存';

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
  String get assetSelectExportType => 'エクスポートタイプを選択';

  @override
  String get assetExportList => 'リストをエクスポート';

  @override
  String get assetExportListSubtitle => '資産をリストとしてエクスポート';

  @override
  String get assetExportDataMatrix => 'データマトリックスをエクスポート';

  @override
  String get assetExportDataMatrixSubtitle => '資産のデータマトリックスコードをエクスポート';

  @override
  String get assetDataMatrixPdfOnly => 'データマトリックスのエクスポートはPDF形式のみ利用可能です';

  @override
  String get assetQuickActions => 'クイックアクション';

  @override
  String get assetReportIssue => '問題を\n報告';

  @override
  String get assetMoveToUser => 'ユーザーに\n移動';

  @override
  String get assetMoveToLocation => '場所に\n移動';

  @override
  String get assetScheduleMaintenance => 'メンテを\nスケジュール';

  @override
  String get assetRecordMaintenance => 'メンテを\n記録';

  @override
  String get assetCopyAsset => '資産を\nコピー';

  @override
  String get assetExportTitle => 'エクスポート';

  @override
  String get assetExportSubtitle => 'データをファイルにエクスポート';

  @override
  String get assetBulkCopy => '一括コピー';

  @override
  String get assetBulkCopyDescription =>
      '同じデータで複数のアセットを作成します。アセットタグ、データマトリックス、シリアル番号のみが異なります。';

  @override
  String get assetEnableBulkCopy => '一括コピーを有効にする';

  @override
  String get assetNumberOfCopies => 'コピー数';

  @override
  String get assetEnterQuantity => '数量を入力';

  @override
  String get assetPleaseEnterQuantity => '数量を入力してください';

  @override
  String get assetMinimumOneCopy => '最小1コピー';

  @override
  String get assetMaximumCopies => '最大100コピー';

  @override
  String get assetSerialNumbersOptional => 'シリアル番号（オプション）';

  @override
  String get assetEnterSerialNumbers => 'カンマまたは改行で区切ったシリアル番号を入力';

  @override
  String get assetPleaseEnterCopyQuantity => 'コピー数を入力してください（最小1）';

  @override
  String assetEnterExactlySerialNumbers(int quantity) {
    return '正確に$quantity個のシリアル番号を入力してください';
  }

  @override
  String get assetDuplicateSerialNumbers => '重複したシリアル番号が見つかりました';

  @override
  String get assetSerialNumbersHint =>
      '1行に1つのシリアル番号を入力するか、カンマで区切ります。シリアル番号をスキップする場合は空のままにしてください。';

  @override
  String get assetBulkAutoGenerateInfo => 'アセットタグとデータマトリックスは各コピーに対して自動生成されます。';

  @override
  String get assetCreatingBulkAssets => '一括アセットを作成中';

  @override
  String get assetCreateBulkAssets => '一括アセットを作成';

  @override
  String get assetGeneratingAssetTags => 'アセットタグを生成中...';

  @override
  String get assetGeneratingDataMatrixImages => 'データマトリックス画像を生成中...';

  @override
  String assetGeneratedDataMatrix(int current, int total) {
    return '$current/$total個のデータマトリックス画像を生成しました';
  }

  @override
  String assetUploadingDataMatrix(int current, int total) {
    return '$current/$total個のデータマトリックス画像をアップロード中...';
  }

  @override
  String assetUploadingDataMatrixProgress(int progress) {
    return 'データマトリックス画像をアップロード中... $progress%';
  }

  @override
  String get assetCreatingAssets => 'アセットを作成中...';

  @override
  String assetFailedToCreateBulkAssets(String error) {
    return '一括アセットの作成に失敗しました: $error';
  }

  @override
  String get assetAutoGenerationDisabled => '一括コピーモードでは自動生成が無効になっています';

  @override
  String get assetAutoGenerateAssetTag => 'アセットタグを自動生成';

  @override
  String get assetCancelBulkProcessingTitle => '一括処理をキャンセルしますか？';

  @override
  String get assetCancelBulkProcessingMessage =>
      '一括資産作成が進行中です。今キャンセルすると、すべての進行状況が失われます。本当にキャンセルしますか？';

  @override
  String get assetContinueProcessing => '続行';

  @override
  String get assetCancelProcessing => '処理をキャンセル';

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
  String get assetMovementValidationToLocationRequired => '移動先の場所は必須です';

  @override
  String get assetMovementValidationToUserRequired => '移動先のユーザーは必須です';

  @override
  String get assetMovementValidationMovedByRequired => '移動者は必須です';

  @override
  String get assetMovementValidationMovementDateFuture =>
      '移動日は未来の日付にすることはできません';

  @override
  String get assetMovementTranslations => '翻訳';

  @override
  String get assetMovementUnknownAsset => '不明な資産';

  @override
  String get assetMovementUnknownTag => '不明なタグ';

  @override
  String get assetMovementUnknown => '不明';

  @override
  String get assetMovementUnassigned => '未割り当て';

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
  String get assetMovementSelectMany => '複数選択';

  @override
  String get assetMovementSelectManySubtitle => '複数の資産移動を削除するために選択';

  @override
  String get assetMovementSelectAssetMovementsToDelete => '削除する資産移動を選択してください';

  @override
  String get assetMovementChooseMovementType => '移動タイプを選択：';

  @override
  String get assetMovementFilterByFromLocation => '移動元の場所でフィルター';

  @override
  String get assetMovementFilterByToLocation => '移動先の場所でフィルター';

  @override
  String get assetMovementFilterByFromUser => '移動元のユーザーでフィルター';

  @override
  String get assetMovementFilterByToUser => '移動先のユーザーでフィルター';

  @override
  String get assetMovementFilterByMovedBy => '移動者でフィルター';

  @override
  String get assetMovementDateFrom => '開始日';

  @override
  String get assetMovementDateTo => '終了日';

  @override
  String get assetMovementSearchAssetPlaceholder => '資産を検索...';

  @override
  String get assetMovementSearchFromLocationPlaceholder => '移動元の場所を検索...';

  @override
  String get assetMovementSearchToLocationPlaceholder => '移動先の場所を検索...';

  @override
  String get assetMovementSearchFromUserPlaceholder => '移動元のユーザーを検索...';

  @override
  String get assetMovementSearchToUserPlaceholder => '移動先のユーザーを検索...';

  @override
  String get assetMovementSearchMovedByPlaceholder => '移動者のユーザーを検索...';

  @override
  String get assetMovementDeleteAssetMovements => '資産移動を削除';

  @override
  String assetMovementDeleteManyConfirmation(int count) {
    return '$count件の資産移動を削除してもよろしいですか？';
  }

  @override
  String get assetMovementNoAssetMovementsSelected => '資産移動が選択されていません';

  @override
  String get assetMovementNotImplementedYet => 'まだ実装されていません';

  @override
  String assetMovementSelectedCount(int count) {
    return '$count件選択中';
  }

  @override
  String get assetMovementLongPressToSelectMore => '長押しでさらに資産移動を選択';

  @override
  String get assetMovementForLocationShort => '場所へ';

  @override
  String get assetMovementForUserShort => 'ユーザーへ';

  @override
  String get authWelcomeBack => 'おかえりなさい';

  @override
  String get authSignInToContinue => '続けるにはログインしてください';

  @override
  String get authEmail => 'メール';

  @override
  String get authEnterYourEmail => 'メールアドレスを入力';

  @override
  String get authPassword => 'パスワード';

  @override
  String get authEnterYourPassword => 'パスワードを入力';

  @override
  String get authForgotPassword => 'パスワードをお忘れですか？';

  @override
  String get authLogin => 'ログイン';

  @override
  String get authDontHaveAccount => 'アカウントをお持ちでないですか？ ';

  @override
  String get authRegister => '登録';

  @override
  String get authLoginSuccessful => 'ログイン成功';

  @override
  String get authCreateAccount => 'アカウント作成';

  @override
  String get authSignUpToGetStarted => '登録して始めましょう';

  @override
  String get authName => '名前';

  @override
  String get authEnterYourName => '名前を入力';

  @override
  String get authConfirmPassword => 'パスワード確認';

  @override
  String get authReEnterYourPassword => 'パスワードを再入力';

  @override
  String get authPasswordMustContain => 'パスワードには以下が必要です：';

  @override
  String get authPasswordRequirementPlaceholder => 'とにかくパスワードを入力してください！';

  @override
  String get authRegistrationSuccessful => '登録成功';

  @override
  String get authAlreadyHaveAccount => '既にアカウントをお持ちですか？ ';

  @override
  String get authForgotPasswordTitle => 'パスワードを忘れた';

  @override
  String get authEnterEmailToResetPassword => 'パスワードをリセットするにはメールアドレスを入力してください';

  @override
  String get authSendResetLink => 'リセットリンクを送信';

  @override
  String get authEmailSentSuccessfully => 'メール送信成功';

  @override
  String get authRememberPassword => 'パスワードを思い出しましたか？ ';

  @override
  String get authValidationEmailRequired => 'メールは必須です';

  @override
  String get authValidationEmailInvalid => '有効なメールアドレスを入力してください';

  @override
  String get authValidationPasswordRequired => 'パスワードは必須です';

  @override
  String get authValidationNameRequired => '名前は必須です';

  @override
  String get authValidationNameMinLength => '名前は3文字以上である必要があります';

  @override
  String get authValidationNameMaxLength => '名前は20文字を超えることはできません';

  @override
  String get authValidationNameAlphanumeric => '名前には英数字とアンダースコアのみ使用できます';

  @override
  String get authValidationConfirmPasswordRequired => 'パスワードを確認してください';

  @override
  String get authValidationPasswordsDoNotMatch => 'パスワードが一致しません';

  @override
  String get authVerifyResetCode => 'リセットコードの確認';

  @override
  String get authEnterResetCode => 'メールに送信されたリセットコードを入力してください';

  @override
  String get authResetCode => 'リセットコード';

  @override
  String get authEnterResetCodePlaceholder => 'リセットコードを入力';

  @override
  String get authVerifyCode => 'コードを確認';

  @override
  String get authResetPasswordTitle => 'パスワードリセット';

  @override
  String get authEnterNewPassword => '新しいパスワードを入力してください';

  @override
  String get authNewPassword => '新しいパスワード';

  @override
  String get authEnterNewPasswordPlaceholder => '新しいパスワードを入力';

  @override
  String get authConfirmNewPassword => '新しいパスワードの確認';

  @override
  String get authReEnterNewPassword => '新しいパスワードを再入力';

  @override
  String get authResetPasswordButton => 'パスワードリセット';

  @override
  String get authCodeVerifiedSuccessfully => 'コードが正常に確認されました';

  @override
  String get authPasswordResetSuccessfully => 'パスワードが正常にリセットされました';

  @override
  String get authValidationResetCodeRequired => 'リセットコードは必須です';

  @override
  String get authValidationResetCodeLength => 'リセットコードは6文字である必要があります';

  @override
  String get authValidationNewPasswordRequired => '新しいパスワードは必須です';

  @override
  String get categoryDetail => 'カテゴリ詳細';

  @override
  String get categoryInformation => 'カテゴリ情報';

  @override
  String get categoryCategoryCode => 'カテゴリコード';

  @override
  String get categoryCategoryName => 'カテゴリ名';

  @override
  String get categoryDescription => '説明';

  @override
  String get categoryParentCategory => '親カテゴリ';

  @override
  String get categoryMetadata => 'メタデータ';

  @override
  String get categoryCreatedAt => '作成日時';

  @override
  String get categoryUpdatedAt => '更新日時';

  @override
  String get categoryOnlyAdminCanEdit => 'カテゴリを編集できるのは管理者のみです';

  @override
  String get categoryOnlyAdminCanDelete => 'カテゴリを削除できるのは管理者のみです';

  @override
  String get categoryDeleteCategory => 'カテゴリを削除';

  @override
  String categoryDeleteConfirmation(String categoryName) {
    return '\"$categoryName\"を削除してもよろしいですか？';
  }

  @override
  String get categoryCancel => 'キャンセル';

  @override
  String get categoryDelete => '削除';

  @override
  String get categoryCategoryDeleted => 'カテゴリが削除されました';

  @override
  String get categoryDeleteFailed => '削除に失敗しました';

  @override
  String get categoryEditCategory => 'カテゴリを編集';

  @override
  String get categoryCreateCategory => 'カテゴリを作成';

  @override
  String get categorySearchCategory => 'カテゴリを検索...';

  @override
  String get categoryEnterCategoryCode => 'カテゴリコードを入力 (例: CAT-001)';

  @override
  String get categoryTranslations => '翻訳';

  @override
  String get categoryAddTranslations => 'さまざまな言語の翻訳を追加';

  @override
  String get categoryEnglish => '英語';

  @override
  String get categoryJapanese => '日本語';

  @override
  String get categoryIndonesian => 'インドネシア語';

  @override
  String get categoryEnterCategoryName => 'カテゴリ名を入力';

  @override
  String get categoryEnterDescription => '説明を入力';

  @override
  String get categoryUpdate => '更新';

  @override
  String get categoryCreate => '作成';

  @override
  String get categoryFillRequiredFields => '必須フィールドをすべて入力してください';

  @override
  String get categorySavedSuccessfully => 'カテゴリが正常に保存されました';

  @override
  String get categoryOperationFailed => '操作に失敗しました';

  @override
  String get categoryFailedToLoadTranslations => '翻訳の読み込みに失敗しました';

  @override
  String get categoryManagement => 'カテゴリ管理';

  @override
  String get categorySearchCategories => 'カテゴリを検索...';

  @override
  String get categoryCreateCategoryTitle => 'カテゴリを作成';

  @override
  String get categoryCreateCategorySubtitle => '新しいカテゴリを追加';

  @override
  String get categorySelectManyTitle => '複数選択';

  @override
  String get categorySelectManySubtitle => '削除する複数のカテゴリを選択';

  @override
  String get categoryFilterAndSortTitle => 'フィルターと並べ替え';

  @override
  String get categoryFilterAndSortSubtitle => 'カテゴリ表示をカスタマイズ';

  @override
  String get categorySelectCategoriesToDelete => '削除するカテゴリを選択';

  @override
  String get categorySortBy => '並べ替え';

  @override
  String get categorySortOrder => '並べ替え順序';

  @override
  String get categoryHasParent => '親カテゴリあり';

  @override
  String get categoryFilterByParent => '親カテゴリでフィルター';

  @override
  String get categorySearchParentCategory => '親カテゴリを検索...';

  @override
  String get categoryReset => 'リセット';

  @override
  String get categoryApply => '適用';

  @override
  String get categoryFilterReset => 'フィルターをリセットしました';

  @override
  String get categoryFilterApplied => 'フィルターを適用しました';

  @override
  String get categoryDeleteCategories => 'カテゴリを削除';

  @override
  String categoryDeleteMultipleConfirmation(int count) {
    return '$count個のカテゴリを削除してもよろしいですか？';
  }

  @override
  String get categoryNoCategoriesSelected => 'カテゴリが選択されていません';

  @override
  String get categoryNotImplementedYet => 'まだ実装されていません';

  @override
  String categorySelectedCount(int count) {
    return '$count個選択済み';
  }

  @override
  String get categoryNoCategoriesFound => 'カテゴリが見つかりません';

  @override
  String get categoryCreateFirstCategory => '最初のカテゴリを作成して開始しましょう';

  @override
  String get categoryLongPressToSelect => '長押ししてさらにカテゴリを選択';

  @override
  String get categoryValidationCodeRequired => 'カテゴリコードは必須です';

  @override
  String get categoryValidationCodeMinLength => 'カテゴリコードは2文字以上である必要があります';

  @override
  String get categoryValidationCodeMaxLength => 'カテゴリコードは20文字を超えることはできません';

  @override
  String get categoryValidationCodeAlphanumeric =>
      'カテゴリコードには英数字とアンダースコアのみ使用できます';

  @override
  String get categoryValidationNameRequired => 'カテゴリ名は必須です';

  @override
  String get categoryValidationNameMinLength => 'カテゴリ名は3文字以上である必要があります';

  @override
  String get categoryValidationNameMaxLength => 'カテゴリ名は100文字を超えることはできません';

  @override
  String get categoryValidationDescriptionRequired => '説明は必須です';

  @override
  String get categoryValidationDescriptionMinLength => '説明は10文字以上である必要があります';

  @override
  String get categoryValidationDescriptionMaxLength => '説明は500文字を超えることはできません';

  @override
  String get dashboardTotalUsers => '総ユーザー数';

  @override
  String get dashboardTotalAssets => '総資産数';

  @override
  String get dashboardAssetStatusOverview => '資産ステータス概要';

  @override
  String get dashboardActive => '稼働中';

  @override
  String get dashboardMaintenance => 'メンテナンス中';

  @override
  String get dashboardDisposed => '廃棄済み';

  @override
  String get dashboardLost => '紛失';

  @override
  String get dashboardUserRoleDistribution => 'ユーザー役割分布';

  @override
  String get dashboardAdmin => '管理者';

  @override
  String get dashboardStaff => 'スタッフ';

  @override
  String get dashboardEmployee => '従業員';

  @override
  String get dashboardAssetStatusBreakdown => '資産ステータス内訳';

  @override
  String get dashboardAssetConditionOverview => '資産状態概要';

  @override
  String get dashboardGood => '良好';

  @override
  String get dashboardFair => '普通';

  @override
  String get dashboardPoor => '不良';

  @override
  String get dashboardDamaged => '破損';

  @override
  String get dashboardUserRegistrationTrends => 'ユーザー登録推移';

  @override
  String get dashboardAssetCreationTrends => '資産作成推移';

  @override
  String get dashboardCategories => 'カテゴリ';

  @override
  String get dashboardLocations => '場所';

  @override
  String get dashboardActivityOverview => '活動概要';

  @override
  String get dashboardScanLogs => 'スキャンログ';

  @override
  String get dashboardNotifications => '通知';

  @override
  String get dashboardAssetMovements => '資産移動';

  @override
  String get dashboardIssueReports => '問題報告';

  @override
  String get dashboardMaintenanceSchedules => 'メンテナンススケジュール';

  @override
  String get dashboardMaintenanceRecords => 'メンテナンス記録';

  @override
  String get homeScreen => 'ホーム';

  @override
  String get issueReportDeleteIssueReport => '問題報告を削除';

  @override
  String issueReportDeleteConfirmation(String title) {
    return '\"$title\"を削除してもよろしいですか？';
  }

  @override
  String get issueReportCancel => 'キャンセル';

  @override
  String get issueReportDelete => '削除';

  @override
  String get issueReportDetail => '問題報告詳細';

  @override
  String get issueReportInformation => '問題報告情報';

  @override
  String get issueReportTitle => 'タイトル';

  @override
  String get issueReportDescription => '説明';

  @override
  String get issueReportAsset => '資産';

  @override
  String get issueReportIssueType => '問題タイプ';

  @override
  String get issueReportPriority => '優先度';

  @override
  String get issueReportStatus => 'ステータス';

  @override
  String get issueReportReportedBy => '報告者';

  @override
  String get issueReportReportedDate => '報告日';

  @override
  String get issueReportResolvedDate => '解決日';

  @override
  String get issueReportResolvedBy => '解決者';

  @override
  String get issueReportResolutionNotes => '解決メモ';

  @override
  String get issueReportMetadata => 'メタデータ';

  @override
  String get issueReportCreatedAt => '作成日時';

  @override
  String get issueReportUpdatedAt => '更新日時';

  @override
  String get issueReportOnlyAdminCanEdit => '問題報告を編集できるのは管理者のみです';

  @override
  String get issueReportOnlyAdminCanDelete => '問題報告を削除できるのは管理者のみです';

  @override
  String get issueReportFailedToLoad => '問題報告の読み込みに失敗しました';

  @override
  String get issueReportDeletedSuccess => '問題報告が削除されました';

  @override
  String get issueReportDeletedFailed => '削除に失敗しました';

  @override
  String get issueReportUnknownAsset => '不明な資産';

  @override
  String get issueReportUnknownUser => '不明なユーザー';

  @override
  String get issueReportEditIssueReport => '問題報告を編集';

  @override
  String get issueReportCreateIssueReport => '問題報告を作成';

  @override
  String get issueReportFillRequiredFields => '必須フィールドをすべて入力してください';

  @override
  String get issueReportSavedSuccessfully => '問題報告が正常に保存されました';

  @override
  String get issueReportOperationFailed => '操作に失敗しました';

  @override
  String get issueReportFailedToLoadTranslations => '翻訳の読み込みに失敗しました';

  @override
  String get issueReportSearchAsset => '資産を検索して選択';

  @override
  String get issueReportSearchReportedBy => '問題を報告したユーザーを検索して選択';

  @override
  String get issueReportEnterIssueType => '問題タイプを入力 (例: ハードウェア、ソフトウェア)';

  @override
  String get issueReportSelectPriority => '優先度を選択';

  @override
  String get issueReportSelectStatus => 'ステータスを選択';

  @override
  String get issueReportSearchResolvedBy => '問題を解決したユーザーを検索して選択';

  @override
  String get issueReportTranslations => '翻訳';

  @override
  String get issueReportEnglish => '英語';

  @override
  String get issueReportJapanese => '日本語';

  @override
  String get issueReportIndonesian => 'インドネシア語';

  @override
  String issueReportEnterTitleIn(String language) {
    return '$languageでタイトルを入力';
  }

  @override
  String issueReportEnterDescriptionIn(String language) {
    return '$languageで説明を入力';
  }

  @override
  String issueReportEnterResolutionNotesIn(String language) {
    return '$languageで解決メモを入力';
  }

  @override
  String get issueReportUpdate => '更新';

  @override
  String get issueReportCreate => '作成';

  @override
  String get issueReportManagement => '問題報告管理';

  @override
  String get issueReportCreateIssueReportTitle => '問題報告を作成';

  @override
  String get issueReportCreateIssueReportSubtitle => '新しい問題報告を追加';

  @override
  String get issueReportSelectManyTitle => '複数選択';

  @override
  String get issueReportSelectManySubtitle => '削除する複数の問題報告を選択';

  @override
  String get issueReportFilterAndSortTitle => 'フィルターと並べ替え';

  @override
  String get issueReportFilterAndSortSubtitle => '問題報告表示をカスタマイズ';

  @override
  String get issueReportSelectIssueReportsToDelete => '削除する問題報告を選択';

  @override
  String get issueReportDeleteIssueReports => '問題報告を削除';

  @override
  String issueReportDeleteMultipleConfirmation(int count) {
    return '$count個の問題報告を削除してもよろしいですか？';
  }

  @override
  String get issueReportNoIssueReportsSelected => '問題報告が選択されていません';

  @override
  String get issueReportNotImplementedYet => 'まだ実装されていません';

  @override
  String issueReportSelectedCount(int count) {
    return '$count個選択済み';
  }

  @override
  String get issueReportSearchIssueReports => '問題報告を検索...';

  @override
  String get issueReportNoIssueReportsFound => '問題報告が見つかりません';

  @override
  String get issueReportCreateFirstIssueReport => '最初の問題報告を作成して開始しましょう';

  @override
  String get issueReportLongPressToSelect => '長押ししてさらに問題報告を選択';

  @override
  String get issueReportFilterByAsset => '資産でフィルター';

  @override
  String get issueReportFilterByReportedBy => '報告者でフィルター';

  @override
  String get issueReportFilterByResolvedBy => '解決者でフィルター';

  @override
  String get issueReportSearchAssetFilter => '資産を検索...';

  @override
  String get issueReportSearchUserFilter => 'ユーザーを検索...';

  @override
  String get issueReportEnterIssueTypeFilter => '問題タイプを入力...';

  @override
  String get issueReportSortBy => '並べ替え';

  @override
  String get issueReportSortOrder => '並べ替え順序';

  @override
  String get issueReportIsResolved => '解決済み';

  @override
  String get issueReportDateFrom => '開始日';

  @override
  String get issueReportDateTo => '終了日';

  @override
  String get issueReportReset => 'リセット';

  @override
  String get issueReportApply => '適用';

  @override
  String get issueReportFilterReset => 'フィルターをリセットしました';

  @override
  String get issueReportFilterApplied => 'フィルターを適用しました';

  @override
  String get issueReportMyIssueReports => '私の問題報告';

  @override
  String get issueReportSearchMyIssueReports => '私の問題報告を検索...';

  @override
  String get issueReportFiltersAndSorting => 'フィルターと並べ替え';

  @override
  String get issueReportApplyFilters => 'フィルターを適用';

  @override
  String get issueReportFiltersApplied => 'フィルター適用済み';

  @override
  String get issueReportFilterAndSort => 'フィルターと並べ替え';

  @override
  String get issueReportNoIssueReportsFoundEmpty => '問題報告が見つかりません';

  @override
  String get issueReportYouHaveNoReportedIssues => '報告された問題はありません';

  @override
  String get issueReportCreateIssueReportTooltip => '問題報告を作成';

  @override
  String get issueReportValidationAssetRequired => '資産は必須です';

  @override
  String get issueReportValidationReportedByRequired => '報告者は必須です';

  @override
  String get issueReportValidationIssueTypeRequired => '問題タイプは必須です';

  @override
  String get issueReportValidationIssueTypeMaxLength =>
      '問題タイプは100文字を超えることはできません';

  @override
  String get issueReportValidationPriorityRequired => '優先度は必須です';

  @override
  String get issueReportValidationStatusRequired => 'ステータスは必須です';

  @override
  String get issueReportValidationTitleRequired => 'タイトルは必須です';

  @override
  String get issueReportValidationTitleMaxLength => 'タイトルは200文字を超えることはできません';

  @override
  String get issueReportValidationDescriptionMaxLength =>
      '説明は1000文字を超えることはできません';

  @override
  String get issueReportValidationResolutionNotesMaxLength =>
      '解決メモは1000文字を超えることはできません';

  @override
  String get locationDeleteLocation => '場所を削除';

  @override
  String locationDeleteConfirmation(String locationName) {
    return '\"$locationName\"を削除してもよろしいですか？';
  }

  @override
  String get locationCancel => 'キャンセル';

  @override
  String get locationDelete => '削除';

  @override
  String get locationDetail => '場所詳細';

  @override
  String get locationInformation => '場所情報';

  @override
  String get locationCode => '場所コード';

  @override
  String get locationName => '場所名';

  @override
  String get locationBuilding => '建物';

  @override
  String get locationFloor => '階';

  @override
  String get locationLatitude => '緯度';

  @override
  String get locationLongitude => '経度';

  @override
  String get locationMetadata => 'メタデータ';

  @override
  String get locationCreatedAt => '作成日時';

  @override
  String get locationUpdatedAt => '更新日時';

  @override
  String get locationOnlyAdminCanEdit => '場所を編集できるのは管理者のみです';

  @override
  String get locationOnlyAdminCanDelete => '場所を削除できるのは管理者のみです';

  @override
  String get locationFailedToLoad => '場所の読み込みに失敗しました';

  @override
  String get locationDeleted => '場所が削除されました';

  @override
  String get locationDeleteFailed => '削除に失敗しました';

  @override
  String get locationEditLocation => '場所を編集';

  @override
  String get locationCreateLocation => '場所を作成';

  @override
  String get locationFillRequiredFields => '必須フィールドをすべて入力してください';

  @override
  String get locationSavedSuccessfully => '場所が正常に保存されました';

  @override
  String get locationOperationFailed => '操作に失敗しました';

  @override
  String get locationFailedToLoadTranslations => '翻訳の読み込みに失敗しました';

  @override
  String get locationEnterLocationCode => '場所コードを入力 (例: LOC-001)';

  @override
  String get locationBuildingOptional => '建物 (オプション)';

  @override
  String get locationEnterBuilding => '建物名を入力';

  @override
  String get locationFloorOptional => '階 (オプション)';

  @override
  String get locationEnterFloor => '階数を入力';

  @override
  String get locationLatitudeOptional => '緯度 (オプション)';

  @override
  String get locationEnterLatitude => '緯度を入力';

  @override
  String get locationLongitudeOptional => '経度 (オプション)';

  @override
  String get locationEnterLongitude => '経度を入力';

  @override
  String get locationGettingLocation => '位置情報取得中...';

  @override
  String get locationUseCurrentLocation => '現在位置を使用';

  @override
  String get locationServicesDisabled => '位置情報サービスが無効です';

  @override
  String get locationServicesDialogTitle => '位置情報サービスが無効です';

  @override
  String get locationServicesDialogMessage =>
      '現在位置を取得するには位置情報サービスが必要です。有効にしますか？';

  @override
  String get locationOpenSettings => '設定を開く';

  @override
  String get locationPermissionDenied => '位置情報許可が拒否されました';

  @override
  String get locationPermissionPermanentlyDenied => '位置情報許可が永続的に拒否されました';

  @override
  String get locationPermissionRequired => '許可が必要です';

  @override
  String get locationPermissionDialogMessage =>
      '位置情報許可が永続的に拒否されています。アプリ設定で有効にしてください。';

  @override
  String get locationRetrievedSuccessfully => '現在位置を正常に取得しました';

  @override
  String get locationFailedToGetCurrent => '現在位置の取得に失敗しました';

  @override
  String get locationTranslations => '翻訳';

  @override
  String get locationTranslationsSubtitle => 'さまざまな言語の翻訳を追加';

  @override
  String get locationEnglish => '英語';

  @override
  String get locationJapanese => '日本語';

  @override
  String get locationIndonesian => 'インドネシア語';

  @override
  String get locationEnterLocationName => '場所名を入力';

  @override
  String get locationUpdate => '更新';

  @override
  String get locationCreate => '作成';

  @override
  String get locationManagement => '場所管理';

  @override
  String get locationCreateLocationTitle => '場所を作成';

  @override
  String get locationCreateLocationSubtitle => '新しい場所を追加';

  @override
  String get locationSelectManyTitle => '複数選択';

  @override
  String get locationSelectManySubtitle => '削除する複数の場所を選択';

  @override
  String get locationFilterAndSortTitle => 'フィルターと並べ替え';

  @override
  String get locationFilterAndSortSubtitle => '場所表示をカスタマイズ';

  @override
  String get locationSelectLocationsToDelete => '削除する場所を選択';

  @override
  String get locationSortBy => '並べ替え';

  @override
  String get locationSortOrder => '並べ替え順序';

  @override
  String get locationReset => 'リセット';

  @override
  String get locationApply => '適用';

  @override
  String get locationFilterReset => 'フィルターをリセットしました';

  @override
  String get locationFilterApplied => 'フィルターを適用しました';

  @override
  String get locationDeleteLocations => '場所を削除';

  @override
  String locationDeleteMultipleConfirmation(int count) {
    return '$count個の場所を削除してもよろしいですか？';
  }

  @override
  String get locationNoLocationsSelected => '場所が選択されていません';

  @override
  String get locationNotImplementedYet => 'まだ実装されていません';

  @override
  String locationSelectedCount(int count) {
    return '$count個選択済み';
  }

  @override
  String get locationSearchLocations => '場所を検索...';

  @override
  String get locationNoLocationsFound => '場所が見つかりません';

  @override
  String get locationCreateFirstLocation => '最初の場所を作成して開始しましょう';

  @override
  String get locationLongPressToSelect => '長押ししてさらに場所を選択';

  @override
  String locationFloorPrefix(String floor) {
    return '$floor階';
  }

  @override
  String get locationValidationCodeRequired => '場所コードは必須です';

  @override
  String get locationValidationCodeMinLength => '場所コードは2文字以上である必要があります';

  @override
  String get locationValidationCodeMaxLength => '場所コードは20文字を超えることはできません';

  @override
  String get locationValidationCodeAlphanumeric => '場所コードには英数字とダッシュのみ使用できます';

  @override
  String get locationValidationNameRequired => '場所名は必須です';

  @override
  String get locationValidationNameMinLength => '場所名は3文字以上である必要があります';

  @override
  String get locationValidationNameMaxLength => '場所名は100文字を超えることはできません';

  @override
  String get locationValidationBuildingMaxLength => '建物は50文字を超えることはできません';

  @override
  String get locationValidationFloorMaxLength => '階は20文字を超えることはできません';

  @override
  String get locationValidationLatitudeInvalid => '緯度は有効な数値である必要があります';

  @override
  String get locationValidationLatitudeRange => '緯度は-90から90の間である必要があります';

  @override
  String get locationValidationLongitudeInvalid => '経度は有効な数値である必要があります';

  @override
  String get locationValidationLongitudeRange => '経度は-180から180の間である必要があります';

  @override
  String get locationNotFound => '場所が見つかりません';

  @override
  String get locationSearchFailed => '検索に失敗しました';

  @override
  String get locationConfirmLocation => '場所を確認';

  @override
  String get locationSelectedFromMap => 'マップから場所を選択しました';

  @override
  String get locationSearchLocation => '場所を検索...';

  @override
  String get locationPickFromMap => 'マップから選択';

  @override
  String get maintenanceScheduleDeleteSchedule => 'メンテナンススケジュールの削除';

  @override
  String maintenanceScheduleDeleteConfirmation(String title) {
    return '「$title」を削除してもよろしいですか？';
  }

  @override
  String get maintenanceScheduleDeleted => 'メンテナンススケジュールを削除しました';

  @override
  String get maintenanceScheduleDeleteFailed => '削除に失敗しました';

  @override
  String get maintenanceScheduleDetail => 'メンテナンススケジュール詳細';

  @override
  String get maintenanceScheduleInformation => 'メンテナンススケジュール情報';

  @override
  String get maintenanceScheduleTitle => 'タイトル';

  @override
  String get maintenanceScheduleDescription => '説明';

  @override
  String get maintenanceScheduleAsset => '資産';

  @override
  String get maintenanceScheduleMaintenanceType => 'メンテナンスタイプ';

  @override
  String get maintenanceScheduleIsRecurring => '定期実行';

  @override
  String get maintenanceScheduleInterval => '間隔';

  @override
  String get maintenanceScheduleScheduledTime => '予定時刻';

  @override
  String get maintenanceScheduleNextScheduledDate => '次回実行予定日';

  @override
  String get maintenanceScheduleLastExecutedDate => '前回実行日';

  @override
  String get maintenanceScheduleState => '状態';

  @override
  String get maintenanceScheduleAutoComplete => '自動完了';

  @override
  String get maintenanceScheduleEstimatedCost => '予想コスト';

  @override
  String get maintenanceScheduleCreatedBy => '作成者';

  @override
  String get maintenanceScheduleYes => 'はい';

  @override
  String get maintenanceScheduleNo => 'いいえ';

  @override
  String get maintenanceScheduleUnknownAsset => '不明な資産';

  @override
  String get maintenanceScheduleUnknownUser => '不明なユーザー';

  @override
  String get maintenanceScheduleOnlyAdminCanEdit => '管理者のみがメンテナンススケジュールを編集できます';

  @override
  String get maintenanceScheduleOnlyAdminCanDelete =>
      '管理者のみがメンテナンススケジュールを削除できます';

  @override
  String get maintenanceScheduleFailedToLoad => 'メンテナンススケジュールの読み込みに失敗しました';

  @override
  String get maintenanceScheduleEditSchedule => 'メンテナンススケジュールの編集';

  @override
  String get maintenanceScheduleCreateSchedule => 'メンテナンススケジュールの作成';

  @override
  String get maintenanceScheduleFillRequiredFields => '必須項目をすべて入力してください';

  @override
  String get maintenanceScheduleSavedSuccessfully => 'メンテナンススケジュールを正常に保存しました';

  @override
  String get maintenanceScheduleOperationFailed => '操作に失敗しました';

  @override
  String get maintenanceScheduleFailedToLoadTranslations => '翻訳の読み込みに失敗しました';

  @override
  String get maintenanceScheduleSearchAsset => '資産を検索して選択';

  @override
  String get maintenanceScheduleSelectMaintenanceType => 'メンテナンスタイプを選択';

  @override
  String get maintenanceScheduleEnterIntervalValue => '間隔値を入力（例：3）';

  @override
  String get maintenanceScheduleSelectIntervalUnit => '間隔単位を選択';

  @override
  String get maintenanceScheduleEnterScheduledTime => '例：09:30';

  @override
  String get maintenanceScheduleSelectState => '状態を選択';

  @override
  String get maintenanceScheduleEnterEstimatedCost => '予想コストを入力（任意）';

  @override
  String get maintenanceScheduleSearchUser => 'スケジュールを作成したユーザーを検索して選択';

  @override
  String get maintenanceScheduleTranslations => '翻訳';

  @override
  String get maintenanceScheduleEnglish => '英語';

  @override
  String get maintenanceScheduleJapanese => '日本語';

  @override
  String maintenanceScheduleEnterTitle(String language) {
    return '$languageでタイトルを入力';
  }

  @override
  String maintenanceScheduleEnterDescription(String language) {
    return '$languageで説明を入力';
  }

  @override
  String get maintenanceScheduleCancel => 'キャンセル';

  @override
  String get maintenanceScheduleUpdate => '更新';

  @override
  String get maintenanceScheduleCreate => '作成';

  @override
  String get maintenanceScheduleManagement => 'メンテナンススケジュール管理';

  @override
  String get maintenanceScheduleCreateTitle => 'メンテナンススケジュールの作成';

  @override
  String get maintenanceScheduleCreateSubtitle => '新しいメンテナンススケジュールを追加';

  @override
  String get maintenanceScheduleSelectManyTitle => '複数選択';

  @override
  String get maintenanceScheduleSelectManySubtitle => '削除する複数のスケジュールを選択';

  @override
  String get maintenanceScheduleFilterAndSortTitle => 'フィルターと並び替え';

  @override
  String get maintenanceScheduleFilterAndSortSubtitle => 'スケジュール表示をカスタマイズ';

  @override
  String get maintenanceScheduleSelectToDelete => '削除するメンテナンススケジュールを選択';

  @override
  String get maintenanceScheduleSortBy => '並び替え';

  @override
  String get maintenanceScheduleSortOrder => '並び順';

  @override
  String get maintenanceScheduleReset => 'リセット';

  @override
  String get maintenanceScheduleApply => '適用';

  @override
  String get maintenanceScheduleFilterReset => 'フィルターをリセットしました';

  @override
  String get maintenanceScheduleFilterApplied => 'フィルターを適用しました';

  @override
  String get maintenanceScheduleDeleteSchedules => 'スケジュールの削除';

  @override
  String maintenanceScheduleDeleteMultipleConfirmation(int count) {
    return '$count件のスケジュールを削除してもよろしいですか？';
  }

  @override
  String get maintenanceScheduleNoSchedulesSelected => 'スケジュールが選択されていません';

  @override
  String get maintenanceScheduleNotImplementedYet => 'まだ実装されていません';

  @override
  String maintenanceScheduleSelectedCount(int count) {
    return '$count件選択中';
  }

  @override
  String get maintenanceScheduleDelete => '削除';

  @override
  String get maintenanceScheduleSearch => 'スケジュールを検索...';

  @override
  String get maintenanceScheduleNoSchedulesFound => 'スケジュールが見つかりません';

  @override
  String get maintenanceScheduleCreateFirstSchedule => '最初のスケジュールを作成して始めましょう';

  @override
  String get maintenanceScheduleLongPressToSelect => '長押しして複数のスケジュールを選択';

  @override
  String get maintenanceScheduleMetadata => 'メタデータ';

  @override
  String get maintenanceScheduleCreatedAt => '作成日時';

  @override
  String get maintenanceScheduleUpdatedAt => '更新日時';

  @override
  String get maintenanceScheduleIntervalValueLabel => '間隔値';

  @override
  String get maintenanceScheduleIntervalUnitLabel => '間隔単位';

  @override
  String get maintenanceScheduleScheduledTimeLabel => '予定時刻（HH:mm）';

  @override
  String get maintenanceRecordDeleteRecord => 'メンテナンス記録の削除';

  @override
  String maintenanceRecordDeleteConfirmation(String title) {
    return '「$title」を削除してもよろしいですか？';
  }

  @override
  String get maintenanceRecordDeleted => 'メンテナンス記録を削除しました';

  @override
  String get maintenanceRecordDeleteFailed => '削除に失敗しました';

  @override
  String get maintenanceRecordDetail => 'メンテナンス記録詳細';

  @override
  String get maintenanceRecordInformation => 'メンテナンス記録情報';

  @override
  String get maintenanceRecordTitle => 'タイトル';

  @override
  String get maintenanceRecordNotes => 'メモ';

  @override
  String get maintenanceRecordAsset => '資産';

  @override
  String get maintenanceRecordMaintenanceDate => 'メンテナンス日';

  @override
  String get maintenanceRecordCompletionDate => '完了日';

  @override
  String get maintenanceRecordDuration => '所要時間';

  @override
  String maintenanceRecordDurationMinutes(int minutes) {
    return '$minutes分';
  }

  @override
  String get maintenanceRecordPerformedByUser => '実行者（ユーザー）';

  @override
  String get maintenanceRecordPerformedByVendor => '実行者（業者）';

  @override
  String get maintenanceRecordResult => '結果';

  @override
  String get maintenanceRecordActualCost => '実際のコスト';

  @override
  String maintenanceRecordActualCostValue(String cost) {
    return '$cost';
  }

  @override
  String get maintenanceRecordUnknownAsset => '不明な資産';

  @override
  String get maintenanceRecordOnlyAdminCanEdit => '管理者のみがメンテナンス記録を編集できます';

  @override
  String get maintenanceRecordOnlyAdminCanDelete => '管理者のみがメンテナンス記録を削除できます';

  @override
  String get maintenanceRecordFailedToLoad => 'メンテナンス記録の読み込みに失敗しました';

  @override
  String get maintenanceRecordEditRecord => 'メンテナンス記録の編集';

  @override
  String get maintenanceRecordCreateRecord => 'メンテナンス記録の作成';

  @override
  String get maintenanceRecordFillRequiredFields => '必須項目をすべて入力してください';

  @override
  String get maintenanceRecordSavedSuccessfully => 'メンテナンス記録を正常に保存しました';

  @override
  String get maintenanceRecordOperationFailed => '操作に失敗しました';

  @override
  String get maintenanceRecordFailedToLoadTranslations => '翻訳の読み込みに失敗しました';

  @override
  String get maintenanceRecordSearchSchedule => 'メンテナンススケジュールを検索して選択';

  @override
  String get maintenanceRecordSearchAsset => '資産を検索して選択';

  @override
  String get maintenanceRecordCompletionDateOptional => '完了日（任意）';

  @override
  String get maintenanceRecordDurationMinutesLabel => '所要時間（分）';

  @override
  String get maintenanceRecordEnterDuration => '所要時間を分単位で入力（任意）';

  @override
  String get maintenanceRecordSearchPerformedByUser => 'メンテナンスを実行したユーザーを検索して選択';

  @override
  String get maintenanceRecordPerformedByVendorLabel => '実行者（業者）';

  @override
  String get maintenanceRecordEnterVendor => '業者名を入力（任意）';

  @override
  String get maintenanceRecordSelectResult => 'メンテナンス結果を選択';

  @override
  String get maintenanceRecordActualCostLabel => '実際のコスト';

  @override
  String get maintenanceRecordEnterActualCost => '実際のコストを入力（任意）';

  @override
  String get maintenanceRecordTranslations => '翻訳';

  @override
  String get maintenanceRecordEnglish => '英語';

  @override
  String get maintenanceRecordJapanese => '日本語';

  @override
  String maintenanceRecordEnterTitle(String language) {
    return '$languageでタイトルを入力';
  }

  @override
  String maintenanceRecordEnterNotes(String language) {
    return '$languageでメモを入力';
  }

  @override
  String get maintenanceRecordCancel => 'キャンセル';

  @override
  String get maintenanceRecordUpdate => '更新';

  @override
  String get maintenanceRecordCreate => '作成';

  @override
  String get maintenanceRecordManagement => 'メンテナンス記録管理';

  @override
  String get maintenanceRecordCreateTitle => 'メンテナンス記録の作成';

  @override
  String get maintenanceRecordCreateSubtitle => '新しいメンテナンス記録を追加';

  @override
  String get maintenanceRecordSelectManyTitle => '複数選択';

  @override
  String get maintenanceRecordSelectManySubtitle => '削除する複数の記録を選択';

  @override
  String get maintenanceRecordFilterAndSortTitle => 'フィルターと並び替え';

  @override
  String get maintenanceRecordFilterAndSortSubtitle => '記録表示をカスタマイズ';

  @override
  String get maintenanceRecordSelectToDelete => '削除するメンテナンス記録を選択';

  @override
  String get maintenanceRecordSortBy => '並び替え';

  @override
  String get maintenanceRecordSortOrder => '並び順';

  @override
  String get maintenanceRecordReset => 'リセット';

  @override
  String get maintenanceRecordApply => '適用';

  @override
  String get maintenanceRecordFilterReset => 'フィルターをリセットしました';

  @override
  String get maintenanceRecordFilterApplied => 'フィルターを適用しました';

  @override
  String get maintenanceRecordDeleteRecords => '記録の削除';

  @override
  String maintenanceRecordDeleteMultipleConfirmation(int count) {
    return '$count件の記録を削除してもよろしいですか？';
  }

  @override
  String get maintenanceRecordNoRecordsSelected => '記録が選択されていません';

  @override
  String get maintenanceRecordNotImplementedYet => 'まだ実装されていません';

  @override
  String maintenanceRecordSelectedCount(int count) {
    return '$count件選択中';
  }

  @override
  String get maintenanceRecordDelete => '削除';

  @override
  String get maintenanceRecordSearch => '記録を検索...';

  @override
  String get maintenanceRecordNoRecordsFound => '記録が見つかりません';

  @override
  String get maintenanceRecordCreateFirstRecord => '最初の記録を作成して始めましょう';

  @override
  String get maintenanceRecordLongPressToSelect => '長押しして複数の記録を選択';

  @override
  String get maintenanceRecordMetadata => 'メタデータ';

  @override
  String get maintenanceRecordCreatedAt => '作成日時';

  @override
  String get maintenanceRecordUpdatedAt => '更新日時';

  @override
  String get maintenanceRecordSchedule => 'メンテナンススケジュール';

  @override
  String get notificationManagement => '通知管理';

  @override
  String get notificationDetail => '通知詳細';

  @override
  String get notificationMyNotifications => '私の通知';

  @override
  String get notificationDeleteNotification => '通知を削除';

  @override
  String get notificationDeleteConfirmation => 'この通知を削除してもよろしいですか？';

  @override
  String notificationDeleteMultipleConfirmation(int count) {
    return '$count個の通知を削除してもよろしいですか？';
  }

  @override
  String get notificationCancel => 'キャンセル';

  @override
  String get notificationDelete => '削除';

  @override
  String get notificationOnlyAdminCanDelete => '通知を削除できるのは管理者のみです';

  @override
  String get notificationDeleted => '通知が削除されました';

  @override
  String get notificationDeleteFailed => '削除に失敗しました';

  @override
  String get notificationFailedToLoad => '通知の読み込みに失敗しました';

  @override
  String get notificationInformation => '通知情報';

  @override
  String get notificationTitle => 'タイトル';

  @override
  String get notificationMessage => 'メッセージ';

  @override
  String get notificationType => 'タイプ';

  @override
  String get notificationPriority => '優先度';

  @override
  String get notificationIsRead => '既読';

  @override
  String get notificationReadStatus => '既読状態';

  @override
  String get notificationRead => '既読';

  @override
  String get notificationUnread => '未読';

  @override
  String get notificationYes => 'はい';

  @override
  String get notificationNo => 'いいえ';

  @override
  String get notificationCreatedAt => '作成日時';

  @override
  String get notificationExpiresAt => '有効期限';

  @override
  String get notificationSearchNotifications => '通知を検索...';

  @override
  String get notificationSearchMyNotifications => '私の通知を検索...';

  @override
  String get notificationNoNotificationsFound => '通知が見つかりません';

  @override
  String get notificationNoNotificationsYet => '通知はありません';

  @override
  String get notificationCreateFirstNotification => '最初の通知を作成して開始しましょう';

  @override
  String get notificationCreateNotification => '通知を作成';

  @override
  String get notificationCreateNotificationSubtitle => '新しい通知を追加';

  @override
  String get notificationSelectMany => '複数選択';

  @override
  String get notificationSelectManySubtitle => '削除する複数の通知を選択';

  @override
  String get notificationFilterAndSort => 'フィルターと並べ替え';

  @override
  String get notificationFilterAndSortSubtitle => '通知表示をカスタマイズ';

  @override
  String get notificationFiltersAndSorting => 'フィルターと並べ替え';

  @override
  String get notificationSelectNotificationsToDelete => '削除する通知を選択';

  @override
  String get notificationLongPressToSelect => '長押ししてさらに通知を選択';

  @override
  String notificationSelectedCount(int count) {
    return '$count個選択済み';
  }

  @override
  String get notificationNoNotificationsSelected => '通知が選択されていません';

  @override
  String get notificationFilterByUser => 'ユーザーでフィルター';

  @override
  String get notificationFilterByRelatedAsset => '関連資産でフィルター';

  @override
  String get notificationSearchUser => 'ユーザーを検索...';

  @override
  String get notificationSearchAsset => '資産を検索...';

  @override
  String get notificationSortBy => '並べ替え';

  @override
  String get notificationSortOrder => '並べ替え順序';

  @override
  String get notificationReset => 'リセット';

  @override
  String get notificationApply => '適用';

  @override
  String get notificationApplyFilters => 'フィルターを適用';

  @override
  String get notificationFilterReset => 'フィルターをリセットしました';

  @override
  String get notificationFilterApplied => 'フィルターを適用しました';

  @override
  String get notificationFiltersApplied => 'フィルター適用済み';

  @override
  String get notificationNotImplementedYet => 'まだ実装されていません';

  @override
  String get notificationJustNow => 'たった今';

  @override
  String notificationMinutesAgo(int minutes) {
    return '$minutes分前';
  }

  @override
  String notificationHoursAgo(int hours) {
    return '$hours時間前';
  }

  @override
  String notificationDaysAgo(int days) {
    return '$days日前';
  }

  @override
  String get notificationMarkAsRead => '既読にする';

  @override
  String get notificationMarkAsUnread => '未読にする';

  @override
  String notificationMarkedAsRead(int count) {
    return '$count件を既読にしました';
  }

  @override
  String notificationMarkedAsUnread(int count) {
    return '$count件を未読にしました';
  }

  @override
  String get scanLogManagement => 'スキャンログ管理';

  @override
  String get scanLogDetail => 'スキャンログ詳細';

  @override
  String get scanLogDeleteScanLog => 'スキャンログを削除';

  @override
  String get scanLogDeleteConfirmation => 'このスキャンログを削除してもよろしいですか？';

  @override
  String scanLogDeleteMultipleConfirmation(int count) {
    return '$count個のスキャンログを削除してもよろしいですか？';
  }

  @override
  String get scanLogCancel => 'キャンセル';

  @override
  String get scanLogDelete => '削除';

  @override
  String get scanLogOnlyAdminCanDelete => 'スキャンログを削除できるのは管理者のみです';

  @override
  String get scanLogDeleted => 'スキャンログが削除されました';

  @override
  String get scanLogDeleteFailed => '削除に失敗しました';

  @override
  String get scanLogFailedToLoad => 'スキャンログの読み込みに失敗しました';

  @override
  String get scanLogInformation => 'スキャン情報';

  @override
  String get scanLogScannedValue => 'スキャン値';

  @override
  String get scanLogScanMethod => 'スキャン方法';

  @override
  String get scanLogScanResult => 'スキャン結果';

  @override
  String get scanLogScanTimestamp => 'スキャン日時';

  @override
  String get scanLogLocation => '場所';

  @override
  String get scanLogSearchScanLogs => 'スキャンログを検索...';

  @override
  String get scanLogNoScanLogsFound => 'スキャンログが見つかりません';

  @override
  String get scanLogCreateFirstScanLog => '最初のスキャンログを作成して開始しましょう';

  @override
  String get scanLogCreateScanLog => 'スキャンログを作成';

  @override
  String get scanLogCreateScanLogSubtitle => '新しいスキャンログを追加';

  @override
  String get scanLogSelectMany => '複数選択';

  @override
  String get scanLogSelectManySubtitle => '削除する複数のスキャンログを選択';

  @override
  String get scanLogFilterAndSort => 'フィルターと並べ替え';

  @override
  String get scanLogFilterAndSortSubtitle => 'スキャンログ表示をカスタマイズ';

  @override
  String get scanLogFiltersAndSorting => 'フィルターと並べ替え';

  @override
  String get scanLogSelectScanLogsToDelete => '削除するスキャンログを選択';

  @override
  String get scanLogLongPressToSelect => '長押ししてさらにスキャンログを選択';

  @override
  String scanLogSelectedCount(int count) {
    return '$count個選択済み';
  }

  @override
  String get scanLogNoScanLogsSelected => 'スキャンログが選択されていません';

  @override
  String get scanLogFilterByAsset => '資産でフィルター';

  @override
  String get scanLogFilterByScannedBy => 'スキャンユーザーでフィルター';

  @override
  String get scanLogSearchAsset => '資産を検索...';

  @override
  String get scanLogSearchUser => 'ユーザーを検索...';

  @override
  String get scanLogSortBy => '並べ替え';

  @override
  String get scanLogSortOrder => '並べ替え順序';

  @override
  String get scanLogHasCoordinates => '座標あり';

  @override
  String get scanLogDateFrom => '開始日';

  @override
  String get scanLogDateTo => '終了日';

  @override
  String get scanLogReset => 'リセット';

  @override
  String get scanLogApply => '適用';

  @override
  String get scanLogFilterReset => 'フィルターをリセットしました';

  @override
  String get scanLogFilterApplied => 'フィルターを適用しました';

  @override
  String get scanLogNotImplementedYet => 'まだ実装されていません';

  @override
  String get userManagement => 'ユーザー管理';

  @override
  String get userCreateUser => 'ユーザーを作成';

  @override
  String get userAddNewUser => '新しいユーザーを追加';

  @override
  String get userSelectMany => '複数選択';

  @override
  String get userSelectMultipleToDelete => '削除する複数のユーザーを選択';

  @override
  String get userFilterAndSort => 'フィルターと並べ替え';

  @override
  String get userCustomizeDisplay => 'ユーザー表示をカスタマイズ';

  @override
  String get userFilters => 'フィルター';

  @override
  String get userRole => '役割';

  @override
  String get userEmployeeId => '従業員ID';

  @override
  String get userEnterEmployeeId => '従業員IDを入力...';

  @override
  String get userActiveStatus => 'アクティブステータス';

  @override
  String get userActive => 'アクティブ';

  @override
  String get userInactive => '非アクティブ';

  @override
  String get userSort => '並べ替え';

  @override
  String get userSortBy => '並べ替え';

  @override
  String get userSortOrder => '並べ替え順序';

  @override
  String get userAscending => '昇順';

  @override
  String get userDescending => '降順';

  @override
  String get userReset => 'リセット';

  @override
  String get userApply => '適用';

  @override
  String get userFilterReset => 'フィルターをリセットしました';

  @override
  String get userFilterApplied => 'フィルターを適用しました';

  @override
  String get userSelectUsersToDelete => '削除するユーザーを選択';

  @override
  String get userDeleteUsers => 'ユーザーを削除';

  @override
  String userDeleteConfirmation(int count) {
    return '$count人のユーザーを削除してもよろしいですか？';
  }

  @override
  String get userCancel => 'キャンセル';

  @override
  String get userDelete => '削除';

  @override
  String get userNoUsersSelected => 'ユーザーが選択されていません';

  @override
  String get userNotImplementedYet => 'まだ実装されていません';

  @override
  String userSelectedCount(int count) {
    return '$count人選択済み';
  }

  @override
  String get userSearchUsers => 'ユーザーを検索...';

  @override
  String get userNoUsersFound => 'ユーザーが見つかりません';

  @override
  String get userCreateFirstUser => '最初のユーザーを作成して開始しましょう';

  @override
  String get userLongPressToSelect => '長押ししてさらにユーザーを選択';

  @override
  String get userEditUser => 'ユーザーを編集';

  @override
  String get userPleaseFixErrors => 'すべてのエラーを修正してください';

  @override
  String get userPleaseSelectRole => '役割を選択してください';

  @override
  String get userPleaseValidateFields => '必須フィールドをすべて入力してください';

  @override
  String get userSavedSuccessfully => 'ユーザーが正常に保存されました';

  @override
  String get userOperationFailed => '操作に失敗しました';

  @override
  String get userInformation => 'ユーザー情報';

  @override
  String get userUsername => 'ユーザー名';

  @override
  String get userEnterUsername => 'ユーザー名を入力';

  @override
  String get userEmail => 'メールアドレス';

  @override
  String get userEnterEmail => 'メールアドレスを入力';

  @override
  String get userPassword => 'パスワード';

  @override
  String get userEnterPassword => 'パスワードを入力';

  @override
  String get userFullName => '氏名';

  @override
  String get userEnterFullName => '氏名を入力';

  @override
  String get userSelectRole => '役割を選択';

  @override
  String get userEmployeeIdOptional => '従業員ID (オプション)';

  @override
  String get userEnterEmployeeIdOptional => '従業員IDを入力';

  @override
  String get userPreferredLanguage => '優先言語 (オプション)';

  @override
  String get userSelectLanguage => '言語を選択';

  @override
  String get userUpdate => '更新';

  @override
  String get userCreate => '作成';

  @override
  String get userDetail => 'ユーザー詳細';

  @override
  String get userOnlyAdminCanEdit => 'ユーザーを編集できるのは管理者のみです';

  @override
  String get userDeleteUser => 'ユーザーを削除';

  @override
  String userDeleteSingleConfirmation(String fullName) {
    return '\"$fullName\"を削除してもよろしいですか？';
  }

  @override
  String get userOnlyAdminCanDelete => 'ユーザーを削除できるのは管理者のみです';

  @override
  String get userDeleted => 'ユーザーが削除されました';

  @override
  String get userDeleteFailed => '削除に失敗しました';

  @override
  String get userName => '名前';

  @override
  String get userPreferredLang => '優先言語';

  @override
  String get userYes => 'はい';

  @override
  String get userNo => 'いいえ';

  @override
  String get userMetadata => 'メタデータ';

  @override
  String get userCreatedAt => '作成日時';

  @override
  String get userUpdatedAt => '更新日時';

  @override
  String get userFailedToLoad => 'ユーザーの読み込みに失敗しました';

  @override
  String get userFailedToLoadProfile => 'プロフィールの読み込みに失敗しました';

  @override
  String get userPersonalInformation => '個人情報';

  @override
  String get userAccountDetails => 'アカウント詳細';

  @override
  String get userStatus => 'ステータス';

  @override
  String get userUpdateProfile => 'プロフィールを更新';

  @override
  String get userNoUserData => 'ユーザーデータがありません';

  @override
  String get userProfileInformation => 'プロフィール情報';

  @override
  String get userProfilePicture => 'プロフィール画像';

  @override
  String get userChooseImage => '画像を選択';

  @override
  String get userProfileUpdatedSuccessfully => 'プロフィールが正常に更新されました';

  @override
  String get userChangePassword => 'パスワードを変更';

  @override
  String get userChangePasswordTitle => 'パスワードを更新';

  @override
  String get userChangePasswordDescription =>
      '現在のパスワードを入力し、新しい安全なパスワードを設定してください。';

  @override
  String get userCurrentPassword => '現在のパスワード';

  @override
  String get userEnterCurrentPassword => '現在のパスワードを入力';

  @override
  String get userNewPassword => '新しいパスワード';

  @override
  String get userEnterNewPassword => '新しいパスワードを入力';

  @override
  String get userConfirmNewPassword => '新しいパスワードを確認';

  @override
  String get userEnterConfirmNewPassword => '新しいパスワードを再入力';

  @override
  String get userPasswordRequirements => 'パスワード要件';

  @override
  String get userPasswordRequirementsList =>
      '• 8文字以上\n• 大文字を1つ以上\n• 小文字を1つ以上\n• 数字を1つ以上';

  @override
  String get userChangePasswordButton => 'パスワードを変更';

  @override
  String get userPasswordChangedSuccessfully => 'パスワードが正常に変更されました';

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
  String get appEndDrawerTitle => 'Sigma Asset';

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
  String get customAppBarTitle => 'Sigma Asset';

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

  @override
  String get staffShellBottomNavDashboard => 'ダッシュボード';

  @override
  String get staffShellBottomNavScanAsset => '資産をスキャン';

  @override
  String get staffShellBottomNavProfile => 'プロフィール';

  @override
  String get shellDoubleBackToExitApp => 'もう一度戻るボタンを押して終了';
}
