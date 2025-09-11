# Simple MCPHost HTTP Startup Script
# Starts NestJS HTTP MCP server and mcphost

Write-Host "🚀 Starting MCP HTTP Server + MCPHost..." -ForegroundColor Green

# Function to check if a command exists
function Test-Command {
    param($Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Check prerequisites
Write-Host "📋 Checking prerequisites..." -ForegroundColor Yellow

# Check Node.js
if (-not (Test-Command "node")) {
    Write-Host "❌ Node.js not found. Please install Node.js v18+ from https://nodejs.org" -ForegroundColor Red
    exit 1
}

# Check mcphost
if (-not (Test-Command "mcphost")) {
    Write-Host "❌ mcphost not found. Please install:" -ForegroundColor Red
    Write-Host "   go install github.com/mark3labs/mcphost@latest" -ForegroundColor Yellow
    exit 1
}

# Check ollama
if (-not (Test-Command "ollama")) {
    Write-Host "❌ ollama not found. Please install from https://ollama.ai" -ForegroundColor Red
    exit 1
}

Write-Host "✅ All prerequisites found" -ForegroundColor Green

# Build the MCP server
Write-Host "🔨 Building MCP server..." -ForegroundColor Yellow
npm install --silent
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Build failed!" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "dist/main.js")) {
    Write-Host "❌ Build output not found" -ForegroundColor Red
    exit 1
}

Write-Host "✅ MCP server built successfully" -ForegroundColor Green

# Stop existing processes
Write-Host "🛑 Cleaning up existing processes..." -ForegroundColor Yellow

# Stop existing Node.js processes
Get-Process -Name "node" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "  Stopping Node.js process (PID: $($_.Id))" -ForegroundColor Gray
    Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
}

# Stop existing Ollama processes
Get-Process -Name "ollama" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "  Stopping Ollama process (PID: $($_.Id))" -ForegroundColor Gray
    Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
}

Start-Sleep -Seconds 2
Write-Host "✅ Cleanup completed" -ForegroundColor Green

# Start Ollama service
Write-Host "🦙 Starting Ollama service..." -ForegroundColor Yellow
$ollamaJob = Start-Job -ScriptBlock {
    ollama serve
}

# Wait for Ollama to be ready
Write-Host "⏳ Waiting for Ollama to initialize..." -ForegroundColor Yellow
$timeout = 30
$elapsed = 0
do {
    Start-Sleep -Seconds 1
    $elapsed++
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:11434/api/tags" -TimeoutSec 2 -ErrorAction SilentlyContinue
        if ($response.StatusCode -eq 200) {
            break
        }
    }
    catch {
        # Continue waiting
    }
} while ($elapsed -lt $timeout)

if ($elapsed -ge $timeout) {
    Write-Host "❌ Timeout waiting for Ollama to start" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Ollama service ready" -ForegroundColor Green

# Check if llama3.2:1b is available
$models = ollama list 2>$null | Select-String "llama3.2:1b"
if (-not $models) {
    Write-Host "⚠️  Llama 3.2:1b model not found. You may need to:" -ForegroundColor Yellow
    Write-Host "   ollama pull llama3.2:1b" -ForegroundColor Gray
}

# Start MCP HTTP Server
Write-Host "🌐 Starting MCP HTTP Server..." -ForegroundColor Yellow
$mcpJob = Start-Job -ScriptBlock {
    Set-Location $using:PWD
    node dist/main-http.js
}

# Wait for HTTP server to be ready
Write-Host "⏳ Waiting for MCP HTTP server..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Test if server is responding
try {
    $response = Invoke-WebRequest -Uri "http://localhost:3000/mcp" -Method Options -TimeoutSec 5 -ErrorAction SilentlyContinue
    Write-Host "✅ MCP HTTP Server ready at http://localhost:3000/mcp" -ForegroundColor Green
}
catch {
    Write-Host "⚠️  MCP Server may still be starting..." -ForegroundColor Yellow
}

# Cleanup function
function Cleanup {
    Write-Host ""
    Write-Host "🛑 Shutting down services..." -ForegroundColor Yellow
    
    # Stop jobs
    Stop-Job -Job $ollamaJob -ErrorAction SilentlyContinue
    Remove-Job -Job $ollamaJob -ErrorAction SilentlyContinue
    
    Stop-Job -Job $mcpJob -ErrorAction SilentlyContinue  
    Remove-Job -Job $mcpJob -ErrorAction SilentlyContinue
    
    # Stop processes
    Get-Process -Name "ollama" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Get-Process -Name "node" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    
    Write-Host "✅ Cleanup completed" -ForegroundColor Green
}

# Register cleanup on script exit
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action { Cleanup } | Out-Null

Write-Host ""
Write-Host "🎯 Server Configuration:" -ForegroundColor Cyan
Write-Host "   • MCP HTTP Endpoint: http://localhost:3000/mcp" -ForegroundColor White
Write-Host "   • Transport: StreamableHTTP" -ForegroundColor White
Write-Host "   • Model: Llama 3.2:1b via Ollama" -ForegroundColor White
Write-Host "   • Config: .mcphost-http.yml" -ForegroundColor White
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
Write-Host "🚀 Starting MCPHost..." -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

try {
    # Start mcphost with HTTP configuration
    mcphost --config ".mcphost-http.yml"
}
finally {
    Cleanup
}
