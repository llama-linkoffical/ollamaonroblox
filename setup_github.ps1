# Ollama Roblox GitHub Setup Script (PowerShell)
# Run this in PowerShell to set up your GitHub repository

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Ollama Roblox GitHub Setup Script" -ForegroundColor Cyan  
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Get user input
$USERNAME = Read-Host "Enter your GitHub username"
$REPONAME = Read-Host "Enter repository name (press Enter for 'ollama-roblox')"
if ([string]::IsNullOrEmpty($REPONAME)) {
    $REPONAME = "ollama-roblox"
}

Write-Host ""
Write-Host "Setting up repository: $USERNAME/$REPONAME" -ForegroundColor Green
Write-Host ""

# Create directory and navigate
if (!(Test-Path $REPONAME)) {
    New-Item -ItemType Directory -Name $REPONAME | Out-Null
    Write-Host "✅ Created directory: $REPONAME" -ForegroundColor Green
} else {
    Write-Host "⚠️  Directory $REPONAME already exists" -ForegroundColor Yellow
}

Set-Location $REPONAME

# Initialize git repository
git init
git branch -M main
Write-Host "✅ Initialized git repository" -ForegroundColor Green

# Copy files from parent directory
Copy-Item "..\*.lua" . -ErrorAction SilentlyContinue
Copy-Item "..\*.md" . -ErrorAction SilentlyContinue
if (!(Test-Path "examples")) {
    New-Item -ItemType Directory -Name "examples" | Out-Null
}
Copy-Item "..\examples\*.lua" "examples\" -ErrorAction SilentlyContinue
Write-Host "✅ Copied project files" -ForegroundColor Green

# Update loader.lua with correct username/repo
if (Test-Path "loader.lua") {
    $content = Get-Content "loader.lua"
    $content = $content -replace "your-username/ollama-roblox", "$USERNAME/$REPONAME"
    $content | Set-Content "loader.lua"
    Write-Host "✅ Updated loader.lua with your repository details" -ForegroundColor Green
}

# Create .gitignore
@"
node_modules/
.DS_Store
*.log
.env
"@ | Out-File -FilePath ".gitignore" -Encoding UTF8
Write-Host "✅ Created .gitignore" -ForegroundColor Green

# Add and commit files
git add .
git commit -m "Initial commit - Ollama AI for Roblox"
Write-Host "✅ Created initial commit" -ForegroundColor Green

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
