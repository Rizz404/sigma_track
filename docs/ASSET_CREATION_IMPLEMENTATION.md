# Asset Creation Implementation Guide

## Overview

Dokumentasi ini menjelaskan implementasi UI untuk 4 alur pembuatan asset sesuai dengan [alur-asset-creation.md](../alur-asset-creation.md).

**Status Implementasi:**
- ✅ Alur 1: Single asset dengan upload images (2 requests)
- ✅ Alur 2: Single asset dengan reuse images (1 request) - **IMPLEMENTED**
- ✅ Alur 3: Bulk create dengan upload images (4 requests)
- ✅ Alur 4: Bulk create dengan reuse images (3 requests) - **IMPLEMENTED**

---

## 🎯 Alur 1: Single Asset dengan Upload Images

### API Flow
1. `POST /assets` - Create asset + upload data matrix
2. `POST /assets/upload/bulk-images` - Upload asset images (optional)

### UI Implementation Status: ✅ Complete

**Location:** `AssetUpsertScreen._handleSubmit()`

```dart
// Disable reuse mode, select local files
_enableReuseImages = false;
await _pickAssetImages(); // Select files from device

// On submit:
// 1. Upload template images
// 2. Create asset with imageUrls
```

---

## 🎯 Alur 2: Single Asset dengan Reuse Images

### API Flow
1. `GET /assets/images` - Fetch available images (automatic via provider)
2. `POST /assets` - Create asset dengan imageUrls

### UI Implementation Status: ✅ Complete

**Location:** `AssetUpsertScreen._buildAssetImagesSection()`

**Features Implemented:**
1. ✅ Toggle switch untuk enable reuse mode
2. ✅ Available images picker dialog dengan grid layout
3. ✅ Multi-select dengan visual feedback
4. ✅ Infinite scroll pagination
5. ✅ Error handling & retry
6. ✅ Empty state handling

**Code Flow:**
```dart
// 1. Enable reuse mode
setState(() => _enableReuseImages = true);

// 2. Show available images picker
await _showAvailableImagesPicker();
// -> Opens _AvailableImagesPickerDialog
// -> User selects images from grid
// -> Returns List<String> imageUrls

// 3. On submit:
if (!_isEdit && _selectedImagePaths.isNotEmpty && !_enableReuseImages) {
  // Upload new images (Alur 1)
} else {
  // Use _uploadedTemplateImageUrls (Alur 2)
}

final params = CreateAssetUsecaseParams(
  imageUrls: _uploadedTemplateImageUrls.isNotEmpty
      ? _uploadedTemplateImageUrls
      : null,
);
```

---

## 🎯 Alur 3: Bulk Create dengan Upload Files

### API Flow
1. `POST /assets/upload/template-images` - Upload shared images
2. `POST /assets/generate-bulk-tags` - Generate tags
3. `POST /assets/upload/bulk-datamatrix` - Upload QR codes
4. `POST /assets/bulk` - Create multiple assets

### UI Implementation Status: ✅ Complete

**Location:** `AssetUpsertScreen._handleBulkCopy()`

**Features:**
- Progress tracking dengan percentage
- Data matrix generation per tag
- Template image upload untuk semua asset
- Bulk create dengan shared imageUrls

---

## 🎯 Alur 4: Bulk Create dengan Reuse Images

### API Flow
1. `GET /assets/images` - Fetch available images (via provider)
2. `POST /assets/generate-bulk-tags` - Generate tags
3. `POST /assets/upload/bulk-datamatrix` - Upload QR codes
4. `POST /assets/bulk` - Create assets dengan existing imageUrls

### UI Implementation Status: ✅ Complete

**Location:** `AssetUpsertScreen._handleBulkCopy()`

**Features Implemented:**
1. ✅ Reuse mode toggle di bulk section
2. ✅ Available images picker integration
3. ✅ Skip template upload when reuse enabled
4. ✅ Shared imageUrls for all bulk assets

**Code Flow:**
```dart
// In _handleBulkCopy():

// Step 2: Upload OR reuse images
if (_enableReuseImages && _uploadedTemplateImageUrls.isNotEmpty) {
  // Alur 4: Reuse existing images (skip upload)
  this.logPresentation('Using ${_uploadedTemplateImageUrls.length} reused images');
} else if (_selectedImagePaths.isNotEmpty) {
  // Alur 3: Upload new template images
  await uploadNotifier.uploadImages(_selectedImagePaths);
  _uploadedTemplateImageUrls = uploadState.data!.imageUrls;
}

// Step 4: Create assets with shared imageUrls
final assetParams = tags.map((tag) {
  return CreateAssetUsecaseParams(
    assetTag: tag,
    imageUrls: _uploadedTemplateImageUrls.isNotEmpty
        ? _uploadedTemplateImageUrls // SAME for all
        : null,
  );
}).toList();
```

