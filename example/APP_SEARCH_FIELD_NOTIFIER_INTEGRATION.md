# AppSearchField + Riverpod Notifier Integration Guide

## Integrasi dengan CategoriesNotifier

### Cara Kerja
`AppSearchField` dapat diintegrasikan dengan `CategoriesNotifier` untuk:
1. **Search** - Menggunakan method `search()` dari notifier
2. **Load More** - Otomatis handle pagination di dropdown (bukan pakai `loadMore()` notifier)

### Key Points
- ✅ `onSearch` callback memanggil `notifier.search(query)`
- ✅ Load more di dropdown handle data dari result search saja (lokal)
- ✅ State dari notifier bisa diwatch untuk debugging/info
- ✅ Search trigger otomatis dengan debounce

## Implementation Example

### 1. Basic Integration
```dart
class MyWidget extends ConsumerWidget {
  Future<List<Category>> _searchCategories(WidgetRef ref, String query) async {
    final notifier = ref.read(categoriesProvider.notifier);

    // Trigger search di notifier
    await notifier.search(query);

    // Return hasil dari state
    final state = ref.read(categoriesProvider);
    return state.categories;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppSearchField<Category>(
      name: 'category_search',
      enableAutocomplete: true,
      onSearch: (query) => _searchCategories(ref, query),
      itemDisplayMapper: (cat) => cat.categoryName,
      itemValueMapper: (cat) => cat.id,
      onItemSelected: (cat) {
        print('Selected: ${cat.categoryName}');
      },
    );
  }
}
```

### 2. With Custom Item Builder
```dart
AppSearchField<Category>(
  name: 'category_search',
  enableAutocomplete: true,
  onSearch: (query) => _searchCategories(ref, query),
  itemBuilder: (context, category) {
    return ListTile(
      leading: Icon(Icons.category),
      title: Text(category.categoryName),
      subtitle: Text(category.description),
    );
  },
  itemValueMapper: (cat) => cat.id,
  onItemSelected: (cat) {
    // Handle selection
  },
  initialItemsToShow: 5,
  itemsPerLoadMore: 5,
  enableLoadMore: true,
)
```

### 3. StatefulWidget Pattern (Recommended)
```dart
class CategorySearchWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<CategorySearchWidget> createState() => _State();
}

class _State extends ConsumerState<CategorySearchWidget> {
  Future<List<Category>> _searchCategories(String query) async {
    final notifier = ref.read(categoriesProvider.notifier);
    await notifier.search(query);
    final state = ref.read(categoriesProvider);
    return state.categories;
  }

  @override
  Widget build(BuildContext context) {
    // Watch state untuk monitoring
    final categoriesState = ref.watch(categoriesProvider);

    return Column(
      children: [
        AppSearchField<Category>(
          name: 'category_search',
          enableAutocomplete: true,
          onSearch: _searchCategories,
          itemDisplayMapper: (cat) => cat.categoryName,
          itemValueMapper: (cat) => cat.id,
          onItemSelected: (cat) {
            // Handle selection
          },
        ),

        // Debug info
        if (categoriesState.isLoading)
          CircularProgressIndicator(),
      ],
    );
  }
}
```

## Important Notes

### ⚠️ Load More Behavior
- **Dropdown load more**: Handle pagination lokal dari hasil search
- **Notifier load more**: Untuk infinite scroll di list/table
- Jangan campur keduanya! Dropdown sudah auto-handle pagination

### ⚠️ Search Flow
1. User ketik → debounce (300ms default)
2. `onSearch` dipanggil → `notifier.search(query)`
3. Notifier fetch data dari API
4. Return `state.categories` ke dropdown
5. Dropdown tampilkan hasil dengan lazy loading

### ⚠️ State Management
```dart
// ✅ DO: Read notifier untuk action
final notifier = ref.read(categoriesProvider.notifier);
await notifier.search(query);

// ✅ DO: Read state untuk data
final state = ref.read(categoriesProvider);
return state.categories;

// ✅ DO: Watch state untuk UI updates
final state = ref.watch(categoriesProvider);
if (state.isLoading) ...

// ❌ DON'T: Watch di dalam callback
onSearch: (query) {
  final notifier = ref.watch(...); // ERROR!
}
```

## Props Configuration

### Recommended Settings
```dart
AppSearchField<Category>(
  name: 'category_search',
  enableAutocomplete: true,
  onSearch: _searchCategories,

  // Display & Value mapping
  itemDisplayMapper: (cat) => cat.categoryName,  // What user sees
  itemValueMapper: (cat) => cat.id,              // What form stores

  // Pagination settings
  initialItemsToShow: 5,    // Show 5 items initially
  itemsPerLoadMore: 5,      // Load 5 more on scroll
  enableLoadMore: true,     // Enable scroll loading

  // UI settings
  suggestionsMaxHeight: 300,
  debounceMilliseconds: 300,

  // Callbacks
  onItemSelected: (cat) {
    // Handle selection here
  },
  onChanged: (value) {
    // Handle text change (value = id if item selected)
  },
)
```

## Real-World Example
Lihat file: `example/app_search_field_categories_example.dart`

### Features Demo:
1. ✅ Basic autocomplete with categories
2. ✅ Custom item builder dengan icon & description
3. ✅ State monitoring (loading, total items, etc)
4. ✅ Load more pagination
5. ✅ Debounced search

## Troubleshooting

### Issue: Results tidak muncul
```dart
// Pastikan return categories dari state
Future<List<Category>> _searchCategories(String query) async {
  final notifier = ref.read(categoriesProvider.notifier);
  await notifier.search(query);  // Wait untuk complete!

  final state = ref.read(categoriesProvider);
  return state.categories;  // Return hasil
}
```

### Issue: Load more tidak jalan
- Cek `enableLoadMore: true`
- Cek `suggestionsMaxHeight` cukup besar untuk scroll
- Pastikan ada data lebih dari `initialItemsToShow`

### Issue: Search terlalu cepat/lambat
```dart
debounceMilliseconds: 500,  // Adjust sesuai kebutuhan
```

## Next Steps
- Implementasi untuk model lain (User, Product, etc)
- Custom error handling
- Loading indicators
- Empty state customization
