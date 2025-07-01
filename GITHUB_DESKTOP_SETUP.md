# GitHub Desktop Setup Guide

## 🚀 Quick Setup Using GitHub Desktop

### Step 1: Create Repository
1. Open **GitHub Desktop**
2. Click **"Create a New Repository on your hard drive"**
3. Fill in the details:
   - **Name**: `ollama-roblox` (or your preferred name)
   - **Description**: `Local AI integration for Roblox using Ollama`
   - **Local Path**: Choose where to save it
   - **Initialize with README**: ✅ Check this
   - **Git ignore**: None
   - **License**: MIT License (recommended)
4. Click **"Create Repository"**

### Step 2: Add Project Files
1. **Copy all `.lua` files** from this project into your new repository folder
2. **Copy all `.md` files** (README.md, SETUP.md, etc.) 
3. Your folder should look like:
   ```
   ollama-roblox/
   ├── loader.lua
   ├── ollama_api.lua
   ├── chat_gui.lua
   ├── main.lua
   ├── README.md
   ├── SETUP.md
   ├── GITHUB_SETUP.md
   └── examples/
       ├── simple_chat.lua
       ├── code_generator.lua
       └── ai_npc.lua
   ```

### Step 3: Update Configuration
1. **Edit `loader.lua`** in your repository folder
2. **Change this line**:
   ```lua
   local GITHUB_REPO = "your-username/ollama-roblox"
   ```
   To your actual GitHub username:
   ```lua
   local GITHUB_REPO = "YourActualUsername/ollama-roblox"
   ```

### Step 4: Commit and Push
1. Go back to **GitHub Desktop**
2. You should see all your files in the "Changes" tab
3. **Add a commit message**: `Initial commit - Ollama AI for Roblox`
4. Click **"Commit to main"**
5. Click **"Publish repository"**
6. Make sure **"Keep this code private"** is **UNCHECKED** (must be public for raw file access)
7. Click **"Publish Repository"**

### Step 5: Get Your Installation Link
Your installation link will be:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOURUSERNAME/ollama-roblox/main/loader.lua"))()
```

Replace `YOURUSERNAME` with your actual GitHub username.

## 🎯 Example Installation Links

If your GitHub username is `john123`:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/john123/ollama-roblox/main/loader.lua"))()
```

If your GitHub username is `robloxdev456`:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/robloxdev456/ollama-roblox/main/loader.lua"))()
```

## 🔄 Making Updates

When you want to update your scripts:
1. **Edit files** in your local repository folder
2. Go to **GitHub Desktop**
3. **Review changes** in the Changes tab
4. **Add commit message** describing what you changed
5. Click **"Commit to main"**
6. Click **"Push origin"**
7. **Users automatically get updates** next time they run your installer!

## ✅ Quick Test

After publishing, test your setup:
1. Copy your installation link
2. Open Roblox with an executor
3. Paste and run your installation link
4. Make sure everything loads correctly

## 🚨 Troubleshooting

### Repository not found
- Make sure repository is **public** (not private)
- Check your username spelling in the URL
- Wait a few minutes after publishing

### Files not loading
- Verify all files are uploaded to the repository
- Check file names match exactly (case-sensitive)
- Make sure you pushed your commits

### Installation link not working
- Test the raw GitHub URL in a browser first
- Make sure Ollama is running locally
- Check executor HTTP permissions

## 📱 Alternative: Command Line

If you prefer command line instead of GitHub Desktop:

```bash
# Create and navigate to your project folder
cd "C:\Users\YourName\Documents"
mkdir ollama-roblox
cd ollama-roblox

# Initialize git repository
git init
git branch -M main

# Add all your files here, then:
git add .
git commit -m "Initial commit - Ollama AI for Roblox"

# Connect to GitHub (replace with your repo URL)
git remote add origin https://github.com/YOURUSERNAME/ollama-roblox.git
git push -u origin main
```

## 🎉 You're Done!

Share your installation link and let people enjoy AI in Roblox! 🤖
