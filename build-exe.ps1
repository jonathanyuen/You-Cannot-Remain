# LOVE Game - Build Executable Script
# This script creates a standalone .exe file from any Löve2D game
# Works with any LOVE game project - just place this script in your game folder
# Be sure you have Love2D installed on your machine, the script will autolocate it for you.
# If you don't have Love2D installed, you can install it from:
# https://love2d.org/

# ============================================
# CONFIGURATION - Edit these paths as needed
# ============================================

# Output folder (where game.exe will be created)
# Default: build folder in project directory
$path1 = Join-Path $PSScriptRoot "build"

# Path of your game project (current directory)
$path3 = $PSScriptRoot

# ============================================
# AUTO-DETECT LOVE INSTALLATION
# ============================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  LOVE Game - Building Executable" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Try to find LOVE installation (same paths as run.bat)
$path2 = $null
$lovePaths = @(
    "C:\Program Files\LOVE",
    "$env:LOCALAPPDATA\Programs\LOVE",
    "C:\Program Files (x86)\LOVE"
)

Write-Host "Searching for LOVE installation..." -ForegroundColor Yellow
foreach ($lovePath in $lovePaths) {
    if (Test-Path "$lovePath\love.exe") {
        $path2 = $lovePath
        Write-Host "Found LOVE at: $path2" -ForegroundColor Green
        break
    }
}

# If not found in common paths, try PATH
if (-not $path2) {
    $loveExe = Get-Command love.exe -ErrorAction SilentlyContinue
    if ($loveExe) {
        $path2 = Split-Path (Split-Path $loveExe.Source)
        Write-Host "Found LOVE in PATH at: $path2" -ForegroundColor Green
    }
}

# If still not found, show error
if (-not $path2) {
    Write-Host "ERROR: LOVE installation not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Searched in:" -ForegroundColor Yellow
    foreach ($lovePath in $lovePaths) {
        Write-Host "  - $lovePath" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "Please install Love2D from: https://love2d.org/" -ForegroundColor Yellow
    Write-Host "Or update this script to point to your LOVE installation." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# Check if game project exists
if (-not (Test-Path "$path3\main.lua")) {
    Write-Host "ERROR: Game project not found at: $path3" -ForegroundColor Red
    Write-Host "main.lua is missing. Please ensure you're running this script from the game directory." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host ""
Write-Host "Build Configuration:" -ForegroundColor Cyan
Write-Host "  Output folder: $path1" -ForegroundColor White
Write-Host "  LOVE installation: $path2" -ForegroundColor White
Write-Host "  Game project: $path3" -ForegroundColor White
Write-Host ""

# Create output folder if it doesn't exist
if (-not (Test-Path $path1)) {
    Write-Host "Creating output folder: $path1" -ForegroundColor Yellow
    New-Item -Path $path1 -ItemType Directory -Force | Out-Null
}

# Remove game.zip, game.exe, and the bin folder if they exist
Write-Host "Cleaning old build files..." -ForegroundColor Yellow
Remove-Item "$path1\game.zip", "$path1\game.exe", "$path1\bin" -ErrorAction SilentlyContinue -Recurse

# Check if the bin folder exists, if not, create it
if (-not (Test-Path "$path1\bin")) {
    New-Item -Path "$path1\bin" -ItemType Directory -Force | Out-Null
}

try {
    Write-Host "Compressing game project..." -ForegroundColor Yellow
    
    # Compress the entire game project folder into a zip file
    # Exclude unnecessary files
    $excludeItems = @("*.git*", "*.ps1", "*.bat", "*.md", "docs\*")
    $tempZip = "$env:TEMP\love_game.zip"
    
    # Remove temp zip if exists
    Remove-Item $tempZip -ErrorAction SilentlyContinue
    
    # Create zip with all game files
    Compress-Archive -Path "$path3\*" -DestinationPath $tempZip -Force
    
    # Move to final location
    Move-Item -Path $tempZip -Destination "$path1\game.zip" -Force
    
    Write-Host "Creating game.exe..." -ForegroundColor Yellow
    
    # Concatenate love.exe and the game.zip into game.exe
    Get-Content -Raw "$path2\love.exe", "$path1\game.zip" -Encoding Byte |
        Set-Content -Encoding Byte -NoNewline "$path1\game.exe"
    
    Write-Host "Copying DLL files..." -ForegroundColor Yellow
    
    # Copy necessary DLLs from Löve2d installation folder to the output folder
    Copy-Item -Path "$path2\*.dll" -Destination $path1 -Force -ErrorAction SilentlyContinue
    
    # Copy necessary DLLs from the game project's bin folder to the output folder's bin folder (if exists)
    if (Test-Path "$path3\bin") {
        if (Test-Path "$path3\bin\*.dll") {
            Copy-Item -Path "$path3\bin\*.dll" -Destination "$path1\bin" -Force -ErrorAction SilentlyContinue
        }
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  Build Complete!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Executable created at: $path1\game.exe" -ForegroundColor Green
    Write-Host ""
    Write-Host "You can now distribute the contents of: $path1" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
} catch {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "  Build Failed!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Error "Error occurred: $_"
    Write-Host ""
    Write-Host "Press any key to exit..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

