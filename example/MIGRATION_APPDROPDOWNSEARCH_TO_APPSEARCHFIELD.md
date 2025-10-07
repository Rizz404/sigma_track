# Migration: AppDropdownSearch → AppSearchField

## Summary
Mengganti `AppDropdownSearch` dengan `AppSearchField` yang baru dengan autocomplete support di `ListCategoriesScreen`.

## Changes Made

### 1. Import Cleanup
```dart
// ❌ Removed
import 'package:sigma_track/shared/presentation/widgets/app_dropdown_search.dart';

// ✅ Already exists
import 'package:sigma_track/shared/presentation/widgets/app_search_field.dart';
```

### 2. State Management
```dart
// Added state untuk track selected parent category
Category? _selectedParentCategory;
```

### 3. Search Method
```dart
Future<List<Category>> _searchParentCategories(String query) async {
  final notifier = ref.read(categoriesSearchProvider.notifier);
  await notifier.search(query);
  final state = ref.read(categoriesSearchProvider);
  return state.categories;
}
```

### 4. Widget Replacement

#### Before (AppDropdownSearch):
```dart
AppDropdownSearch<Category>(
  name: 'parentId',
  label: 'Filter by Parent Category',
  hintText: 'Select parent category',
  initialValue: currentFilter.parentId != null ? ... : null,
  asyncItems: (search) async {
    await ref.read(categoriesSearchProvider.notifier).search(search);
    return ref.read(categoriesSearchProvider).categories;
  },
  itemAsString: (category) => category.categoryName,
  compareFn: (item1, item2) => item1.id == item2.id,
  itemBuilder: (context, category, isDisabled, isSelected) {
    return ListTile(...);
  },
)
```

#### After (AppSearchField):
```dart
AppSearchField<Category>(
  name: 'parentId',
  label: 'Filter by Parent Category',
  hintText: 'Search parent category...',
  initialValue: _selectedParentCategory?.categoryName,
  enableAutocomplete: true,
  onSearch: _searchParentCategories,
  itemDisplayMapper: (category) => category.categoryName,
  itemValueMapper: (category) => category.id,
  itemBuilder: (context, category) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: context.colors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.category, color: context.colors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  category.categoryName,
                  style: AppTextStyle.bodyMedium,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 2),
                AppText(
                  category.categoryCode,
                  style: AppTextStyle.bodySmall,
                  color: context.colors.textTertiary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
  onItemSelected: (category) {
    setState(() {
      _selectedParentCategory = category;
    });
  },
  initialItemsToShow: 5,
  itemsPerLoadMore: 5,
  enableLoadMore: true,
  suggestionsMaxHeight: 300,
)
```

### 5. Filter Apply Logic
```dart
// Updated to use _selectedParentCategory instead of formData['parentId']
final newFilter = CategoriesFilter(
  search: currentFilter.search,
  sortBy: sortByStr != null ? CategorySortBy.fromString(sortByStr) : null,
  sortOrder: sortOrderStr != null ? SortOrder.fromString(sortOrderStr) : null,
  hasParent: hasParentValue,
  parentId: _selectedParentCategory?.id, // ✅ From state
);
```

### 6. Reset Logic
```dart
// Added reset for selected parent category
setState(() {
  _selectedParentCategory = null;
});
```

## Key Differences

### AppDropdownSearch vs AppSearchField

| Feature | AppDropdownSearch | AppSearchField |
|---------|------------------|----------------|
| Type | Modal dropdown | Overlay autocomplete |
| Item Builder | 4 params (context, item, isDisabled, isSelected) | 2 params (context, item) |
| Value Mapping | `itemAsString` | `itemDisplayMapper` + `itemValueMapper` |
| Compare | `compareFn` | Handled internally |
| Load More | Not supported | ✅ Supported |
| Debounce | Manual | ✅ Built-in |
| State | FormBuilder only | FormBuilder + local state |

## Benefits

✅ **Better UX**: Overlay dropdown dengan scroll + load more
✅ **Cleaner API**: Simpler props, easier to understand
✅ **Built-in Debounce**: No manual timer needed
✅ **Lazy Loading**: Show 5, load more on scroll
✅ **Consistent**: Same pattern as other searches
✅ **Flexible**: Custom item builder dengan full control

## Usage Flow

1. User ketik "Mobile" → debounce 300ms
2. `_searchParentCategories` dipanggil
3. Notifier fetch data dari API
4. Dropdown tampilkan 5 item pertama
5. User scroll → load 5 item lagi
6. User pilih item → `_selectedParentCategory` di-set
7. Apply filter → `parentId` dari `_selectedParentCategory.id`

## Testing Checklist

- [x] Search parent category
- [x] Select parent category
- [x] Apply filter with parent
- [x] Reset filter (clears parent)
- [x] Custom item builder rendering
- [x] Load more on scroll
- [x] No errors on compile

## Next Steps

Consider migrating other `AppDropdownSearch` usages:
- User selection screens
- Product category selection
- Location selection
- etc.

Same pattern dapat digunakan untuk semua autocomplete search!
