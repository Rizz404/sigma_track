# Convert notification sound files from MP3 to OGG for Android
# Requires: ffmpeg (install via: choco install ffmpeg)

$rawPath = "android\app\src\main\res\raw"

Write-Host "🔊 Converting notification sounds MP3 -> OGG..." -ForegroundColor Cyan
Write-Host ""

# Check if ffmpeg is installed
if (-not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    Write-Host "❌ ffmpeg not found!" -ForegroundColor Red
    Write-Host "   Install: choco install ffmpeg" -ForegroundColor Yellow
    exit 1
}

# Check if raw folder exists
if (-not (Test-Path $rawPath)) {
    Write-Host "❌ Raw folder not found: $rawPath" -ForegroundColor Red
    exit 1
}

# Convert all MP3 files to OGG
$mp3Files = Get-ChildItem -Path $rawPath -Filter "*.mp3"

if ($mp3Files.Count -eq 0) {
    Write-Host "✅ No MP3 files to convert (already done?)" -ForegroundColor Green
    Write-Host ""
    Write-Host "Current files:" -ForegroundColor Cyan
    Get-ChildItem -Path $rawPath | ForEach-Object { Write-Host "   - $($_.Name)" }
    exit 0
}

foreach ($file in $mp3Files) {
    $inputPath = $file.FullName
    $outputPath = $inputPath -replace '\.mp3$', '.ogg'
    $fileName = $file.BaseName

    Write-Host "🎵 Converting: $fileName.mp3 -> $fileName.ogg" -ForegroundColor Yellow

    # Convert with quality 4 (similar to 128kbps)
    ffmpeg -i $inputPath -c:a libvorbis -q:a 4 $outputPath -y 2>&1 | Out-Null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Success" -ForegroundColor Green

        # Get file sizes
        $inputSize = [math]::Round((Get-Item $inputPath).Length / 1KB, 2)
        $outputSize = [math]::Round((Get-Item $outputPath).Length / 1KB, 2)
        Write-Host "   📦 Size: $inputSize KB -> $outputSize KB" -ForegroundColor Gray

        # Remove original MP3
        Remove-Item $inputPath
        Write-Host "   🗑️  Removed MP3" -ForegroundColor Gray
    } else {
        Write-Host "   ✗ Failed to convert" -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host "✅ Conversion complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📁 Files in raw folder:" -ForegroundColor Cyan
Get-ChildItem -Path $rawPath | ForEach-Object {
    Write-Host "   - $($_.Name)" -ForegroundColor White
}

Write-Host ""
Write-Host "📝 Next steps:" -ForegroundColor Yellow
Write-Host "   1. Uninstall app: adb uninstall com.example.sigma_track"
Write-Host "   2. Clean build: flutter clean && flutter pub get"
Write-Host "   3. Run: flutter run"
Write-Host "   4. Test notification with custom sound"
Write-Host ""
