import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';

class AppSearchField extends StatefulWidget {
  final String name;
  final String? hintText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final bool enabled;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final bool showClearButton;
  final String? Function(String?)? validator;
  final String? label;

  const AppSearchField({
    super.key,
    required this.name,
    this.hintText,
    this.initialValue,
    this.onChanged,
    this.onClear,
    this.contentPadding,
    this.fillColor,
    this.enabled = true,
    this.controller,
    this.prefixIcon,
    this.showClearButton = true,
    this.validator,
    this.label,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late GlobalKey<FormBuilderFieldState> _fieldKey;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _fieldKey = GlobalKey<FormBuilderFieldState>();
    _hasText = widget.initialValue?.isNotEmpty ?? false;
  }

  void _onTextChanged(String? value) {
    final hasText = value?.isNotEmpty ?? false;
    if (_hasText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChanged?.call(value ?? '');
  }

  void _clearText() {
    _fieldKey.currentState?.didChange('');
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      key: _fieldKey,
      name: widget.name,
      initialValue: widget.initialValue,
      controller: widget.controller,
      enabled: widget.enabled,
      onChanged: _onTextChanged,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText ?? 'Search...',
        hintStyle: context.textTheme.bodyMedium?.copyWith(
          color: context.colors.textTertiary,
        ),
        prefixIcon:
            widget.prefixIcon ??
            Icon(Icons.search, color: context.colors.textSecondary),
        suffixIcon: widget.showClearButton && _hasText
            ? IconButton(
                icon: Icon(Icons.clear, color: context.colors.textSecondary),
                onPressed: widget.enabled ? _clearText : null,
                tooltip: 'Clear',
              )
            : null,
        filled: true,
        fillColor: widget.fillColor ?? context.colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.colors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.colors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.colors.primary, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.colors.disabled, width: 1),
        ),
        contentPadding:
            widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      style: context.textTheme.bodyMedium,
    );
  }
}