---

## 📋 Components Implemented

### 1. State Variables

```dart
class _AssetUpsertScreenState {
  List<String> _selectedImagePaths = [];        // Local file paths
  List<String> _uploadedTemplateImageUrls = []; // URLs from pool/upload
  bool _enableReuseImages = false;              // Toggle reuse mode
}
```

### 2. Available Images Picker Dialog

**Widget:** `_AvailableImagesPickerDialog`

**Features:**
- Grid layout (4 columns)
- Infinite scroll dengan `ScrollController`
- Loading states (initial, loadMore)
- Error handling dengan retry
- Empty state
- Multi-select dengan visual overlay
- Selected count badge

**Provider Integration:**
```dart
final state = ref.watch(availableAssetImagesProvider);

// Load more on scroll
_scrollController.addListener(() {
  if (_scrollController.position.pixels >= maxScrollExtent - 200) {
    ref.read(availableAssetImagesProvider.notifier).loadMore();
  }
});
```

### 3. Image Tile Widget

**Widget:** `_ImageTile`

**Features:**
- Network image loading dengan error handling
- Loading progress indicator
- Selection overlay dengan checkmark
- Border color changes when selected
- Tap to toggle selection

---

## 🔄 Provider Flow

### availableAssetImagesProvider

**Type:** `AutoDisposeNotifierProvider`

**State:** `AvailableAssetImagesState`
- `List<ImageResponse> images`
- `bool isLoading`
- `bool isLoadingMore`
- `Cursor? cursor`
- `Failure? failure`

**Methods:**
- `build()` - Auto-initialize & load first page
- `loadMore()` - Cursor-based pagination
- `refresh()` - Reload from start

**Usage:**
```dart
// Watch state
final state = ref.watch(availableAssetImagesProvider);

// Load more
ref.read(availableAssetImagesProvider.notifier).loadMore();

// Refresh
ref.read(availableAssetImagesProvider.notifier).refresh();
```

---

## 🎨 UI/UX Features

### Reuse Mode Toggle

**Location:** `_buildAssetImagesSection()`

```dart
SwitchListTile(
  title: AppText('Reuse Existing Images'),
  subtitle: AppText('Use images already uploaded to the system'),
  value: _enableReuseImages,
  onChanged: (value) {
    setState(() {
      _enableReuseImages = value;
      if (value) {
        _selectedImagePaths.clear();
      } else {
        _uploadedTemplateImageUrls.clear();
      }
    });
  },
)
```

### Dynamic Button Text

```dart
AppButton(
  text: _enableReuseImages
      ? (_uploadedTemplateImageUrls.isEmpty
          ? 'Select from Available Images'
          : 'Images Selected (${_uploadedTemplateImageUrls.length})')
      : (_selectedImagePaths.isEmpty
          ? context.l10n.assetSelectImages
          : context.l10n.assetImagesSelected(_selectedImagePaths.length)),
  onPressed: _enableReuseImages
      ? _showAvailableImagesPicker
      : _pickAssetImages,
)
```

---

## 🔑 Key Implementation Details

### 1. Conditional Upload Logic

```dart
// Only upload if NOT in reuse mode
if (!_isEdit && _selectedImagePaths.isNotEmpty && !_enableReuseImages) {
  await uploadNotifier.uploadImages(_selectedImagePaths);
  _uploadedTemplateImageUrls = uploadState.data!.imageUrls;
}
```

### 2. Bulk Copy Reuse Logic

```dart
if (_enableReuseImages && _uploadedTemplateImageUrls.isNotEmpty) {
  // Skip upload, use existing URLs
} else if (_selectedImagePaths.isNotEmpty) {
  // Upload new template images
}
```

### 3. Image Selection State Management

```dart
void _toggleSelection(String imageUrl) {
  setState(() {
    if (_selectedUrls.contains(imageUrl)) {
      _selectedUrls.remove(imageUrl);
    } else {
      _selectedUrls.add(imageUrl);
    }
  });
}
```

### 4. Pagination Trigger

```dart
_scrollController.addListener(() {
  if (_scrollController.position.pixels >=
      _scrollController.position.maxScrollExtent - 200) {
    ref.read(availableAssetImagesProvider.notifier).loadMore();
  }
});
```

---

## ✅ Testing Checklist

### Alur 2 - Single Reuse
- [x] Toggle reuse mode ON
- [x] Click "Select from Available Images"
- [x] See grid of available images
- [x] Select 3 images
- [x] Verify selection overlay & count
- [x] Submit form
- [x] Verify imageUrls sent to API

