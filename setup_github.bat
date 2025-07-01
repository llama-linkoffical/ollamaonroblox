@echo off
echo ========================================
echo    Ollama Roblox GitHub Setup Script
echo ========================================
echo.

REM Get user input
set /p USERNAME="Enter your GitHub username: "
set /p REPONAME="Enter repository name (default: ollama-roblox): "
if "%REPONAME%"=="" set REPONAME=ollama-roblox

echo.
echo Setting up repository: %USERNAME%/%REPONAME%
echo.

REM Create directory and navigate
if not exist "%REPONAME%" (
    mkdir "%REPONAME%"
    echo ✅ Created directory: %REPONAME%
) else (
    echo ⚠️  Directory %REPONAME% already exists
)

cd "%REPONAME%"

REM Initialize git repository
git init
git branch -M main
echo ✅ Initialized git repository

REM Copy files from parent directory
copy "..\*.lua" . >nul 2>&1
copy "..\*.md" . >nul 2>&1
if not exist "examples" mkdir examples
copy "..\examples\*.lua" "examples\" >nul 2>&1
echo ✅ Copied project files

REM Update loader.lua with correct username/repo
powershell -Command "(Get-Content 'loader.lua') -replace 'your-username/ollama-roblox', '%USERNAME%/%REPONAME%' | Set-Content 'loader.lua'"
echo ✅ Updated loader.lua with your repository details

REM Create .gitignore
echo node_modules/ > .gitignore
echo .DS_Store >> .gitignore
echo *.log >> .gitignore
echo .env >> .gitignore
echo ✅ Created .gitignore

REM Add and commit files
git add .
git commit -m "Initial commit - Ollama AI for Roblox"
echo ✅ Created initial commit

echo.
echo ========================================
echo    Setup Complete! Next Steps:
echo ========================================
echo.
echo 1. Create repository on GitHub.com:
echo    - Go to https://github.com/new
echo    - Repository name: %REPONAME%
echo    - Make it PUBLIC (very important!)
echo    - Don't initialize with README (we already have one)
echo    - Click "Create repository"
echo.
echo 2. Push your code:
echo    git remote add origin https://github.com/%USERNAME%/%REPONAME%.git
echo    git push -u origin main
echo.
echo 3. Your installation link will be:
echo    loadstring(game:HttpGet("https://raw.githubusercontent.com/%USERNAME%/%REPONAME%/main/loader.lua"))()
echo.
echo 4. Test it in Roblox!
echo.
echo ========================================

pause
