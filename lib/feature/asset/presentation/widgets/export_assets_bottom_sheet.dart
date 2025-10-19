import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/asset/domain/usecases/export_asset_list_usecase.dart';
import 'package:sigma_track/feature/asset/presentation/providers/asset_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_checkbox.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class ExportAssetsBottomSheet extends ConsumerStatefulWidget {
  final ExportAssetListUsecaseParams initialParams;

  const ExportAssetsBottomSheet({super.key, required this.initialParams});

  @override
  ConsumerState<ExportAssetsBottomSheet> createState() =>
      _ExportAssetsBottomSheetState();
}

class _ExportAssetsBottomSheetState
    extends ConsumerState<ExportAssetsBottomSheet> {
  final _formKey = GlobalKey<FormBuilderState>();
  ExportFormat? _selectedFormat;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exportAssetsProvider);
    final previewData = state.previewData;

    ref.listen(exportAssetsProvider, (previous, next) {
      if (next.message != null) {
        AppToast.success(next.message!);
      }

      if (next.failure != null) {
        this.logError('Export error', next.failure);
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
              const AppText(
                'Export Assets',
                style: AppTextStyle.titleLarge,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 24),
              AppDropdown<String>(
                name: 'format',
                label: 'Export Format',
                initialValue: widget.initialParams.format.value,
                items: ExportFormat.values
                    .map(
                      (format) => AppDropdownItem<String>(
                        value: format.value,
                        label: format.label.toUpperCase(),
                        icon: Icon(format.icon, size: 18),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedFormat = ExportFormat.values.firstWhere(
                        (f) => f.value == value,
                      );
                    });
                    // * Reset preview when format changes
                    ref.read(exportAssetsProvider.notifier).reset();
                  }
                },
              ),
              const SizedBox(height: 16),
              AppCheckbox(
                name: 'includeDataMatrixImage',
                title: Row(
                  children: [
                    Icon(
                      Icons.qr_code,
                      size: 18,
                      color: context.colors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: AppText(
                        'Include Data Matrix Images',
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
                    color: context.colors.surfaceVariant.withOpacity(0.5),
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
                          const AppText(
                            'Export Ready',
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
                        'Size: ${(previewData.lengthInBytes / 1024).toStringAsFixed(2)} KB',
                        style: AppTextStyle.bodySmall,
                        color: context.colors.textSecondary,
                      ),
                      const SizedBox(height: 8),
                      AppText(
                        'Format: ${_selectedFormat?.label.toUpperCase() ?? 'N/A'}',
                        style: AppTextStyle.bodySmall,
                        color: context.colors.textSecondary,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.semantic.info.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: context.semantic.info.withOpacity(0.3),
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
                                'File will open share menu. Choose app to open or save directly.',
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
                      text: 'Cancel',
                      color: AppButtonColor.secondary,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (previewData == null) ...[
                    Expanded(
                      child: AppButton(
                        text: 'Export',
                        leadingIcon: const Icon(Icons.download),
                        isLoading: state.isLoading,
                        onPressed: state.isLoading ? null : _handleExport,
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: AppButton(
                        text: 'Share & Save',
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
      final formatStr = formData['format'] as String;
      final includeDataMatrix = formData['includeDataMatrixImage'] as bool?;

      final format = ExportFormat.values.firstWhere(
        (f) => f.value == formatStr,
      );

      final params = widget.initialParams.copyWith(
        format: format,
        includeDataMatrixImage: includeDataMatrix ?? false,
      );

      this.logPresentation('Exporting assets with params: $params');

      await ref.read(exportAssetsProvider.notifier).exportAssets(params);

      setState(() {
        _selectedFormat = format;
      });
    }
  }

  // * Flow: Export -> Save to temp -> Share file -> User can open & save
  // * Using share_plus to avoid FileUriExposedException on Android
  Future<void> _handleOpenAndSave(Uint8List fileData) async {
    try {
      // * Save to temporary directory first
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = _selectedFormat?.value ?? 'pdf';
      final fileName = 'assets_export_$timestamp.$extension';
      final tempFilePath = '${tempDir.path}/$fileName';

      final tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(fileData);

      this.logPresentation('Temp file created: $tempFilePath');

      // * Share file - this will open system share sheet
      // * User can choose to open with PDF/Excel app or save directly
      final result = await Share.shareXFiles(
        [XFile(tempFilePath)],
        text: 'Assets Export',
        subject: fileName,
      );

      if (mounted) {
        if (result.status == ShareResultStatus.success) {
          // * Ask if user wants to save permanently to Downloads
          final shouldSave = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const AppText(
                'Save to Downloads?',
                style: AppTextStyle.titleMedium,
              ),
              content: const AppText(
                'File has been shared. Would you like to save a copy to Downloads folder?',
                style: AppTextStyle.bodyMedium,
              ),
              actionsAlignment: MainAxisAlignment.end,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const AppText('No'),
                ),
                const SizedBox(width: 8),
                AppButton(
                  text: 'Save',
                  isFullWidth: false,
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ),
          );

          if (shouldSave == true) {
            await _saveFilePermanently(fileData);
          } else {
            AppToast.success('File shared successfully');
            Navigator.pop(context);
          }
        } else if (result.status == ShareResultStatus.dismissed) {
          AppToast.info('Share cancelled');
        }
      }
    } catch (e, s) {
      this.logError('Failed to share/save file', e, s);
      AppToast.error('Failed to share file: ${e.toString()}');
    }
  }

  Future<void> _saveFilePermanently(Uint8List fileData) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = _selectedFormat?.value ?? 'pdf';
      final fileName = 'assets_export_$timestamp';

      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: fileData,
        fileExtension: extension,
        mimeType: _selectedFormat == ExportFormat.pdf
            ? MimeType.pdf
            : MimeType.microsoftExcel,
      );

      if (mounted) {
        AppToast.success('File saved successfully to Downloads');
        Navigator.pop(context);
      }
    } catch (e, s) {
      this.logError('Failed to save file permanently', e, s);
      AppToast.error('Failed to save file: ${e.toString()}');
    }
  }
}
