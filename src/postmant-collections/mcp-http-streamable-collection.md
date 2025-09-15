# MCP HTTP Streamable Protocol - Postman Collection

## Overview
This Postman collection is designed to mimic MCPHost requests to an MCP server using the HTTP streamable protocol. It provides a set of requests that demonstrate the complete workflow of initializing a session, discovering tools, executing tools, and managing sessions.

## Environment Variables
The collection uses the following environment variables:
- `base_url`: localhost (The base URL of the MCP server)
- `port`: 3000 (The port the MCP server is running on)
- `protocol`: http (The protocol to use)
- `base_path`: /mcp (The base path for MCP endpoints)

## Collection Variables
The collection uses the following collection variables:
- `session_id`: "" (Automatically populated with the session ID from initialization)
- `request_id`: 1 (Incrementing counter for JSON-RPC request IDs)
- `test_path`: "C:/Users" (Default path for testing the list_directory tool)
- `base_endpoint`: {{protocol}}://{{base_url}}:{{port}}{{base_path}} (Constructed endpoint URL)

## Request Workflow

### 1. Initialization Folder
Contains requests for initializing a new MCP session.

#### 01. Initialize MCP Session
- **Method**: POST
- **URL**: {{base_endpoint}}
- **Headers**: 
  - Content-Type: application/json
- **Body**: 
  ```json
  {
    "jsonrpc": "2.0",
    "id": {{request_id}},
    "method": "tools/list"
  }
  ```
- **Tests**: Captures the session ID from the `Mcp-Session-Id` response header and saves it to the `session_id` collection variable.

### 2. Tool Discovery Folder
Contains requests for discovering available tools.

#### 02. List Available Tools
- **Method**: POST
- **URL**: {{base_endpoint}}
- **Headers**: 
  - Content-Type: application/json
  - Mcp-Session-Id: {{session_id}}
- **Body**: 
  ```json
  {
    "jsonrpc": "2.0",
    "id": {{request_id}},
    "method": "tools/list"
  }
  ```

### 3. Tool Execution Folder
Contains requests for executing tools.

#### 03. Execute List Directory Tool
- **Method**: POST
- **URL**: {{base_endpoint}}
- **Headers**: 
  - Content-Type: application/json
  - Mcp-Session-Id: {{session_id}}
- **Body**: 
  ```json
  {
    "jsonrpc": "2.0",
    "id": {{request_id}},
    "method": "tools/call",
    "params": {
      "name": "list_directory",
      "arguments": {
        "path": "{{test_path}}"
      }
    }
  }
  ```

### 4. Session Management Folder
Contains requests for managing sessions.

#### 04. Delete MCP Session
- **Method**: DELETE
- **URL**: {{base_endpoint}}
- **Headers**: 
  - Mcp-Session-Id: {{session_id}}

## Usage Instructions

1. Start the MCP HTTP server using `npm run start:http`
2. Import this collection into Postman
3. Create an environment with the required variables
4. Run the requests in order (01, 02, 03, 04)
5. The session ID will be automatically captured and used in subsequent requests

## Pre-request Scripts

Each request includes pre-request scripts to:
- Increment the `request_id` collection variable
- Log the request details to the Postman console

## Test Scripts

Each request includes test scripts to:
- Validate the response status code
- Validate the JSON-RPC response format
- Extract and save the session ID for initialization requests
- Log the response details to the Postman console

## Notes
- The collection is designed to work with the simple-directory-mcp-server example
- The list_directory tool is the only tool available in this example
- The test_path variable can be modified to test different directories
- Session management is important to prevent resource leaks on the server