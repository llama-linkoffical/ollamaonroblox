-- Main Ollama AI Integration Script for Roblox
-- This script is loaded by the loader system

-- Get modules from global scope (set by loader)
local OllamaAPI = _G.OllamaAPI
local ChatGUI = _G.ChatGUI

-- Fallback if modules aren't loaded globally
if not OllamaAPI or not ChatGUI then
    error("❌ Required modules not found! Make sure to use the loader.lua script.")
end

-- Configuration
local CONFIG = {
    model = "llama2", -- Change to your preferred model
    serverURL = "http://localhost:11434",
    autoStartGUI = true
}

-- Chat history for context
local chatHistory = {}

-- Main OllamaChat class
local OllamaChat = {}
OllamaChat.__index = OllamaChat

function OllamaChat.new()
    local self = setmetatable({}, OllamaChat)
    self.api = OllamaAPI
    self.gui = nil
    self.isConnected = false
    
    -- Configure API
    self.api.Config.baseURL = CONFIG.serverURL
    self.api.Config.defaultModel = CONFIG.model
    
    return self
end

-- Check connection to Ollama server
function OllamaChat:checkConnection()
    print("🔍 Checking Ollama server connection...")
    
    self.isConnected = self.api:isServerRunning()
    
    if self.isConnected then
        print("✅ Connected to Ollama server!")
        
        -- List available models
        local models = self.api:listModels()
        if #models > 0 then
            print("📚 Available models:")
            for _, model in ipairs(models) do
                print("  - " .. model.name)
            end
        else
            print("⚠️  No models found. Make sure you have pulled some models.")
            print("   Run: ollama pull " .. CONFIG.model)
        end
    else
        print("❌ Could not connect to Ollama server!")
        print("   Make sure Ollama is running on " .. CONFIG.serverURL)
        print("   Run: ollama serve")
    end
    
    return self.isConnected
end

-- Send message to AI
function OllamaChat:sendMessage(message, callback)
    if not self.isConnected then
        if callback then callback(false, "Not connected to Ollama server") end
        return
    end
    
    print("💭 Sending message to AI...")
    
    -- Add user message to history
    table.insert(chatHistory, {
        role = "user",
        content = message
    })
    
    -- Use chat API for context-aware responses
    local result = self.api:chat(chatHistory, CONFIG.model)
    
    if result.success then
        local aiResponse = result.message.content
        
        -- Add AI response to history
        table.insert(chatHistory, {
            role = "assistant", 
            content = aiResponse
        })
        
        print("🤖 AI Response received!")
        if callback then callback(true, aiResponse) end
    else
        print("❌ Error getting AI response:", result.error)
        if callback then callback(false, result.error) end
    end
end

-- Create and show GUI
function OllamaChat:createGUI()
    if self.gui then
        self.gui.destroy()
    end
    
    self.gui = ChatGUI:create(
        -- onMessageSent callback
        function(message)
            self:sendMessage(message, function(success, response)
                if success then
                    self.gui.addMessage("AI (" .. CONFIG.model .. ")", response, false)
                else
                    self.gui.addMessage("System", "Error: " .. tostring(response), false)
                end
            end)
        end,
        
        -- onClose callback
        function()
            self.gui = nil
            print("Chat GUI closed")
        end
    )
    
    -- Add welcome message
    self.gui.addMessage("System", "Welcome! Connected to Ollama AI (" .. CONFIG.model .. ")", false)
    self.gui.addMessage("System", "Start typing to chat with the AI!", false)
end

-- Initialize and start
function OllamaChat:start()
    print("🚀 Starting Ollama AI Integration...")
    
    if self:checkConnection() then
        if CONFIG.autoStartGUI then
            self:createGUI()
            print("✨ Chat GUI created! Start chatting!")
        end
    else
        print("⚠️  Please start Ollama server and try again")
    end
end

-- Create global instance
_G.OllamaChat = OllamaChat.new()

-- Auto-start
_G.OllamaChat:start()

-- Global functions for easy access
_G.sendToAI = function(message)
    _G.OllamaChat:sendMessage(message, function(success, response)
        if success then
            print("🤖 AI:", response)
        else
            print("❌ Error:", response)
        end
    end)
end

_G.showOllamaGUI = function()
    _G.OllamaChat:createGUI()
end

_G.checkOllama = function()
    return _G.OllamaChat:checkConnection()
end

print("🎉 Ollama AI Integration loaded!")
print("📖 Usage:")
print("   - GUI should auto-open (if enabled)")
print("   - Use _G.sendToAI('your message') for quick messages")
print("   - Use _G.showOllamaGUI() to show chat interface")
print("   - Use _G.checkOllama() to test connection")
print("")
print("🔧 Make sure Ollama is running: ollama serve")
print("📦 Make sure you have models: ollama pull llama2")
