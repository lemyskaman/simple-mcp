# MCP HTTP StreamableTransport - Postman Collection

## 📋 Overview

This directory contains a comprehensive Postman collection for testing the **MCP HTTP StreamableTransport** server. The collection demonstrates the complete Model Context Protocol (MCP) workflow and provides direct testing capabilities for the directory service endpoints.

## 📁 Files Included

- **`MCP-HTTP-StreamableTransport.postman_collection.json`** - Main collection with all requests and tests
- **`MCP-HTTP-Local.postman_environment.json`** - Environment variables for local development
- **`mcp-http-streamable-collection.md`** - Original documentation and requirements
- **`README.md`** - This documentation file

## 🚀 Quick Start

### 1. Import into Postman

1. Open Postman
2. Click **Import** button
3. Drag and drop both JSON files or click **Upload Files**
4. Select both:
   - `MCP-HTTP-StreamableTransport.postman_collection.json`
   - `MCP-HTTP-Local.postman_environment.json`

### 2. Set Environment

1. In Postman, select **"MCP HTTP Local Development"** environment from the dropdown
2. Verify environment variables are set correctly:
   - `base_url`: localhost
   - `port`: 3000
   - `protocol`: http

### 3. Start MCP Server

Before running the collection, ensure your MCP HTTP server is running:

```powershell
# In your project directory
npm run build
npm run start:http
```

The server should be accessible at `http://localhost:3000`

## 📊 Collection Structure

### 1. MCP Protocol Workflow

Complete end-to-end MCP protocol demonstration:

#### 01. Initialize MCP Session
- **Method**: POST `/mcp`
- **Purpose**: Initialize a new MCP session
- **Captures**: Session ID from `Mcp-Session-Id` header
- **Sets**: `session_id` collection variable

#### 02. List Available Tools
- **Method**: POST `/mcp`
- **Purpose**: Discover available tools
- **Requires**: Valid session ID
- **Validates**: `list_directory` tool availability

#### 03. Execute List Directory Tool
- **Method**: POST `/mcp`
- **Purpose**: Execute the directory listing tool
- **Uses**: `test_path` variable (default: "C:/Users")
- **Validates**: Tool execution and response format

#### 04. Execute Tool with Root Path
- **Method**: POST `/mcp`
- **Purpose**: Test tool with different path
- **Uses**: Root drive path ("C:/")
- **Validates**: Tool flexibility

#### 05. Delete MCP Session
- **Method**: DELETE `/mcp`
- **Purpose**: Clean up session resources
- **Clears**: `session_id` variable

### 2. Directory Service Testing

Direct HTTP testing without MCP protocol:

#### 01. Test Directory List - Default Path
- **Method**: GET `/directory/list`
- **Purpose**: Test with default path (current directory)

#### 02. Test Directory List - Custom Path
- **Method**: GET `/directory/list?path={{test_path}}`
- **Purpose**: Test with custom path parameter

#### 03. Test Directory List - Root Drive
- **Method**: GET `/directory/list?path=C:/`
- **Purpose**: Test with root drive path

### 3. Health Check & Diagnostics

Server monitoring and health checks:

#### 01. MCP Health Check - GET
- **Method**: GET `/mcp`
- **Purpose**: Basic MCP endpoint availability

#### 02. Server Connection Test
- **Method**: GET `/`
- **Purpose**: Basic server connectivity test

## 🔧 Collection Variables

The collection uses several variables for reusability:

### Environment Variables (configurable)
- **`base_url`**: localhost (server hostname)
- **`port`**: 3000 (server port)
- **`protocol`**: http (connection protocol)

### Collection Variables (auto-managed)
- **`session_id`**: "" (MCP session identifier - auto-captured)
- **`request_id`**: "1" (JSON-RPC request counter - auto-incremented)
- **`test_path`**: "C:/Users" (default test directory path)
- **`base_endpoint`**: "{{protocol}}://{{base_url}}:{{port}}" (constructed URL)

## ⚠️ **Important Headers Required**

The MCP StreamableHTTP transport requires specific headers for all requests:

