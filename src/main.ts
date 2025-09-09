import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { 
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import { DirectoryService } from './directory/directory.service';

async function bootstrap() {
  // Create the NestJS application
  const app = await NestFactory.createApplicationContext(AppModule);
  const directoryService = app.get(DirectoryService);

  // Create the MCP server
  const server = new Server(
    {
      name: 'simple-directory-mcp-server',
      version: '1.0.0',
    }
  );

  // Register the handler to list tools
  server.setRequestHandler(ListToolsRequestSchema, async () => {
    return {
      tools: [
        {
          name: 'list_directory',
          description: 'List contents of a directory using Git Bash ls command on Windows',
          inputSchema: {
            type: 'object',
            properties: {
              path: {
                type: 'string',
                description: 'The directory path to list',
              },
            },
            required: ['path'],
          },
        },
      ],
    };
  });

  // Register the handler to execute tools
  server.setRequestHandler(CallToolRequestSchema, async (request) => {
    const { name, arguments: args } = request.params;

    if (name === 'list_directory') {
      const path = args.path as string;
      try {
        const result = await directoryService.listDirectory(path);
        return {
          content: [
            {
              type: 'text',
              text: result,
            },
          ],
        };
      } catch (error) {
        return {
          content: [
            {
              type: 'text',
              text: `Error listing directory: ${error.message}`,
            },
          ],
          isError: true,
        };
      }
    }

    throw new Error(`Unknown tool: ${name}`);
  });

  // Start the server with stdio transport
  const transport = new StdioServerTransport();
  await server.connect(transport);

  console.error('Simple MCP Directory Server running on stdio');
}

bootstrap().catch((error) => {
  console.error('Error starting server:', error);
  process.exit(1);
});
