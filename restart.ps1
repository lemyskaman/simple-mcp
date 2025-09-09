# Simple MCP Server with MCPHost
# Main startup script for MCPHost integration with Llama 3.2:1b

Write-Host "🚀 Simple MCP Directory Server with MCPHost" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

# Check prerequisites
Write-Host "📋 Checking prerequisites..." -ForegroundColor Yellow

if (-not (Get-Command "node" -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Node.js not found. Please install Node.js v18+" -ForegroundColor Red
    exit 1
}

if (-not (Get-Command "mcphost" -ErrorAction SilentlyContinue)) {
    Write-Host "❌ mcphost not found. Please install:" -ForegroundColor Red
    Write-Host "   go install github.com/mark3labs/mcphost@latest" -ForegroundColor Yellow
    exit 1
}

if (-not (Get-Command "ollama" -ErrorAction SilentlyContinue)) {
    Write-Host "❌ ollama not found. Please install from https://ollama.ai" -ForegroundColor Red
    exit 1
}

Write-Host "✅ All prerequisites found" -ForegroundColor Green

# Function to kill processes safely
function Stop-ProcessSafely {
    param($ProcessName)
    Get-Process -Name $ProcessName -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Host "  Stopping $ProcessName process (PID: $($_.Id))" -ForegroundColor Gray
        Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
    }
}

# 1. Clean up any existing processes
Write-Host "`n🛑 Cleaning up existing processes..." -ForegroundColor Yellow

Stop-ProcessSafely "node"
Stop-ProcessSafely "ollama"  
Stop-ProcessSafely "mcphost"

Write-Host "  ✅ Cleanup completed" -ForegroundColor Green
Start-Sleep -Seconds 2

# 2. Build MCP server
Write-Host "`n🔨 Building MCP server..." -ForegroundColor Yellow

npm install --silent
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    Write-Host "`nPress Enter to exit..." -ForegroundColor Cyan
    Read-Host
    exit 1
}

if (-not (Test-Path "dist/main.js")) {
    Write-Host "❌ Build output not found" -ForegroundColor Red
    exit 1
}

Write-Host "✅ MCP server built successfully" -ForegroundColor Green

# 3. Start Ollama server
Write-Host "`n🦙 Starting Ollama service..." -ForegroundColor Yellow

Start-Process -FilePath "ollama" -ArgumentList "serve" -WindowStyle Hidden
Write-Host "✅ Ollama server started (background)" -ForegroundColor Green

# Wait for Ollama to be ready
Write-Host "⏳ Waiting for Ollama to initialize..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Check if llama3.2:1b is available
$models = ollama list 2>$null | Select-String "llama3.2:1b"
if (-not $models) {
    Write-Host "⚠️  Llama 3.2:1b model not found. You may need to:" -ForegroundColor Yellow
    Write-Host "   ollama pull llama3.2:1b" -ForegroundColor Gray
}

# 4. Start MCPHost
Write-Host "`n🚀 Starting MCPHost with Llama 3.2:1b..." -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "🎯 Available MCPHost Commands:" -ForegroundColor Cyan
Write-Host "   /help     - Show all commands" -ForegroundColor White
Write-Host "   /tools    - List available MCP tools" -ForegroundColor White  
Write-Host "   /quit     - Exit MCPHost" -ForegroundColor White
Write-Host ""
Write-Host "💡 Try these example queries:" -ForegroundColor Cyan
Write-Host "   • 'List the files in C:\\Users'" -ForegroundColor White
Write-Host "   • 'Show me what's in the current directory'" -ForegroundColor White
Write-Host "   • 'List files in my Documents folder'" -ForegroundColor White
Write-Host ""
Write-Host "🔧 Configuration: .mcphost.yml (Llama 3.2:1b optimized)" -ForegroundColor Gray
Write-Host ""

# Start mcphost - this will block until user exits
mcphost
