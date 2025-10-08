# AppSearchField - Improved Version

## Perubahan Utama

### 1. Default Item Design
- `AppSearchField` sekarang memiliki design bawaan untuk list items
- Tampilan default: icon + title + subtitle (opsional)
- Design konsisten dengan surfaceVariant background

### 2. Display Text vs Value
- Field menampilkan `displayText` tapi menyimpan `value` (biasanya ID)
- Tidak perlu widget konfirmasi terpisah lagi
- `initialDisplayText` untuk menampilkan text awal saat edit mode

## Property Baru

```dart
AppSearchField<T>(
  // ... property existing ...

  // New properties:
  itemSubtitleMapper: (item) => item.code,  // Subtitle untuk default design
  itemIcon: Icons.category,                  // Icon untuk default design
  initialDisplayText: 'Category Name',       // Display text saat init (edit mode)
)
```

## Contoh Penggunaan

### Sebelum (Complex)
```dart
// Perlu widget terpisah untuk konfirmasi
if (_selectedCategory != null) ...[
  Container(...selected category display...),
],
AppSearchField<Category>(
  itemBuilder: (context, category) {
    return Container(...custom design...);
  },
  onItemSelected: (category) => setState(...),
),
```

### Sesudah (Simple)
```dart
AppSearchField<Category>(
  name: 'categoryId',
  initialValue: asset?.categoryId,
  initialDisplayText: asset?.category?.categoryName,  // Display name
  enableAutocomplete: true,
  onSearch: _searchCategories,
  itemDisplayMapper: (category) => category.categoryName,  // Display
  itemValueMapper: (category) => category.id,              // Value
  itemSubtitleMapper: (category) => category.categoryCode, // Subtitle
  itemIcon: Icons.category,
)
```

## Behavior

### Display vs Value
- **Display**: Text yang tampil di **chip indicator** di bawah field
- **Value**: Data yang disimpan di form (ID category, location, dll)
- **TextField**: Tetap untuk search, tidak menyimpan display text

### User Interaction
1. **Mengetik manual**: User mengetik untuk search → suggestions muncul
2. **Select item**: User pilih item → chip indicator muncul dengan nama item, form value = ID
3. **Clear chip**: User klik X pada chip → chip hilang, form value dikosongkan
4. **Clear field**: User klik X di field → hanya clear text search, tidak affect chip/value

### Example Flow
```
User ketik: "Elect"
  ↓
TextField: "Elect"
Chip: (tidak ada)
Form value: "" (empty)
  ↓
Suggestions muncul: "Electronics", "Electrical"
  ↓
User pilih: "Electronics" (id: "cat-123")
  ↓
TextField: "Elect" (tetap)
Chip: ✓ Electronics [X]
Form value: "cat-123" (ID)
  ↓
User klik [X] pada chip
  ↓
TextField: "Elect" (tetap)
Chip: (hilang)
Form value: "" (cleared)
  ↓
Submit → Backend terima ID: "cat-123" ✅
```

## Benefits

✅ Kode lebih simple & clean
✅ Konsistensi design otomatis
✅ Tidak perlu widget konfirmasi terpisah
✅ Display text & value terpisah otomatis
✅ Form value selalu ID (tidak pernah display text)
✅ User harus select item dari list (tidak bisa submit manual input)
✅ Custom itemBuilder masih bisa digunakan jika perlu

## Implementation Details

### State Management
```dart
String? _displayText;  // Text yang ditampilkan di field
TextEditingController _textController;  // Controller untuk TextField

// Saat user mengetik manual
_onTextChanged(value) {
  if (value != _displayText) {
    _fieldKey.currentState?.didChange('');  // Clear form value
  }
  _debounceSearch(value);  // Trigger search
}

// Saat user select item
_onItemTapped(item) {
  _displayText = itemDisplayMapper(item);  // "Electronics"
  _textController.text = _displayText;
  _fieldKey.currentState?.didChange(itemValueMapper(item));  // "cat-123"
}
```

## Migration Guide

### Files Updated
- ✅ `app_search_field.dart` - Widget utama
- ✅ `asset_upsert_screen.dart` - Simplified, hapus selected widget
- ✅ `category_upsert_screen.dart` - Gunakan new properties
- ✅ `list_categories_screen.dart` - Gunakan new properties

### Breaking Changes
- `const AppSearchField()` → `AppSearchField()` (non-const karena controller)
- Hapus manual selected item display widgets
- Gunakan `initialDisplayText` untuk edit mode
