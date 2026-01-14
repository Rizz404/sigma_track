import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

/// Reusable searchable dropdown widget with search functionality
/// Parent widget manages state and provides items/callbacks
///
/// Example usage with Riverpod provider:
/// ```dart
/// final categoriesState = ref.watch(categoriesSearchDropdownProvider);
///
/// AppSearchableDropdown<Category>(
///   name: 'category_id',
///   label: 'Category',
///   items: categoriesState.categories,
///   isLoading: categoriesState.isLoading,
///   onSearch: (query) {
///     ref.read(categoriesSearchDropdownProvider.notifier).search(query);
///   },
///   itemDisplayMapper: (category) => category.name,
///   itemValueMapper: (category) => category.id,
///   onChanged: (category) => print(category?.name),
/// )
/// ```
class AppSearchableDropdown<T> extends StatefulWidget {
  final String name;
  final T? initialValue;
  final String? label;
  final String? hintText;
  final bool enabled;
  final String? Function(String?)? validator;

  // * Data & callbacks
  final List<T> items;
  final bool isLoading;
  final ValueChanged<String> onSearch;

  // * Item configuration
  final String Function(T item) itemDisplayMapper;
  final String Function(T item) itemValueMapper;
  final String? Function(T item)? itemSubtitleMapper;
  final IconData? Function(T item)? itemIconMapper;

  // * Selection callback
  final Function(T? item)? onChanged;

  // * UI customization
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Widget? prefixIcon;
  final double dropdownMaxHeight;

  const AppSearchableDropdown({
    super.key,
    required this.name,
    required this.items,
    required this.isLoading,
    required this.onSearch,
    required this.itemDisplayMapper,
    required this.itemValueMapper,
    this.initialValue,
    this.label,
    this.hintText,
    this.enabled = true,
    this.validator,
    this.itemSubtitleMapper,
    this.itemIconMapper,
    this.onChanged,
    this.contentPadding,
    this.fillColor,
    this.prefixIcon,
    this.dropdownMaxHeight = 400,
  });

  @override
  State<AppSearchableDropdown<T>> createState() =>
      _AppSearchableDropdownState<T>();
}

class _AppSearchableDropdownState<T> extends State<AppSearchableDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late GlobalKey<FormBuilderFieldState> _fieldKey;

  OverlayEntry? _overlayEntry;
  T? _selectedItem;
  DateTime? _lastSearchTime;

  @override
  void initState() {
    super.initState();
    _fieldKey = GlobalKey<FormBuilderFieldState>();
    _selectedItem = widget.initialValue;
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    _debounceSearch(query);
  }

  void _debounceSearch(String query) {
    _lastSearchTime = DateTime.now();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_lastSearchTime != null &&
          DateTime.now().difference(_lastSearchTime!) >=
              const Duration(milliseconds: 500)) {
        widget.onSearch(query);
        _updateOverlay();
      }
    });
  }

  void _toggleDropdown() {
    if (!widget.enabled) return;

    if (_overlayEntry != null) {
      _hideDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    _removeOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _focusNode.requestFocus();
  }

  void _hideDropdown() {
    _removeOverlay();
    _searchController.clear();
    // Reset search when closing
    widget.onSearch('');
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _selectItem(T item) {
    final value = widget.itemValueMapper(item);
    _fieldKey.currentState?.didChange(value);

    setState(() {
      _selectedItem = item;
    });

    widget.onChanged?.call(item);
    _hideDropdown();
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    final spaceBelow = screenHeight - offset.dy - size.height;
    final spaceAbove = offset.dy;
    final maxHeight = widget.dropdownMaxHeight;

    final shouldShowAbove = spaceBelow < maxHeight && spaceAbove > spaceBelow;
    final availableHeight = shouldShowAbove
        ? (spaceAbove - 8).clamp(200.0, maxHeight)
        : (spaceBelow - 8).clamp(200.0, maxHeight);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: shouldShowAbove
              ? Offset(0, -(availableHeight + 4))
              : Offset(0, size.height + 4),
          child: Material(
            elevation: 16,
            borderRadius: BorderRadius.circular(12),
            color: context.colors.surface,
            child: Container(
              constraints: BoxConstraints(maxHeight: availableHeight),
              decoration: BoxDecoration(
                border: Border.all(color: context.colors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSearchHeader(),
                  Flexible(child: _buildItemsList()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.colors.border)),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: _performSearch,
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: context.textTheme.bodySmall?.copyWith(
            color: context.colors.textTertiary,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: context.colors.textSecondary,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 20,
                    color: context.colors.textSecondary,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                )
              : null,
          isDense: true,
          filled: true,
          fillColor: context.colors.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        style: context.textTheme.bodySmall,
      ),
    );
  }

  Widget _buildItemsList() {
    final items = widget.items;
    final isLoading = widget.isLoading;

    if (isLoading && items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(context.colors.primary),
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AppText(
            'No items available',
            style: AppTextStyle.bodyMedium,
            color: context.colors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected =
            _selectedItem != null &&
            widget.itemValueMapper(_selectedItem as T) ==
                widget.itemValueMapper(item);

        return _buildItem(item, isSelected);
      },
    );
  }

  Widget _buildItem(T item, bool isSelected) {
    final displayText = widget.itemDisplayMapper(item);
    final subtitle = widget.itemSubtitleMapper?.call(item);
    final icon = widget.itemIconMapper?.call(item);

    return InkWell(
      onTap: () => _selectItem(item),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.primary.withValues(alpha: 0.1)
              : context.colors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: context.colors.primary, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSelected
                    ? context.colors.primary
                    : context.colors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    displayText,
                    style: AppTextStyle.bodyMedium,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? context.colors.primary
                        : context.colors.textPrimary,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    AppText(
                      subtitle,
                      style: AppTextStyle.bodySmall,
                      color: context.colors.textTertiary,
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: context.colors.primary, size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: FormBuilderField<String>(
        key: _fieldKey,
        name: widget.name,
        initialValue: widget.initialValue != null
            ? widget.itemValueMapper(widget.initialValue!)
            : null,
        enabled: widget.enabled,
        validator: widget.validator,
        builder: (FormFieldState<String> field) {
          final hasError = field.hasError;
          final displayText = _selectedItem != null
              ? widget.itemDisplayMapper(_selectedItem as T)
              : null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: _toggleDropdown,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: widget.label,
                    hintText: widget.hintText ?? 'Select option',
                    hintStyle: context.textTheme.bodyMedium?.copyWith(
                      color: context.colors.textTertiary,
                    ),
                    prefixIcon: widget.prefixIcon,
                    suffixIcon: Icon(
                      _overlayEntry != null
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: widget.enabled
                          ? context.colors.textSecondary
                          : context.colors.textDisabled,
                    ),
                    filled: true,
                    fillColor: widget.fillColor ?? context.colors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.colors.border,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.colors.border,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.colors.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.semantic.error,
                        width: 1,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.semantic.error,
                        width: 2,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.colors.disabled,
                        width: 1,
                      ),
                    ),
                    contentPadding:
                        widget.contentPadding ??
                        const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                    errorText: hasError ? field.errorText : null,
                  ),
                  child: displayText != null
                      ? AppText(
                          displayText,
                          style: AppTextStyle.bodyMedium,
                          color: widget.enabled
                              ? context.colors.textPrimary
                              : context.colors.textDisabled,
                        )
                      : null,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