### Alur 4 - Bulk Reuse
- [x] Enable bulk copy mode
- [x] Toggle reuse images ON
- [x] Select template images from pool
- [x] Generate 10 tags
- [x] Verify all 10 assets share same imageUrls

### Edge Cases
- [x] Empty image pool - Show empty state
- [x] Network error - Show error with retry
- [x] Pagination - Load more on scroll
- [x] Switch between upload/reuse - Clear opposite state

---

## 📊 Performance Benefits

### Storage Efficiency

**Alur 1 (Upload per asset):**
- 100 assets × 3 images = 300 image files
- Storage: ~300 MB (assuming 1MB per image)

**Alur 3 (Upload template):**
- 100 assets × 3 shared images = 3 image files
- Storage: ~3 MB
- **Savings: 99%**

**Alur 4 (Reuse existing):**
- 100 assets × 3 existing images = 0 new files
- Upload time: 0 seconds
- **Maximum efficiency**

### Network Efficiency

**Upload time comparison (assuming 5 Mbps upload):**
- Alur 1: 300 files × 1 MB = 300 MB ≈ **8 minutes**
- Alur 3: 3 files × 1 MB = 3 MB ≈ **5 seconds**
- Alur 4: 0 files = **instant**

---

## 🚀 Future Improvements

### Potential Enhancements
- [ ] Image search/filter by upload date
- [ ] Image preview (full-size) on click
- [ ] Batch delete unused images
- [ ] Image metadata display (size, dimensions)
- [ ] Recently used images section
- [ ] Image categorization by asset type
- [ ] Lazy loading with placeholder
- [ ] Image compression before upload

### Performance Optimizations
- [ ] Implement image CDN caching
- [ ] Add virtual scrolling for 1000+ images
- [ ] Preload next page images
- [ ] Debounce scroll events

**Provider Setup:**
```dart
final availableAssetImagesProvider =
    AutoDisposeNotifierProvider<AvailableAssetImagesNotifier, AvailableAssetImagesState>(
  AvailableAssetImagesNotifier.new,
);
```

**UI Flow:**
```dart
// 1. Show image picker dialog
void _showAvailableImagesPicker() {
  showDialog(
    context: context,
    builder: (context) => AvailableImagesPickerDialog(
      onImagesSelected: (selectedUrls) {
        setState(() {
          _uploadedTemplateImageUrls = selectedUrls;
        });
      },
    ),
  );
}

// 2. Create asset with selected image URLs
void _handleSubmit() async {
  await _generateDataMatrix(assetTag);

  final params = CreateAssetUsecaseParams(
    assetTag: assetTag,
    assetName: assetName,
    categoryId: categoryId,
    dataMatrixImageUrl: dataMatrixUrl, // Generated data matrix
    imageUrls: _uploadedTemplateImageUrls, // Selected from available images
  );

  ref.read(assetsProvider.notifier).createAsset(params);
}
```

**Available Images Picker Dialog:**
```dart
class AvailableImagesPickerDialog extends ConsumerStatefulWidget {
  final Function(List<String>) onImagesSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(availableAssetImagesProvider);
    final notifier = ref.read(availableAssetImagesProvider.notifier);

    return AlertDialog(
      title: Text('Select Images'),
      content: SizedBox(
        width: 600,
        height: 400,
        child: state.isLoading
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: state.images.length,
                itemBuilder: (context, index) {
                  final image = state.images[index];
                  return _ImageTile(
                    imageUrl: image.imageUrl,
                    isSelected: _selectedUrls.contains(image.imageUrl),
                    onTap: () => _toggleSelection(image.imageUrl),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onImagesSelected(_selectedUrls);
            Navigator.pop(context);
          },
          child: Text('Select (${_selectedUrls.length})'),
        ),
      ],
    );
  }

  // Load more on scroll
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(availableAssetImagesProvider.notifier).loadMore();
      }
    });
  }
}
```

---

## 🎯 Alur 3: Bulk Create dengan Upload Files

### API Flow
1. `POST /assets/upload/template-images` - Upload shared images
2. `POST /assets/generate-bulk-tags` - Generate tags
3. `POST /assets/upload/bulk-datamatrix` - Upload QR codes
4. `POST /assets/bulk` - Create multiple assets

### UI Implementation

