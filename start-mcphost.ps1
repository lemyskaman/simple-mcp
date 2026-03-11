#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Start MCPHost with the Simple Directory MCP Server configuration
    
.DESCRIPTION
    This script starts MCPHost using the .mcphost.yml configuration file
    which connects to the local NestJS MCP server for directory operations.
    
.NOTES
    Prerequisites:
    - mcphost must be installed (go install github.com/mark3labs/mcphost@latest)
    - Node.js project must be built (npm run build)
    - dist/main.js must exist
    - Ollama must be running with llama3.2:1b model available
#>

# Set error handling
$ErrorActionPreference = "Stop"

# Get the script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Change to the project directory
Push-Location $ScriptDir

try {
    # Check if the built main.js exists
    if (-not (Test-Path "dist/main.js")) {
        Write-Host "Error: dist/main.js not found. Please run 'npm run build' first." -ForegroundColor Red
        exit 1
    }
    
    # Check if .mcphost.yml exists
    if (-not (Test-Path ".mcphost.yml")) {
        Write-Host "Error: .mcphost.yml configuration file not found." -ForegroundColor Red
        exit 1
    }
    
    # Check if mcphost is available
    try {
        $mcphostVersion = mcphost --version 2>$null
        Write-Host "Using mcphost: $mcphostVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "Error: mcphost not found. Please install it with:" -ForegroundColor Red
        Write-Host "go install github.com/mark3labs/mcphost@latest" -ForegroundColor Yellow
        exit 1
    }
    
    # Check if Ollama is running (optional check)
    try {
        $ollamaStatus = Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -Method Get -TimeoutSec 5 2>$null
        Write-Host "Ollama is running with models available" -ForegroundColor Green
    }
    catch {
        Write-Host "Warning: Ollama may not be running on localhost:11434" -ForegroundColor Yellow
        Write-Host "Make sure Ollama is running and llama3.2:1b model is available" -ForegroundColor Yellow
    }
    
    Write-Host "Starting MCPHost with Simple Directory MCP Server..." -ForegroundColor Cyan
    Write-Host "Configuration: .mcphost.yml" -ForegroundColor Gray
    Write-Host "MCP Server: simple-directory-server (dist/main.js)" -ForegroundColor Gray
    Write-Host "Model: ollama:llama3.2:1b" -ForegroundColor Gray
    Write-Host "" -ForegroundColor Gray
    Write-Host "Press Ctrl+C to stop" -ForegroundColor Gray
    Write-Host "Type '/help' for available commands once started" -ForegroundColor Gray
    Write-Host "" -ForegroundColor Gray
    
    # Start mcphost with the configuration file
    mcphost --config ".mcphost.yml"
}
catch {
    Write-Host "Error starting MCPHost: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
finally {
    # Return to original location
    Pop-Location
}