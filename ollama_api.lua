-- Ollama API Wrapper for Roblox
-- This module handles communication with local Ollama server

local OllamaAPI = {}

-- Configuration
OllamaAPI.Config = {
    baseURL = "http://localhost:11434",
    defaultModel = "llama2",
    timeout = 30,
    maxTokens = 2048
}

-- HTTP Service (assuming executor provides this)
local HttpService = game:GetService("HttpService")

-- Make HTTP request to Ollama server
local function makeRequest(endpoint, data, method)
    method = method or "POST"
    
    local url = OllamaAPI.Config.baseURL .. endpoint
    local headers = {
        ["Content-Type"] = "application/json"
    }
    
    local success, result = pcall(function()
        if method == "GET" then
            return HttpService:GetAsync(url)
        else
            return HttpService:PostAsync(url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
        end
    end)
    
    if success then
        local decodedResult = HttpService:JSONDecode(result)
        return true, decodedResult
    else
        return false, result
    end
end

-- Check if Ollama server is running
function OllamaAPI:isServerRunning()
    local success, result = makeRequest("/api/tags", nil, "GET")
    return success
end

-- List available models
function OllamaAPI:listModels()
    local success, result = makeRequest("/api/tags", nil, "GET")
    if success then
        return result.models or {}
    else
        return {}
    end
end

-- Generate response from model
function OllamaAPI:generate(prompt, model, options)
    model = model or self.Config.defaultModel
    options = options or {}
    
    local data = {
        model = model,
        prompt = prompt,
        stream = false,
        options = {
            num_predict = options.maxTokens or self.Config.maxTokens,
            temperature = options.temperature or 0.7,
            top_p = options.top_p or 0.9
        }
    }
    
    local success, result = makeRequest("/api/generate", data)
    if success then
        return {
            success = true,
            response = result.response,
            model = result.model,
            done = result.done
        }
    else
        return {
            success = false,
            error = result
        }
    end
end

-- Chat with model (maintains conversation context)
function OllamaAPI:chat(messages, model, options)
    model = model or self.Config.defaultModel
    options = options or {}
    
    local data = {
        model = model,
        messages = messages,
        stream = false,
        options = {
            num_predict = options.maxTokens or self.Config.maxTokens,
            temperature = options.temperature or 0.7,
            top_p = options.top_p or 0.9
        }
    }
    
    local success, result = makeRequest("/api/chat", data)
    if success then
        return {
            success = true,
            message = result.message,
            model = result.model,
            done = result.done
        }
    else
        return {
            success = false,
            error = result
        }
    end
end

-- Pull a model (download)
function OllamaAPI:pullModel(modelName)
    local data = {
        name = modelName
    }
    
    local success, result = makeRequest("/api/pull", data)
    return success, result
end

-- Show model information
function OllamaAPI:showModel(modelName)
    local data = {
        name = modelName
    }
    
    local success, result = makeRequest("/api/show", data)
    return success, result
end

return OllamaAPI
