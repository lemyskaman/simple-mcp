#!/bin/bash

# Simple MCP Server with MCPHost (Bash version)  
# Main startup script for MCPHost integration with Llama 3.2:1b

echo -e "\033[36m🚀 Simple MCP Directory Server with MCPHost\033[0m"
echo -e "\033[36m============================================\033[0m"

PROJECT_PATH="/c/Users/lemys.lopez/projects/fusable/simple-mcp"

# Check prerequisites  
echo -e "\n\033[33m📋 Checking prerequisites...\033[0m"

if ! command -v node &> /dev/null; then
    echo -e "\033[31m❌ Node.js not found. Please install Node.js v18+\033[0m"
    exit 1
fi

if ! command -v mcphost &> /dev/null; then
    echo -e "\033[31m❌ mcphost not found. Please install:\033[0m"
    echo -e "\033[33m   go install github.com/mark3labs/mcphost@latest\033[0m"
    exit 1
fi

if ! command -v ollama &> /dev/null; then
    echo -e "\033[31m❌ ollama not found. Please install from https://ollama.ai\033[0m"
    exit 1
fi

echo -e "\033[32m✅ All prerequisites found\033[0m"

# Function to kill processes safely
kill_process_safely() {
    local process_name=$1
    if pgrep -f "$process_name" > /dev/null; then
        echo "  Stopping $process_name processes..."
        pkill -f "$process_name"
    fi
}

# 1. Clean up existing processes
echo -e "\n\033[33m🛑 Cleaning up existing processes...\033[0m"

kill_process_safely "node.*main.js"
kill_process_safely "ollama"
kill_process_safely "mcphost"

echo -e "  \033[32m✅ Cleanup completed\033[0m"
sleep 2

# 2. Build MCP server
echo -e "\n\033[33m🔨 Building MCP server...\033[0m"

cd "$PROJECT_PATH"

npm install --silent
npm run build

if [ $? -ne 0 ]; then
    echo -e "\033[31m❌ Build failed!\033[0m"
    echo -e "\n\033[36mPress Enter to exit...\033[0m"
    read
    exit 1
fi

if [ ! -f "dist/main.js" ]; then
    echo -e "\033[31m❌ Build output not found\033[0m"
    exit 1
fi

echo -e "\033[32m✅ MCP server built successfully\033[0m"

# 3. Start Ollama server
echo -e "\n\033[33m🦙 Starting Ollama service...\033[0m"

ollama serve &
echo -e "\033[32m✅ Ollama server started (background)\033[0m"

# Wait for Ollama to be ready
echo -e "\033[33m⏳ Waiting for Ollama to initialize...\033[0m"
sleep 5

# Check if llama3.2:1b is available
if ! ollama list 2>/dev/null | grep -q "llama3.2:1b"; then
    echo -e "\033[33m⚠️  Llama 3.2:1b model not found. You may need to:\033[0m"
    echo -e "\033[37m   ollama pull llama3.2:1b\033[0m"
fi

# 4. Start MCPHost
echo -e "\n\033[32m🚀 Starting MCPHost with Llama 3.2:1b...\033[0m"
echo -e "\033[32m==========================================\033[0m"
echo ""
echo -e "\033[36m🎯 Available MCPHost Commands:\033[0m"
echo -e "\033[37m   /help     - Show all commands\033[0m"
echo -e "\033[37m   /tools    - List available MCP tools\033[0m"
echo -e "\033[37m   /quit     - Exit MCPHost\033[0m"
echo ""
echo -e "\033[36m💡 Try these example queries:\033[0m"
echo -e "\033[37m   • 'List the files in C:/Users'\033[0m"
echo -e "\033[37m   • 'Show me what's in the current directory'\033[0m"
echo -e "\033[37m   • 'List files in my Documents folder'\033[0m"
echo ""
echo -e "\033[37m🔧 Configuration: .mcphost.yml (Llama 3.2:1b optimized)\033[0m"
echo ""

# Start mcphost - this will block until user exits
mcphost
