-- AI NPC Example
-- Creates an NPC that players can talk to using AI

-- Load the main API
local OllamaAPI = require("ollama_api") -- Adjust path as needed

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Configuration
local NPC_NAME = "AI Assistant"
local NPC_MODEL = "llama2"
local NPC_PERSONALITY = "You are a helpful NPC in a Roblox game. You are friendly, enthusiastic about the game, and always ready to help players. Keep your responses short and game-appropriate."

-- Configure API
OllamaAPI.Config.defaultModel = NPC_MODEL
OllamaAPI.Config.baseURL = "http://localhost:11434"

-- NPC Chat System
local NPCChat = {}

-- Store conversation history for each player
local playerConversations = {}

-- Initialize conversation for a player
local function initPlayerConversation(player)
    if not playerConversations[player.UserId] then
        playerConversations[player.UserId] = {
            {
                role = "system",
                content = NPC_PERSONALITY
            }
        }
    end
end

-- Handle player chat with NPC
local function handleNPCChat(player, message)
    initPlayerConversation(player)
    
    -- Add player message to conversation
    table.insert(playerConversations[player.UserId], {
        role = "user",
        content = message
    })
    
    print(string.format("💬 %s said to NPC: %s", player.Name, message))
    
    -- Get AI response
    local result = OllamaAPI:chat(playerConversations[player.UserId], NPC_MODEL)
    
    if result.success then
        local npcResponse = result.message.content
        
        -- Add NPC response to conversation
        table.insert(playerConversations[player.UserId], {
            role = "assistant",
            content = npcResponse
        })
        
        -- Send response to player (you'll need to implement this based on your game)
        print(string.format("🤖 %s responds: %s", NPC_NAME, npcResponse))
        
        -- In a real game, you might:
        -- - Show this in a GUI
        -- - Display as chat bubble
        -- - Use TextChatService
        -- - Send via RemoteEvent
        
        -- Example: Simple chat output
        if player.Character and player.Character:FindFirstChild("Head") then
            -- Create chat bubble or use game's chat system
            game:GetService("Chat"):Chat(player.Character.Head, "[" .. NPC_NAME .. "]: " .. npcResponse)
        end
        
    else
        print("❌ NPC AI Error:", result.error)
        -- Fallback response
        if player.Character and player.Character:FindFirstChild("Head") then
            game:GetService("Chat"):Chat(player.Character.Head, "[" .. NPC_NAME .. "]: Sorry, I'm having trouble thinking right now!")
        end
    end
end

-- Set up NPC interaction
local function setupNPCInteraction()
    -- Listen for chat messages (adjust this based on your game's chat system)
    Players.PlayerAdded:Connect(function(player)
        player.Chatted:Connect(function(message)
            -- Check if player is talking to NPC (customize this logic)
            if string.find(string.lower(message), "npc") or 
               string.find(string.lower(message), "assistant") or
               string.find(string.lower(message), "ai") then
                
                -- Clean the message (remove NPC trigger words)
                local cleanMessage = message
                cleanMessage = string.gsub(cleanMessage, "[Nn][Pp][Cc]", "")
                cleanMessage = string.gsub(cleanMessage, "[Aa][Ss][Ss][Ii][Ss][Tt][Aa][Nn][Tt]", "")
                cleanMessage = string.gsub(cleanMessage, "[Aa][Ii]", "")
                cleanMessage = string.gsub(cleanMessage, "^%s*", "") -- Remove leading spaces
                
                if cleanMessage ~= "" then
                    handleNPCChat(player, cleanMessage)
                end
            end
        end)
    end)
end

-- Initialize
if OllamaAPI:isServerRunning() then
    print("🤖 AI NPC System Ready!")
    print("📢 Players can chat with the NPC by including 'NPC', 'Assistant', or 'AI' in their message")
    
    setupNPCInteraction()
    
    -- Test the NPC
    print("🧪 Testing NPC...")
    local testPlayer = Players.LocalPlayer or Players:GetPlayers()[1]
    if testPlayer then
        handleNPCChat(testPlayer, "Hello! What can you help me with?")
    end
    
else
    print("❌ Ollama server is not running!")
    print("Please start it with: ollama serve")
end

-- Global functions
_G.talkToNPC = function(message)
    local player = Players.LocalPlayer
    if player then
        handleNPCChat(player, message)
    end
end

_G.resetNPCConversation = function()
    local player = Players.LocalPlayer
    if player then
        playerConversations[player.UserId] = nil
        print("🔄 NPC conversation reset!")
    end
end

print("💡 Use _G.talkToNPC('your message') to test NPC chat!")
print("💡 Use _G.resetNPCConversation() to start fresh!")
