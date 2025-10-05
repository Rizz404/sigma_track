## AppDropdownSearch Usage Example

Widget reusable untuk dropdown dengan fitur **search**.

### ⚠️ Important Requirements

1. **`compareFn` wajib diisi** untuk tipe data non-primitive (bukan String/int/double)
2. **`asyncItems`** menerima 1 parameter: `(search)` untuk filtering
3. **Infinite scroll TIDAK supported** - dropdown_search tidak bisa pakai `infiniteScrollProps` + `showSearchBox` bersamaan

### Basic Usage

```dart
AppDropdownSearch<Category>(
  name: 'parentId',
  label: 'Select Parent Category',
  hintText: 'Search category...',
  asyncItems: (search) async {
    // * Load data based on search query
    await ref.read(categoriesSearchProvider.notifier).search(search);
    return ref.read(categoriesSearchProvider).categories;
  },
  itemAsString: (category) => category.categoryName,
  compareFn: (item1, item2) => item1.id == item2.id, // * WAJIB!
  onChanged: (category) {
    print('Selected: ${category?.categoryName}');
  },
)
```

### With Custom Item Builder

```dart
AppDropdownSearch<Category>(
  name: 'category',
  asyncItems: (search) async {
    // * Return filtered data
    return await loadCategories(search);
  },
  itemAsString: (category) => category.categoryName,
  compareFn: (item1, item2) => item1.id == item2.id,
  itemBuilder: (context, category, isDisabled, isSelected) {
    return ListTile(
      selected: isSelected,
      leading: Icon(Icons.category),
      title: Text(category.categoryName),
      subtitle: Text(category.categoryCode),
    );
  },
)
```

### With Validation

```dart
AppDropdownSearch<Category>(
  name: 'category',
  validator: (value) {
    if (value == null) return 'Category is required';
    return null;
  },
  asyncItems: (search) => loadCategories(search),
  itemAsString: (category) => category.categoryName,
  compareFn: (item1, item2) => item1.id == item2.id,
)
```

### Features

- ✅ **Search functionality** dengan debounce
- ✅ **Form builder integration**
- ✅ **Custom validation**
- ✅ **Loading & empty states**
- ✅ **Clear button**
- ✅ **Custom item builder**
- ✅ **Error handling**
- ✅ Consistent theme dengan app widgets lainnya
- ❌ **Infinite scroll** - tidak supported (conflict dengan search box)

### Integration with Riverpod

Gunakan provider **terpisah** untuk dropdown search agar data tidak bercampur:

```dart
// Provider untuk list utama
final categoriesProvider =
  AutoDisposeNotifierProvider<CategoriesNotifier, CategoriesState>(...);

// Provider terpisah untuk dropdown search
final categoriesSearchProvider =
  AutoDisposeNotifierProvider<CategoriesNotifier, CategoriesState>(...);
```

**Keuntungan:**
- Data dropdown tidak mempengaruhi list utama
- Filter independen untuk setiap use case
- State management lebih bersih
- Bisa reuse notifier & state yang sama

### 📋 How It Works with Backend Cursor Pagination

Widget ini **tidak handle pagination** karena dropdown_search limitation (cannot use infiniteScrollProps + showSearchBox together).

**Backend behavior:**
- Backend pakai **cursor pagination** (`loadMore()` di notifier)
- Dropdown search **hanya return data yang sudah di-load**
- User harus **scroll list utama** dulu untuk load more data
- Dropdown akan show semua data yang sudah ada di state

**Alternative untuk banyak data:**
1. Limit data dropdown (e.g. top 50 items)
2. User type untuk filter (search)
3. Use separate search provider

### Common Errors

**Error 1: `compareFn` is required**
```dart
// ❌ SALAH - tidak ada compareFn
AppDropdownSearch<Category>(
  asyncItems: (s) => load(),
  itemAsString: (c) => c.name,
)

// ✅ BENAR - dengan compareFn
AppDropdownSearch<Category>(
  asyncItems: (s) => load(),
  itemAsString: (c) => c.name,
  compareFn: (i1, i2) => i1.id == i2.id, // * Required!
)
```

**Error 2: `infiniteScrollProps == null || disableFilter`**
```dart
// ❌ SALAH - tidak bisa pakai infiniteScrollProps + showSearchBox
popupProps: PopupProps.menu(
  showSearchBox: true,
  infiniteScrollProps: InfiniteScrollProps(...), // Conflict!
)

// ✅ BENAR - pilih salah satu
popupProps: PopupProps.menu(
  showSearchBox: true, // Tanpa infinite scroll
)
```
