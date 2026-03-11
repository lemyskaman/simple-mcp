import { Injectable, OnModuleDestroy } from '@nestjs/common';
import { Request, Response } from 'express';
import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StreamableHTTPServerTransport } from '@modelcontextprotocol/sdk/server/streamableHttp.js';
import { isInitializeRequest } from '@modelcontextprotocol/sdk/types.js';
import { randomUUID } from 'node:crypto';
import { DirectoryService } from '../directory/directory.service';
import { z } from 'zod';

@Injectable()
export class McpService implements OnModuleDestroy {
  private transports: { [sessionId: string]: StreamableHTTPServerTransport } = {};

  constructor(private readonly directoryService: DirectoryService) {}

  onModuleDestroy() {
    // Clean up all transports when service is destroyed
    Object.values(this.transports).forEach(transport => {
      if (transport) {
        transport.close();
      }
    });
    this.transports = {};
  }

  private async createServer(): Promise<McpServer> {
    const server = new McpServer({
      name: 'simple-directory-mcp-server',
      version: '1.0.0'
    });

    // Register the list_directory tool using the modern API
    server.registerTool(
      'list_directory',
      {
        title: 'List Directory',
        description: 'List contents of a directory using Git Bash ls command on Windows',
        inputSchema: {
          path: z.string().describe('The directory path to list')
        }
      },
      async ({ path }) => {
        try {
          const result = await this.directoryService.listDirectory(path);
          return {
            content: [
              {
                type: 'text' as const,
                text: result,
              },
            ],
          };
        } catch (error) {
          return {
            content: [
              {
                type: 'text' as const,
                text: `Error listing directory: ${error.message}`,
              },
            ],
            isError: true,
          };
        }
      }
    );

    return server;
  }

  async handleRequest(req: Request, res: Response, body?: any, sessionId?: string) {
    try {
      let transport: StreamableHTTPServerTransport;

      if (sessionId && this.transports[sessionId]) {
        // Reuse existing transport
        transport = this.transports[sessionId];
      } else if (!sessionId && isInitializeRequest(body)) {
        // New initialization request
        transport = new StreamableHTTPServerTransport({
          sessionIdGenerator: () => randomUUID(),
          onsessioninitialized: (newSessionId) => {
            // Store the transport by session ID
            this.transports[newSessionId] = transport;
          },
          // DNS rebinding protection is disabled for backwards compatibility
          // as recommended in the documentation for local development
          enableDnsRebindingProtection: false,
          // allowedHosts: ['127.0.0.1', 'localhost'],
        });

        // Clean up transport when closed
        transport.onclose = () => {
          if (transport.sessionId) {
            delete this.transports[transport.sessionId];
          }
        };

        // Create and connect the MCP server to the transport
        const server = await this.createServer();
        await server.connect(transport);
      } else {
        // Invalid request
        res.status(400).json({
          jsonrpc: '2.0',
          error: {
            code: -32000,
            message: 'Bad Request: No valid session ID provided',
          },
          id: null,
        });
        return;
      }

      // Handle the request
      await transport.handleRequest(req, res, body);
    } catch (error) {
      console.error('Error handling MCP request:', error);
      if (!res.headersSent) {
        res.status(500).json({
          jsonrpc: '2.0',
          error: {
            code: -32603,
            message: 'Internal server error',
          },
          id: null,
        });
      }
    }
  }
}
