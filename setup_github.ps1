# Ollama Roblox GitHub Setup Script (PowerShell) - FIXED VERSION
# Run this in PowerShell to set up your GitHub repository

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Ollama Roblox GitHub Setup Script" -ForegroundColor Cyan  
Write-Host "     (Fixed Version - Cleans Up Issues)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if we're in the right directory
$currentDir = Split-Path -Leaf (Get-Location)
if ($currentDir -ne "ollamaonroblox") {
    Write-Host "❌ Please run this script from the ollamaonroblox directory!" -ForegroundColor Red
    Write-Host "Current directory: $(Get-Location)" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit
}

# Clean up any previous mess
if (Test-Path "ollama-roblox") {
    Write-Host "🧹 Cleaning up previous setup attempts..." -ForegroundColor Yellow
    Remove-Item "ollama-roblox" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✅ Cleaned up old directory" -ForegroundColor Green
}

# Get user input
$USERNAME = Read-Host "Enter your GitHub username"
$REPONAME = Read-Host "Enter repository name (press Enter for 'ollama-roblox')"
if ([string]::IsNullOrEmpty($REPONAME)) {
    $REPONAME = "ollama-roblox"
}

Write-Host ""
Write-Host "Setting up repository: $USERNAME/$REPONAME" -ForegroundColor Green
Write-Host "Working in current directory (not creating subdirectory)" -ForegroundColor Cyan
Write-Host ""

# Initialize git repository in current directory (if not already done)
if (!(Test-Path ".git")) {
    git init
    git branch -M main
    Write-Host "✅ Initialized git repository" -ForegroundColor Green
} else {
    Write-Host "ℹ️  Git repository already exists" -ForegroundColor Blue
}

# Initialize git repository in current directory (if not already done)
if (!(Test-Path ".git")) {
    git init
    git branch -M main
    Write-Host "✅ Initialized git repository" -ForegroundColor Green
} else {
    Write-Host "ℹ️  Git repository already exists" -ForegroundColor Blue
}

# Verify all required files are present
$requiredFiles = @("loader.lua", "ollama_api.lua", "chat_gui.lua", "main.lua", "README.md")
$missingFiles = @()

foreach ($file in $requiredFiles) {
    if (!(Test-Path $file)) {
        $missingFiles += $file
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Host "❌ Missing required files:" -ForegroundColor Red
    foreach ($file in $missingFiles) {
        Write-Host "   - $file" -ForegroundColor Red
    }
    Write-Host "Please make sure all files are in the current directory!" -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit
}

Write-Host "✅ All required files found" -ForegroundColor Green

# Create examples directory if it doesn't exist
if (!(Test-Path "examples")) {
    New-Item -ItemType Directory -Name "examples" | Out-Null
    Write-Host "✅ Created examples directory" -ForegroundColor Green
}

# Update loader.lua with correct username/repo
if (Test-Path "loader.lua") {
    try {
        $content = Get-Content "loader.lua" -Raw
        $content = $content -replace "your-username/ollama-roblox", "$USERNAME/$REPONAME"
        $content | Set-Content "loader.lua" -NoNewline
        Write-Host "✅ Updated loader.lua with your repository details" -ForegroundColor Green
    } catch {
        Write-Host "⚠️  Could not update loader.lua: $($_.Exception.Message)" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ loader.lua not found!" -ForegroundColor Red
}

# Create or update .gitignore
$gitignoreContent = @"
# Dependencies
node_modules/

# System files
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*

# Environment files
.env
.env.local

# IDE files
.vscode/
.idea/

# Temporary files
*.tmp
*.temp

# Python cache (if any)
__pycache__/
*.pyc
*.pyo

# Windows
desktop.ini
"@

$gitignoreContent | Out-File -FilePath ".gitignore" -Encoding UTF8
Write-Host "✅ Created/updated .gitignore" -ForegroundColor Green

# Add and commit files
try {
    git add .
    git commit -m "Initial commit - Ollama AI for Roblox"
    Write-Host "✅ Created initial commit" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Git commit might have failed, but continuing..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Setup Complete! Next Steps:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Create repository on GitHub.com:" -ForegroundColor Yellow
Write-Host "   - Go to https://github.com/new" -ForegroundColor White
Write-Host "   - Repository name: $REPONAME" -ForegroundColor White
Write-Host "   - Make it PUBLIC (very important!)" -ForegroundColor Red
Write-Host "   - Don't initialize with README (we already have one)" -ForegroundColor White
Write-Host "   - Click 'Create repository'" -ForegroundColor White
Write-Host ""
Write-Host "2. Push your code (run these commands):" -ForegroundColor Yellow
Write-Host "   git remote add origin https://github.com/$USERNAME/$REPONAME.git" -ForegroundColor Magenta
Write-Host "   git push -u origin main" -ForegroundColor Magenta
Write-Host ""
Write-Host "3. Your installation link will be:" -ForegroundColor Yellow
Write-Host "   loadstring(game:HttpGet(`"https://raw.githubusercontent.com/$USERNAME/$REPONAME/main/loader.lua`"))()" -ForegroundColor Green
Write-Host ""
Write-Host "4. Test it in Roblox!" -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan

# Copy installation link to clipboard
$installLink = "loadstring(game:HttpGet(`"https://raw.githubusercontent.com/$USERNAME/$REPONAME/main/loader.lua`"))()"
$installLink | Set-Clipboard
Write-Host "📋 Installation link copied to clipboard!" -ForegroundColor Green

Read-Host "Press Enter to exit"
