-- Code Generation Assistant Example
-- Uses AI to help generate Roblox scripts

-- Load the main API
local OllamaAPI = require("ollama_api") -- Adjust path as needed

-- Configure for code generation (CodeLlama is better for this)
OllamaAPI.Config.defaultModel = "codellama" -- or "llama2" if you don't have codellama
OllamaAPI.Config.baseURL = "http://localhost:11434"

-- Code generation function
local function generateCode(description, callback)
    local prompt = string.format([[
You are a Roblox Lua scripting assistant. Generate clean, working Roblox Lua code for the following request:

Request: %s

Please provide only the Lua code with comments explaining what it does. Make sure the code follows Roblox best practices.
]], description)
    
    print("🛠️  Generating code for:", description)
    
    local result = OllamaAPI:generate(prompt)
    
    if result.success then
        print("✅ Generated code:")
        print("---")
        print(result.response)
        print("---")
        
        if callback then
            callback(result.response)
        end
    else
        print("❌ Error generating code:", result.error)
    end
end

-- Example usage
if OllamaAPI:isServerRunning() then
    print("🚀 Code Generation Assistant Ready!")
    
    -- Generate some example scripts
    generateCode("A simple part that changes color when touched")
    
    wait(3)
    
    generateCode("A GUI button that teleports the player to spawn")
    
    wait(3)
    
    generateCode("A script that makes a part rotate continuously")
    
else
    print("❌ Ollama server is not running!")
    print("Please start it with: ollama serve")
    print("For best results, install CodeLlama: ollama pull codellama")
end

-- Global function for easy code generation
_G.generateRobloxCode = function(description)
    generateCode(description)
end

print("💡 Use _G.generateRobloxCode('your description') to generate code!")
