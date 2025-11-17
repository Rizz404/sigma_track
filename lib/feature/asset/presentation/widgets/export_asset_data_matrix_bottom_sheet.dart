import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/asset/domain/usecases/export_asset_data_matrix_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_checkbox.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class ExportAssetDataMatrixBottomSheet extends ConsumerStatefulWidget {
  final ExportAssetDataMatrixUsecaseParams initialParams;

  const ExportAssetDataMatrixBottomSheet({
    super.key,
    required this.initialParams,
  });

  @override
  ConsumerState<ExportAssetDataMatrixBottomSheet> createState() =>
      _ExportAssetDataMatrixBottomSheetState();
}

class _ExportAssetDataMatrixBottomSheetState
    extends ConsumerState<ExportAssetDataMatrixBottomSheet> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exportAssetDataMatrixProvider);
    final previewData = state.previewData;

    ref.listen(exportAssetDataMatrixProvider, (previous, next) {
      if (next.message != null) {
        AppToast.success(next.message!);
      }

      if (next.failure != null) {
        this.logError('Export data matrix error', next.failure);
        AppToast.error(next.failure!.message);
      }
    });

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.colors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.qr_code_2,
                    color: context.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppText(
                      context.l10n.assetExportDataMatrix,
                      style: AppTextStyle.titleLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.semantic.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.semantic.info.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: context.semantic.info,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppText(
                        context.l10n.assetDataMatrixPdfOnly,
                        style: AppTextStyle.bodySmall,
                        color: context.colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              AppCheckbox(
                name: 'includeDataMatrixImage',
                title: Row(
                  children: [
                    Icon(
                      Icons.image,
                      size: 18,
                      color: context.colors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppText(
                        context.l10n.assetIncludeDataMatrixImages,
                        style: AppTextStyle.bodyMedium,
                      ),
                    ),
                  ],
                ),
                initialValue: widget.initialParams.includeDataMatrixImage,
              ),
              const SizedBox(height: 24),
              if (previewData != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.surfaceVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.colors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: context.colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          AppText(
                            context.l10n.assetExportReady,
                            style: AppTextStyle.titleSmall,
                            fontWeight: FontWeight.w600,
                          ),
                          const Spacer(),
                          Icon(
                            Icons.check_circle,
                            color: context.semantic.success,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AppText(
                        context.l10n.assetExportSize(
                          (previewData.lengthInBytes / 1024).toStringAsFixed(2),
                        ),
                        style: AppTextStyle.bodySmall,
                        color: context.colors.textSecondary,
                      ),
                      const SizedBox(height: 8),
                      AppText(
                        context.l10n.assetExportFormatDisplay('PDF'),
                        style: AppTextStyle.bodySmall,
                        color: context.colors.textSecondary,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.semantic.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: context.semantic.info.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 18,
                              color: context.semantic.info,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppText(
                                context.l10n.assetExportShareInstruction,
                                style: AppTextStyle.bodySmall,
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: context.l10n.assetCancel,
                      color: AppButtonColor.secondary,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (previewData == null) ...[
                    Expanded(
                      child: AppButton(
                        text: context.l10n.assetExport,
                        leadingIcon: const Icon(Icons.download),
                        isLoading: state.isLoading,
                        onPressed: state.isLoading ? null : _handleExport,
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: AppButton(
                        text: context.l10n.assetShareAndSave,
                        leadingIcon: const Icon(Icons.share),
                        onPressed: () => _handleOpenAndSave(previewData),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleExport() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState!.value;
      final includeDataMatrix = formData['includeDataMatrixImage'] as bool?;

      final params = widget.initialParams.copyWith(
        format: ExportFormat.pdf, // * Data matrix hanya support PDF
        includeDataMatrixImage: includeDataMatrix ?? false,
      );

      this.logPresentation('Exporting data matrix with params: $params');

      await ref
          .read(exportAssetDataMatrixProvider.notifier)
          .exportDataMatrix(params);
    }
  }

  // * Flow: Export -> Save to temp -> Share file -> User can open & save
  // * Using share_plus to avoid FileUriExposedException on Android
  Future<void> _handleOpenAndSave(Uint8List fileData) async {
    try {
      // * Save to temporary directory first
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      const extension = 'pdf';
      final fileName = 'assets_datamatrix_$timestamp.$extension';
      final tempFilePath = '${tempDir.path}/$fileName';

      final tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(fileData);

      this.logPresentation('Temp file created: $tempFilePath');

      // * Share file - this will open system share sheet
      // * User can choose to open with PDF app or save directly
      final result = await Share.shareXFiles(
        [XFile(tempFilePath)],
        text: context.l10n.assetExportSubject,
        subject: fileName,
      );

      if (mounted) {
        if (result.status == ShareResultStatus.success) {
          // * Ask if user wants to save permanently to Downloads
          final shouldSave = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: AppText(
                context.l10n.assetSaveToDownloads,
                style: AppTextStyle.titleMedium,
              ),
              content: AppText(
                context.l10n.assetSaveToDownloadsMessage,
                style: AppTextStyle.bodyMedium,
              ),
              actionsAlignment: MainAxisAlignment.end,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: AppText(context.l10n.assetNo),
                ),
                const SizedBox(width: 8),
                AppButton(
                  text: context.l10n.assetSave,
                  isFullWidth: false,
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ),
          );

          if (shouldSave == true) {
            await _saveFilePermanently(fileData);
          } else {
            AppToast.success(context.l10n.assetFileSharedSuccessfully);
            Navigator.pop(context);
          }
        } else if (result.status == ShareResultStatus.dismissed) {
          AppToast.info(context.l10n.assetShareCancelled);
        }
      }
    } catch (e, s) {
      this.logError('Failed to share/save file', e, s);
      AppToast.error(context.l10n.assetFailedToShareFile(e.toString()));
    }
  }

  Future<void> _saveFilePermanently(Uint8List fileData) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      const extension = 'pdf';
      final fileName = 'assets_datamatrix_$timestamp';

      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: fileData,
        fileExtension: extension,
        mimeType: MimeType.pdf,
      );

      if (mounted) {
        AppToast.success(context.l10n.assetFileSavedSuccessfully);
        Navigator.pop(context);
      }
    } catch (e, s) {
      this.logError('Failed to save file permanently', e, s);
      AppToast.error(context.l10n.assetFailedToSaveFile(e.toString()));
    }
  }
}
