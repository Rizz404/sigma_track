import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sigma_track/core/enums/filtering_sorting_enums.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/feature/scan_log/domain/usecases/export_scan_log_list_usecase.dart';
import 'package:sigma_track/feature/scan_log/presentation/providers/scan_log_providers.dart';
import 'package:sigma_track/shared/presentation/widgets/app_button.dart';
import 'package:sigma_track/shared/presentation/widgets/app_dropdown.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class ExportScanLogsBottomSheet extends ConsumerStatefulWidget {
  final ExportScanLogListUsecaseParams initialParams;

  const ExportScanLogsBottomSheet({super.key, required this.initialParams});

  @override
  ConsumerState<ExportScanLogsBottomSheet> createState() =>
      _ExportScanLogsBottomSheetState();
}

class _ExportScanLogsBottomSheetState
    extends ConsumerState<ExportScanLogsBottomSheet> {
  final _formKey = GlobalKey<FormBuilderState>();
  ExportFormat? _selectedFormat;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exportScanLogsProvider);
    final previewData = state.previewData;

    ref.listen(exportScanLogsProvider, (previous, next) {
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
              AppText(
                context.l10n.assetExportAssets,
                style: AppTextStyle.titleLarge,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 24),
              AppDropdown<String>(
                name: 'format',
                label: context.l10n.assetExportFormat,
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
                    ref.read(exportScanLogsProvider.notifier).reset();
                  }
                },
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
                        context.l10n.assetExportFormatDisplay(
                          _selectedFormat?.label.toUpperCase() ?? 'N/A',
                        ),
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
                        leadingIcon: const Icon(Icons.download),
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

      final format = ExportFormat.values.firstWhere(
        (f) => f.value == formatStr,
      );

      final params = widget.initialParams.copyWith(format: format);

      this.logPresentation('Exporting scan logs with params: $params');

      await ref.read(exportScanLogsProvider.notifier).exportScanLogs(params);

      setState(() {
        _selectedFormat = format;
      });
    }
  }

  Future<void> _handleOpenAndSave(Uint8List fileData) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = _selectedFormat?.value ?? 'pdf';
      final fileName = 'scan_logs_export_$timestamp';

      if (_selectedFormat == ExportFormat.pdf) {
        await Printing.layoutPdf(
          onLayout: (_) => fileData,
          name: fileName,
          format: PdfPageFormat.a4.landscape,
        );

        if (mounted) {
          Navigator.pop(context);
        }
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/$fileName.$extension';

      final tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(fileData);

      this.logPresentation('Temp file created: $tempFilePath');

      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(tempFilePath)],
          text: context.l10n.assetExportSubject,
          subject: '$fileName.$extension',
        ),
      );

      if (mounted) {
        if (result.status == ShareResultStatus.success) {
          AppToast.success(context.l10n.assetFileSharedSuccessfully);
          Navigator.pop(context);
        }
      }
    } catch (e, s) {
      this.logError('Failed to share/save file', e, s);
      AppToast.error(context.l10n.assetFailedToShareFile(e.toString()));
    }
  }
}