### Required Headers
- **`Content-Type`**: `application/json` (for POST requests with body)
- **`Accept`**: `application/json, text/event-stream` (**CRITICAL** - without this header you'll get error -32000)
- **`Mcp-Session-Id`**: Session identifier (after initialization)

### Why Accept Header is Required
The StreamableHTTP transport supports both:
- **`application/json`**: For standard JSON-RPC responses
- **`text/event-stream`**: For streaming capabilities

If the client doesn't declare support for both content types, the server returns:
```json
{
  "jsonrpc": "2.0",
  "error": {
    "code": -32000,
    "message": "Not Acceptable: Client must accept both application/json and text/event-stream"
  },
  "id": null
}
```

## 🧪 Testing Features

### Automated Test Scripts

Each request includes comprehensive test scripts:

- **JSON-RPC Validation**: Ensures proper protocol format
- **Response Structure**: Validates expected response properties
- **Session Management**: Captures and manages session IDs
- **Tool Discovery**: Verifies available tools
- **Content Validation**: Checks tool execution results
- **Error Handling**: Proper error response validation

### Pre-request Scripts

- **Request ID Management**: Auto-increments JSON-RPC request IDs
- **Session Tracking**: Manages session state
- **Logging**: Comprehensive console output for debugging

### Global Scripts

- **Response Timing**: Tracks response times
- **Status Validation**: Basic HTTP status code checks
- **Logging**: Request/response logging for troubleshooting

## 🏃‍♂️ Running the Collection

### Option 1: Manual Execution

1. Start with **"1. MCP Protocol Workflow"** folder
2. Run requests in sequence (01 → 02 → 03 → 04 → 05)
3. Test direct endpoints with **"2. Directory Service Testing"**
4. Verify server health with **"3. Health Check & Diagnostics"**

### Option 2: Collection Runner

1. Click **"Run Collection"** button
2. Select entire collection or specific folder
3. Configure iterations and delays if needed
4. Click **"Run"** to execute all requests automatically

## 📝 Expected Responses

### MCP Session Initialization
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "protocolVersion": "2024-11-05",
    "capabilities": {
      "tools": {}
    },
    "serverInfo": {
      "name": "simple-directory-mcp-server",
      "version": "1.0.0"
    }
  }
}
```

### Tools List Response
```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "result": {
    "tools": [
      {
        "name": "list_directory",
        "description": "List the contents of a directory",
        "inputSchema": {
          "type": "object",
          "properties": {
            "path": {
              "type": "string",
              "description": "The directory path to list"
            }
          },
          "required": ["path"]
        }
      }
    ]
  }
}
```

### Tool Execution Response
```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "result": {
    "content": [
      {
        "type": "text",
        "text": "Directory listing for C:/Users:\n\ndrwxr-xr-x  user1\ndrwxr-xr-x  user2\n..."
      }
    ]
  }
}
```

## 🔍 Troubleshooting

### Common Issues

1. **Error -32000: "Not Acceptable: Client must accept both application/json and text/event-stream"**
   - **Cause**: Missing or incorrect `Accept` header
   - **Solution**: Ensure all MCP requests include `Accept: application/json, text/event-stream`
   - **Note**: This is automatically included in the updated collection

2. **Connection Refused**
   - Ensure MCP server is running on port 3000
   - Check firewall settings
   - Verify `npm run start:http` was successful

3. **Session ID Not Captured**
   - Check if server returns `Mcp-Session-Id` header
   - Verify pre-request scripts are enabled
   - Look for JavaScript errors in Postman console

4. **Tool Not Found**
   - Ensure server has `list_directory` tool registered
   - Check server logs for errors
   - Verify MCP service is properly configured

5. **Path Access Denied**
   - Try different test paths
   - Ensure directory exists and is readable
   - Check Windows permissions

### Debugging Tips

1. **Enable Postman Console**: View → Show Postman Console
2. **Check Collection Variables**: Hover over variables to see current values
3. **Review Test Results**: Look at test tab after each request
4. **Monitor Server Logs**: Check server console for error messages

## 🌐 Environment Customization

### Production Environment

Create a new environment for production testing:

```json
{
  "base_url": "your-production-server.com",
  "port": "443",
  "protocol": "https"
}
```

### Docker Environment

For Docker deployments:

```json
{
  "base_url": "host.docker.internal",
  "port": "3000", 
  "protocol": "http"
}
```

## 📚 Educational Value

This collection serves as a comprehensive example of:

- **MCP Protocol Implementation**: Real-world usage patterns
- **Session Management**: Proper session lifecycle
- **Tool Discovery**: Dynamic tool enumeration
- **Tool Execution**: Parameter passing and result handling
- **Error Handling**: Robust error management
- **Testing Strategies**: Comprehensive API testing
- **Postman Best Practices**: Professional collection structure

## 🔗 Related Resources

- **MCP Specification**: [Model Context Protocol](https://spec.modelcontextprotocol.io/)
- **NestJS Documentation**: [NestJS Framework](https://nestjs.com/)
- **Postman Learning Center**: [Postman Documentation](https://learning.postman.com/)
- **Project README**: `../README.md`
- **Development Process**: `../DEVELOPMENT_PROCESS.md`

## 🤝 Contributing

To improve this collection:

1. Export updated collection from Postman
2. Replace the existing JSON file
3. Update this README with changes
4. Test all scenarios thoroughly
5. Document any new features or requirements

## 📄 License

This collection is part of the educational MCP project and follows the same license terms as the main project.

---

**Happy Testing! 🚀**

*This collection demonstrates professional API testing practices and serves as a complete reference for MCP HTTP protocol implementation.*