-- Setup Instructions for Ollama AI on Roblox

# Getting Started with Ollama AI on Roblox

## Prerequisites

### 1. Install Ollama
- Download from https://ollama.ai
- Install on your local machine
- Ollama will run on `http://localhost:11434` by default

### 2. Download AI Models
Open terminal/command prompt and run:
```bash
# Popular models to try:
ollama pull llama2          # General conversation (3.8GB)
ollama pull codellama       # Code generation (3.8GB)  
ollama pull mistral         # Fast and efficient (4.1GB)
ollama pull llama2:7b-chat  # Chat-optimized version

# Smaller models for testing:
ollama pull tinyllama       # Very small model (600MB)
```

### 3. Start Ollama Server
```bash
ollama serve
```
Keep this running while using the Roblox scripts.

### 4. Roblox Executor Setup
- Use any executor that supports HTTP requests
- Make sure HTTP requests are enabled
- The scripts use `HttpService` for API calls

## Quick Start

### Method 1: Execute Main Script
1. Copy `main.lua` into your executor
2. Execute the script
3. A chat GUI should appear automatically
4. Start chatting with your local AI!

### Method 2: Manual Setup
1. Load the individual modules:
   - `ollama_api.lua` - Core API wrapper
   - `chat_gui.lua` - Chat interface (optional)
2. Use the API directly in your scripts

## Configuration

Edit the configuration in `main.lua`:
```lua
local CONFIG = {
    model = "llama2",                    -- Change to your preferred model
    serverURL = "http://localhost:11434", -- Ollama server URL
    autoStartGUI = true                  -- Auto-show chat interface
}
```

## Testing Connection

Run this in your executor to test:
```lua
_G.checkOllama() -- Returns true if connected
```

## Usage Examples

### Quick Chat
```lua
_G.sendToAI("Hello! What is Roblox?")
```

### Show Chat GUI
```lua
_G.showOllamaGUI()
```

### Generate Code
```lua
-- Load the code generator example
loadstring(game:HttpGet("path/to/code_generator.lua"))()
_G.generateRobloxCode("A script that makes a part glow")
```

## Troubleshooting

### "Could not connect to Ollama server"
- Make sure Ollama is running: `ollama serve`
- Check if localhost:11434 is accessible
- Try restarting Ollama

### "No models found"
- Make sure you've pulled at least one model
- Run: `ollama pull llama2`
- Check available models: `ollama list`

### HTTP requests not working
- Ensure your executor supports HTTP requests
- Some executors require HTTP to be explicitly enabled
- Check if the executor has network restrictions

### Slow responses
- Larger models take more time to respond
- Try smaller models like `tinyllama` for testing
- Ensure your computer has enough RAM for the model

## Model Recommendations

### For General Chat
- `llama2` - Best overall performance
- `mistral` - Fast and efficient
- `tinyllama` - Quick testing

### For Code Generation
- `codellama` - Specialized for coding
- `codellama:python` - Python-focused version

### For Roleplay/NPCs
- `llama2:7b-chat` - Chat-optimized
- `mistral:instruct` - Good at following instructions

## Security Notes

- This runs on your local machine only
- No data is sent to external servers
- Your conversations stay private
- Ollama runs completely offline

## Advanced Usage

### Custom Personalities
Modify the system prompt in examples to create different AI personalities:
```lua
local PERSONALITY = "You are a pirate NPC in a Roblox pirate game. Speak like a pirate!"
```

### Multiple Models
You can switch between models dynamically:
```lua
OllamaAPI.Config.defaultModel = "codellama" -- Switch to code model
```

### Conversation Context
The chat system maintains conversation history automatically for context-aware responses.

## Need Help?

1. Check Ollama is running: `curl http://localhost:11434/api/tags`
2. Test API directly: Visit `http://localhost:11434` in your browser
3. Check executor HTTP permissions
4. Try with a smaller model first (`tinyllama`)

Happy AI chatting! 🤖
