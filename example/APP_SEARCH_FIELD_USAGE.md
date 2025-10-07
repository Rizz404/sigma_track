# AppSearchField - Usage Guide

## Overview
`AppSearchField` mendukung 2 mode:
1. **Live/Submit Search** - Search biasa tanpa suggestions
2. **Autocomplete/Suggestion Search** - Search dengan dropdown suggestions, load more, dan custom item builder

## Features Autocomplete
✅ Autocomplete dropdown with overlay
✅ Custom item builder
✅ Separate value & display text (e.g., value=id, display=name)
✅ Lazy loading dengan scroll (load more)
✅ Debounce search
✅ Loading indicator
✅ Custom max height & padding

## Props

### Basic Props
- `name` - Form field name (required)
- `hintText` - Placeholder text
- `label` - Label text
- `initialValue` - Initial value
- `onChanged` - Callback saat text berubah
- `onClear` - Callback saat clear button ditekan
- `controller` - TextEditingController
- `validator` - Validation function
- `enabled` - Enable/disable field
- `showClearButton` - Show/hide clear button

### Autocomplete Props
- `enableAutocomplete` - Enable/disable autocomplete mode (default: false)
- `onSearch` - Function untuk fetch data (required jika enableAutocomplete=true)
- `itemBuilder` - Custom widget builder untuk setiap item
- `itemValueMapper` - Function untuk mapping item ke value (e.g., user → user.id)
- `itemDisplayMapper` - Function untuk mapping item ke display text (e.g., user → user.name)
- `onItemSelected` - Callback saat item dipilih
- `initialItemsToShow` - Jumlah item awal yang ditampilkan (default: 5)
- `itemsPerLoadMore` - Jumlah item per load more (default: 5)
- `enableLoadMore` - Enable/disable load more (default: true)
- `suggestionsMaxHeight` - Max height dropdown (default: 300)
- `suggestionsPadding` - Padding dropdown
- `debounceMilliseconds` - Debounce delay (default: 300ms)

## Usage Examples

### 1. Basic Live Search
```dart
AppSearchField(
  name: 'search',
  hintText: 'Search...',
  onChanged: (value) => print('Search: $value'),
)
```

### 2. Autocomplete with Default Style
```dart
AppSearchField<User>(
  name: 'user_search',
  enableAutocomplete: true,
  onSearch: (query) => userRepository.search(query),
  itemDisplayMapper: (user) => user.name,
  itemValueMapper: (user) => user.id,
  onItemSelected: (user) => print('Selected: ${user.name}'),
)
```

### 3. Autocomplete with Custom Item Builder
```dart
AppSearchField<User>(
  name: 'user_search',
  enableAutocomplete: true,
  onSearch: (query) => userRepository.search(query),
  itemBuilder: (context, user) {
    return ListTile(
      leading: CircleAvatar(child: Text(user.name[0])),
      title: Text(user.name),
      subtitle: Text(user.email),
    );
  },
  itemValueMapper: (user) => user.id,
  onItemSelected: (user) => handleSelection(user),
  initialItemsToShow: 5,
  itemsPerLoadMore: 5,
  enableLoadMore: true,
)
```

### 4. Autocomplete without Load More
```dart
AppSearchField<Product>(
  name: 'product_search',
  enableAutocomplete: true,
  onSearch: (query) => productService.search(query),
  itemDisplayMapper: (product) => product.name,
  itemValueMapper: (product) => product.id,
  enableLoadMore: false,
  initialItemsToShow: 10,
)
```

## How It Works

### Autocomplete Flow:
1. User mengetik → debounce timer dimulai
2. Setelah debounce → `onSearch` dipanggil
3. Results diterima → tampilkan `initialItemsToShow` items
4. User scroll ke bawah → load `itemsPerLoadMore` items
5. User klik item → `itemValueMapper` dipanggil untuk dapat value
6. Value diset ke field → `onItemSelected` & `onChanged` dipanggil

### Value vs Display:
- **itemValueMapper**: Menentukan value yang akan diset ke form field (e.g., user.id)
- **itemDisplayMapper**: Menentukan text yang tampil di dropdown (e.g., user.name)
- Saat item dipilih, field akan berisi **value**, tapi user melihat **display text**

## Notes
- `onSearch` wajib ada jika `enableAutocomplete: true`
- Default item builder menampilkan result dari `itemDisplayMapper` atau `toString()`
- Load more otomatis trigger saat scroll mendekati bottom (50px threshold)
- Clear button menghilangkan suggestions dan reset field
- Suggestions auto-hide saat focus hilang atau field kosher

Lihat `example/app_search_field_example.dart` untuk contoh lengkap!
