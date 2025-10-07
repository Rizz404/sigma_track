import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sigma_track/core/extensions/theme_extension.dart';

class AppSearchField<T> extends StatefulWidget {
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

  // * Autocomplete/Suggestion props
  final bool enableAutocomplete;
  final Future<List<T>> Function(String query)? onSearch;
  final Widget Function(BuildContext context, T item)? itemBuilder;
  final String Function(T item)? itemValueMapper;
  final String Function(T item)? itemDisplayMapper;
  final Function(T item)? onItemSelected;
  final int initialItemsToShow;
  final int itemsPerLoadMore;
  final bool enableLoadMore;
  final double? suggestionsMaxHeight;
  final EdgeInsetsGeometry? suggestionsPadding;
  final int debounceMilliseconds;

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
    // Autocomplete props
    this.enableAutocomplete = false,
    this.onSearch,
    this.itemBuilder,
    this.itemValueMapper,
    this.itemDisplayMapper,
    this.onItemSelected,
    this.initialItemsToShow = 5,
    this.itemsPerLoadMore = 5,
    this.enableLoadMore = true,
    this.suggestionsMaxHeight = 300,
    this.suggestionsPadding,
    this.debounceMilliseconds = 300,
  }) : assert(
         !enableAutocomplete || onSearch != null,
         'onSearch is required when enableAutocomplete is true',
       );

  @override
  State<AppSearchField<T>> createState() => _AppSearchFieldState<T>();
}

class _AppSearchFieldState<T> extends State<AppSearchField<T>> {
  late GlobalKey<FormBuilderFieldState> _fieldKey;
  bool _hasText = false;

  // Autocomplete state
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<T> _allSuggestions = [];
  List<T> _displayedSuggestions = [];
  bool _isLoadingSuggestions = false;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  int _currentDisplayCount = 0;

  @override
  void initState() {
    super.initState();
    _fieldKey = GlobalKey<FormBuilderFieldState>();
    _hasText = widget.initialValue?.isNotEmpty ?? false;
    _currentDisplayCount = widget.initialItemsToShow;

    if (widget.enableAutocomplete) {
      _focusNode.addListener(_onFocusChanged);
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      _hideSuggestions();
    }
  }

  void _onScroll() {
    if (!widget.enableLoadMore) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    if (_displayedSuggestions.length >= _allSuggestions.length) return;

    setState(() {
      _currentDisplayCount += widget.itemsPerLoadMore;
      _displayedSuggestions = _allSuggestions
          .take(_currentDisplayCount)
          .toList();
    });
    _updateOverlay();
  }

  Future<void> _performSearch(String query) async {
    if (!widget.enableAutocomplete || widget.onSearch == null) return;
    if (query.isEmpty) {
      _hideSuggestions();
      return;
    }

    setState(() {
      _isLoadingSuggestions = true;
    });

    try {
      final results = await widget.onSearch!(query);
      _allSuggestions = results;
      _currentDisplayCount = widget.initialItemsToShow;
      _displayedSuggestions = results.take(_currentDisplayCount).toList();

      if (_displayedSuggestions.isNotEmpty && _focusNode.hasFocus) {
        _showSuggestionsOverlay();
      } else {
        _hideSuggestions();
      }
    } catch (e) {
      _hideSuggestions();
    } finally {
      setState(() {
        _isLoadingSuggestions = false;
      });
    }
  }

  void _onTextChanged(String? value) {
    final hasText = value?.isNotEmpty ?? false;
    if (_hasText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChanged?.call(value ?? '');

    if (widget.enableAutocomplete) {
      _debounceSearch(value ?? '');
    }
  }

  DateTime? _lastSearchTime;
  void _debounceSearch(String query) {
    _lastSearchTime = DateTime.now();
    Future.delayed(Duration(milliseconds: widget.debounceMilliseconds), () {
      if (_lastSearchTime != null &&
          DateTime.now().difference(_lastSearchTime!) >=
              Duration(milliseconds: widget.debounceMilliseconds)) {
        _performSearch(query);
      }
    });
  }

  void _clearText() {
    _fieldKey.currentState?.didChange('');
    widget.onClear?.call();
    widget.onChanged?.call('');
    _hideSuggestions();
  }

  void _onItemTapped(T item) {
    final displayValue =
        widget.itemDisplayMapper?.call(item) ?? item.toString();
    final value = widget.itemValueMapper?.call(item) ?? displayValue;

    _fieldKey.currentState?.didChange(value);
    widget.onItemSelected?.call(item);
    widget.onChanged?.call(value);

    _hideSuggestions();
    _focusNode.unfocus();
  }

  void _showSuggestionsOverlay() {
    _removeOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideSuggestions() {
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    // * Calculate available space above and below
    final spaceBelow = screenHeight - offset.dy - size.height;
    final spaceAbove = offset.dy;
    final maxHeight = widget.suggestionsMaxHeight ?? 300;

    // * Determine if dropdown should appear above or below
    final shouldShowAbove = spaceBelow < maxHeight && spaceAbove > spaceBelow;
    final availableHeight = shouldShowAbove
        ? (spaceAbove - 8).clamp(100.0, maxHeight)
        : (spaceBelow - 8).clamp(100.0, maxHeight);

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
            elevation: 16, // * Increased elevation to appear above bottom sheet
            borderRadius: BorderRadius.circular(12),
            color: context.colors.surface,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: availableHeight,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: context.colors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildSuggestionsList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionsList() {
    if (_isLoadingSuggestions && _displayedSuggestions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(context.colors.primary),
          ),
        ),
      );
    }

    if (_displayedSuggestions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'No results found',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: widget.suggestionsPadding ?? const EdgeInsets.all(8),
      shrinkWrap: true,
      itemCount:
          _displayedSuggestions.length +
          (_displayedSuggestions.length < _allSuggestions.length &&
                  widget.enableLoadMore
              ? 1
              : 0),
      itemBuilder: (context, index) {
        if (index >= _displayedSuggestions.length) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(context.colors.primary),
                ),
              ),
            ),
          );
        }

        final item = _displayedSuggestions[index];
        return InkWell(
          onTap: () => _onItemTapped(item),
          borderRadius: BorderRadius.circular(8),
          child: widget.itemBuilder != null
              ? widget.itemBuilder!(context, item)
              : _buildDefaultItem(item),
        );
      },
    );
  }

  Widget _buildDefaultItem(T item) {
    final displayText = widget.itemDisplayMapper?.call(item) ?? item.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Text(displayText, style: context.textTheme.bodyMedium),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: FormBuilderTextField(
        key: _fieldKey,
        name: widget.name,
        initialValue: widget.initialValue,
        controller: widget.controller,
        enabled: widget.enabled,
        focusNode: widget.enableAutocomplete ? _focusNode : null,
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
          suffixIcon: _buildSuffixIcon(),
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
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (_isLoadingSuggestions && widget.enableAutocomplete) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(context.colors.primary),
          ),
        ),
      );
    }

    if (widget.showClearButton && _hasText) {
      return IconButton(
        icon: Icon(Icons.clear, color: context.colors.textSecondary),
        onPressed: widget.enabled ? _clearText : null,
        tooltip: 'Clear',
      );
    }

    return null;
  }
}
