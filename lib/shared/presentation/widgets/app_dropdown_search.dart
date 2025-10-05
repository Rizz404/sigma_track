import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:sigma_track/core/extensions/theme_extension.dart';
import 'package:sigma_track/shared/presentation/widgets/app_text.dart';

class AppDropdownSearch<T> extends StatelessWidget {
  final String name;
  final T? initialValue;
  final Future<List<T>> Function(String search) asyncItems;
  final String Function(T item) itemAsString;
  final bool Function(T item1, T item2) compareFn;
  final ValueChanged<T?>? onChanged;
  final String? hintText;
  final String? label;
  final bool enabled;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Widget? prefixIcon;
  final double? width;
  final String? Function(T?)? validator;
  final Widget Function(BuildContext, T, bool, bool)? itemBuilder;
  final Widget Function(BuildContext, String?)? emptyBuilder;
  final Widget Function(BuildContext, String?)? loadingBuilder;
  final bool showSearchBox;
  final String? searchHint;
  final bool clearable;

  const AppDropdownSearch({
    super.key,
    required this.name,
    this.initialValue,
    required this.asyncItems,
    required this.itemAsString,
    required this.compareFn,
    this.onChanged,
    this.hintText,
    this.label,
    this.enabled = true,
    this.contentPadding,
    this.fillColor,
    this.prefixIcon,
    this.width,
    this.validator,
    this.itemBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
    this.showSearchBox = true,
    this.searchHint,
    this.clearable = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget dropdown = FormBuilderField<T>(
      name: name,
      initialValue: initialValue,
      enabled: enabled,
      validator: validator,
      builder: (FormFieldState<T> field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label != null) ...[
              AppText(
                label!,
                style: AppTextStyle.labelMedium,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
            ],
            DropdownSearch<T>(
              selectedItem: field.value,
              enabled: enabled,
              items: (filter, infiniteScrollProps) => asyncItems(filter),
              itemAsString: itemAsString,
              compareFn: compareFn,
              onChanged: (value) {
                field.didChange(value);
                onChanged?.call(value);
              },
              suffixProps: DropdownSuffixProps(
                clearButtonProps: clearable
                    ? const ClearButtonProps(isVisible: true)
                    : const ClearButtonProps(isVisible: false),
              ),
              decoratorProps: DropDownDecoratorProps(
                decoration: InputDecoration(
                  hintText: hintText ?? 'Select option',
                  hintStyle: context.textTheme.bodyMedium?.copyWith(
                    color: context.colors.textTertiary,
                  ),
                  prefixIcon: prefixIcon,
                  filled: true,
                  fillColor: fillColor ?? context.colors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: field.hasError
                          ? context.colorScheme.error
                          : context.colors.border,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: field.hasError
                          ? context.colorScheme.error
                          : context.colors.border,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: field.hasError
                          ? context.colorScheme.error
                          : context.colorScheme.primary,
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
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.colorScheme.error,
                      width: 1,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: context.colorScheme.error,
                      width: 2,
                    ),
                  ),
                  contentPadding:
                      contentPadding ??
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              popupProps: PopupProps.menu(
                showSearchBox: showSearchBox,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    hintText: searchHint ?? 'Search...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  style: context.textTheme.bodyMedium,
                ),
                itemBuilder:
                    itemBuilder ??
                    (context, item, isDisabled, isSelected) {
                      return ListTile(
                        selected: isSelected,
                        selectedTileColor: context.colorScheme.primary
                            .withOpacity(0.1),
                        title: AppText(
                          itemAsString(item),
                          style: AppTextStyle.bodyMedium,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      );
                    },
                emptyBuilder:
                    emptyBuilder ??
                    (context, search) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 48,
                                color: context.colors.textDisabled,
                              ),
                              const SizedBox(height: 12),
                              AppText(
                                'No items found',
                                style: AppTextStyle.bodyMedium,
                                color: context.colors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                loadingBuilder:
                    loadingBuilder ??
                    (context, search) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: CircularProgressIndicator(
                            color: context.colorScheme.primary,
                          ),
                        ),
                      );
                    },
                fit: FlexFit.loose,
                constraints: const BoxConstraints(maxHeight: 400),
              ),
            ),
            if (field.hasError) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: AppText(
                  field.errorText ?? '',
                  style: AppTextStyle.bodySmall,
                  color: context.colorScheme.error,
                ),
              ),
            ],
          ],
        );
      },
    );

    if (width != null) {
      dropdown = SizedBox(width: width, child: dropdown);
    }

    return dropdown;
  }
}
