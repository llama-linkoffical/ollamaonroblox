# Cleanup Script - Fixes Issues from Failed Setup
# Run this if the setup script created a mess

Write-Host "========================================" -ForegroundColor Red
Write-Host "   Cleanup Script for Failed Setup" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
Write-Host ""

$currentLocation = Get-Location
Write-Host "Current directory: $currentLocation" -ForegroundColor Yellow
Write-Host ""

# Check if we're in ollamaonroblox directory
$currentDir = Split-Path -Leaf $currentLocation
if ($currentDir -eq "ollamaonroblox") {
    Write-Host "✅ We're in the correct directory" -ForegroundColor Green
    
    # Remove any subdirectories that shouldn't be there
    $badDirs = @("ollama-roblox", "roblox-ai", "ai-chat")
    foreach ($dir in $badDirs) {
        if (Test-Path $dir) {
            Write-Host "🧹 Removing problematic directory: $dir" -ForegroundColor Yellow
            Remove-Item $dir -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "✅ Removed $dir" -ForegroundColor Green
        }
    }
    
    # Clean up git if it's messed up
    if (Test-Path ".git") {
        $response = Read-Host "Found .git directory. Reset it? (y/n)"
        if ($response -eq "y" -or $response -eq "Y") {
            Remove-Item ".git" -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "✅ Removed old git repository" -ForegroundColor Green
        }
    }
    
    # List what we have now
    Write-Host ""
    Write-Host "Current files in directory:" -ForegroundColor Cyan
    Get-ChildItem | ForEach-Object { 
        if ($_.PSIsContainer) {
            Write-Host "📁 $($_.Name)" -ForegroundColor Blue
        } else {
            Write-Host "📄 $($_.Name)" -ForegroundColor White
        }
    }
    
    Write-Host ""
    Write-Host "✅ Cleanup complete!" -ForegroundColor Green
    Write-Host "Now you can run the fixed setup_github.ps1 script" -ForegroundColor Yellow
    
} else {
    Write-Host "❌ You're not in the ollamaonroblox directory!" -ForegroundColor Red
    Write-Host "Please navigate to the ollamaonroblox directory first" -ForegroundColor Yellow
    Write-Host "Example: cd 'C:\Users\micah\Downloads\ollamaonroblox'" -ForegroundColor White
}

Write-Host ""
Read-Host "Press Enter to exit"
