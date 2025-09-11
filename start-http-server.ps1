# PowerShell script to start the Simple MCP Server in HTTP mode with MCPHost

# Set error action preference
$ErrorActionPreference = "Stop"

Write-Host "🚀 Starting Simple MCP Server (HTTP Mode)" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

# Check if Ollama is running
Write-Host "🔍 Checking Ollama service..." -ForegroundColor Yellow
try {
    $ollamaResponse = Invoke-WebRequest -Uri "http://localhost:11434/api/tags" -Method GET -TimeoutSec 5 -ErrorAction Stop
    Write-Host "✅ Ollama is running" -ForegroundColor Green
} catch {
    Write-Host "❌ Ollama is not running. Starting Ollama..." -ForegroundColor Red
    Start-Process "ollama" -ArgumentList "serve" -NoNewWindow
    Write-Host "⏳ Waiting for Ollama to start..." -ForegroundColor Yellow
    Start-Sleep -Seconds 3
}

# Check if the model exists
Write-Host "🔍 Checking if llama3.2:1b model is available..." -ForegroundColor Yellow
try {
    $models = Invoke-RestMethod -Uri "http://localhost:11434/api/tags"
    $hasModel = $models.models | Where-Object { $_.name -match "llama3\.2:1b" }
    
    if (-not $hasModel) {
        Write-Host "📦 Model llama3.2:1b not found. Pulling model..." -ForegroundColor Yellow
        Start-Process "ollama" -ArgumentList "pull", "llama3.2:1b" -Wait -NoNewWindow
    } else {
        Write-Host "✅ Model llama3.2:1b is available" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  Could not check models, but continuing..." -ForegroundColor Yellow
}

# Check if project is built
Write-Host "🔍 Checking if project is built..." -ForegroundColor Yellow
if (-not (Test-Path "dist/main-http.js")) {
    Write-Host "🔨 Building project..." -ForegroundColor Yellow
    npm run build
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Build failed!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✅ Project is built" -ForegroundColor Green
}

Write-Host ""
Write-Host "🌐 Starting HTTP MCP Server..." -ForegroundColor Cyan
Write-Host "📡 Server will be available at: http://localhost:3000/mcp" -ForegroundColor Cyan
Write-Host "🧪 Test endpoint at: http://localhost:3000/directory/list" -ForegroundColor Cyan
Write-Host ""
Write-Host "💡 In another terminal, run:" -ForegroundColor Yellow
Write-Host "   mcphost --config .mcphost-http.yml" -ForegroundColor White
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Gray
Write-Host "=========================================" -ForegroundColor Green

# Start the HTTP server
npm run start:http
