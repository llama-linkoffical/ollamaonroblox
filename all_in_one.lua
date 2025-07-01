-- All-in-One Ollama AI - No separate files needed!
-- This version includes everything in one script

print("🚀 Loading All-in-One Ollama AI...")

-- Check if Ollama server is reachable
local function testOllamaConnection()
    local success, result = pcall(function()
        return game:GetService("HttpService"):GetAsync("http://localhost:11434/api/tags")
    end)
    return success
end

-- Simple HTTP request function
local function makeOllamaRequest(endpoint, data)
    local HttpService = game:GetService("HttpService")
    local url = "http://localhost:11434" .. endpoint
    
    local success, result = pcall(function()
        if data then
            return HttpService:PostAsync(url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
        else
            return HttpService:GetAsync(url)
        end
    end)
    
    if success then
        return HttpService:JSONDecode(result)
    else
        return nil, result
    end
end

-- Simple chat function
local function askOllama(question, model)
    model = model or "llama2"
    print("🤔 Asking AI: " .. question)
    
    local data = {
        model = model,
        prompt = question,
        stream = false
    }
    
    local result, err = makeOllamaRequest("/api/generate", data)
    if result then
        print("🤖 AI Response: " .. result.response)
        return result.response
    else
        print("❌ Error: " .. tostring(err))
        return nil
    end
end

-- Create simple GUI
local function createSimpleGUI()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Clean up existing GUI
    if playerGui:FindFirstChild("SimpleOllamaGUI") then
        playerGui.SimpleOllamaGUI:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SimpleOllamaGUI"
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 300)
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    title.Text = "🤖 Ollama AI Chat"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title
    
    local chatArea = Instance.new("ScrollingFrame")
    chatArea.Size = UDim2.new(1, -20, 1, -100)
    chatArea.Position = UDim2.new(0, 10, 0, 50)
    chatArea.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    chatArea.BorderSizePixel = 0
    chatArea.ScrollBarThickness = 5
    chatArea.Parent = frame
    
    local chatCorner = Instance.new("UICorner")
    chatCorner.CornerRadius = UDim.new(0, 8)
    chatCorner.Parent = chatArea
    
    local chatLayout = Instance.new("UIListLayout")
    chatLayout.Padding = UDim.new(0, 5)
    chatLayout.Parent = chatArea
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -80, 0, 30)
    inputBox.Position = UDim2.new(0, 10, 1, -40)
    inputBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    inputBox.BorderSizePixel = 0
    inputBox.Text = ""
    inputBox.PlaceholderText = "Type your message..."
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.TextScaled = true
    inputBox.Font = Enum.Font.Gotham
    inputBox.Parent = frame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 5)
    inputCorner.Parent = inputBox
    
    local sendButton = Instance.new("TextButton")
    sendButton.Size = UDim2.new(0, 60, 0, 30)
    sendButton.Position = UDim2.new(1, -70, 1, -40)
    sendButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sendButton.BorderSizePixel = 0
    sendButton.Text = "Send"
    sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    sendButton.TextScaled = true
    sendButton.Font = Enum.Font.GothamBold
    sendButton.Parent = frame
    
    local sendCorner = Instance.new("UICorner")
    sendCorner.CornerRadius = UDim.new(0, 5)
    sendCorner.Parent = sendButton
    
    -- Add message function
    local function addMessage(sender, message, isUser)
        local messageFrame = Instance.new("Frame")
        messageFrame.Size = UDim2.new(1, -10, 0, 60)
        messageFrame.BackgroundColor3 = isUser and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(70, 70, 70)
        messageFrame.BorderSizePixel = 0
        messageFrame.Parent = chatArea
        
        local msgCorner = Instance.new("UICorner")
        msgCorner.CornerRadius = UDim.new(0, 5)
        msgCorner.Parent = messageFrame
        
        local senderLabel = Instance.new("TextLabel")
        senderLabel.Size = UDim2.new(1, -10, 0, 20)
        senderLabel.Position = UDim2.new(0, 5, 0, 5)
        senderLabel.BackgroundTransparency = 1
        senderLabel.Text = sender
        senderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        senderLabel.TextScaled = true
        senderLabel.Font = Enum.Font.GothamBold
        senderLabel.TextXAlignment = Enum.TextXAlignment.Left
        senderLabel.Parent = messageFrame
        
        local messageLabel = Instance.new("TextLabel")
        messageLabel.Size = UDim2.new(1, -10, 0, 35)
        messageLabel.Position = UDim2.new(0, 5, 0, 20)
        messageLabel.BackgroundTransparency = 1
        messageLabel.Text = message
        messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        messageLabel.TextSize = 14
        messageLabel.Font = Enum.Font.Gotham
        messageLabel.TextXAlignment = Enum.TextXAlignment.Left
        messageLabel.TextYAlignment = Enum.TextYAlignment.Top
        messageLabel.TextWrapped = true
        messageLabel.Parent = messageFrame
        
        chatLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            chatArea.CanvasSize = UDim2.new(0, 0, 0, chatLayout.AbsoluteContentSize.Y)
        end)
        chatArea.CanvasSize = UDim2.new(0, 0, 0, chatLayout.AbsoluteContentSize.Y)
        chatArea.CanvasPosition = Vector2.new(0, chatArea.CanvasSize.Y.Offset)
    end
    
    -- Send message function
    local function sendMessage()
        local message = inputBox.Text
        if message and message ~= "" then
            addMessage("You", message, true)
            inputBox.Text = ""
            
            spawn(function()
                local response = askOllama(message)
                if response then
                    addMessage("AI", response, false)
                else
                    addMessage("System", "Error: Could not get AI response. Make sure Ollama is running!", false)
                end
            end)
        end
    end
    
    sendButton.MouseButton1Click:Connect(sendMessage)
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            sendMessage()
        end
    end)
    
    -- Add welcome message
    addMessage("System", "Welcome! Make sure Ollama is running (ollama serve) and you have a model installed (ollama pull llama2)", false)
    
    return screenGui
end

-- Test connection and create GUI
print("🔗 Testing Ollama connection...")
if testOllamaConnection() then
    print("✅ Ollama server is running!")
    print("🎨 Creating chat GUI...")
    createSimpleGUI()
    print("🎉 All-in-One Ollama AI loaded successfully!")
    print("💬 Chat GUI is now available!")
else
    print("❌ Cannot connect to Ollama server!")
    print("💡 Please make sure:")
    print("   1. Ollama is running: ollama serve")
    print("   2. You have a model: ollama pull llama2")
    print("   3. Server is on localhost:11434")
    
    -- Still create GUI but with error message
    createSimpleGUI()
end

-- Global functions for easy testing
_G.testOllama = function()
    return testOllamaConnection()
end

_G.askAI = function(question)
    return askOllama(question)
end

print("🎯 Quick test: _G.askAI('Hello, who are you?')")