```dart
Future<void> _handleBulkCopy() async {
  try {
    // Step 1: Generate bulk tags
    final tagsNotifier = ref.read(generateBulkAssetTagsNotifierProvider.notifier);
    await tagsNotifier.generateTags(categoryId, quantity);

    final tagsState = ref.read(generateBulkAssetTagsNotifierProvider);
    final tags = tagsState.data!.tags;

    // Step 2: Upload template images (if selected)
    List<String> templateImageUrls = [];
    if (_selectedImagePaths.isNotEmpty) {
      final uploadNotifier = ref.read(uploadTemplateImagesProvider.notifier);
      await uploadNotifier.uploadImages(
        _selectedImagePaths.map((p) => File(p)).toList()
      );

      final uploadState = ref.read(uploadTemplateImagesProvider);
      templateImageUrls = uploadState.data!.imageUrls;
    }

    // Step 3: Generate & upload data matrix
    final dataMatrixFiles = <File>[];
    for (final tag in tags) {
      final file = await _generateDataMatrixFile(tag);
      dataMatrixFiles.add(file);
    }

    final dmNotifier = ref.read(uploadBulkDataMatrixNotifierProvider.notifier);
    await dmNotifier.uploadImages(
      files: dataMatrixFiles,
      assetTags: tags,
    );

    final dmState = ref.read(uploadBulkDataMatrixNotifierProvider);
    final dataMatrixUrls = dmState.data!.urls;

    // Step 4: Bulk create assets
    final assets = List.generate(quantity, (i) {
      return CreateAssetDto(
        assetTag: tags[i],
        assetName: '$assetName #${i + 1}',
        categoryId: categoryId,
        dataMatrixImageUrl: dataMatrixUrls[i],
        imageUrls: templateImageUrls, // SAME for all assets
        serialNumber: bulkSerialNumbers?[i],
        // ... other fields
      );
    });

    final params = BulkCreateAssetsParams(assets: assets);
    ref.read(assetsProvider.notifier).createManyAssets(params);

  } catch (e) {
    AppToast.error('Bulk create failed: $e');
  }
}
```

---

## 🎯 Alur 4: Bulk Create dengan Reuse Images

### API Flow
1. `GET /assets/images` - Fetch available images
2. `POST /assets/generate-bulk-tags` - Generate tags
3. `POST /assets/upload/bulk-datamatrix` - Upload QR codes
4. `POST /assets/bulk` - Create assets dengan existing imageUrls

### UI Implementation

**Combined Flow:**
```dart
Future<void> _handleBulkCopyWithReuseImages() async {
  try {
    // Step 1: Generate bulk tags (same as Alur 3)
    final tagsNotifier = ref.read(generateBulkAssetTagsNotifierProvider.notifier);
    await tagsNotifier.generateTags(categoryId, quantity);

    final tagsState = ref.read(generateBulkAssetTagsNotifierProvider);
    final tags = tagsState.data!.tags;

    // Step 2: Select template images from available images
    List<String> templateImageUrls = [];

    if (_enableReuseImages) {
      // Use selected URLs from available images picker
      templateImageUrls = _uploadedTemplateImageUrls;
    } else {
      // Upload new images (Alur 3)
      final uploadNotifier = ref.read(uploadTemplateImagesProvider.notifier);
      await uploadNotifier.uploadImages(
        _selectedImagePaths.map((p) => File(p)).toList()
      );

      final uploadState = ref.read(uploadTemplateImagesProvider);
      templateImageUrls = uploadState.data!.imageUrls;
    }

    // Step 3 & 4: Same as Alur 3
    // Generate data matrix -> Upload -> Bulk create

  } catch (e) {
    AppToast.error('Bulk create failed: $e');
  }
}
```

**UI Toggle:**
```dart
// In _buildBulkCopySection()
SwitchListTile(
  title: Text('Reuse Existing Images'),
  subtitle: Text('Use images already uploaded to the system'),
  value: _enableReuseImages,
  onChanged: (value) {
    setState(() {
      _enableReuseImages = value;
      if (value) {
        _selectedImagePaths.clear(); // Clear file selection
      } else {
        _uploadedTemplateImageUrls.clear(); // Clear URL selection
      }
    });
  },
),

if (_enableReuseImages)
  // Show available images picker button
  AppButton.secondary(
    text: 'Select from Available Images',
    onPressed: _showAvailableImagesPicker,
  )
else
  // Show file picker button
  AppButton.secondary(
    text: 'Pick Images from Device',
    onPressed: _pickAssetImages,
  ),
```

---

## 📋 Provider Dependencies

### Available Asset Images (Alur 2 & 4)

