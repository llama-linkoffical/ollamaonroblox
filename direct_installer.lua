-- Direct Ollama AI Installer - No Setup Required!
-- This version loads immediately without any global setup needed

local GITHUB_REPO = "llama-linkoffical/ollamaonroblox"
local BRANCH = "main"
local BASE_URL = "https://raw.githubusercontent.com/" .. GITHUB_REPO .. "/" .. BRANCH .. "/"

print("🚀 Starting Ollama AI Direct Installer...")
print("📦 Repository: " .. GITHUB_REPO)

-- Create simple loading screen
local function createLoadingScreen()
    local Players = game:GetService("Players")
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "OllamaDirectLoader"
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 120)
    frame.Position = UDim2.new(0.5, -175, 0.5, -60)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "🤖 Loading Ollama AI..."
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local repo = Instance.new("TextLabel")
    repo.Size = UDim2.new(1, -20, 0, 20)
    repo.Position = UDim2.new(0, 10, 0, 40)
    repo.BackgroundTransparency = 1
    repo.Text = "From: " .. GITHUB_REPO
    repo.TextColor3 = Color3.fromRGB(150, 150, 150)
    repo.TextSize = 12
    repo.Font = Enum.Font.Gotham
    repo.Parent = frame
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -20, 0, 20)
    status.Position = UDim2.new(0, 10, 0, 70)
    status.BackgroundTransparency = 1
    status.Text = "Initializing..."
    status.TextColor3 = Color3.fromRGB(100, 200, 255)
    status.TextScaled = true
    status.Font = Enum.Font.Gotham
    status.Parent = frame
    
    return {
        gui = screenGui,
        updateStatus = function(text)
            status.Text = text
        end,
        destroy = function()
            screenGui:Destroy()
        end
    }
end

-- Load script from GitHub
local function loadScript(filename, displayName)
    displayName = displayName or filename
    print("📥 Loading " .. displayName .. "...")
    
    local url = BASE_URL .. filename
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and result and result ~= "" then
        print("✅ " .. displayName .. " loaded successfully (" .. string.len(result) .. " chars)")
        return result
    else
        warn("❌ Failed to load " .. displayName .. ": " .. tostring(result))
        return nil
    end
end

-- Main installation function
local function installOllamaAI()
    local loader = createLoadingScreen()
    
    -- Load scripts in order
    loader.updateStatus("📡 Loading API wrapper...")
    wait(0.5)
    local ollamaAPI = loadScript("ollama_api.lua", "Ollama API")
    if not ollamaAPI then
        loader.updateStatus("❌ Failed to load API - Check connection")
        wait(3)
        loader.destroy()
        return
    end
    
    loader.updateStatus("🎨 Loading chat interface...")
    wait(0.5)
    local chatGUI = loadScript("chat_gui.lua", "Chat GUI")
    if not chatGUI then
        loader.updateStatus("❌ Failed to load GUI - Check connection")
        wait(3)
        loader.destroy()
        return
    end
    
    loader.updateStatus("⚙️ Loading main system...")
    wait(0.5)
    local mainScript = loadScript("main.lua", "Main System")
    if not mainScript then
        loader.updateStatus("❌ Failed to load main system")
        wait(3)
        loader.destroy()
        return
    end
    
    loader.updateStatus("🔧 Initializing components...")
    wait(0.5)
    
    -- Execute the scripts in global environment
    local success, err = pcall(function()
        -- Load OllamaAPI module
        local ollamaModule = loadstring(ollamaAPI)
        if ollamaModule then
            _G.OllamaAPI = ollamaModule()
        else
            error("Failed to compile OllamaAPI")
        end
        
        -- Load ChatGUI module  
        local chatModule = loadstring(chatGUI)
        if chatModule then
            _G.ChatGUI = chatModule()
        else
            error("Failed to compile ChatGUI")
        end
        
        -- Execute main script (this will set up everything)
        local mainModule = loadstring(mainScript)
        if mainModule then
            mainModule()
        else
            error("Failed to compile main script")
        end
    end)
    
    if success then
        loader.updateStatus("✅ Ollama AI loaded successfully!")
        wait(1.5)
        loader.destroy()
        print("🎉 Ollama AI system ready!")
        print("💬 Chat GUI should be visible now!")
        print("🔧 Make sure Ollama is running: ollama serve")
    else
        loader.updateStatus("❌ Initialization failed")
        warn("❌ Error: " .. tostring(err))
        wait(5)
        loader.destroy()
        
        -- Show error help
        print("🆘 Installation failed. Common fixes:")
        print("   1. Make sure your executor supports HTTP requests")
        print("   2. Check your internet connection")
        print("   3. Verify Ollama is running: ollama serve")
        print("   4. Try a different executor if the problem persists")
    end
end

-- Start installation immediately
installOllamaAI()
