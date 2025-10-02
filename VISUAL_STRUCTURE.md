# Visual Structure Diagram

## UserShell Structure

### Screen DENGAN Bottom Navigation (3 screen utama):
```
┌─────────────────────────────────────────────────────────┐
│                    UserShell Widget                     │
│  ┌───────────────────────────────────────────────────┐  │
│  │              Scaffold (dari UserShell)            │  │
│  │  ┌─────────────────────────────────────────────┐  │  │
│  │  │          body: HomeScreen Widget           │  │  │
│  │  │  ┌───────────────────────────────────────┐  │  │  │
│  │  │  │    Scaffold (dari HomeScreen)         │  │  │  │
│  │  │  │  ┌─────────────────────────────────┐  │  │  │  │
│  │  │  │  │  AppBar: "Home"                 │  │  │  │  │
│  │  │  │  └─────────────────────────────────┘  │  │  │  │
│  │  │  │  ┌─────────────────────────────────┐  │  │  │  │
│  │  │  │  │  Body: Your Content             │  │  │  │  │
│  │  │  │  │  - Widgets                      │  │  │  │  │
│  │  │  │  │  - Lists                        │  │  │  │  │
│  │  │  │  │  - Buttons                      │  │  │  │  │
│  │  │  │  └─────────────────────────────────┘  │  │  │  │
│  │  │  └───────────────────────────────────────┘  │  │  │
│  │  └─────────────────────────────────────────────┘  │  │
│  │  ┌─────────────────────────────────────────────┐  │  │
│  │  │  bottomNavigationBar: NavigationBar        │  │  │
│  │  │  ┏━━━━━━━┳━━━━━━━━━━━━┳━━━━━━━━━┓          │  │  │
│  │  │  ┃ Home  ┃ Scan Asset ┃ Profile ┃ ← PERSISTENT │
│  │  │  ┗━━━━━━━┻━━━━━━━━━━━━┻━━━━━━━━━┛          │  │  │
│  │  └─────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

### Screen TANPA Bottom Navigation (fullscreen):
```
┌───────────────────────────────────────────────────┐
│         MyListAssetsScreen Widget                 │
│  ┌─────────────────────────────────────────────┐  │
│  │         Scaffold (dari Screen)              │  │
│  │  ┌───────────────────────────────────────┐  │  │
│  │  │  AppBar: "My Assets" [←]             │  │  │
│  │  └───────────────────────────────────────┘  │  │
│  │  ┌───────────────────────────────────────┐  │  │
│  │  │  Body: Asset List                     │  │  │
│  │  │  - Asset 1                            │  │  │
│  │  │  - Asset 2                            │  │  │
│  │  │  - Asset 3                            │  │  │
│  │  │  ...                                  │  │  │
│  │  └───────────────────────────────────────┘  │  │
│  │  ┌───────────────────────────────────────┐  │  │
│  │  │  FloatingActionButton: [+]            │  │  │
│  │  └───────────────────────────────────────┘  │  │
│  └─────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────┘
     NO BOTTOM NAVIGATION ✓ More screen space
```

## Navigation Flow

### User Journey Example:
```
┌──────────────┐
│  HomeScreen  │  ← Dengan Bottom Nav (UserShell)
└──────┬───────┘
       │ Tap "View My Assets" button
       ▼
┌──────────────────┐
│ MyListAssets     │  ← Fullscreen, No Bottom Nav
│ Screen           │
└──────┬───────────┘
       │ Tap back button
       ▼
┌──────────────┐
│  HomeScreen  │  ← Kembali ke Bottom Nav
└──────────────┘
```

### Bottom Nav Quick Switch:
```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  HomeScreen  │────▶│ ScanAsset    │────▶│  Profile     │
│              │     │ Screen       │     │  Screen      │
└──────────────┘     └──────────────┘     └──────────────┘
       ▲                                           │
       └───────────────────────────────────────────┘
              Bottom Nav selalu ada (persistent)
```

## Code Comparison

### ❌ SALAH - Mencoba override bottom nav di HomeScreen:
```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: MyContent(),
      bottomNavigationBar: NavigationBar(...), // ❌ Konflik dengan UserShell!
    );
  }
}
```

### ✅ BENAR - Biarkan UserShell handle bottom nav:
```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.home),
        backgroundColor: context.colorScheme.surface,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Welcome!', style: context.textTheme.headlineMedium),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.toMyAssets(),
                child: Text(context.l10n.viewMyAssets),
              ),
            ],
          ),
        ),
      ),
      // NO bottomNavigationBar! UserShell will provide it
    );
  }
}
```

### ✅ BENAR - Fullscreen dengan back button:
```dart
class MyListAssetsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.myAssets),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.beamBack(), // ✓ Back navigation
        ),
      ),
      body: ListView(...),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.toAssetCreate(),
        child: const Icon(Icons.add),
      ),
      // NO bottomNavigationBar! This is fullscreen
    );
  }
}
```

## Key Differences

| Aspect | With UserShell | Fullscreen |
|--------|----------------|------------|
| **Widget Tree** | UserShell → Scaffold → body: YourScreen (Scaffold) | YourScreen (Scaffold) |
| **Bottom Nav** | ✅ Persistent | ❌ None |
| **Back Button** | ❌ Not needed | ✅ Required in AppBar |
| **Screen Space** | Less (nav takes space) | More (full screen) |
| **Use Case** | Main navigation | Details/Forms/Lists |
| **Routes** | `/`, `/scan-asset`, `/profile` | `/my-assets`, `/asset/:id`, etc |

## Tips

1. **Nested Scaffold is OK!**
   - Outer: dari UserShell (provides bottom nav)
   - Inner: dari screen Anda (provides appBar & body)

2. **Think Mobile First**
   - Bottom nav = Quick access to main features
   - Fullscreen = Deep dive into specific content

3. **Consistent Patterns**
   - Main screens = Always with bottom nav
   - Secondary = Always fullscreen with back
   - No mixing!

4. **Navigation Extensions**
   ```dart
   // From HomeScreen to fullscreen
   context.toMyAssets(); // Opens fullscreen

   // From fullscreen back to HomeScreen
   context.beamBack(); // Returns to previous (with bottom nav)

   // Quick switch between main screens
   context.toScanAsset(); // Switches tab in bottom nav
   ```
