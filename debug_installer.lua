-- Debug Installer - Shows what files are missing
-- Run this to see what's going wrong

local GITHUB_REPO = "llama-linkoffical/ollamaonroblox"
local BRANCH = "main"
local BASE_URL = "https://raw.githubusercontent.com/" .. GITHUB_REPO .. "/" .. BRANCH .. "/"

print("🔍 Debug Installer for Ollama AI")
print("📦 Repository: " .. GITHUB_REPO)
print("🌐 Base URL: " .. BASE_URL)
print("")

-- List of required files
local requiredFiles = {
    "ollama_api.lua",
    "chat_gui.lua", 
    "main.lua"
}

-- Test each file
print("📋 Checking required files:")
local missingFiles = {}
local foundFiles = {}

for _, filename in ipairs(requiredFiles) do
    local url = BASE_URL .. filename
    print("   Testing: " .. filename)
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and result and result ~= "" and not string.find(result, "404") then
        print("   ✅ " .. filename .. " - Found (" .. string.len(result) .. " chars)")
        foundFiles[filename] = result
    else
        print("   ❌ " .. filename .. " - Missing or empty")
        print("      URL: " .. url)
        print("      Error: " .. tostring(result))
        table.insert(missingFiles, filename)
    end
    print("")
end

print("========================================")
print("📊 Results:")
print("✅ Found: " .. #foundFiles .. " files")
print("❌ Missing: " .. #missingFiles .. " files")

if #missingFiles > 0 then
    print("")
    print("🚨 Missing files that need to be uploaded to GitHub:")
    for _, filename in ipairs(missingFiles) do
        print("   - " .. filename)
    end
    print("")
    print("💡 To fix this:")
    print("   1. Go to https://github.com/llama-linkoffical/ollamaonroblox")
    print("   2. Upload these missing files from your local folder")
    print("   3. Make sure they're in the main branch (not in a subfolder)")
    print("   4. Try the installer again")
else
    print("")
    print("🎉 All files found! Let's try loading...")
    
    -- Try to load everything
    local success, err = pcall(function()
        if foundFiles["ollama_api.lua"] then
            print("📦 Loading OllamaAPI...")
            _G.OllamaAPI = loadstring(foundFiles["ollama_api.lua"])()
            print("✅ OllamaAPI loaded")
        end
        
        if foundFiles["chat_gui.lua"] then
            print("📦 Loading ChatGUI...")
            _G.ChatGUI = loadstring(foundFiles["chat_gui.lua"])()
            print("✅ ChatGUI loaded")
        end
        
        if foundFiles["main.lua"] then
            print("📦 Loading Main System...")
            loadstring(foundFiles["main.lua"])()
            print("✅ Main System loaded")
        end
    end)
    
    if success then
        print("🎉 Everything loaded successfully!")
        print("💬 Look for the chat GUI!")
    else
        print("❌ Error during loading: " .. tostring(err))
    end
end

print("========================================")
