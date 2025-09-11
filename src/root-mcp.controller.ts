import { Controller, Post, Get, Delete, Req, Res, Body, Headers } from '@nestjs/common';
import { Request, Response } from 'express';
import { McpService } from './mcp/mcp.service';

@Controller()
export class RootMcpController {
  constructor(private readonly mcpService: McpService) {}

  @Post('mcp')
  async handleRootMcpPost(
    @Req() req: Request,
    @Res() res: Response,
    @Body() body: any,
    @Headers('mcp-session-id') sessionId?: string,
  ) {
    await this.mcpService.handleRequest(req, res, body, sessionId);
  }

  @Get('mcp')
  async handleRootMcpGet(
    @Req() req: Request,
    @Res() res: Response,
    @Headers('mcp-session-id') sessionId?: string,
  ) {
    await this.mcpService.handleRequest(req, res, undefined, sessionId);
  }

  @Delete('mcp')
  async handleRootMcpDelete(
    @Req() req: Request,
    @Res() res: Response,
    @Headers('mcp-session-id') sessionId?: string,
  ) {
    await this.mcpService.handleRequest(req, res, undefined, sessionId);
  }
}
