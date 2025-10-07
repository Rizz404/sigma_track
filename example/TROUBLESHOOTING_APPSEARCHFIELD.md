# Troubleshooting: AppSearchField Autocomplete Dropdown

## Issue: Dropdown tidak muncul

### Kemungkinan Penyebab:

#### 1. ❌ `initialValue` diset saat `enableAutocomplete: true`
```dart
// ❌ WRONG - initialValue akan block autocomplete
AppSearchField<Category>(
  enableAutocomplete: true,
  initialValue: selectedCategory?.name, // Ini bikin field jadi read-only!
  onSearch: _search,
)

// ✅ CORRECT - Tampilkan selected item di luar field
Column(
  children: [
    if (selectedCategory != null)
      Container(...), // Show selected item
    AppSearchField<Category>(
      enableAutocomplete: true,
      // NO initialValue!
      onSearch: _search,
    ),
  ],
)
```

#### 2. ❌ Provider yang sama untuk list utama dan search
```dart
// ❌ WRONG - Data tercampur!
Future<List<Category>> _search(String query) async {
  final notifier = ref.read(categoriesProvider.notifier); // Main list!
  await notifier.search(query);
  return ref.read(categoriesProvider).categories;
}

// ✅ CORRECT - Pakai provider terpisah
Future<List<Category>> _search(String query) async {
  final notifier = ref.read(categoriesSearchProvider.notifier); // Dedicated!
  await notifier.search(query);
  return ref.read(categoriesSearchProvider).categories;
}
```

#### 3. ❌ `onSearch` return empty atau null
```dart
// ❌ WRONG - Return null/empty
Future<List<Category>> _search(String query) async {
  // Forgot to return!
  await api.search(query);
  return []; // Empty!
}

// ✅ CORRECT - Return actual data
Future<List<Category>> _search(String query) async {
  final notifier = ref.read(categoriesSearchProvider.notifier);
  await notifier.search(query);
  final state = ref.read(categoriesSearchProvider);
  return state.categories; // Return data!
}
```

#### 4. ❌ Search query terlalu pendek
```dart
// Default behavior: hanya trigger search jika query tidak kosong
// Dropdown auto-hide jika query.isEmpty

// Solution: Type minimal 1 karakter
```

#### 5. ❌ Focus issue
```dart
// Dropdown hanya muncul jika field has focus
// Check: Pastikan field bisa di-focus dan tidak disabled
```

## Solution untuk ListCategoriesScreen

### Before (Bermasalah):
```dart
AppSearchField<Category>(
  name: 'parentId',
  initialValue: _selectedParentCategory?.categoryName, // ❌ Problem!
  enableAutocomplete: true,
  onSearch: (query) {
    // Using main provider ❌
    final notifier = ref.read(categoriesProvider.notifier);
    await notifier.search(query);
    return ref.read(categoriesProvider).categories;
  },
)
```

### After (Fixed):
```dart
// Show selected item separately
if (_selectedParentCategory != null) ...[
  Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: context.colors.surfaceVariant,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: context.colors.primary, width: 2),
    ),
    child: Row(
      children: [
        Icon(Icons.category, color: context.colors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText('Selected:', style: AppTextStyle.bodySmall),
              AppText(
                _selectedParentCategory!.categoryName,
                style: AppTextStyle.bodyMedium,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () => setState(() => _selectedParentCategory = null),
        ),
      ],
    ),
  ),
  const SizedBox(height: 8),
],

// Search field without initialValue
AppSearchField<Category>(
  name: 'parentId',
  // NO initialValue! ✅
  enableAutocomplete: true,
  onSearch: _searchParentCategories, // Use dedicated provider ✅
  itemDisplayMapper: (cat) => cat.categoryName,
  itemValueMapper: (cat) => cat.id,
  onItemSelected: (cat) {
    setState(() => _selectedParentCategory = cat);
  },
)
```

## Debug Checklist

### 1. Check onSearch callback
```dart
Future<List<Category>> _searchParentCategories(String query) async {
  print('🔍 Search called with: $query'); // Add logging

  final notifier = ref.read(categoriesSearchProvider.notifier);
  await notifier.search(query);

  final state = ref.read(categoriesSearchProvider);
  print('📦 Results: ${state.categories.length} items'); // Add logging

  return state.categories;
}
```

### 2. Check provider
```dart
// In category_providers.dart
final categoriesSearchProvider =
    AutoDisposeNotifierProvider<CategoriesNotifier, CategoriesState>(
      CategoriesNotifier.new,
    );
```

### 3. Check field focus
- Pastikan field bisa diklik
- Pastikan `enabled: true` (default)
- Pastikan tidak ada overlay yang blocking

### 4. Check query
- Type minimal 1 karakter
- Jangan hanya space
- Query akan di-debounce 300ms

### 5. Check overlay rendering
- Overlay muncul di atas field
- Check z-index jika ada conflict
- Check `suggestionsMaxHeight` cukup besar

## Common Patterns

### Pattern 1: Simple Autocomplete
```dart
AppSearchField<User>(
  name: 'user_search',
  enableAutocomplete: true,
  onSearch: (query) async {
    final users = await api.searchUsers(query);
    return users;
  },
  itemDisplayMapper: (user) => user.name,
  itemValueMapper: (user) => user.id,
)
```

### Pattern 2: With Riverpod Notifier
```dart
Future<List<User>> _searchUsers(String query) async {
  final notifier = ref.read(usersSearchProvider.notifier);
  await notifier.search(query);
  return ref.read(usersSearchProvider).users;
}

AppSearchField<User>(
  enableAutocomplete: true,
  onSearch: _searchUsers,
  ...
)
```

### Pattern 3: With Selected Item Display
```dart
Column(
  children: [
    if (selectedItem != null) SelectedItemChip(item: selectedItem),
    AppSearchField<Item>(
      enableAutocomplete: true,
      onSearch: _search,
      onItemSelected: (item) => setState(() => selectedItem = item),
    ),
  ],
)
```

## Testing

1. Open filter bottom sheet
2. Click on parent category field
3. Type "mob" → Should trigger search after 300ms
4. Check console for logs:
   ```
   🔍 Search called with: mob
   📦 Results: 5 items
   ```
5. Dropdown should appear with results
6. Click item → Should be selected
7. Selected item chip should appear above field

## Still Not Working?

1. Check Flutter version (support Overlay widget)
2. Check dependencies (flutter_form_builder, etc)
3. Check if there's any global overlay blocking
4. Try hot restart (not just hot reload)
5. Check device/emulator rendering issues

## Reference Files
- `lib/shared/presentation/widgets/app_search_field.dart`
- `lib/feature/category/presentation/screens/admin/list_categories_screen.dart`
- `lib/feature/category/presentation/providers/category_providers.dart`
