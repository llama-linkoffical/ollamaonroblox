-- Chat GUI for Ollama AI Integration
-- Creates a simple interface for chatting with local AI models

local ChatGUI = {}

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Get player and GUI
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main GUI
local function createMainGUI()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "OllamaChat"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "Ollama AI Chat"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextScaled = true
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 95, 95)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    -- Chat Display Frame
    local chatFrame = Instance.new("ScrollingFrame")
    chatFrame.Name = "ChatFrame"
    chatFrame.Size = UDim2.new(1, -20, 1, -100)
    chatFrame.Position = UDim2.new(0, 10, 0, 50)
    chatFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    chatFrame.BorderSizePixel = 0
    chatFrame.ScrollBarThickness = 6
    chatFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    chatFrame.Parent = mainFrame
    
    local chatCorner = Instance.new("UICorner")
    chatCorner.CornerRadius = UDim.new(0, 8)
    chatCorner.Parent = chatFrame
    
    -- Chat Layout
    local chatLayout = Instance.new("UIListLayout")
    chatLayout.Name = "ChatLayout"
    chatLayout.Padding = UDim.new(0, 5)
    chatLayout.SortOrder = Enum.SortOrder.LayoutOrder
    chatLayout.Parent = chatFrame
    
    -- Input Frame
    local inputFrame = Instance.new("Frame")
    inputFrame.Name = "InputFrame"
    inputFrame.Size = UDim2.new(1, -20, 0, 40)
    inputFrame.Position = UDim2.new(0, 10, 1, -50)
    inputFrame.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = mainFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputFrame
    
    -- Text Input
    local textInput = Instance.new("TextBox")
    textInput.Name = "TextInput"
    textInput.Size = UDim2.new(1, -90, 1, -10)
    textInput.Position = UDim2.new(0, 10, 0, 5)
    textInput.BackgroundTransparency = 1
    textInput.Text = ""
    textInput.PlaceholderText = "Type your message here..."
    textInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    textInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    textInput.TextScaled = true
    textInput.Font = Enum.Font.Gotham
    textInput.TextXAlignment = Enum.TextXAlignment.Left
    textInput.Parent = inputFrame
    
    -- Send Button
    local sendButton = Instance.new("TextButton")
    sendButton.Name = "SendButton"
    sendButton.Size = UDim2.new(0, 70, 1, -10)
    sendButton.Position = UDim2.new(1, -75, 0, 5)
    sendButton.BackgroundColor3 = Color3.fromRGB(75, 150, 255)
    sendButton.BorderSizePixel = 0
    sendButton.Text = "Send"
    sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    sendButton.TextScaled = true
    sendButton.Font = Enum.Font.GothamBold
    sendButton.Parent = inputFrame
    
    local sendCorner = Instance.new("UICorner")
    sendCorner.CornerRadius = UDim.new(0, 6)
    sendCorner.Parent = sendButton
    
    return {
        screenGui = screenGui,
        mainFrame = mainFrame,
        chatFrame = chatFrame,
        textInput = textInput,
        sendButton = sendButton,
        closeButton = closeButton,
        chatLayout = chatLayout
    }
end

-- Add message to chat
local function addMessage(chatFrame, chatLayout, sender, message, isUser)
    local messageFrame = Instance.new("Frame")
    messageFrame.Name = "Message"
    messageFrame.Size = UDim2.new(1, -10, 0, 0)
    messageFrame.BackgroundColor3 = isUser and Color3.fromRGB(75, 150, 255) or Color3.fromRGB(75, 75, 75)
    messageFrame.BorderSizePixel = 0
    messageFrame.LayoutOrder = #chatFrame:GetChildren()
    messageFrame.Parent = chatFrame
    
    local messageCorner = Instance.new("UICorner")
    messageCorner.CornerRadius = UDim.new(0, 8)
    messageCorner.Parent = messageFrame
    
    -- Sender label
    local senderLabel = Instance.new("TextLabel")
    senderLabel.Name = "Sender"
    senderLabel.Size = UDim2.new(1, -20, 0, 20)
    senderLabel.Position = UDim2.new(0, 10, 0, 5)
    senderLabel.BackgroundTransparency = 1
    senderLabel.Text = sender
    senderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    senderLabel.TextScaled = true
    senderLabel.Font = Enum.Font.GothamBold
    senderLabel.TextXAlignment = Enum.TextXAlignment.Left
    senderLabel.Parent = messageFrame
    
    -- Message text
    local messageText = Instance.new("TextLabel")
    messageText.Name = "MessageText"
    messageText.Size = UDim2.new(1, -20, 0, 0)
    messageText.Position = UDim2.new(0, 10, 0, 25)
    messageText.BackgroundTransparency = 1
    messageText.Text = message
    messageText.TextColor3 = Color3.fromRGB(255, 255, 255)
    messageText.TextSize = 14
    messageText.Font = Enum.Font.Gotham
    messageText.TextXAlignment = Enum.TextXAlignment.Left
    messageText.TextYAlignment = Enum.TextYAlignment.Top
    messageText.TextWrapped = true
    messageText.Parent = messageFrame
    
    -- Calculate text height
    local textBounds = messageText.TextBounds
    local textHeight = math.max(textBounds.Y, 20)
    
    messageText.Size = UDim2.new(1, -20, 0, textHeight)
    messageFrame.Size = UDim2.new(1, -10, 0, textHeight + 35)
    
    -- Update canvas size
    chatLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        chatFrame.CanvasSize = UDim2.new(0, 0, 0, chatLayout.AbsoluteContentSize.Y)
        chatFrame.CanvasPosition = Vector2.new(0, chatFrame.CanvasSize.Y.Offset)
    end)
    
    chatFrame.CanvasSize = UDim2.new(0, 0, 0, chatLayout.AbsoluteContentSize.Y)
    chatFrame.CanvasPosition = Vector2.new(0, chatFrame.CanvasSize.Y.Offset)
end

-- Create and setup GUI
function ChatGUI:create(onMessageSent, onClose)
    local gui = createMainGUI()
    
    -- Handle send button click
    local function sendMessage()
        local message = gui.textInput.Text
        if message and message ~= "" then
            addMessage(gui.chatFrame, gui.chatLayout, "You", message, true)
            gui.textInput.Text = ""
            
            if onMessageSent then
                onMessageSent(message)
            end
        end
    end
    
    -- Connect events
    gui.sendButton.MouseButton1Click:Connect(sendMessage)
    
    gui.textInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            sendMessage()
        end
    end)
    
    gui.closeButton.MouseButton1Click:Connect(function()
        gui.screenGui:Destroy()
        if onClose then
            onClose()
        end
    end)
    
    -- Make draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    gui.mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.mainFrame.Position
        end
    end)
    
    gui.mainFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            gui.mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return {
        gui = gui,
        addMessage = function(sender, message, isUser)
            addMessage(gui.chatFrame, gui.chatLayout, sender, message, isUser or false)
        end,
        destroy = function()
            gui.screenGui:Destroy()
        end
    }
end

return ChatGUI
