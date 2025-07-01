# GitHub Repository Setup Guide

## Quick Setup (Recommended)

### 1. Create GitHub Repository
1. Go to [GitHub.com](https://github.com)
2. Click "New Repository"
3. Name it something like `ollama-roblox` or `roblox-ai-chat`
4. Make it **Public** (required for raw file access)
5. Create repository

### 2. Upload Files
Upload all the `.lua` files from this project to your GitHub repository:
- `loader.lua` (main installer)
- `ollama_api.lua` (API wrapper)
- `chat_gui.lua` (chat interface)
- `main.lua` (main system)
- `examples/` folder (optional examples)

### 3. Update Loader
Edit `loader.lua` and change this line:
```lua
local GITHUB_REPO = "your-username/ollama-roblox" -- Change this!
```
To your actual repository:
```lua
local GITHUB_REPO = "yourusername/your-repo-name"
```

### 4. Get Installation Link
Your installation link will be:
```
https://raw.githubusercontent.com/YOURUSERNAME/YOURREPO/main/loader.lua
```

## Usage

### For Users (Super Simple!)
Just run this one line in any Roblox executor:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOURUSERNAME/YOURREPO/main/loader.lua"))()
```

### Example
If your GitHub is `john123/roblox-ai`:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/john123/roblox-ai/main/loader.lua"))()
```

## What This Does

1. **Downloads** all necessary scripts automatically
2. **Loads** them into Roblox in the correct order  
3. **Initializes** the complete AI chat system
4. **Shows** a loading screen during setup
5. **Creates** the chat GUI automatically

## Benefits of GitHub Method

✅ **One-line installation** - Super easy for users
✅ **Auto-updates** - Push changes and users get them instantly  
✅ **Easy sharing** - Just share one link
✅ **Version control** - Track changes and improvements
✅ **Professional** - Looks more legitimate and trustworthy
✅ **Modular** - Easy to add new features and examples

## File Structure in GitHub

```
your-repo/
├── loader.lua          (Main installer - users run this)
├── ollama_api.lua       (API wrapper)
├── chat_gui.lua         (Chat interface)
├── main.lua            (Main system)
├── README.md           (Project description)
├── SETUP.md            (Setup instructions)
└── examples/           (Example scripts)
    ├── simple_chat.lua
    ├── code_generator.lua
    └── ai_npc.lua
```

## Advanced Setup

### Custom Branch
To use a different branch (like `dev`):
```lua
local BRANCH = "dev" -- Change in loader.lua
```

### Private Repository
For private repos, you'll need to use GitHub tokens or make it public.

### Multiple Versions
Create different branches for different versions:
- `main` - Stable release
- `beta` - Testing version  
- `dev` - Development version

## Testing

Before sharing, test your setup:
1. Upload files to GitHub
2. Update `GITHUB_REPO` in loader.lua
3. Test the installation link in Roblox
4. Make sure everything loads correctly

## Sharing

Share your installation link:
```lua
-- Ollama AI for Roblox - Created by YourName
-- Paste this into your executor:
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOURUSERNAME/YOURREPO/main/loader.lua"))()
```

## Troubleshooting

### "HTTP requests are not enabled"
- User's executor doesn't support HTTP requests
- Try a different executor

### "Failed to load [filename]"
- Check if files are uploaded to GitHub
- Verify repository is public
- Check file names match exactly

### "Repository not found"
- Make sure repository is public
- Check username and repo name spelling
- Verify the URL works in a browser

Happy coding! 🚀
