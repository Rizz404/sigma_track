import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

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
    final theme = Theme.of(context);

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
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        prefixIcon:
            widget.prefixIcon ??
            Icon(
              Icons.search,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
        suffixIcon: widget.showClearButton && _hasText
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                onPressed: widget.enabled ? _clearText : null,
                tooltip: 'Clear',
              )
            : null,
        filled: true,
        fillColor:
            widget.fillColor ??
            theme.colorScheme.surface.withValues(alpha: 0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        contentPadding:
            widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      style: theme.textTheme.bodyMedium,
    );
  }
}
