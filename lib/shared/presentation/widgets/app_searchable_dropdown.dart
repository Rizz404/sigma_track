import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sigma_track/core/extensions/localization_extension.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

/// Searchable dropdown with initial data loading and infinite scroll
/// Combines dropdown + search + pagination in one widget
class AppSearchableDropdown<T> extends StatefulWidget {
  final String name;
  final T? initialValue;
  final String? label;
  final String? hintText;
  final bool enabled;
  final String? Function(String?)? validator;

  // * Initial data loading (cursor-based pagination)
  final Future<List<T>> Function({String? cursor})? onLoadInitial;
  final int initialLoadCount;

  // * Search functionality
  final Future<List<T>> Function(String query)? onSearch;

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
  final int itemsPerPage;

  const AppSearchableDropdown({
    super.key,
    required this.name,
    required this.itemDisplayMapper,
    required this.itemValueMapper,
    this.initialValue,
    this.label,
    this.hintText,
    this.enabled = true,
    this.validator,
    this.onLoadInitial,
    this.initialLoadCount = 20,
    this.onSearch,
    this.itemSubtitleMapper,
    this.itemIconMapper,
    this.onChanged,
    this.contentPadding,
    this.fillColor,
    this.prefixIcon,
    this.dropdownMaxHeight = 400,
    this.itemsPerPage = 20,
  }) : assert(
         onLoadInitial != null || onSearch != null,
         'Either onLoadInitial or onSearch must be provided',
       );

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
  List<T> _items = [];
  bool _isLoading = false;
  bool _isSearchMode = false;
  String? _cursor;
  bool _hasMoreData = true;
  T? _selectedItem;

  @override
  void initState() {
    super.initState();
    _fieldKey = GlobalKey<FormBuilderFieldState>();
    _scrollController.addListener(_onScroll);
    _selectedItem = widget.initialValue;

    // * Load initial data if initialValue exists
    if (widget.initialValue != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadInitialData();
      });
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isSearchMode) return; // No pagination in search mode
    if (!_hasMoreData || _isLoading) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      _loadMoreData();
    }
  }

  Future<void> _loadInitialData() async {
    if (widget.onLoadInitial == null) return;

    setState(() {
      _isLoading = true;
      _cursor = null;
      _hasMoreData = true;
      _items.clear();
    });

    try {
      final results = await widget.onLoadInitial!(cursor: null);
      setState(() {
        _items = results;
        _hasMoreData = results.length >= widget.initialLoadCount;
        if (results.isNotEmpty && results.length >= widget.itemsPerPage) {
          _cursor = widget.itemValueMapper(results.last);
        }
      });
    } catch (e) {
      // Handle error silently or show toast
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreData() async {
    if (widget.onLoadInitial == null || !_hasMoreData || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await widget.onLoadInitial!(cursor: _cursor);
      setState(() {
        _items.addAll(results);
        _hasMoreData = results.length >= widget.itemsPerPage;
        if (results.isNotEmpty) {
          _cursor = widget.itemValueMapper(results.last);
        }
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _performSearch(String query) async {
    if (widget.onSearch == null) return;

    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      // Switch back to browse mode
      setState(() {
        _isSearchMode = false;
      });
      await _loadInitialData();
      return;
    }

    setState(() {
      _isSearchMode = true;
      _isLoading = true;
    });

    try {
      final results = await widget.onSearch!(trimmedQuery);
      setState(() {
        _items = results;
        _hasMoreData = false; // No pagination in search mode
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleDropdown() {
    if (!widget.enabled) return;

    if (_overlayEntry != null) {
      _hideDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() async {
    // Load initial data if not loaded yet
    if (_items.isEmpty && !_isLoading) {
      await _loadInitialData();
    }

    _removeOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _focusNode.requestFocus();
  }

  void _hideDropdown() {
    _removeOverlay();
    _searchController.clear();
    _isSearchMode = false;
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
                  if (widget.onSearch != null) _buildSearchHeader(),
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
        onChanged: (value) {
          _performSearch(value);
          _updateOverlay();
        },
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
                    _updateOverlay();
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
    if (_isLoading && _items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(context.colors.primary),
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AppText(
            _isSearchMode ? 'No results found' : 'No items available',
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
      itemCount: _items.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _items.length) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(context.colors.primary),
                ),
              ),
            ),
          );
        }

        final item = _items[index];
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
