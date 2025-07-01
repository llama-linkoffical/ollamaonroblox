-- Simple AI Chat Example
-- Quick demonstration of sending messages to Ollama

-- Load the main API
local OllamaAPI = require("ollama_api") -- Adjust path as needed

-- Configure
OllamaAPI.Config.defaultModel = "llama2"
OllamaAPI.Config.baseURL = "http://localhost:11434"

-- Simple function to ask the AI something
local function askAI(question)
    print("🤔 Question:", question)
    
    local result = OllamaAPI:generate(question)
    
    if result.success then
        print("🤖 AI Response:")
        print(result.response)
    else
        print("❌ Error:", result.error)
    end
    
    print("---")
end

-- Test the connection
if OllamaAPI:isServerRunning() then
    print("✅ Ollama server is running!")
    
    -- Ask some questions
    askAI("Hello! What is Roblox?")
    
    wait(2) -- Give time for response
    
    askAI("Can you write a simple Lua function that says hello?")
    
    wait(2)
    
    askAI("What are some fun game ideas for Roblox?")
    
else
    print("❌ Ollama server is not running!")
    print("Please start it with: ollama serve")
end
