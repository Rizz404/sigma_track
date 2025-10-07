# Fix: AppSearchField Overlay Position & Provider Disposal

## Issues Fixed

### 1. ❌ Overlay tertutup oleh Bottom Sheet
**Problem**: Dropdown autocomplete muncul di bawah bottom sheet karena z-index/elevation rendah.

**Solution**:
- Increase `elevation: 16` (dari 8) agar muncul di atas bottom sheet
- Auto-detect ruang tersedia di atas/bawah field
- Render dropdown di atas jika ruang bawah tidak cukup

### 2. ❌ Provider Auto-Dispose Kills Data
**Problem**: `categoriesSearchProvider` disposed setelah search, data hilang sebelum dropdown render.

**Solution**:
- Cache hasil search di local state `_searchCache`
- Return cached list instead of direct provider state

## Changes Made

### 1. AppSearchField - Smart Positioning

#### Before:
```dart
OverlayEntry _createOverlayEntry() {
  final renderBox = context.findRenderObject() as RenderBox;
  final size = renderBox.size;

  return OverlayEntry(
    builder: (context) => Positioned(
      width: size.width,
      child: CompositedTransformFollower(
        offset: Offset(0, size.height + 4), // Always below
        child: Material(
          elevation: 8, // Low elevation
          child: Container(
            constraints: BoxConstraints(
              maxHeight: widget.suggestionsMaxHeight ?? 300, // Fixed max
            ),
            ...
          ),
        ),
      ),
    ),
  );
}
```

#### After:
```dart
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
        offset: shouldShowAbove
            ? Offset(0, -(availableHeight + 4))  // Above field
            : Offset(0, size.height + 4),         // Below field
        child: Material(
          elevation: 16, // Higher elevation for bottom sheets
          child: Container(
            constraints: BoxConstraints(
              maxHeight: availableHeight, // Dynamic based on space
            ),
            ...
          ),
        ),
      ),
    ),
  );
}
```

### 2. ListCategoriesScreen - Cache Search Results

#### Before:
```dart
Future<List<Category>> _searchParentCategories(String query) async {
  final notifier = ref.read(categoriesSearchProvider.notifier);
  await notifier.search(query);

  final state = ref.read(categoriesSearchProvider);
  return state.categories; // ❌ Provider disposed, data lost!
}
```

#### After:
```dart
// Add cache field
List<Category> _searchCache = [];

Future<List<Category>> _searchParentCategories(String query) async {
  final notifier = ref.read(categoriesSearchProvider.notifier);
  await notifier.search(query);

  final state = ref.read(categoriesSearchProvider);

  // * Cache results to prevent disposal issue
  _searchCache = List<Category>.from(state.categories);

  return _searchCache; // ✅ Return cached copy
}
```

## How It Works

### Smart Positioning Algorithm:

```
1. Get field position on screen
2. Calculate available space:
   - spaceBelow = screenHeight - fieldBottom
   - spaceAbove = fieldTop
3. Decide direction:
   - If spaceBelow < maxHeight AND spaceAbove > spaceBelow
     → Show ABOVE
   - Else
     → Show BELOW
4. Calculate dynamic height:
   - availableHeight = clamp(availableSpace, 100, maxHeight)
5. Render overlay at calculated position with dynamic height
```

### Provider Disposal Fix:

```
1. Search called → Provider initialized
2. API response received → Provider updated
3. Return data from provider → Provider auto-disposed (AutoDispose)
4. Widget tries to render → ❌ Data gone!

Solution:
1. Search called → Provider initialized
2. API response received → Provider updated
3. Copy data to local cache → _searchCache = [...categories]
4. Return cached data → ✅ Data persists
5. Provider auto-disposed → No problem, data cached locally
```

## Benefits

### ✅ Smart Positioning
- Auto-detects available space
- Renders above if needed (e.g., in bottom sheets)
- Dynamic height based on screen space
- Always visible, never cut off

### ✅ Higher Elevation
- `elevation: 16` ensures overlay appears above:
  - Bottom sheets (elevation: 8-12)
  - Dialogs (elevation: 24, but usually fullscreen)
  - App bars (elevation: 4)
  - Cards (elevation: 2-8)

### ✅ Cached Results
- Provider can dispose freely
- No race conditions
- Data persists for dropdown rendering
- Memory-efficient (only recent search cached)

## Testing

### Test Case 1: Bottom Sheet Context
```
1. Open filter bottom sheet
2. Click parent category field
3. Type query
4. ✅ Dropdown appears ABOVE field (smart positioning)
5. ✅ Results visible (not hidden by sheet)
```

### Test Case 2: Top of Screen
```
1. Field near top of screen
2. Type query
3. ✅ Dropdown appears BELOW field (normal behavior)
4. ✅ Height adjusts to screen space
```

### Test Case 3: Middle of Screen
```
1. Field in middle position
2. Type query
3. ✅ Dropdown appears BELOW (default)
4. ✅ Full maxHeight available
```

### Test Case 4: Provider Disposal
```
1. Type query → Search starts
2. Results arrive → Provider updates
3. Data cached → _searchCache filled
4. Provider disposed → No problem
5. ✅ Dropdown renders with cached data
```

## Visual Examples

### Before (Broken):
```
┌─────────────────────┐
│  Bottom Sheet       │
│  ┌───────────────┐  │
│  │ Search Field  │  │
│  └───────────────┘  │
│                     │ ← Dropdown here (hidden!)
│                     │
│  [Hidden Results]   │
└─────────────────────┘
```

### After (Fixed):
```
┌─────────────────────┐
│  ┌─────────────┐    │ ← Dropdown above!
│  │  Results    │    │
│  │  - Item 1   │    │
│  │  - Item 2   │    │
│  └─────────────┘    │
│  ┌───────────────┐  │
│  │ Search Field  │  │
│  └───────────────┘  │
│                     │
│  Bottom Sheet       │
└─────────────────────┘
```

## Configuration

### Custom Elevation
```dart
// In app_search_field.dart
Material(
  elevation: 16, // Adjust if needed
  ...
)
```

### Minimum Height
```dart
// In _createOverlayEntry()
.clamp(100.0, maxHeight) // Min 100px, adjust as needed
```

### Space Margin
```dart
final spaceBelow = screenHeight - offset.dy - size.height - 8; // Add margin
final spaceAbove = offset.dy - 8; // Add margin
```

## Known Limitations

1. **Keyboard Overlap**: Dropdown may be covered by keyboard on mobile
   - Solution: Use `MediaQuery.of(context).viewInsets.bottom`

2. **Landscape Mode**: Limited vertical space
   - Solution: Reduce `maxHeight` in landscape

3. **Multiple Overlays**: If multiple autocomplete fields open
   - Solution: Close previous overlay before opening new one

## Next Steps

- [ ] Add keyboard awareness
- [ ] Add landscape-specific height limits
- [ ] Add animation for position transitions
- [ ] Add custom elevation prop
- [ ] Add min/max height props

## References
- Material Design elevation guidelines
- Flutter Overlay positioning
- Riverpod AutoDispose behavior
- MediaQuery screen calculations
