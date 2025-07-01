-- Ollama AI Loader - Single script to load everything
-- Execute this one script to get the complete Ollama AI system

local GITHUB_REPO = "your-username/ollama-roblox" -- Change this to your actual repo
local BRANCH = "main"
local BASE_URL = "https://raw.githubusercontent.com/" .. GITHUB_REPO .. "/" .. BRANCH .. "/"

-- Loading status
local LoadingGUI = {}

-- Create simple loading screen
local function createLoadingScreen()
    local Players = game:GetService("Players")
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "OllamaLoader"
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 100)
    frame.Position = UDim2.new(0.5, -150, 0.5, -50)
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
    title.Text = "Loading Ollama AI..."
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -20, 0, 20)
    status.Position = UDim2.new(0, 10, 0, 50)
    status.BackgroundTransparency = 1
    status.Text = "Initializing..."
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
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
    
    if success then
        print("✅ " .. displayName .. " loaded successfully")
        return result
    else
        warn("❌ Failed to load " .. displayName .. ": " .. tostring(result))
        return nil
    end
end

-- Main loader function
local function loadOllamaAI()
    local loader = createLoadingScreen()
    
    -- Load scripts in order
    loader.updateStatus("Loading API wrapper...")
    local ollamaAPI = loadScript("ollama_api.lua", "Ollama API")
    if not ollamaAPI then
        loader.updateStatus("❌ Failed to load API")
        wait(2)
        loader.destroy()
        return
    end
    
    loader.updateStatus("Loading chat interface...")
    local chatGUI = loadScript("chat_gui.lua", "Chat GUI")
    if not chatGUI then
        loader.updateStatus("❌ Failed to load GUI")
        wait(2)
        loader.destroy()
        return
    end
    
    loader.updateStatus("Loading main system...")
    local mainScript = loadScript("main.lua", "Main System")
    if not mainScript then
        loader.updateStatus("❌ Failed to load main system")
        wait(2)
        loader.destroy()
        return
    end
    
    loader.updateStatus("Initializing components...")
    
    -- Execute the scripts in global environment
    local success, err = pcall(function()
        -- Load OllamaAPI module
        _G.OllamaAPI = loadstring(ollamaAPI)()
        
        -- Load ChatGUI module  
        _G.ChatGUI = loadstring(chatGUI)()
        
        -- Execute main script (this will set up everything)
        loadstring(mainScript)()
    end)
    
    if success then
        loader.updateStatus("✅ Ollama AI loaded!")
        wait(1)
        loader.destroy()
        print("🎉 Ollama AI system ready!")
    else
        loader.updateStatus("❌ Initialization failed")
        warn("Error: " .. tostring(err))
        wait(3)
        loader.destroy()
    end
end

-- Quick setup function for users
_G.setupOllamaAI = function(repoUrl)
    if repoUrl then
        GITHUB_REPO = repoUrl
        BASE_URL = "https://raw.githubusercontent.com/" .. GITHUB_REPO .. "/" .. BRANCH .. "/"
    end
    loadOllamaAI()
end

-- Auto-load if repo is configured
if GITHUB_REPO ~= "your-username/ollama-roblox" then
    loadOllamaAI()
else
    print("🔧 Ollama AI Loader Ready!")
    print("📖 Usage:")
    print('   _G.setupOllamaAI("your-username/your-repo")')
    print("")
    print("Or edit the GITHUB_REPO variable at the top of this script")
end
