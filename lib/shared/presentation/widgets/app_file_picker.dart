import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/core/utils/logging.dart';
import 'package:sigma_track/core/utils/toast_utils.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

// * Reusable file picker widget dengan FormBuilder support
// * Features: single/multiple upload, validation, preview untuk image/video
// * Usage: AppFilePicker(name: 'avatar', fileType: FileType.image, maxFiles: 1)
class AppFilePicker extends StatefulWidget {
  final String name;
  final String? label;
  final String? hintText;
  final bool isRequired;
  final bool allowMultiple;
  final List<String>? allowedExtensions;
  final int? maxFiles;
  final int? maxSizeInMB;
  final String? Function(List<PlatformFile>?)? validator;
  final List<PlatformFile>? initialFiles;
  final FileType fileType;

  const AppFilePicker({
    super.key,
    required this.name,
    this.label,
    this.hintText,
    this.isRequired = false,
    this.allowMultiple = false,
    this.allowedExtensions,
    this.maxFiles,
    this.maxSizeInMB,
    this.validator,
    this.initialFiles,
    this.fileType = FileType.any,
  });

  @override
  State<AppFilePicker> createState() => _AppFilePickerState();
}

class _AppFilePickerState extends State<AppFilePicker> {
  List<PlatformFile> _selectedFiles = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialFiles != null) {
      _selectedFiles = widget.initialFiles!;
    }
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: widget.fileType,
        allowMultiple: widget.allowMultiple,
        allowedExtensions: widget.allowedExtensions,
      );

      if (result != null) {
        // * Validate max files
        if (widget.maxFiles != null && result.files.length > widget.maxFiles!) {
          AppToast.warning('Maximum ${widget.maxFiles} files allowed');
          return;
        }

        // * Validate file size
        if (widget.maxSizeInMB != null) {
          for (final file in result.files) {
            if (file.size > (widget.maxSizeInMB! * 1024 * 1024)) {
              AppToast.warning(
                'File ${file.name} exceeds ${widget.maxSizeInMB}MB limit',
              );
              return;
            }
          }
        }

        setState(() {
          if (widget.allowMultiple) {
            _selectedFiles = [..._selectedFiles, ...result.files];
          } else {
            _selectedFiles = result.files;
          }
        });

        // * Update form value
        FormBuilder.of(context)?.fields[widget.name]?.didChange(_selectedFiles);
        this.logData('Files selected: ${_selectedFiles.length}');
      }
    } catch (e, s) {
      this.logError('Error picking files', e, s);
      AppToast.error('Failed to pick files');
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
      FormBuilder.of(context)?.fields[widget.name]?.didChange(_selectedFiles);
    });
  }

  void _previewFile(PlatformFile file) {
    showDialog(
      context: context,
      builder: (context) => _FilePreviewDialog(file: file),
    );
  }

  bool _isPreviewable(PlatformFile file) {
    final extension = file.extension?.toLowerCase();
    return [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp',
      'mp4',
      'mov',
      'avi',
    ].contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<PlatformFile>>(
      name: widget.name,
      validator: widget.validator,
      initialValue: widget.initialFiles,
      builder: (FormFieldState<List<PlatformFile>> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null) ...[
              Row(
                children: [
                  AppText(
                    widget.label!,
                    style: AppTextStyle.bodySmall,
                    fontWeight: FontWeight.w600,
                  ),
                  if (widget.isRequired)
                    const AppText(
                      ' *',
                      color: Colors.red,
                      style: AppTextStyle.bodySmall,
                    ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            InkWell(
              onTap: _pickFiles,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: field.hasError
                        ? context.semantic.error
                        : context.colors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.upload_file_outlined,
                      color: context.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppText(
                        widget.hintText ?? 'Choose file(s)',
                        style: AppTextStyle.bodyMedium,
                        color: context.colors.textSecondary,
                      ),
                    ),
                    Icon(
                      Icons.add_circle_outline,
                      color: context.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
            if (_selectedFiles.isNotEmpty) ...[
              const SizedBox(height: 12),
              ..._selectedFiles.asMap().entries.map((entry) {
                final index = entry.key;
                final file = entry.value;
                return _FileItem(
                  file: file,
                  onRemove: () => _removeFile(index),
                  onPreview: _isPreviewable(file)
                      ? () => _previewFile(file)
                      : null,
                );
              }),
            ],
            if (field.hasError) ...[
              const SizedBox(height: 8),
              AppText(
                field.errorText ?? '',
                style: AppTextStyle.bodySmall,
                color: context.semantic.error,
              ),
            ],
          ],
        );
      },
    );
  }
}

class _FileItem extends StatelessWidget {
  final PlatformFile file;
  final VoidCallback onRemove;
  final VoidCallback? onPreview;

  const _FileItem({required this.file, required this.onRemove, this.onPreview});

  String _getFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  IconData _getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'mp4':
      case 'mov':
      case 'avi':
        return Icons.video_file;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colors.border),
      ),
      child: Row(
        children: [
          Icon(
            _getFileIcon(file.extension),
            color: context.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  file.name,
                  style: AppTextStyle.bodyMedium,
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                AppText(
                  _getFileSize(file.size),
                  style: AppTextStyle.bodySmall,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
          ),
          if (onPreview != null) ...[
            IconButton(
              icon: const Icon(Icons.visibility_outlined),
              onPressed: onPreview,
              iconSize: 20,
              color: context.colorScheme.primary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
          ],
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onRemove,
            iconSize: 20,
            color: context.semantic.error,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}

class _FilePreviewDialog extends StatelessWidget {
  final PlatformFile file;

  const _FilePreviewDialog({required this.file});

  bool _isImage() {
    final extension = file.extension?.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  bool _isVideo() {
    final extension = file.extension?.toLowerCase();
    return ['mp4', 'mov', 'avi'].contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.colors.surface,
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText(
                    file.name,
                    style: AppTextStyle.titleMedium,
                    fontWeight: FontWeight.bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(child: Center(child: _buildPreviewContent())),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewContent() {
    if (_isImage()) {
      if (kIsWeb) {
        return file.bytes != null
            ? Image.memory(file.bytes!, fit: BoxFit.contain)
            : const AppText('Unable to preview image');
      } else {
        return file.path != null
            ? Image.file(File(file.path!), fit: BoxFit.contain)
            : const AppText('Unable to preview image');
      }
    } else if (_isVideo()) {
      // TODO: Implement video preview with video_player package
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_file, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const AppText(
            'Video preview not implemented yet',
            style: AppTextStyle.bodyMedium,
          ),
        ],
      );
    } else {
      return const AppText('Preview not available for this file type');
    }
  }
}