**Notifier:**
```dart
class AvailableAssetImagesNotifier extends AutoDisposeNotifier<AvailableAssetImagesState> {
  @override
  AvailableAssetImagesState build() {
    _initializeImages();
    return AvailableAssetImagesState.initial();
  }

  Future<void> loadMore() async {
    // Cursor-based pagination
    if (state.cursor == null || !state.cursor!.hasNextPage) return;

    final filter = GetAvailableAssetImagesCursorUsecaseParams(
      cursor: state.cursor?.nextCursor,
    );

    final result = await _getAvailableAssetImagesUsecase(filter);
    // ... handle result
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    state = await _loadImages(
      filter: const GetAvailableAssetImagesCursorUsecaseParams(),
    );
  }
}
```

**State:**
```dart
class AvailableAssetImagesState extends Equatable {
  final List<ImageResponse> images;
  final bool isLoading;
  final bool isLoadingMore;
  final Failure? failure;
  final Cursor? cursor;

  factory AvailableAssetImagesState.initial() =>
      const AvailableAssetImagesState(isLoading: true);

  factory AvailableAssetImagesState.success({
    required List<ImageResponse> images,
    required Cursor cursor,
  }) => AvailableAssetImagesState(images: images, cursor: cursor);

  factory AvailableAssetImagesState.loadingMore({
    required List<ImageResponse> currentImages,
    required Cursor cursor,
  }) => AvailableAssetImagesState(
        images: currentImages,
        isLoadingMore: true,
        cursor: cursor,
      );
}
```

---

## 🔑 Key Points

### 1. **Image Selection Strategy**

- **Alur 1**: Upload langsung ke asset (2 requests)
- **Alur 2**: Pilih dari pool → 1 request
- **Alur 3**: Upload template dulu → attach ke semua
- **Alur 4**: Pilih dari pool → attach ke semua

### 2. **Provider Usage**

```dart
// Single create with new images (Alur 1)
uploadTemplateImagesProvider → createAsset → uploadBulkImages

// Single create with reuse (Alur 2)
availableAssetImagesProvider → createAsset (with imageUrls)

// Bulk create with new images (Alur 3)
uploadTemplateImagesProvider → generateBulkTags → uploadBulkDataMatrix → bulkCreate

// Bulk create with reuse (Alur 4)
availableAssetImagesProvider → generateBulkTags → uploadBulkDataMatrix → bulkCreate
```

### 3. **State Management**

- `availableAssetImagesProvider`: Auto-dispose, cursor pagination
- `uploadTemplateImagesProvider`: Non-auto-dispose (invalidate after create)
- `uploadBulkDataMatrixNotifierProvider`: Non-auto-dispose (invalidate after create)
- `generateBulkAssetTagsNotifierProvider`: Non-auto-dispose (invalidate after create)

### 4. **Performance Optimization**

- **Lazy loading**: Load 20 images per page
- **Image caching**: Cloudinary URLs with CDN
- **Reuse benefits**:
  - 100 assets × 3 images = 300 junction records
  - Storage: Only 3 actual images!

### 5. **UI/UX Considerations**

- Show image preview before selection
- Display selected count badge
- Enable multi-select with checkboxes
- Infinite scroll for large image pools
- Search/filter by upload date
- Show image dimensions & size

---

## 📝 TODO Implementations

### Required UI Components

- [ ] `AvailableImagesPickerDialog` - Modal for selecting images
- [ ] `ImageTile` - Grid item with selection state
- [ ] `ImagePreviewDialog` - Full-size image preview
- [ ] Toggle switch untuk "Reuse Images" mode
- [ ] Badge counter untuk selected images
- [ ] Search bar untuk filter images

### Provider Integration

- [x] `AvailableAssetImagesNotifier` - Fetch & paginate
- [x] `AvailableAssetImagesState` - State management
- [ ] Wire up to `AssetUpsertScreen`
- [ ] Handle image selection state
- [ ] Integrate with create/bulk create flows

### Error Handling

- [ ] Network error saat fetch images
- [ ] Invalid image URL
- [ ] Empty image pool
- [ ] Selection validation (min/max images)

---

## 🧪 Testing Scenarios

1. **Alur 2 - Reuse Single**
   - Open create asset form
   - Click "Select from Available Images"
   - Select 3 images from grid
   - Verify preview shows selected images
   - Submit → Check imageUrls sent to API

2. **Alur 4 - Reuse Bulk**
   - Enable bulk copy mode
   - Toggle "Reuse Images" ON
   - Select template images from pool
   - Generate 50 tags
   - Verify all 50 assets share same imageUrls

3. **Pagination**
   - Fetch 20 images
   - Scroll to bottom
   - Verify loadMore called
   - Check next 20 images appended

4. **Edge Cases**
   - Empty image pool
   - Only 1 image available
   - Network timeout
   - Invalid cursor
