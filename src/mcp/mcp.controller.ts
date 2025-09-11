import { Controller, Post, Get, Delete, Req, Res, Body, Headers } from '@nestjs/common';
import { Request, Response } from 'express';
import { McpService } from './mcp.service';

@Controller('mcp')
export class McpController {
  constructor(private readonly mcpService: McpService) {}

  @Post()
  async handleMcpPost(
    @Req() req: Request,
    @Res() res: Response,
    @Body() body: any,
    @Headers('mcp-session-id') sessionId?: string,
  ) {
    await this.mcpService.handleRequest(req, res, body, sessionId);
  }

  @Get()
  async handleMcpGet(
    @Req() req: Request,
    @Res() res: Response,
    @Headers('mcp-session-id') sessionId?: string,
  ) {
    await this.mcpService.handleRequest(req, res, undefined, sessionId);
  }

  @Delete()
  async handleMcpDelete(
    @Req() req: Request,
    @Res() res: Response,
    @Headers('mcp-session-id') sessionId?: string,
  ) {
    await this.mcpService.handleRequest(req, res, undefined, sessionId);
  }
}
